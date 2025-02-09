dimensionedScalar pUnit("pUnit",dimensionSet (1,-1,-2,0,0,0,0),1.0);
dimensionedScalar TUnit("TUnit", dimTemperature, 1.0);
dimensionedScalar DUnit("DUnit",dimensionSet (0,2,-1,0,0,0,0),1.0);
dimensionedScalar MuUnit("MuUnit",dimensionSet (1,-1,-1,0,0,0,0),1.0);
dimensionedScalar lambdaUnit("lambdaUnit",dimensionSet (1,1,-3,-1,0,0,0),1.0);

mixMu *= 0;
mixAlpha *= 0;
mixLambda_a *= 0 ;
mixLambda_b *= 0 ;

// get mixture mole mass
MW *= 0;
forAll(Y,specI)
{
    MW += Y[specI] / thermo.composition().Wi(specI);
}
MW = 1 / MW;

// get species mole fraction
forAll(Y,specI)
{
    XFluid[specI] = Y[specI] * (MW / thermo.composition().Wi(specI));
}

// evaluate polynomials
volScalarField tmpT = log(thermoFluid[i].T()/TUnit);

// Compute mu and lambda
forAll(Y,specI)
{
    // Cantera-like interpolation for thermal conductivity
    LambdaY[specI] = lambdaUnit*sqrt(thermoFluid[i].T()/TUnit)*(
                                  Lambda1[specI] + tmpT*(
                                    Lambda2[specI] + tmpT*(
                                      Lambda3[specI] + tmpT*(
                                        Lambda4[specI] + tmpT*Lambda5[specI])))
                                  );

    // Cantera-like interpolation for viscosity
    MuY[specI] = MuUnit*sqrt(thermoFluid[i].T()/TUnit)*pow(
                              Mu1[specI] + tmpT*(
                                Mu2[specI] + tmpT*(
                                  Mu3[specI] + tmpT*(
                                    Mu4[specI] + tmpT*Mu5[specI]))), 2);
}

// Mu and Lambda mixture rule
forAll(Y,specI)
{
    volScalarField& Xi = XFluid[specI];
    volScalarField& Mui = MuY[specI];
    double Wi = thermoFluid[i].composition().Wi(specI);
    
    WilkeMixRule *= 0;
    forAll (Y,z)
    {
        volScalarField& Xz = XFluid[z];
        volScalarField& Muz = MuY[z];
        double Wz = thermoFluid[i].composition().Wi(z);
        WilkeMixRule += Xz*0.353553391*pow(1.0 + Foam::sqrt(Mui/Muz)*pow025(Wz/Wi),2)/Foam::sqrt(1.0+Wi/Wz);
    }
    mixMu += (Xi)*Mui/WilkeMixRule;
    
    mixLambda_a += Xi*LambdaY[specI];
    mixLambda_b += Xi/LambdaY[specI];
}

// XXX this is only right if we solve for enthalpy
// XXX when solving for internal energy, gotta use Cv and not Cp...
mixAlpha = 0.5*(mixLambda_a+(1/mixLambda_b))/thermo.Cp();  // OpenFOAM "alpha"


if (differentialDiffusion)
{
    if (thermalDiffusion)
    {
        Info << " WITH differential diffusion and thermalDiffusion" << endl;
    }
    else
    {
        Info << " WITH differential diffusion"  << endl;
    }
}
else
{
    Info << " WITHOUT differential diffusion " << endl;
}

dimensionedScalar pUnit("pUnit",dimensionSet (1,-1,-2,0,0,0,0),1.0);
dimensionedScalar TUnit("TUnit", dimTemperature, 1.0);
dimensionedScalar DUnit("DUnit",dimensionSet (0,2,-1,0,0,0,0),1.0);
dimensionedScalar MuUnit("MuUnit",dimensionSet (1,-1,-1,0,0,0,0),1.0);
dimensionedScalar lambdaUnit("lambdaUnit",dimensionSet (1,1,-3,-1,0,0,0),1.0);

mixMu *= 0;
mixLambdaA *= 0 ;
mixLambdaB *= 0 ;

// get mixture mole mass
MW *= 0;
forAll(Y,i)
{
    MW += Y[i]/composition.Wi(i);
}
MW = 1/MW;

// get species mole fraction
forAll(Y,i)
{
    X[i] = Y[i]*MW/composition.Wi(i);
}

// evaluate polynomials
volScalarField tmpT = log(T/TUnit);

if (differentialDiffusion)
{
    forAll(groupSpecies,i)
    {
        if(groupSpecies[i][0] != -1)
        {
            for(label j = i; j < groupSpecies.size();j ++)
            {
                if(groupSpecies[j][0] != -1)
                {
                    label m = max(groupSpecies[i][0],groupSpecies[j][0]);
                    label n = min(groupSpecies[i][0],groupSpecies[j][0]);	
                    label k = Y.size()*n+m-0.5*n*(n+1);

                    volScalarField tmpd = sqrt(T/TUnit)*(T/TUnit) / (p/pUnit)*(
                                            Diff1[k] + tmpT*(
                                              Diff2[k] + tmpT*(
                                                Diff3[k] + tmpT*(
                                                  Diff4[k] + tmpT*Diff5[k]))));

                    forAll(groupSpecies[i],h)
                    {
                        forAll(groupSpecies[j],z)
                        {
                            label m = max(groupSpecies[i][h],groupSpecies[j][z]);
                            label n = min(groupSpecies[i][h],groupSpecies[j][z]);	
                            label k = Y.size()*n+m-0.5*n*(n+1);
                            d[k] = tmpd;
                        }
                    }
                }
            }
        }
    }

    /* * * * * * * * * * * * * * * * * * * * *
    // Diffusivity mixture rule
    forAll(Y,i)
    {
        DiNumerator *= 0;
        DiDenominator *= 0;
        for (label j = 0; j < Y.size(); j++)
        {
            label m = max(i,j);
            label n = min(i,j);
            volScalarField& Xj = X[j];

            if (j != i)
            {
                label k = Y.size()*n+m-0.5*n*(n+1);
                DiNumerator += (Xj+1e-12) * composition.Wi(j);
                DiDenominator += MW*(Xj+1e-12)/d[k];
            } 
        }
        // FIXME :: currently, won't account for singular cases
        Diff[i] = DiNumerator*DUnit/ DiDenominator;
    }
    * * * * * * * * * * * * * * * * * * * * */

    // Diffusivity mixture rule
    forAll(Y,i)
    {
        DiNumerator *= 0;
        DiDenominator *= 0;
        for (label j = 0; j < Y.size(); j++)
        {
            label m = max(i,j);
            label n = min(i,j);
            label k = Y.size()*n+m-0.5*n*(n+1);
            volScalarField& Xj = X[j];
            
            if (j != i)
            {
                DiNumerator += (Xj) * composition.Wi(j);
                DiDenominator += MW*(Xj)/d[k];
            }
            else
            {
                selfDiffusion_Dii = d[k];
            }            
        }
        Diff[i] = DUnit*( (DiNumerator + 1e-12*selfDiffusion_Dii)/(DiDenominator + 1e-12) );
    }
}

// Compute mu and lambda
forAll(groupSpecies,i)
{
    if(groupSpecies[i][0] != -1)
    {
        // Cantera-like interpolation for thermal conductivity
        Lambda[groupSpecies[i][0]] = lambdaUnit*sqrt(T/TUnit)*(
                                      Lambda1[groupSpecies[i][0]] + tmpT*(
                                        Lambda2[groupSpecies[i][0]] + tmpT*(
                                          Lambda3[groupSpecies[i][0]] + tmpT*(
                                            Lambda4[groupSpecies[i][0]] + tmpT*Lambda5[groupSpecies[i][0]])))
                                      );

        // Cantera-like interpolation for viscosity
        Mu[groupSpecies[i][0]] = MuUnit*sqrt(T/TUnit)*pow(
                                  Mu1[groupSpecies[i][0]] + tmpT*(
                                    Mu2[groupSpecies[i][0]] + tmpT*(
                                      Mu3[groupSpecies[i][0]] + tmpT*(
                                        Mu4[groupSpecies[i][0]] + tmpT*Mu5[groupSpecies[i][0]]))), 2);
                                        
        // The implementation may combine some species, so this is used to 
        // copy-and-paste the values among all of the grouped ones...
        forAll(groupSpecies[i],j)
        {
            if (j > 0)
            {
                Lambda[groupSpecies[i][j]] = Lambda[groupSpecies[i][0]];
                Mu[groupSpecies[i][j]] = Mu[groupSpecies[i][0]];
            }
        }
    }
}

// Mu and Lambda mixture rule
forAll(Y,i)
{
    volScalarField& Xi = X[i];
    volScalarField& Mui = Mu[i];
    yhi *= 0;
    forAll (Y,z)
    {
        volScalarField& Xz = X[z];
        volScalarField& Muz = Mu[z];
        yhi += Xz*0.353553391*pow(1.0 + Foam::sqrt(Mui/Muz)*pow025(composition.Wi(z)/composition.Wi(i)),2)/Foam::sqrt(1.0+composition.Wi(i)/composition.Wi(z));
    }
    mixMu += (Xi)*Mui/yhi;
    
    mixLambdaA += Xi*Lambda[i];
    mixLambdaB += Xi/Lambda[i];
}

mixLambda = 0.5*(mixLambdaA+(1/mixLambdaB));
mixAlpha = 0.5*(mixLambdaA+(1/mixLambdaB))/thermo.Cp();  // OpenFOAM "alpha"

/*
// for Soret effect, thermal diffusion for light species
if(thermalDiffusion)
{
    TDRatio_H *= 0;
    TDRatio_H2 *= 0;
    volScalarField tmpTT = T/TUnit;
    forAll(Y,i)
    {
        if(Y[i].name() == "H")
        {
            forAll(Y,j)
            {
                if(j != i)
                {
                   TDRatio_H += X[i]*X[j]*(TDiff1[j] + tmpTT*(TDiff2[j]+ tmpTT*(TDiff3[j]+tmpTT*TDiff4[j])));
                }
            }			
        }
        
        if(Y[i].name() == "H2")
        {
            forAll(Y,j)
            {
                if(j != i)
                {
                    TDRatio_H2 += X[i]*X[j]*(TDiff1[j+Y.size()] + tmpTT*(TDiff2[j+Y.size()]+ tmpTT*(TDiff3[j+Y.size()]+tmpTT*TDiff4[j+Y.size()])));
                }
            }
        }
    }
}
*/

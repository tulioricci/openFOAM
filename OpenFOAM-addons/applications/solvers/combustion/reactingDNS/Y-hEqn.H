tmp<fv::convectionScheme<scalar> > mvConvection
(
    fv::convectionScheme<scalar>::New
    (
        mesh,
        fields,
        phi,
        mesh.divScheme("div(phi,Yi_h)")
    )
);
//label tmpDebug = solverPerformance::debug; 
//solverPerformance::debug = 0; 

volScalarField Yt(0.0*Y[0]);
for(label i=0; i < Y.size(); i++)
{
    if(i != inertIndex)
    {
        volScalarField& Yi = Y[i];
         
        fvScalarMatrix YEqn
        (
            fvm::ddt(rho, Yi)
            + mvConvection->fvmDiv(phi, Yi)
            - fvm::laplacian(mixAlpha, Yi)
            //- fvm::laplacian(mixAlpha+turbulence->mut()/Sct, Yi)   //Lewis Number to be unity for all species
            ==
            reaction->R(Yi)
            + fvOptions(rho, Yi)
        );
        YEqn.relax();

        fvOptions.constrain(YEqn);

        YEqn.solve("Yi");

        fvOptions.correct(Yi);

        Yi.max(0.0);
        Yt += Yi;
    }
}
// for N2			
Y[inertIndex] = scalar(1) - Yt;
Y[inertIndex].max(0.0);
chemistryhsSource = reaction->Qdot();

// Energy Equation	

volScalarField& he = thermo.he();
fvScalarMatrix EEqn
(
    fvm::ddt(rho, he)
    + mvConvection->fvmDiv(phi, he)
    + fvc::ddt(rho, K)
    + fvc::div(phi, K)
    + (
        he.name() == "e"
        ? fvc::div
        (
            fvc::absolute(phi/fvc::interpolate(rho), U),
            p,
            "div(phiv,p)"
        )
        : -dpdt
    )
    //- fvm::laplacian(mixAlpha+turbulence->mut()/Prt, he)
    - fvm::laplacian(mixAlpha, he)
    ==
    reaction->Qdot()
    + fvOptions(rho, he)
);

EEqn.relax();

fvOptions.constrain(EEqn);

EEqn.solve();

fvOptions.correct(he);

thermo.correct();

Info<< "min/max(T) = " << min(T).value() << ", " << max(T).value() << endl;
Info<< "min/max(P) = " << min(p).value() << ", " << max(p).value() << endl;


//Info << " chemistryhsSource max/min: "<<  max(chemistryhsSource).value() <<" " << min(chemistryhsSource).value() << endl;
//solverPerformance::debug = tmpDebug; 

//Info<< "ExecutionTime = " << runTime.elapsedCpuTime() << " s"
//    << "  ClockTime = " << runTime.elapsedClockTime() << " s"
//            << endl;

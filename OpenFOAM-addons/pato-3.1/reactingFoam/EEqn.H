{
    volScalarField& he = thermo.he();

    Info << turb.type() << endl;

    fvScalarMatrix EEqn
    (
        fvm::ddt(rho, he) + fvm::div(phi, he)
        + fvc::ddt(rho, K) + fvc::div(phi, K)
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
        // FIXME
        //- fvm::laplacian(turb.alphaEff(), he)
        - fvm::laplacian(mixAlpha, he)
        // no contribution from other terms since they cancel out in Le=1 assumption
        ==
        rho*(U&g)
        + rad.Sh(thermo, he)
        + reaction.Qdot()
        + fvOptions(rho, he)
    );

    EEqn.relax();

    fvOptions.constrain(EEqn);

    EEqn.solve(/*he.select(finalIter)*/);

    fvOptions.correct(he);

    thermo.correct();
    rad.correct();

    Info<< "Min/max T:" << min(thermo.T()).value() << ' '
    << max(thermo.T()).value() << endl;
}

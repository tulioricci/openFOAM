// Solve the Momentum equation

MRF.correctBoundaryVelocity(U);

tmp<fvVectorMatrix> tUEqn  // TRR Always using the mixAvg transport!
(
    fvm::ddt(rho, U) + fvm::div(phi, U)
  + MRF.DDt(rho, U)
  - fvm::laplacian(mixMu+turbulence->mut(),U)
  //- fvc::div(((mixMu+turbulence->mut())*dev2(fvc::grad(U)().T()))) // XXX ???
 ==  
  fvOptions(rho, U)
  - rho*sponge*(U - Uref)
);
fvVectorMatrix& UEqn = tUEqn.ref();

UEqn.relax();

fvOptions.constrain(UEqn);

if (pimple.momentumPredictor())
{
    solve
    (
        UEqn
     ==
        fvc::reconstruct
        (
            (
              - ghf*fvc::snGrad(rho)
              - fvc::snGrad(p_rgh)
            )*mesh.magSf()
        )
    );

    fvOptions.correct(U);
    K = 0.5*magSqr(U);
}

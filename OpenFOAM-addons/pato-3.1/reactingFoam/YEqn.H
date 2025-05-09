tmp<fv::convectionScheme<scalar>> mvConvection
(
    fv::convectionScheme<scalar>::New
    (
        mesh,
        fields,
        phi,
        mesh.divScheme("div(phi,Yi)")
    )
);
    
{
  reaction.correct();
//  dQ = reaction.dQ();
  label inertIndex = -1;
  volScalarField Yt(0.0*Y[0]);
  forAll(Y, i)
  {
    if (Y[i].name() != inertSpecie) {
      volScalarField& Yi = Y[i];
      //diffY[i] = turb.muEff();
      fvScalarMatrix YiEqn
      (
          // See Eq. 1.52 in Poinsot and Veynant -- if Le=1, ends up being this:
          fvm::ddt(rho, Yi)
          + mvConvection->fvmDiv(phi, Yi)
          //- fvm::laplacian(turb.muEff(), Yi)
          - fvm::laplacian(mixAlpha, Yi)
          ==
          reaction.R(Yi)
          + fvOptions(rho, Yi)
      );

      YiEqn.relax();

      fvOptions.constrain(YiEqn);

      YiEqn.solve("Yi");

      fvOptions.correct(Yi);

      Yi.max(0.0);
      Yt += Yi;
    }
    else
    {
      inertIndex = i;
    }
  }

  Y[inertIndex] = scalar(1) - Yt;
  Y[inertIndex].max(0.0);
}

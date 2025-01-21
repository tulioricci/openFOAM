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

vk *= 0;
diffsh *= 0;
DiffError *= 0;
surfaceScalarField sumOfOtherSpeices = fvc::interpolate(DiffError) & mesh.Sf();

// Compute correction velocity
forAll(Y,i)
{
    volScalarField& Yi = Y[i];
    volScalarField& Diffi = Diff[i];
    
    // nabla X --  may be singular when using harmonic fluxes
    //DiffError += (rho*Diffi*fvc::grad(Yi) + Yi*rho*Diffi*fvc::grad(MW)/MW);
    
    // nabla Y
    DiffError += rho*Diffi*fvc::grad(Yi);
    
    /* TODO
    volScalarField& Xi = X[i];    
    if (thermalDiffusion)
    {
        if(Y[i].name() == "H")
        {
            DiffError += (-rho*Diffi*TDRatio_H*fvc::grad(T)*Yi/(T*(Xi+SMALL)));
        }
        else if(Y[i].name() == "H2")
        {
            DiffError +=  (-rho*Diffi*TDRatio_H2*fvc::grad(T)*Yi/(T*(Xi+SMALL)));
        }
    }
    */
}

volScalarField Yt(0.0*Y[0]);
surfaceScalarField phiUc = fvc::interpolate(DiffError) & mesh.Sf();  // treat the correction velocity as a velocity

// ************************* TRR
#include "cellZoneMesh.H"

const cellZoneMesh& czMesh = mesh.cellZones();
const word targetZoneName = "porosity";
// ************************* TRR

for(label i=0; i < Y.size(); i++)
{
    if(i != inertIndex)
    {
        volScalarField& Yi = Y[i];
        volScalarField& Diffi = Diff[i];

        // ************************* TRR
        // porosity region
        // TODO put this snippet when computing the diffusivity, and not here?
        label zoneIndex = czMesh.findZoneID(targetZoneName);
        if (zoneIndex != -1) // -1 indicates the zone was not found
        {
            const cellZone& targetZone = czMesh[targetZoneName];

            // Access the cells in the cellZone
            const labelList& cellIndices = targetZone;
            
            forAll(cellIndices, j)
            {
                Diffi[cellIndices[j]] = volFraction[cellIndices[j]]*Diffi[cellIndices[j]];
            }  
        }
        // ************************* TRR
     
        /* TODO 
        if(thermalDiffusion)
        volScalarField& Xi = X[i];
        volScalarField  ThermalDiffRatio = TDRatio_H*0;
        {
            if(Y[i].name() == "H")
            {
               ThermalDiffRatio = TDRatio_H;
            }
            else if(Y[i].name() == "H2")
            {
               ThermalDiffRatio = TDRatio_H2;
            }
            else
            {
               ThermalDiffRatio *= 0;
            }
        }
        */
        
        // *********************************************************************
        // Enthalpy evaluated in this loop, with the species
        // (ideally, it would be more organized if they were split apart)
        
        // for boundaries, obtain it from P and T
        for(label icell = 0; icell < rho.size(); icell++)
        {
            Hsi[icell] = composition.Hs(i, p[icell], T[icell]);
        }

        volScalarField::Boundary& HsiBf = Hsi.boundaryFieldRef();

        forAll(HsiBf, patchi)
        {
            scalarField& HsiPatch = HsiBf[patchi];
            const scalarField& pp = p.boundaryField()[patchi];
            const scalarField& Tp = T.boundaryField()[patchi];

            forAll(HsiPatch, facei)
            {
                HsiPatch[facei] = composition.Hs(i, pp[facei], Tp[facei]);
            }
        }
    
        // TODO TRR surfaceScalarField speicesFlux = fvc::interpolate(rho*Diffi*fvc::grad(Yi) + Yi*rho*Diffi*fvc::grad(MW)/MW + (-rho*Diff[i]*ThermalDiffRatio*fvc::grad(T)*Yi/(T*(Xi+SMALL)))-Yi*DiffError)& mesh.Sf();
        
        // nabla X
        //surfaceScalarField speciesFlux = fvc::interpolate(rho*Diffi*fvc::grad(Yi) + Yi*rho*Diffi*fvc::grad(MW)/MW - Yi*DiffError)& mesh.Sf();
        
        // nabla Y
        surfaceScalarField speciesFlux = fvc::interpolate(rho*Diffi*fvc::grad(Yi) - Yi*DiffError)& mesh.Sf();
        
        vk += fvc::interpolate(Hsi)*speciesFlux;
        sumOfOtherSpeices += speciesFlux;
        diffsh += fvc::laplacian(mixAlpha*Hsi, Yi); // override temperature to enthalpy
        // *********************************************************************
        
        fvScalarMatrix YEqn
        (
          fvm::ddt(rho, Yi)
          + mvConvection->fvmDiv(phi, Yi)
          - fvm::laplacian(rho*Diffi, Yi)
          //- fvc::laplacian(rho*Diffi*Yi/MW,MW) // nabla X
          + mvConvection->fvmDiv(phiUc, Yi)
          // TODO - fvm::laplacian(rho*Diffi+turbulence->mut()/Sct, Yi) // TRR
          // TODO - fvc::laplacian(-rho*Diffi*ThermalDiffRatio*Yi/(T*(Xi+SMALL)),T) // soret effect  Yi/(T*(Xi+SMALL)),T) // TRR
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
        
        omegaDot[i] = reaction->R(Yi) & rho / mag(rho); //composition.Wi(i);
    }
}
// for N2
{
    label i = inertIndex;
    for(label icell = 0; icell < rho.size(); icell++)
    {
        Hsi[icell] = composition.Hs(i, p[icell], T[icell]);
    }

    volScalarField::Boundary& HsiBf = Hsi.boundaryFieldRef();

    forAll(HsiBf, patchi)
    {
        scalarField& HsiPatch = HsiBf[patchi];
        const scalarField& pp = p.boundaryField()[patchi];
        const scalarField& Tp = T.boundaryField()[patchi];

        forAll(HsiPatch, facei)
        {
            HsiPatch[facei] = composition.Hs(i, pp[facei], Tp[facei]);
        }
    }
    
    // this is weird but it is right. It comes from "Y_N2 = 1 - Yt"
    vk += fvc::interpolate(Hsi)*-sumOfOtherSpeices;
    diffsh += fvc::laplacian(mixAlpha*Hsi, 1-Yt);  // XXX: there is a laplacian((mixAlpha*Hsi),(1-(0*C2H4))).. Is this coming from here? Why the zero?
}

Y[inertIndex] = scalar(1) - Yt;
Y[inertIndex].max(0.0);





// TODO : put in separate file
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
    - fvm::laplacian(mixAlpha, he)  // lambda nabla T -- first term
    //- fvm::laplacian(mixAlpha+turbulence->mut()/Prt, he)
    + diffsh  // lambda nabla T -- second term
    - fvc::div(vk)
    ==
    reaction->Qdot()
    + fvOptions(rho, he)
);

EEqn.relax();

fvOptions.constrain(EEqn);

EEqn.solve("he");

fvOptions.correct(he);

thermo.correct();
        
chemistryhsSource = reaction->Qdot();  // visualization only?

Info<< "min/max(T) = " << min(T).value() << ", " << max(T).value() << endl;
Info<< "min/max(P) = " << min(p).value() << ", " << max(p).value() << endl;

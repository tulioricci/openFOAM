#include "fvCFD.H"
#include <cmath>
#include "volFields.H"
#include "surfaceFields.H"

int main(int argc, char *argv[])
{
 
    #include "setRootCase.H"
    #include "createTime.H"
//    #include "createMesh.H"

    // Hardcoded region name here
    Foam::word regionName("flow");
    Foam::Info << "Using hardcoded region: " << regionName << Foam::endl;

    Foam::fvMesh mesh
    (
        Foam::IOobject
        (
            regionName,
            runTime.timeName(),
            runTime,
            Foam::IOobject::MUST_READ,
            Foam::IOobject::AUTO_WRITE
        )
    );

    Foam::Info << "Mesh loaded for region: " << regionName << Foam::endl;

    Foam::volScalarField myVariable
    (
        Foam::IOobject
        (
            "rDeltaT",
            runTime.timeName(),
            mesh,
            Foam::IOobject::NO_READ,
            Foam::IOobject::AUTO_WRITE
        ),
        mesh,
        Foam::dimensionedScalar("zero", dimensionSet(0,0,-1,0,0,0,0), 0.0)
    );

    const Foam::vectorField& C = mesh.C();

    forAll(C, cellI)
    {
        scalar x = C[cellI].x();
        scalar y = C[cellI].y();

        scalar aux;

        // Use OpenFOAM math functions
        //myVariable[cellI] = Foam::sin(x) * Foam::cos(y);
        aux = Foam::sqrt(
            0.5*(1.0 - Foam::tanh(2500.0*(y-0.103))) * 
            0.5*(1.0 - Foam::tanh(500.0*(x-0.050))));
            
        myVariable[cellI] = 1.0/(1e-4*(1-aux) + 1e-6*aux);
    }
    
    // Loop over all patches
    forAll(myVariable.boundaryField(), patchI)
    {
        fvPatchScalarField& patchField = myVariable.boundaryFieldRef()[patchI];

        const fvPatch& patch = mesh.boundary()[patchI];
        const labelList& faceCells = patch.faceCells();  // Owner cells for each face

        forAll(patchField, faceI)
        {
            label cellI = faceCells[faceI];
            patchField[faceI] = myVariable[cellI];  // Nearest cell center value
        }
    }    

    myVariable.write();

    Foam::Info << "Field 'myVariable' written successfully." << Foam::endl;

    return 0;
}


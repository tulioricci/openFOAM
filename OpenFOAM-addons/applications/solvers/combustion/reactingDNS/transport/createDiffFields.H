
//dimensionedScalar pUnit("pUnit",dimensionSet (1,-1,-2,0,0,0,0),1.0);
//dimensionedScalar TUnit("TUnit", dimTemperature, 1.0);
//dimensionedScalar DUnit("DUnit",dimensionSet (0,2,-1,0,0,0,0),1.0);
//dimensionedScalar MuUnit("MuUnit",dimensionSet (1,-1,-1,0,0,0,0),1.0);
//dimensionedScalar lambdaUnit("lambdaUnit",dimensionSet (1,1,-3,-1,0,0,0),1.0);

volScalarField volFraction
(
    IOobject
    (
        "volFraction",
        runTime.timeName(),
        mesh,
        IOobject::READ_IF_PRESENT,
        IOobject::AUTO_WRITE
    ),
    mesh,  
    dimensionedScalar("volFraction",dimensionSet (0,0,0,0,0,0,0),1.0)
);

PtrList<volScalarField> omegaDot(Y.size());
forAll(Y,i)
{
    word name("omegaDot"+Y[i].name());
    omegaDot.set
    (
    i,new volScalarField
        ( 
        IOobject
        (
            name,
            runTime.timeName(),
            mesh,
            IOobject::NO_READ,
            //IOobject::AUTO_WRITE
            IOobject::NO_WRITE
        ),
        mesh,  
        dimensionedScalar(name,dimensionSet (1,-3,-1,0,0,0,0),0)
        )
    );
}

// *****************************************************************************

volScalarField MW
(
    IOobject
    (
        "MW",
        runTime.constant(),
        mesh,
        IOobject::NO_READ,
        IOobject::NO_WRITE
    ),
    mesh,
    dimensionedScalar("MW",dimensionSet (0,0,0,0,0,0,0),0.0)
);

volScalarField chemistryhsSource
(
    IOobject
    (
        "chemistryhsSource",
        runTime.timeName(),
        mesh,
        IOobject::NO_READ,
        IOobject::AUTO_WRITE
        //false
    ),
    mesh,
    dimensionedScalar("chemistryhsSource", dimEnergy/dimTime/dimVolume, 0.0)
);

PtrList<volScalarField> Diff(Y.size());
forAll(Y,i)
{
    word name("Diff"+Y[i].name());
    Diff.set
    (
    i,new volScalarField
        ( 
        IOobject
        (
            name,
            runTime.timeName(),
            mesh,
            IOobject::NO_READ,
            IOobject::NO_WRITE
            //IOobject::AUTO_WRITE
        ),
        mesh,  
        dimensionedScalar(name,dimensionSet (0,2,-1,0,0,0,0),0)
        )
    );
}

PtrList<volScalarField> d(0.5*Y.size()*(Y.size()+1));
forAll(d,i)
{
    word name("d"+i);
    d.set
    (
    i,new volScalarField
        ( 
        IOobject
        (
            name,
            runTime.timeName(),
            mesh,
            IOobject::NO_READ,
            IOobject::NO_WRITE
        ),
        mesh,  
        dimensionedScalar(name,dimensionSet (0,0,0,0,0,0,0),0)
        )
    );
}

PtrList<volScalarField> X(Y.size());
forAll(X,i)
{
    word name("X"+Y[i].name());
    X.set
    (
    i,new volScalarField
        ( 
        IOobject
        (
            name,
            runTime.timeName(),
            mesh,
            IOobject::NO_READ,
            IOobject::NO_WRITE
        ),
        mesh,  
        dimensionedScalar(name,dimensionSet (0,0,0,0,0,0,0),0)
        )
    );
}

List<dimensionedScalar> Diff1(0.5*Y.size()*(Y.size()+1));
List<dimensionedScalar> Diff2(0.5*Y.size()*(Y.size()+1));
List<dimensionedScalar> Diff3(0.5*Y.size()*(Y.size()+1));
List<dimensionedScalar> Diff4(0.5*Y.size()*(Y.size()+1));
List<dimensionedScalar> Diff5(0.5*Y.size()*(Y.size()+1));

volScalarField DiNumerator
(
    IOobject
    (
        "DiNumerator",
        runTime.timeName(),
        mesh,
        IOobject::NO_READ,
        IOobject::NO_WRITE
    ),
    mesh,
    dimensionedScalar("DiNumerator",dimensionSet (0,0,0,0,0,0,0),0.0)
);

volScalarField DiDenominator
(
    IOobject
    (
        "DiDenominator",
        runTime.timeName(),
        mesh,
        IOobject::NO_READ,
        IOobject::NO_WRITE
    ),
    mesh,
    dimensionedScalar("DiDenominator",dimensionSet (0,0,0,0,0,0,0),0.0)
);

volScalarField Di
(
    IOobject
    (
        "Di",
        runTime.timeName(),
        mesh,
        IOobject::NO_READ,
        IOobject::NO_WRITE
    ),
    mesh,
    dimensionedScalar("Di",dimensionSet (0,2,-1,0,0,0,0),0.0)
);

volScalarField selfDiffusion_Dii
(
    IOobject
    (
        "selfDiffusion_Dii",
        runTime.timeName(),
        mesh,
        IOobject::NO_READ,
        IOobject::NO_WRITE
    ),
    mesh,
    dimensionedScalar("selfDiffusion_Dii",dimensionSet (0,0,0,0,0,0,0),0.0)
);

volScalarField Hsi
(
    IOobject
    (
        "Hsi",
        runTime.timeName(),
        mesh,
        IOobject::NO_READ,
        IOobject::NO_WRITE
    ),
    mesh,
    dimensionedScalar("Hsi",dimensionSet (0,2,-2,0,0,0,0),0.0),
    zeroGradientFvPatchScalarField::typeName
);

volVectorField DiffError
(
    IOobject
    (
        "DiffError",
        runTime.timeName(),
        mesh,
        IOobject::NO_READ,
        IOobject::NO_WRITE
    ),
    mesh,
    dimensionedVector("DiffError",dimensionSet (1,-2,-1,0,0,0,0),vector::zero)
);

surfaceScalarField vk
(
    IOobject
    (
        "vk",
        runTime.timeName(),
        mesh,
        IOobject::NO_READ,
        IOobject::NO_WRITE
    ),
    mesh,
    dimensionedScalar("vk",dimensionSet(1,2,-3,0,0,0,0),0.0)
);

volScalarField diffsh
(
    IOobject
    (
        "diffsh",
        runTime.timeName(),
        mesh,
        IOobject::NO_READ,
        IOobject::NO_WRITE
    ),
    mesh,
    dimensionedScalar("diffsh", dimEnergy/dimTime/dimVolume, 0.0)
);

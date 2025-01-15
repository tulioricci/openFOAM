Info << "Read speciesMu" << endl;

IOdictionary speciesMu
(
    IOobject
    (
        "speciesMu",
        runTime.constant(),
        mesh,
        IOobject::MUST_READ_IF_MODIFIED,
        IOobject::NO_WRITE
    )
);

//******in order to give unit to the log polynomial coefficient***//
const dimensionedScalar speciesMuUnit
(
   "speciesMuUnit",
   dimensionSet(0,0,0,0,0,0,0),
    1.0
);

forAll(groupSpecies,i)
{
    dictionary muDict;
    if(groupSpecies[i][0] != -1)
    {
        forAll(groupSpecies[i],j)
        {
            if(speciesMu.found(Y[groupSpecies[i][j]].name()))
            {
                muDict = speciesMu.subDict(Y[groupSpecies[i][j]].name());
                forAll(groupSpecies[i],j)
                {
                    Mu1[groupSpecies[i][j]].dimensions().reset(dimensionSet(0,0,0,0,0,0,0));
                    Mu2[groupSpecies[i][j]].dimensions().reset(dimensionSet(0,0,0,0,0,0,0));
                    Mu3[groupSpecies[i][j]].dimensions().reset(dimensionSet(0,0,0,0,0,0,0));
                    Mu4[groupSpecies[i][j]].dimensions().reset(dimensionSet(0,0,0,0,0,0,0));
                    Mu5[groupSpecies[i][j]].dimensions().reset(dimensionSet(0,0,0,0,0,0,0));

                    Mu1[groupSpecies[i][j]] = readScalar(muDict.lookup("Mu1")) * speciesMuUnit;
                    Mu2[groupSpecies[i][j]] = readScalar(muDict.lookup("Mu2")) * speciesMuUnit;
                    Mu3[groupSpecies[i][j]] = readScalar(muDict.lookup("Mu3")) * speciesMuUnit;
                    Mu4[groupSpecies[i][j]] = readScalar(muDict.lookup("Mu4")) * speciesMuUnit;
                    Mu5[groupSpecies[i][j]] = readScalar(muDict.lookup("Mu5")) * speciesMuUnit;
                }
                break;
            }
            else 
            {
                if( j == (groupSpecies[i].size()-1) )
                {
                    Info << "species viscosity log polynomial fitting coefficient for " << endl;
                    Info << "(" << endl;
                    forAll(groupSpecies[i],j)
                    {
	                    Info << Y[groupSpecies[i][j]].name() << endl;
                    }
                    Info << ")" << endl;
                    Info << " are not provided in constant/speciesMu" <<	FatalErrorIn( "something wrong in your constant/speciesMu") << abort(FatalError);
                }					
            }
        }
    }
}

Info << "species viscosity log polynomial fitting coefficient" << endl;
Info << "(" << endl;
forAll(Y,i)
{
    Info << Y[i].name() << tab << Mu1[i].value() << tab << Mu2[i].value() << tab << Mu3[i].value() << tab << Mu4[i].value() << tab << Mu5[i].value() << endl;
}
Info << ")" << endl;

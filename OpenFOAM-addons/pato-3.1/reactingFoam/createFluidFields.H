// Initialise fluid field pointer lists
thermoFluid.resize(fluidRegions.size());
reactionFluid.resize(fluidRegions.size());
rhoFluid.resize(fluidRegions.size());
UFluid.resize(fluidRegions.size());
phiFluid.resize(fluidRegions.size());
gFluid.resize(fluidRegions.size());
hRefFluid.resize(fluidRegions.size());
ghFluid.resize(fluidRegions.size());
ghfFluid.resize(fluidRegions.size());
turbulence.resize(fluidRegions.size());
p_rghFluid.resize(fluidRegions.size());
radiation.resize(fluidRegions.size());
KFluid.resize(fluidRegions.size());
dpdtFluid.resize(fluidRegions.size());
//dQFluid.resize(fluidRegions.size());

initialMassFluid.resize(fluidRegions.size());
frozenFlowFluid.resize(fluidRegions.size(), false);

MRFfluid.resize(fluidRegions.size());
fluidFvOptions.resize(fluidRegions.size());
fieldsFluid.resize(fluidRegions.size());

MWFluid.resize(fluidRegions.size());
XFluid.resize(fluidRegions.size());
mixMuFluid.resize(fluidRegions.size());
mixAlphaFluid.resize(fluidRegions.size());
WilkeMixtureRule.resize(fluidRegions.size());
mixLambdaA.resize(fluidRegions.size());
mixLambdaB.resize(fluidRegions.size());

// Populate fluid field pointer lists
forAll(fluidRegions, i)
{
  Info << "*** Reading fluid mesh thermophysical properties for region "
      << fluidRegions[i].name() << nl << endl;

  Info << "    Creating combustion model\n" << endl;

  thermoFluid.set
  (
      i,
      rhoReactionThermo::New(fluidRegions[i]).ptr()
  );

  Info << "    Adding to rhoFluid\n" << endl;
  rhoFluid.set
  (
      i,
      new volScalarField
      (
          IOobject
          (
              "rho",
              runTime.timeName(),
              fluidRegions[i],
              IOobject::NO_READ,
              IOobject::AUTO_WRITE
          ),
          thermoFluid[i].rho()
      )
  );

  Info << "    Adding to UFluid\n" << endl;
  UFluid.set
  (
      i,
      new volVectorField
      (
          IOobject
          (
              "U",
              runTime.timeName(),
              fluidRegions[i],
              IOobject::MUST_READ,
              IOobject::AUTO_WRITE
          ),
          fluidRegions[i]
      )
  );

  Info << "    Adding to phiFluid\n" << endl;
  phiFluid.set
  (
      i,
      new surfaceScalarField
      (
          IOobject
          (
              "phi",
              runTime.timeName(),
              fluidRegions[i],
              IOobject::READ_IF_PRESENT,
              IOobject::AUTO_WRITE
          ),
          linearInterpolate(rhoFluid[i]*UFluid[i])
          & fluidRegions[i].Sf()
      )
  );

  Info << "    Adding to gFluid\n" << endl;
  gFluid.set
  (
      i,
      new uniformDimensionedVectorField
      (
          IOobject
          (
              "g",
              runTime.constant(),
              fluidRegions[i],
              IOobject::MUST_READ,
              IOobject::NO_WRITE
          )
      )
  );

  Info << "    Adding to hRefFluid\n" << endl;
  hRefFluid.set
  (
      i,
      new uniformDimensionedScalarField
      (
          IOobject
          (
              "hRef",
              runTime.constant(),
              fluidRegions[i],
              IOobject::READ_IF_PRESENT,
              IOobject::NO_WRITE
          ),
          dimensionedScalar("hRef", dimLength, 0)
      )
  );

  dimensionedScalar ghRef
  (
      mag(gFluid[i].value()) > SMALL
      ? gFluid[i]
      & (cmptMag(gFluid[i].value())/mag(gFluid[i].value()))*hRefFluid[i]
      : dimensionedScalar("ghRef", gFluid[i].dimensions()*dimLength, 0)
  );

  Info << "    Adding to ghFluid\n" << endl;
  ghFluid.set
  (
      i,
      new volScalarField
      (
          "gh",
          (gFluid[i] & fluidRegions[i].C()) - ghRef
      )
  );

  Info << "    Adding to ghfFluid\n" << endl;
  ghfFluid.set
  (
      i,
      new surfaceScalarField
      (
          "ghf",
          (gFluid[i] & fluidRegions[i].Cf()) - ghRef
      )
  );

  Info << "    Adding to turbulence\n" << endl;
  turbulence.set
  (
      i,
      compressible::turbulenceModel::New
      (
          rhoFluid[i],
          UFluid[i],
          phiFluid[i],
          thermoFluid[i]
      ).ptr()
  );

  reactionFluid.set
  (   i,
      CombustionModel<rhoReactionThermo>::New(thermoFluid[i], turbulence[i]).ptr()
  );

  p_rghFluid.set
  (
      i,
      new volScalarField
      (
          IOobject
          (
              "p_rgh",
              runTime.timeName(),
              fluidRegions[i],
              IOobject::MUST_READ,
              IOobject::AUTO_WRITE
          ),
          fluidRegions[i]
      )
  );

  // Force p_rgh to be consistent with p
  p_rghFluid[i] = thermoFluid[i].p() - rhoFluid[i]*ghFluid[i];

  fluidRegions[i].setFluxRequired(p_rghFluid[i].name());

  radiation.set
  (
      i,
      radiationModel::New(thermoFluid[i].T())
  );

  initialMassFluid[i] = fvc::domainIntegrate(rhoFluid[i]).value();

  Info << "    Adding to KFluid\n" << endl;
  KFluid.set
  (
      i,
      new volScalarField
      (
          "K",
          0.5*magSqr(UFluid[i])
      )
  );

  Info << "    Adding to dpdtFluid\n" << endl;
  dpdtFluid.set
  (
      i,
      new volScalarField
      (
          IOobject
          (
              "dpdt",
              runTime.timeName(),
              fluidRegions[i]
          ),
          fluidRegions[i],
          dimensionedScalar
          (
              "dpdt",
              thermoFluid[i].p().dimensions()/dimTime,
              0
          )
      )
  );


//  Info << "    Adding to dQ\n" << endl;
//  dQFluid.set
//  (
//      i,
//      new volScalarField
//      (
//          IOobject
//          (
//              "dQ",
//              runTime.timeName(),
//              fluidRegions[i],
//              IOobject::NO_READ,
//              IOobject::AUTO_WRITE
//          ),
//          fluidRegions[i],
//          dimensionedScalar
//          (
//              "dQ",
//              dimEnergy/dimTime,
//              0
//          )
//      )
//  );

  const dictionary& pimpleDict =
      fluidRegions[i].solutionDict().subDict("PIMPLE");
  pimpleDict.readIfPresent("frozenFlow", frozenFlowFluid[i]);

  Info << "    Adding MRF\n" << endl;
  MRFfluid.set
  (
      i,
      new IOMRFZoneList(fluidRegions[i])
  );

  Info << "    Adding fvOptions\n" << endl;
  fluidFvOptions.set
  (
      i,
      new fv::options(fluidRegions[i])
  );

  turbulence[i].validate();

  fieldsFluid.set
  (
      i,
      new multivariateSurfaceInterpolationScheme<scalar>::fieldTable
  );

  basicMultiComponentMixture& composition = thermoFluid[i].composition();

  forAll(composition.Y(), j) {
    fieldsFluid[i].add(composition.Y()[i]);
  }

  fieldsFluid[i].add(thermoFluid[i].he());

  dynamicFvMesh& mesh_ = fluidRegions[i];

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  diffY.resize(composition.Y().size());
  forAll(composition.Y(), specI) {
    word diffYName = "diffY["+composition.Y()[specI].name()+"]";
    diffY.set(
        specI,
        new volScalarField
        (
            IOobject
            (
                diffYName,
                mesh_.time().timeName(),
                mesh_,
                IOobject::READ_IF_PRESENT,
                IOobject::NO_WRITE
            ),
            mesh_,
            dimensionedScalar("0", dimensionSet(1,-1,-1,0,0), 0.0)
        )
    );
  }
  forAll(mesh_.boundaryMesh(), patchI) {
    forAll(composition.Y(), specI) {
      word diffYName = "diffY["+composition.Y()[specI].name()+"]";
      forAll(mesh_.boundaryMesh(), patchI) {
        if (isA<coupledMixedFvPatchScalarField>(composition.Y()[specI].boundaryFieldRef()[patchI])) {
          coupledMixedFvPatchScalarField& cm_ =  refCast<coupledMixedFvPatchScalarField>(composition.Y()[specI].boundaryFieldRef()[patchI]);
          word name = composition.Y()[specI].name();
          if (composition.Y()[specI].name()=="C") {
            name = "C(gr)";
          }
          cm_.setTnbrName(name);
          cm_.setKappa(diffYName);
        }
      }
    }
  }

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  MWFluid.set
  (
      i,
      new volScalarField
      (
          IOobject
          (
              "MW",
              runTime.timeName(),
              fluidRegions[i],
              IOobject::NO_READ,
              IOobject::NO_WRITE
          ),
          fluidRegions[i],
          dimensionedScalar("MW",dimensionSet (0,0,0,0,0,0,0),0.0)
      )
  );
    
  XFluid.resize(composition.Y().size());
  forAll(composition.Y(), specI)
  {
      word moleName = "X" + composition.Y()[specI].name();
      XFluid.set
      (
          specI,
          new volScalarField
          ( 
              IOobject
              (
                  moleName,
                  fluidRegions[i].time().timeName(),
                  fluidRegions[i],
                  IOobject::NO_READ,
                  IOobject::NO_WRITE
              ),
              fluidRegions[i],  
              dimensionedScalar(moleName, dimensionSet(0,0,0,0,0,0,0), 0)
          )
      );
  }

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  MuY.resize(composition.Y().size());
  forAll(composition.Y(), specI) {
    word MuYName = "MuY["+composition.Y()[specI].name()+"]";
    MuY.set(
        specI,
        new volScalarField
        (
            IOobject
            (
                MuYName,
                mesh_.time().timeName(),
                mesh_,
                IOobject::NO_READ,
                IOobject::NO_WRITE
            ),
            mesh_,
            dimensionedScalar(MuYName,dimensionSet (1,-1,-1,0,0,0,0),0)
        )
    );
  }

  WilkeMixtureRule.set
  (
      i,
      new volScalarField
      (
          IOobject
          (
              "mixRule",
              runTime.timeName(),
              fluidRegions[i],
              IOobject::NO_READ,
              IOobject::NO_WRITE
          ),
          fluidRegions[i],
          dimensionedScalar("mixRule",dimensionSet (0,0,0,0,0,0,0),0.0)
      )
  );

  mixMuFluid.set
  (
      i,
      new volScalarField
      (
          IOobject
          (
              "mixMu",
              runTime.timeName(),
              fluidRegions[i],
              IOobject::NO_READ,
              IOobject::AUTO_WRITE
          ),
          fluidRegions[i],
          dimensionedScalar("mixMu",dimensionSet (1,-1,-1,0,0,0,0),0.0)
      )
  );

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  LambdaY.resize(composition.Y().size());
  forAll(composition.Y(), specI) {
      word LambdaYName = "LambdaY["+composition.Y()[specI].name()+"]";
      LambdaY.set(
          specI,
          new volScalarField
          (
              IOobject
              (
                  LambdaYName,
                  mesh_.time().timeName(),
                  mesh_,
                  IOobject::NO_READ,
                  IOobject::NO_WRITE
              ),
              mesh_,
              dimensionedScalar(LambdaYName,dimensionSet (1,1,-3,-1,0,0,0),0)
          )
      );
  }

  mixLambdaA.set
  (
      i,
      new volScalarField
      (
          IOobject
          (
              "mixLambdaA",
              runTime.timeName(),
              fluidRegions[i],
              IOobject::NO_READ,
              IOobject::NO_WRITE
          ),
          fluidRegions[i],
          dimensionedScalar("mixLambdaA",dimensionSet (1,1,-3,-1,0,0,0),0.0)
      )
  ); 
  
  mixLambdaB.set
  (
      i,
      new volScalarField
      (
          IOobject
          (
              "mixLambdaB",
              runTime.timeName(),
              fluidRegions[i],
              IOobject::NO_READ,
              IOobject::NO_WRITE
          ),
          fluidRegions[i],
          dimensionedScalar("mixLambdaB",dimensionSet (-1,-1,3,1,0,0,0),0.0)
      )
  );

  mixAlphaFluid.set
  (
      i,
      new volScalarField
      (
          IOobject
          (
              "mixAlpha",
              runTime.timeName(),
              fluidRegions[i],
              IOobject::NO_READ,
              IOobject::AUTO_WRITE
          ),
          fluidRegions[i],
          dimensionedScalar("mixAlpha",dimensionSet (1,-1,-1,0,0,0,0),0.0)
      )
  );

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  // TODO: simplify this
  
  IFstream speciesInfo(mesh_.time().constant()/"flow/trandat");
  if(!speciesInfo.good())
  {
      Info << mesh_.time().constant() << endl;
      Info << FatalErrorIn( "cannot open trandat in constant") << abort(FatalError);
  }
  Foam::string   headerStr;
  Foam::word    thisSpecies;
  boolList foundSpecies(composition.Y().size(), false);
  List<scalarList> trandata(composition.Y().size());
  forAll(trandata,specI)
  {
      trandata[specI].setSize(6, 0.0);
  }

  speciesInfo.Foam::ISstream::getLine(headerStr);
  while( !speciesInfo.eof() )
  {
      speciesInfo >> thisSpecies;
      if(!speciesInfo.bad() )
      {
          for(label ii=0; ii< composition.Y().size() ; ii++)
          {
              if(thisSpecies == composition.Y()[ii].name())
              { 
                  foundSpecies[ii] = true;
                  speciesInfo >> trandata[ii][0] >> trandata[ii][1] >> trandata[ii][2] >> trandata[ii][3]  >> trandata[ii][4]  >> trandata[ii][5];
                  Info << "Read the trandata of " << thisSpecies << tab <<
                      trandata[ii][0] << tab << trandata[ii][1] << tab <<
                      trandata[ii][2] << tab << trandata[ii][3] << tab <<
                      trandata[ii][4] << tab << trandata[ii][5] << tab << endl;
              }
          }
      }
      speciesInfo.Foam::ISstream::getLine(headerStr);	
  }

  forAll(composition.Y(),specI)
  {
      if(!foundSpecies[specI])
      {
         Info << " species trandata for " << composition.Y()[specI].name() << " is not found in constant/trandat "<< FatalErrorIn("something wrong in your constant/trandat") << abort(FatalError);	
      }		
  }
  // group the species that have the same trandata
  List<scalarList> groupSpecies(composition.Y().size());
  forAll(groupSpecies,specI)
  {
      groupSpecies[specI].setSize(1,specI);
  }

  forAll(groupSpecies,specI)
  {
      if(groupSpecies[specI].size() > 1)
      {
          Info << "trandata group species:  " << endl;
          Info << "(" << endl;
          forAll(groupSpecies[specI],j)
          {
              Info << composition.Y()[groupSpecies[specI][j]].name() << endl;
          }
          Info << ")" << endl;
      }
  }

  Info << "trandata reduced species list:  " << endl;
  Info << "(" << endl;
  forAll(groupSpecies, specI)
  {
      if(groupSpecies[specI][0] != -1)
      {
          Info << composition.Y()[groupSpecies[specI][0]].name() << endl;		
      }
  }
  Info << ")" << endl;

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  Info << "Read speciesLambda" << endl;

  IOdictionary speciesLambda
  (
      IOobject
      (
          "speciesLambda",
          runTime.constant(),
          mesh_,
          IOobject::MUST_READ_IF_MODIFIED,
          IOobject::NO_WRITE
      )
  );

  Lambda1.resize(composition.Y().size());
  Lambda2.resize(composition.Y().size());
  Lambda3.resize(composition.Y().size());
  Lambda4.resize(composition.Y().size());
  Lambda5.resize(composition.Y().size());

  forAll(groupSpecies, specI)
  {
      dictionary lambdaDict;
      if(groupSpecies[specI][0] != -1)
      {
          forAll(groupSpecies[specI],j)
          {
              if(speciesLambda.found(composition.Y()[groupSpecies[specI][j]].name()))
              {
                  lambdaDict = speciesLambda.subDict(composition.Y()[groupSpecies[specI][j]].name());
                  forAll(groupSpecies[specI],j)
                  {
                      Lambda1[groupSpecies[specI][j]] = readScalar(lambdaDict.lookup("Lambda1"));
                      Lambda2[groupSpecies[specI][j]] = readScalar(lambdaDict.lookup("Lambda2"));
                      Lambda3[groupSpecies[specI][j]] = readScalar(lambdaDict.lookup("Lambda3"));
                      Lambda4[groupSpecies[specI][j]] = readScalar(lambdaDict.lookup("Lambda4"));
                      Lambda5[groupSpecies[specI][j]] = readScalar(lambdaDict.lookup("Lambda5"));
                  }
                  break;
              }
              else 
              {
                  if( j == (groupSpecies[specI].size()-1) )
                  {
                      Info << "species conductivity log polynomial fitting coefficient for " << endl;
                      Info << "(" << endl;
                      forAll(groupSpecies[specI],j)
                      {
                          Info << composition.Y()[groupSpecies[specI][j]].name() << endl;
                      }
                      Info << ")" << endl;
                      Info << " are not provided in constant/speciesLambda" <<	FatalErrorIn( "something wrong in your constant/speciesLambda") << abort(FatalError);
                  }					
              }
          }
      }
  }

  Info << "species conductivity log polynomial fitting coefficient" << endl;
  Info << "(" << endl;
  forAll(composition.Y(), specI)
  {
      Info << composition.Y()[specI].name() << tab <<
        Lambda1[specI].value() << tab <<
        Lambda2[specI].value() << tab <<
        Lambda3[specI].value() << tab <<
        Lambda4[specI].value() << tab <<
        Lambda5[specI].value() << endl;
  }
  Info << ")" << endl;


  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  Info << "Read speciesMu" << endl;

  IOdictionary speciesMu
  (
      IOobject
      (
          "speciesMu",
          runTime.constant(),
          mesh_,
          IOobject::MUST_READ_IF_MODIFIED,
          IOobject::NO_WRITE
      )
  );

  Mu1.resize(composition.Y().size());
  Mu2.resize(composition.Y().size());
  Mu3.resize(composition.Y().size());
  Mu4.resize(composition.Y().size());
  Mu5.resize(composition.Y().size());

  forAll(groupSpecies, specI)
  {
      dictionary muDict;
      if(groupSpecies[specI][0] != -1)
      {
          forAll(groupSpecies[specI],j)
          {
              if(speciesMu.found(composition.Y()[groupSpecies[specI][j]].name()))
              {
                  muDict = speciesMu.subDict(composition.Y()[groupSpecies[specI][j]].name());
                  forAll(groupSpecies[specI],j)
                  {
                      Mu1[groupSpecies[specI][j]] = readScalar(muDict.lookup("Mu1"));
                      Mu2[groupSpecies[specI][j]] = readScalar(muDict.lookup("Mu2"));
                      Mu3[groupSpecies[specI][j]] = readScalar(muDict.lookup("Mu3"));
                      Mu4[groupSpecies[specI][j]] = readScalar(muDict.lookup("Mu4"));
                      Mu5[groupSpecies[specI][j]] = readScalar(muDict.lookup("Mu5"));
                  }
                  break;
              }
              else 
              {
                  if( j == (groupSpecies[specI].size()-1) )
                  {
                      Info << "species viscosity log polynomial fitting coefficient for " << endl;
                      Info << "(" << endl;
                      forAll(groupSpecies[specI],j)
                      {
                          Info << composition.Y()[groupSpecies[specI][j]].name() << endl;
                      }
                      Info << ")" << endl;
                      Info << " are not provided in constant/speciesMu" << FatalErrorIn( "something wrong in your constant/speciesMu") << abort(FatalError);
                  }					
              }
          }
      }
  }

  Info << "Species viscosity log-polynomial fitting coefficients" << endl;
  Info << "(" << endl;
  forAll(composition.Y(), specI)
  {
      Info << composition.Y()[specI].name() << tab <<
        Mu1[specI].value() << tab <<
        Mu2[specI].value() << tab <<
        Mu3[specI].value() << tab <<
        Mu4[specI].value() << tab <<
        Mu5[specI].value() << endl;
  }
  Info << ")" << endl;
  
  
  
}

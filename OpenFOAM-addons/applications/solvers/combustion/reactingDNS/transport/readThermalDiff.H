//*****************S. Zhong 2020.09.08******************//
Info << "Read thermoDiff" << endl;
IOdictionary thermoDiff
(
IOobject
    (
    "thermoDiff",
    runTime.constant(),
    mesh,
    IOobject::MUST_READ_IF_MODIFIED,
    IOobject::NO_WRITE
    )
);


const dimensionedScalar tdUnit
(
   "tdUnit",
   dimensionSet(0,0,0,0,0,0,0),
    1.0
);
boolList tflags(2*Y.size(), true);

if(thermalDiffusion)
{
  forAll(Y,i)
  {
      if(groupSpecies[i][0] != -1)
      {
          if(Y[i].name() == "H" || Y[i].name() == "H2")
          {
              dictionary tdDict;
              forAll(groupSpecies,j)
              {
                  if(groupSpecies[j][0] != -1)
                  {
                      forAll(groupSpecies[j],z)
                      {
                          bool foundDict = false;
                          if(thermoDiff.found(Y[i].name()+"-"+Y[groupSpecies[j][z]].name()))
                          {
                              tdDict = thermoDiff.subDict(Y[i].name()+"-"+Y[groupSpecies[j][z]].name());
                              foundDict = true;
                          }
                          else if(thermoDiff.found(Y[groupSpecies[j][z]].name()+"-"+Y[i].name()))
                          {
                              tdDict = thermoDiff.subDict(Y[groupSpecies[j][z]].name()+"-"+Y[i].name());
                              foundDict = true;
                          }
                          else 
                          {
                              if( z == (groupSpecies[j].size()-1) )
                              {
                                  Info << "thermal diffsusion coefficient for " << Y[i].name() << " and " << endl;
                                  Info << "(" << endl;
                                  forAll(groupSpecies[j],z)
                                  {
                                      Info << Y[groupSpecies[j][z]].name() << endl;
                                  }
                                  Info << ")" << endl;
                                  Info << " are not provided in constant/thermoDiff" <<	FatalErrorIn( "something wrong in your constant/thermoDiff") << abort(FatalError);
                              }					
                          }
                          
                          if(foundDict)
                          {
                              forAll(groupSpecies[j],z)
                              {
                                  if( i != groupSpecies[j][z])
                                  {
                                      label k = -1;
                                      if(Y[i].name() == "H")
                                      {
                                          k = groupSpecies[j][z];
                                      }
                                      if(Y[i].name() == "H2")
                                      {
                                          k = Y.size()+groupSpecies[j][z];
                                      }
                                          if(tflags[k])
                                      {
                                          TDiff1[k].dimensions().reset(dimensionSet(0,0,0,0,0,0,0));
                                          TDiff2[k].dimensions().reset(dimensionSet(0,0,0,0,0,0,0));
                                          TDiff3[k].dimensions().reset(dimensionSet(0,0,0,0,0,0,0));
                                          TDiff4[k].dimensions().reset(dimensionSet(0,0,0,0,0,0,0));

                                          TDiff1[k] = readScalar(tdDict.lookup("ThermDiff_1")) * tdUnit;
                                          TDiff2[k] = readScalar(tdDict.lookup("ThermDiff_2")) * tdUnit;
                                          TDiff3[k] = readScalar(tdDict.lookup("ThermDiff_3")) * tdUnit;
                                          TDiff4[k] = readScalar(tdDict.lookup("ThermDiff_4")) * tdUnit;
                                          tflags[k] = false;
                                      }
                                  }
                              }
                              break;
                          }
                      }
                  }
              }
          }
      }		
  }


  Info << "species (H and H2, molecular weight less than 5) thermal diffusion ratio polynomial fitting coefficient" << endl;
  Info << "(" << endl;
  forAll(Y,i)
  {
      if(Y[i].name() == "H" || Y[i].name() == "H2")
      {
          for (label j = 0; j < Y.size(); j++)
          {
              label k = -1;
              if(Y[i].name() == "H")
              {
                  k = j;
                  Info << Y[i].name() << "-" << Y[j].name() << tab << TDiff1[k].value() << tab << TDiff2[k].value() << tab << TDiff3[k].value() << tab << TDiff4[k].value() << endl;
              }
              if(Y[i].name() == "H2")
              {
                  k = Y.size()+j;
                  Info << Y[i].name() << "-" << Y[j].name() << tab << TDiff1[k].value() << tab << TDiff2[k].value() << tab << TDiff3[k].value() << tab << TDiff4[k].value() << endl;
              }
          }
      }
  }
  Info << ")" << endl;
  
}

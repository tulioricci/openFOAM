reconstructPar -region alumina
reconstructPar -region graphite
reconstructPar -region porousMat
reconstructPar -region flow

foamToVTK -region alumina
foamToVTK -region graphite
foamToVTK -region porousMat
foamToVTK -region flow

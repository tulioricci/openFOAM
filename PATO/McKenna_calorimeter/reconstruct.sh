#reconstructPar -region alumina
#reconstructPar -region graphite
#reconstructPar -region porousMat
#reconstructPar -region flow

endTime=0.0
for i in "$@"; do
  case $i in
    -t=*|--time=*)
    endTime="${i#*=}"
    shift # past argument=value
    ;;
  esac
done

reconstructPar -allRegions -newTimes

foamToVTK -region alumina -time $endTime:
foamToVTK -region graphite -time $endTime:
foamToVTK -region porousMat -time $endTime:
foamToVTK -region flow -time $endTime:

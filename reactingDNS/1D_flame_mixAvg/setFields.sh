
set -e

rm -rf 0.000000
rm -rf dynamicCode
rm -rf constant/polyMesh
rm -rf processor?
find -name "cellToRegion" -delete

#~~~ Create IC file
cp -r init_cond 0.000000
cd 0.000000
python3 setup_Cantera.py
cd ../

#~~~
gmsh flame.geo -parse_and_exit
gmshToFoam mesh.msh
line=$(grep -n "frontAndBack" constant/polyMesh/boundary | cut -f1 -d:)
type_line=$(($line+2))
sed -i "${type_line}s/patch/empty/" constant/polyMesh/boundary | sed -n "${type_line}p"
phys_line=$(($line+3))
sed -i "${phys_line}s/patch/empty/" constant/polyMesh/boundary | sed -n "${phys_line}p"

#~~~ Initial condition
setFields

#~~~ Domain decomposition 
#decomposePar

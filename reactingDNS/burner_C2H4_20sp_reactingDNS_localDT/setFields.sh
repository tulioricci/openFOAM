
set -e

rm -rf 0.000000
rm -rf dynamicCode
rm -rf constant/polyMesh
rm -rf processor?
find -name "cellToRegion" -delete

#~~~ Create IC file
cp -r init_cond 0.000000
cd 0.000000
#python3 setup_Cantera.py --phi 1.00
python3 setup_Neumann.py --phi 1.00 --slpm 25
cd ../

#~~~
gmsh mesh_v7_HAB=10mm.geo -parse_and_exit
gmshToFoam mesh.msh
line=$(grep -n "f_front" constant/polyMesh/boundary | cut -f1 -d:)
type_line=$(($line+2))
sed -i "${type_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${type_line}p"
phys_line=$(($line+3))
sed -i "${phys_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${phys_line}p"
line=$(grep -n "f_back" constant/polyMesh/boundary | cut -f1 -d:)
type_line=$(($line+2))
sed -i "${type_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${type_line}p"
phys_line=$(($line+3))
sed -i "${phys_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${phys_line}p"

#~~~ Use "wall" in the "sample" patch
line=$(grep -n "sample" constant/polyMesh/boundary | cut -f1 -d:)
patch=$(sed -n "${line}p" constant/polyMesh/boundary)
echo "Patch ${patch}:"
type_line=$(($line+2))
sed -i "${type_line}s/patch/wall/" constant/polyMesh/boundary | sed -n "${type_line}p"
phys_line=$(($line+3))
sed -i "${phys_line}s/patch/wall/" constant/polyMesh/boundary | sed -n "${phys_line}p"

#~~~ Initial condition
setFields

#~~~ Domain decomposition 
decomposePar

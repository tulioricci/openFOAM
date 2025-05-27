
set -e

rm -rf 0.000000
rm -rf dynamicCode
rm -rf constant/polyMesh
rm -rf constant/flow/polyMesh
rm -rf constant/graphite/polyMesh
rm -rf constant/alumina/polyMesh
rm -rf constant/porousMat/polyMesh
rm -rf processor?
find -name "cellToRegion" -delete

#~~~ Create IC file
cp -r init_cond 0.000000
cd 0.000000/flow
#python3 setup_Neumann.py --phi 0.7 --slpm=25
python3 setup_Cantera.py --phi 0.7 --slpm=25
cd ../../

#~~~
gmsh mesh_v1_HAB=10mm.geo -parse_and_exit
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

line=$(grep -n "a_front" constant/polyMesh/boundary | cut -f1 -d:)
type_line=$(($line+2))
sed -i "${type_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${type_line}p"
phys_line=$(($line+3))
sed -i "${phys_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${phys_line}p"
line=$(grep -n "a_back" constant/polyMesh/boundary | cut -f1 -d:)
type_line=$(($line+2))
sed -i "${type_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${type_line}p"
phys_line=$(($line+3))
sed -i "${phys_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${phys_line}p"

line=$(grep -n "g_front" constant/polyMesh/boundary | cut -f1 -d:)
type_line=$(($line+2))
sed -i "${type_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${type_line}p"
phys_line=$(($line+3))
sed -i "${phys_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${phys_line}p"
line=$(grep -n "g_back" constant/polyMesh/boundary | cut -f1 -d:)
type_line=$(($line+2))
sed -i "${type_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${type_line}p"
phys_line=$(($line+3))
sed -i "${phys_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${phys_line}p"

line=$(grep -n "s_front" constant/polyMesh/boundary | cut -f1 -d:)
type_line=$(($line+2))
sed -i "${type_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${type_line}p"
phys_line=$(($line+3))
sed -i "${phys_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${phys_line}p"
line=$(grep -n "s_back" constant/polyMesh/boundary | cut -f1 -d:)
type_line=$(($line+2))
sed -i "${type_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${type_line}p"
phys_line=$(($line+3))
sed -i "${phys_line}s/patch/wedge/" constant/polyMesh/boundary | sed -n "${phys_line}p"

splitMeshRegions -cellZones -overwrite

#postProcess -func writeCellCentres -region flow -constant -noZero
#mv constant/flow/C constant/flow/cellCenter
#rm constant/flow/C[x,y,z]
#python3 decompose.py

#~~~ Initial condition
setFields -region flow

cd myTools
wmake
cd ../
./create_localDT

#~~~ Domain decomposition 
decomposePar -allRegions

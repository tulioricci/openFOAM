#~~~ Create IC file
rm -rf 0.000000
cp -r init_cond 0.000000
cd 0.000000
python3 setup.py --phi 1.0
cd ../

#~~~ If chtMultiRegionFoam
#splitMeshRegions -cellZones -overwrite

#~~~
find -name "cellToRegion" -delete
rm -rf constant/polyMesh
gmsh mesh_v2_10mm_10um.geo -parse_and_exit
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

#~~~ Initial condition
setFields

#~~~ Use "wall" in the "sample" patch
line=$(grep -n "sample" constant/polyMesh/boundary | cut -f1 -d:)
patch=$(sed -n "${line}p" constant/polyMesh/boundary)
echo "Patch ${patch}:"
type_line=$(($line+2))
sed -i "${type_line}s/patch/wall/" constant/polyMesh/boundary | sed -n "${type_line}p"
phys_line=$(($line+3))
sed -i "${phys_line}s/patch/wall/" constant/polyMesh/boundary | sed -n "${phys_line}p"

#~~~ Domain decomposition 
decomposePar -force

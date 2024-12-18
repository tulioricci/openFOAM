#~~~ Create IC file
#rm -rf 0.000000
#cp -r init_cond 0.000000

#~~~ If chtMultiRegionFoam
#splitMeshRegions -cellZones -overwrite

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
#decomposePar

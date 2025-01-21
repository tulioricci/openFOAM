
set -e

rm -rf 0.0000000
rm -rf constant/polyMesh

#~~~ Create IC file
cp -r init_cond 0.0000000

#~~~
gmsh mesh.geo -parse_and_exit
gmshToFoam mesh.msh

line=$(grep -n "frontAndBack" constant/polyMesh/boundary | cut -f1 -d:)
type_line=$(($line+2))
sed -i "${type_line}s/patch/empty/" constant/polyMesh/boundary | sed -n "${type_line}p"
phys_line=$(($line+3))
sed -i "${phys_line}s/patch/empty/" constant/polyMesh/boundary | sed -n "${phys_line}p"

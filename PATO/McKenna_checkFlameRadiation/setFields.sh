rm -rf 0.000000
cp -r init_cond 0.000000
splitMeshRegions -cellZones -overwrite
setFields -region flow

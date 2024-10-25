rm -rf 0.000000
cp -r init_cond 0.000000

# create material properties
cd material_data
    if ! command -v python3 2>&1 >/dev/null
        python3 UQ_script.py
    then
        python UQ_script.py    
    fi
    cd ../

# make the mesh for the multiple domains
splitMeshRegions -cellZones -overwrite

# apply IC
setFields -region flow

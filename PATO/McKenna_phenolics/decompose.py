import os
import numpy as np

def read_cell_centres(filename):
    with open(filename) as f:
        lines = f.readlines()

    # Find line with number of cells
    for i, line in enumerate(lines):
        if "internalField" in line and "nonuniform List<vector>" in line:
            n_cells = int(lines[i+1].strip())
            data_start = i + 3
            break
    else:
        raise ValueError("Could not find internalField nonuniform List<vector> in file")

    centres = []
    for line in lines[data_start:data_start + n_cells]:
        vec_str = line.strip().strip('()')
        x, y, z = map(float, vec_str.split())
        centres.append((x, y, z))
        
    return centres

def sort_list_of_lists(list_of_lists, idx):
  return sorted(list_of_lists, key=lambda x: x[idx])

def assign_processors_by_bounding_box(centres, box_min, box_max, nCPUs, nSpecialCPUs):
    proc_ids = []
    flame_counter = 0
    outside_counter = 0
    nOutsideCPUs = nCPUs - nSpecialCPUs

    inside = []
    outside = []
    counter = 0
    for c in centres:
        x, y, z = c
        in_box = (
            box_min[0] <= x <= box_max[0] and
            box_min[1] <= y <= box_max[1] and
            box_min[2] <= z <= box_max[2]
        )
        if in_box:
            inside.append((x,y,z,counter))
        else:
            outside.append((x,y,z,counter))
        counter += 1
            
    inside = sort_list_of_lists(inside, 0)
    outside = sort_list_of_lists(outside, 0)

    nCells_inFlame = int(len(inside)/nSpecialCPUs)
    nCells_outside = int(len(outside)/nOutsideCPUs)

    flame_counter = 0
    outside_counter = 0
    for c in inside:
        _, _, _, myIdx = c
        proc_id = min(int(flame_counter/nCells_inFlame), nSpecialCPUs-1)
        flame_counter += 1
        proc_ids.append((proc_id, myIdx))
        
    for c in outside:
        _, _, _, myIdx = c
        proc_id = nSpecialCPUs + min(int(outside_counter/nCells_outside), nOutsideCPUs-1)
        outside_counter += 1
        proc_ids.append((proc_id, myIdx))

    sortedByElements = sort_list_of_lists(proc_ids, -1)
   
    return list(np.asarray(sortedByElements)[:,0])    

def write_cellProcIDs(proc_ids, filename):
    with open(filename, 'w') as f:
    
        f.write('/*--------------------------------*- C++ -*----------------------------------*\\\n')
        f.write('  =========                 |\n')
        f.write('  \\\\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox\n')
        f.write('   \\\\    /   O peration     | Website:  https://openfoam.org\n')
        f.write('    \\\\  /    A nd           | Version:  7\n')
        f.write('     \\\\/     M anipulation  |\n')
        f.write('\\*---------------------------------------------------------------------------*/\n')
        f.write('FoamFile\n')
        f.write('{\n')
        f.write('    version     2.0;\n')
        f.write('    format      ascii;\n')
        f.write('    class       labelList;\n')
        f.write('    location    "constant/flow";\n')
        f.write('    object      cellProcIDs;\n')
        f.write('}\n')
        f.write('// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //\n')    
        f.write('\n')
    
        f.write(f"{len(proc_ids)}\n")
        f.write("(\n")
        for pid in proc_ids:
            f.write(f"{pid}\n")
        f.write(")\n")

# Adjust paths and parameters here:
cell_centres_file = "constant/flow/cellCenter"  # Path to the cell centres file
output_file = "./constant/flow/cellProcIDs"
nCPUs = 6
nSpecialCPUs = 4
box_min = (0.0, 0.10, -1)
box_max = (0.0366806, 0.105, 1)

print("Reading cell centres...")
centres = read_cell_centres(cell_centres_file)
print(f"Read {len(centres)} cell centres.")

print("Assigning processor IDs based on bounding box...")
proc_ids = assign_processors_by_bounding_box(centres, box_min, box_max, nCPUs, nSpecialCPUs)

print(f"Writing processor IDs to {output_file}...")
write_cellProcIDs(proc_ids, output_file)

print("Done!")


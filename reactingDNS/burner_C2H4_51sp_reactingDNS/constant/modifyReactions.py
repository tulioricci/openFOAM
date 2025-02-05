import re

# Pick the reaction to be modified (0-based index)
# If negative, will do nothing
change_reaction = -1

# Example: Increase A by 50%: A_multiplier = 1.5 
A_multiplier = 1.0

def modify_reaction_A(input_file, output_file, reaction_index, A_modifier):
    with open(input_file, 'r') as f:
        content = f.readlines()
    
    reaction_count = -1
    inside_reaction = False
    modified_content = []
    
    for line in content:
        if "type" in line:  # Identifying occurrences of "reaction"
            reaction_count += 1
            if reaction_count == reaction_index:
                inside_reaction = True

        if inside_reaction:
            if "reaction" in line or "beta" in line:
                print(line.replace("\n",""))
                
            if "Ta" in line:    
                print(line.replace("\n",""))      
                inside_reaction = False  # Ensure only modifying one "A" value per reaction      

            if "A" in line and "type" not in line:
                print(line.replace("\n",""))
                match = re.search(r'([\deE+.-]+)', line)
                if match:
                    old_A = float(match.group(1))
                    new_A = old_A * A_modifier
                    line = re.sub(r'([\deE+.-]+)', f'{new_A:.6e}', line, 1)
        
        modified_content.append(line)
    
    with open(output_file, 'w') as f:
        f.writelines(modified_content)

input_file = "originalReactions"
output_file = "reactions"

modify_reaction_A(input_file, output_file, change_reaction, A_multiplier)

# Computer-Architecture-Course-Projects-S2023
Computer Architecturecourse projects in the spring semester of the University of Tehran under the supervision of Dr.Safari. 

## Rat in Maze

In this project we read maze data from a file and then try to find a way from our mouse to the cheese. the priority for moving is up, right, left, down so the route we find is unique.

### Maze Asset

- `utils`: Some useful python code for generating map and also checking accuracy of project and visualizing the path
- `maps` : List of maps, in each file if you convert the 4 digit hex string to binary format, each **1** represent wall and each **0** shows empty cells that we can move between those. There is 16 lines each 4 digit hex, so the map is 16 * 16.
    - `maps with solution` : in this folder we have maps that there exists a way to get the cheese. `.dat` file are original map, `.txt` file contains binary converted map, and $result_{i}.txt$ are python code's results, and the $code result_{i}.txt$ file contains Verilog simulation results. result means the way we move in maze. you can understand it with this map.

        ```text
        00 up
        01 right
        10 left
        11 down
        ```

    - `maps without solution` : in this folder we have maps that doesn't exist a way to get the cheese.
- `photos`    : contains datapath and controller designs


## RISC-V
In these projects we designed a RISC-V processor using Verilog but with different approaches. The first approach is to use a simple Single-Cycle model which is not very good when it comes to hardware-utilization. The second approach is to use a shorter cycle but multiple cycles (i.e. Multi-Cycles) so each command use as many cycles as it needs and we have better performance. The last is the Pipeline approach which combines some instructions and gave us the best performance.

Supported commands are(for now):

- R-Type: add, sub, and, or, slt
- I-Type: lw, addi, xori, slti, jalr
- S-Type: sw
- J-Type: jal
- B-Type: beq, bneq, blt, beg
- U-Type: lui

### RISC-V Assets

- `assembly`  : Assembly code of RISC-V
- `controller` and `datapath` : General design of RISC-V 
- `memory` : `data.mem` which shows the data storage and `instructions.mem` which have the instructions that our processor will execute. Note that for Multi-Cycles as shown in it's datapath, data memory and instruction memory are not apart so they are in `data.mem`
### RISC-V code

Verilog files that you can use to simulate the project using ModelSim. When simulating make sure that a `.mem` files are in the project of ModelSim.

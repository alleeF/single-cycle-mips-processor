# Single-Cycle MIPS Processor

Implementation of a single-cycle MIPS processor in Verilog.

## Overview

The design was developed for educational purposes and includes the main architectural blocks required for instruction execution, memory access, arithmetic operations, and control.

The processor supports:
- R-type instructions
- Immediate instructions
- Load / Store
- Branch
- Jump

## Project Structure

- TOP.v – top-level module
- uP.v – processor integration
- UC.v – control unit
- UD.v – datapath integration
- BE.v – execution block
- BCA.v – address calculation
- FR.v – register file
- UAL.v – arithmetic logic unit
- MI.v – instruction memory
- MD.v – data memory

## Architecture

The processor follows a Harvard-style architecture, using separate instruction and data memories.  
The top-level design integrates the control unit, datapath, instruction memory, and data memory.

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b1caf384-ae0b-44c9-bd79-05167ecbb0f5" />


## Example Simulation Waveform

<img width="1725" height="409" alt="image" src="https://github.com/user-attachments/assets/b1861107-e8dc-487e-85c6-f21363177ba2" />

## Explanation
It can be observed that:
- `addrInstr` increases sequentially, showing correct instruction fetch
- `instructiune` changes according to the current instruction address
- `outUAL` updates during execution, indicating arithmetic and logic operations
- `dOutR` and `dInR` show register file activity during execution

These results confirm the correct behavior of the processor in simulation.

The waveform below shows the final stage of program execution.

At instruction address **21**, the processor executes the `SW` instruction used to store the computed result into data memory.

Key signals:
- **outUAL = 10** → target memory address
- **dOutR = 30** → value written to memory
- **wMD = 1** → memory write enabled

This confirms that the processor correctly stores the final result:

**MD[10] = 30**

After that, the processor executes a jump to itself (`J 22`), entering the final infinite loop.

<img width="1896" height="466" alt="image" src="https://github.com/user-attachments/assets/1bddd448-d36a-4dc2-a810-0e0404dfe00d" />




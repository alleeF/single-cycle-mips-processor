# Single-Cycle MIPS Processor

Implementation of a single-cycle MIPS processor in Verilog.

## Overview

The design was developed for educational purposes and includes the main architectural blocks required for instruction execution, memory access, arithmetic operations, and control. The processor follows a Harvard-style architecture, using separate instruction and data memories.

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
- UAL.v – ALU
- MI.v – instruction memory
- MD.v – data memory

## Example Simulation Waveform

  <img width="1892" height="393" alt="image" src="https://github.com/user-attachments/assets/743ca05a-7568-44b6-b6d4-196c19c983c5" />

## Explanation
It can be observed that:
- `addrInstr` increases sequentially, showing correct instruction fetch
- `instructiune` changes according to the current instruction address
- `outUAL` updates during execution, indicating arithmetic and logic operations
- `dOutR` and `dInR` show register file activity during execution

These results confirm the correct behavior of the processor in simulation.



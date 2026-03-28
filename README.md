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

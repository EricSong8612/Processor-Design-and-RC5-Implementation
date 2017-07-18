# Processor-Design-and-RC5-Implementation
For this project, we implemented a 32-bit processor in VHDL, which is capable of executing programs. 
The processor supports the instruction set specified in the next section.

Every instruction has 32 bits that define the type of instruction as well as the operands and the destination of the result. This Processor has three instruction types: 
(a) R-Type for arithmetic instructions, 
(b) I-Type for immediate value operations, load and store instructions, 
(c) J-Type for jump instructions.

The instruction set supported by this Processor is defined as below.
(All operations are performed assuming 2’s complement notation for the operands and the result, unless otherwise specified.) 
ADD, ADDI, SUB, SUBI, AND, ANDI, OR, NOR, ORI, SHL, SHR, LW, SW, BLT, BEQ, BNE, JMP, HAL.
The general design and coding were finished in December 2016.

For implementation details, please read Design-Implement.pdf

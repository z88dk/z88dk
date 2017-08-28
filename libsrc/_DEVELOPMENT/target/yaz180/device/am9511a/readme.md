# The Am9511A

The Am9511A Arithmetic Processing Unit (APU) is a monolithic MOS/LSI device that provides high performance fixed and floating point arithmetic and a variety of floating pOint trigonometric and mathematical operations. It may be used to enhance the computational capability of a wide variety of processor-oriented systems. 

- Fixed point 16 and 32 bit operations
- Floating point 32 bit operations
- Binary data formats
- Add, Subtract, Multiply and Divide
- Trigonometric and inverse trigonometric functions
- Square roots, logarithms, exponentation
- Float to fixed and fixed to float conversions
- Stack-oriented operand storage
- DMA or programmed I/O data transfers
- End signal simplifies concurrent processing
- Synchronous/Asynchronous operations
- General purpose 8-bit data bus interface
- 100% MIL-STD-883 reliability assurance testing

All transfers, including operand, result, status and command information, take place over an 8-bit bidirectional data bus. Operands are pushed onto an internal stack and a command is issued to perform operations on the data in the stack. Results are then available to be retrieved from the stack, or additional commands may be entered.

Am9511a, Intel 8008, Intel 8080: floating point UCRL-51940

 7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0
+-+-------------+-----------------------------------------------+
|S|  Two's exp. |                 positive mantissa             |
+-+-------------+-----------------------------------------------+


The format for floating-point values in the Am9511A is given above. The mantissa is expressed as a 24-bit (fractional) value; the exponent is expressed as an unbiased two's complement 7-bit value having a range of -64 to +63. The most significant bit is the sign of the mantissa (0 = positive, 1 = negative), for a total of 32 bits. The binary point is assumed to be to the left of the most significant mantissa bit (bit 23). All floating-point data values must be normalized. Bit 23 must be equal to 1, except for the value zero, which is represented by all zeros.

The Am9511 is a binary arithmetic processor and requires that floating point data be represented by a normalised fractional mantissa value between .5 and 1 multiplied by 2 raised to an appropriate power.

## Driver concept

The Am9511A works similarly to a HP Reverse Polish Notation (RPN) calculator, with a 16 or 32 bit wide operand stack. Operands must be pushed onto the stack before a command can then act upon the (or these) operands. The depth of the stack depends on whether 16 bit fixed or 32 bit fixed (or floating) numbers are being used.

The driver implements two FIFO buffers, which are managed by an interrupt attached (on the yaz180) to the NMI.

The command buffer is 255 commands deep, which allows for complex calculations to be programmed, and then the result will be calculated with no further action from the controlling program.

The operand pointer buffer is 127 operands deep. As an operand can be either 16 or 32 bits in width, using a pointer buffer allows for the buffer managment to be simplified (accelerated).

Four special commands are provided to permit operands to be loaded (or pushed) onto the Am9511A internal stack and, at the end of the calculation sequence, also to allow results to be unloaded (or popped) from the Am9511A stack to a location provided in the operand pointer buffer.

A calculation sequence can continue after one operand has been unloaded, and this may be necessary if the Am9511A stack is not deep enough to maintain an intermediate result. Clearly using an internal XCHx command to rearange the Am9511A stack will be substantially faster than popping and pushing an intermediate result using the operand pointer buffer.

## Driver usage

Example code for a two operand calculation of Pythagoras Triangle

<code>

                            ;EXAMPLE CODE - INITIALISATION

    ld hl, INT_NMI_ADDR     ;GET NMI VECTOR ADDRESS
    CALL _am9511a_reset     ;INITIALISE THE APU

                            ;EXAMPLE CODE - TWO OPERAND INPUT LOADING 

    LD D, SCRPG             ;SET D REGISTER TO RAM SCRATCH PAGE
    LD E, OP1               ;POINTER TO OPERAND 1
    LD a, __IO_APU_OP_ENT32 ;ENTER 32 bit (double word from INPUT)
    CALL _am9511a_op_ld     ;POINTER TO OPERAND IN OPERAND BUFFER

    LD D, SCRPG             ;SET D REGISTER TO RAM SCRATCH PAGE
    LD E, OP2               ;POINTER TO OPERAND 2
    LD A, __IO_APU_OP_ENT32 ;ENTER 32 bit (double word from INPUT)
    CALL _am9511a_op_ld     ;POINTER TO OPERAND IN OPERAND BUFFER

                            ;EXAMPLE CODE - COMMAND LOADING
                            
    LD A, __IO_APU_OP_FLTD  ;COMMAND for FLTD (float double)
    CALL _am9511a_cmd_ld    ;ENTER a COMMAND

    LD A, __IO_APU_OP_PTOF  ;COMMAND for PTOF (push float)
    CALL _am9511a_cmd_ld    ;ENTER a COMMAND

    LD A, __IO_APU_OP_FMUL  ;COMMAND for FMUL (floating multiply)
    CALL _am9511a_cmd_ld    ;ENTER a COMMAND

    LD A, __IO_APU_OP_XCHF  ;COMMAND for XCHF (swap float)
    CALL _am9511a_cmd_ld    ;ENTER a COMMAND

    LD A, __IO_APU_OP_FLTD  ;COMMAND for FLTD (float double)
    CALL _am9511a_cmd_ld    ;ENTER a COMMAND

    LD A, __IO_APU_OP_PTOF  ;COMMAND for PTOF (push floating)
    CALL _am9511a_cmd_ld    ;ENTER a COMMAND

    LD A, __IO_APU_OP_FMUL  ;COMMAND for FMUL (floating multiply)
    CALL _am9511a_cmd_ld    ;ENTER a COMMAND

    LD A, __IO_APU_OP_FADD  ;COMMAND for FADD (floating add)
    CALL _am9511a_cmd_ld    ;ENTER a COMMAND

    LD A, __IO_APU_OP_SQRT  ;COMMAND for SQRT (floating square root)
    CALL _am9511a_cmd_ld    ;ENTER a COMMAND

    LD A, __IO_APU_OP_FIXD  ;COMMAND for FIXD (fix double)
    CALL _am9511a_cmd_ld    ;ENTER a COMMAND

    LD D, SCRPG             ;SET D REGISTER TO RAM SCRATCH PAGE
    LD E, RSULT             ;(D)E POINTER NOW RSULT
    LD A, __IO_APU_OP_REM32 ;REMOVE 32 bit OPERAND
    CALL _am9511a_op_ld

                            ;EXAMPLE CODE - PROCESSING
                            
    CALL _am9511a_isr       ;KICK OFF APU PROCESS, WHICH THEN INTERRUPTS

    CALL _am9511a_chk_idle  ;CHECK, because it could be doing a last command

</code>


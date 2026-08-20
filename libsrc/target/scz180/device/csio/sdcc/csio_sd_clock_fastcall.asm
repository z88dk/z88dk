
SECTION code_driver

PUBLIC _sd_clock_fastcall

EXTERN asm_sd_clock

    ;Set the CSIO clock rate either to maximum or between 400kHz and 100kHz
    ;This will usually be CNTR_SS_DIV_160, which gives 230kHz to 115kHz
    ;
    ;input (H)L = clock divisor (typically CNTR_SS_DIV_160 or CNTR_SS_DIV_20)
    ;Uses AF,L

defc _sd_clock_fastcall = asm_sd_clock

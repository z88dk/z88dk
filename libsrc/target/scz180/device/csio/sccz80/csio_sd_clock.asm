
SECTION code_driver

PUBLIC sd_clock

EXTERN asm_sd_clock

    ;Set the CSIO clock rate either to maximum or between 400kHz and 100kHz
    ;This will usually be CNTR_SS_DIV_160, which gives 230kHz to 115kHz
    ;
    ;input (H)L = clock divisor (typically CNTR_SS_DIV_160 or CNTR_SS_DIV_20)
    ;Uses AF,L

defc sd_clock = asm_sd_clock

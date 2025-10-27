
INCLUDE "config_private.inc"

SECTION code_driver

PUBLIC asm_sd_clock

    ;Set the CSIO clock rate either to maximum or between 400kHz and 100kHz
    ;This will usually be CNTR_SS_DIV_160, which gives 230kHz to 115kHz
    ;
    ;input (H)L = clock divisor (typically CNTR_SS_DIV_160 or CNTR_SS_DIV_20)
    ;Uses AF,L

.asm_sd_clock
    ld a,CNTR_SS_MASK
    and l                   ;mask to speed bits
    ld l,a
    in0 a,(CNTR)            ;get current CNTR 
    and ~CNTR_SS_MASK       ;mask out current speed bits
    or l                    ;insert new speed bits
    out0 (CNTR),a           ;write them
    ret

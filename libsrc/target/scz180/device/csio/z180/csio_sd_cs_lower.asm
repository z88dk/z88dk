
INCLUDE "config_private.inc"

SECTION code_driver

PUBLIC asm_sd_cs_lower

    ;Lower the SC130 SD card CS using the GPIO address
    ;
    ;input (H)L = SD CS selector of 0 or 1
    ;uses AF

.asm_sd_cs_lower
    in0 a,(CNTR)            ;check the CSIO is not enabled
    and CNTR_TE|CNTR_RE
    jr NZ,asm_sd_cs_lower

    ld a,l
    and $01                 ;isolate SD CS 0 and 1 (to prevent bad input).    
    inc a                   ;convert input 0/1 to SD1/2 CS
    xor $03                 ;invert bits to lower correct I/O bit.
    rlca
    rlca                    ;SC130 SD1 CS is on Bit 2 (SC126 SD2 is on Bit 3).
    out (__IO_SYSTEM),a
    ret

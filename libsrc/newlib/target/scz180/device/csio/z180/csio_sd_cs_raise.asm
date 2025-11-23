
INCLUDE "config_private.inc"

SECTION code_driver

PUBLIC asm_sd_cs_raise

    ;Raise the SC180 SD card CS using the GPIO address
    ;
    ;uses AF

.asm_sd_cs_raise
    in0 a,(CNTR)            ;check the CSIO is not enabled
    and CNTR_TE|CNTR_RE
    jr NZ,asm_sd_cs_raise

    ld a,$0C                ;SC130 SC1 CS is on Bit 2 and SC126 SC2 CS is on Bit 3, raise both.
    out (__IO_SYSTEM),a
    ret

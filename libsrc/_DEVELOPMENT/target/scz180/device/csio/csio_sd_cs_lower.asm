
INCLUDE "config_private.inc"

SECTION code_driver

PUBLIC sd_cs_lower

    ;Lower the SC130 SD card CS using the GPIO address
    ;
    ;uses AF

.sd_cs_lower
    in0 a,(CNTR)            ;check the SD is not enabled
    and CNTR_TE|CNTR_RE
    jr NZ,sd_cs_lower

    ld a,$08                ;SC130 SD1 CS is on Bit 2 (but SC126 SD2 also on Bit 3, raise it).
    out (__IO_SYSTEM),a
    ret

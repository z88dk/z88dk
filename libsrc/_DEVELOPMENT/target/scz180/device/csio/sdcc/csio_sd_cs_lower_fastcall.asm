
SECTION code_driver

PUBLIC _sd_cs_lower_fastcall

EXTERN asm_sd_cs_lower

    ;Lower the SC130 SD card CS using the GPIO address
    ;
    ;uses AF

defc _sd_cs_lower_fastcall = asm_sd_cs_lower

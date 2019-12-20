
SECTION code_driver

PUBLIC _sd_cs_lower

EXTERN asm_sd_cs_lower

    ;Lower the SC130 SD card CS using the GPIO address
    ;
    ;uses AF

defc _sd_cs_lower = asm_sd_cs_lower

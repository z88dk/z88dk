
SECTION code_driver

PUBLIC _sd_cs_lower_fastcall

EXTERN asm_sd_cs_lower

    ;Lower the SC130 SD card CS using the GPIO address
    ;
    ;input (H)L = SD CS selector of 0 or 1
    ;uses AF

defc _sd_cs_lower_fastcall = asm_sd_cs_lower

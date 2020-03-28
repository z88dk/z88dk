
SECTION code_driver

PUBLIC sd_cs_lower

EXTERN asm_sd_cs_lower

    ;Lower the SC130 SD card CS using the GPIO address
    ;
    ;input (H)L = SD CS selector of 0 or 1
    ;uses AF

defc sd_cs_lower = asm_sd_cs_lower

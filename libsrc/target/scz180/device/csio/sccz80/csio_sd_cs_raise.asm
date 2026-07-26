
SECTION code_driver

PUBLIC sd_cs_raise

EXTERN asm_sd_cs_raise

    ;Raise the SC180 SD card CS using the GPIO address
    ;
    ;uses AF

defc sd_cs_raise = asm_sd_cs_raise


SECTION code_driver

PUBLIC _sd_cs_lower

EXTERN asm_sd_cs_lower

    ;Lower the SC130 SD card CS using the GPIO address
    ;
    ;input (H)L = SD CS selector of 1 or 2
    ;uses AF

._sd_cs_lower
    pop af
    pop hl
    push hl
    push af
    jp asm_sd_cs_lower

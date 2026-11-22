
; uint8_t hbios_e(uint16_t func_device) __z88dk_fastcall

SECTION code_clib
SECTION code_arch

PUBLIC hbios_e

EXTERN asm_hbios_e

.hbios_e

    ld b,h
    ld c,l

    jp asm_hbios_e

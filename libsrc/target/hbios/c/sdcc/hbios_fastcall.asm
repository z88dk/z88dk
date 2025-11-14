
; uint32_t hbios(uint16_t func_device) __z88dk_fastcall

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_fastcall

EXTERN asm_hbios

._hbios_fastcall

    ld b,h
    ld c,l

    jp asm_hbios


; uint8_t hbios_a(uint16_t func_device) __z88dk_fastcall

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_a_fastcall

EXTERN asm_hbios_a

._hbios_a_fastcall

    ld b,h
    ld c,l

    jp asm_hbios_a

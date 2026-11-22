
; uint8_t hbios_a(uint16_t func_device) __smallc __z88dk_fastcall

SECTION code_clib
SECTION code_arch

PUBLIC hbios_a

EXTERN asm_hbios_a

.hbios_a

    ld b,h
    ld c,l

    jp asm_hbios_a


; uint32_t hbios(uint16_t func_device) __smallc __z88dk_fastcall

SECTION code_clib
SECTION code_arch

PUBLIC hbios

EXTERN asm_hbios

.hbios

    ld b,h
    ld c,l

    jp asm_hbios

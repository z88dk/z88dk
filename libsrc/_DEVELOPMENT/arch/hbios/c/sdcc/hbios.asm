
; uint32_t hbios(uint16_t func_device)

SECTION code_clib
SECTION code_arch

PUBLIC _hbios

EXTERN asm_hbios

._hbios

    pop af
    pop bc

    push bc
    push af

    jp asm_hbios


; uint8_t hbios_a_dehl(uint16_t func_device, uint32_t arg)

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_a_dehl

EXTERN asm_hbios_a

._hbios_a_dehl

    pop af
    pop bc
    pop hl
    pop de

    push de
    push hl
    push bc
    push af

    jp asm_hbios_a

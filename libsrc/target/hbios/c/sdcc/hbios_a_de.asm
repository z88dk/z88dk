
; uint8_t hbios_a_de(uint16_t func_device, uint16_t arg)

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_a_de

EXTERN asm_hbios_a

._hbios_a_de

    pop af
    pop bc
    pop de

    push de
    push bc
    push af

    jp asm_hbios_a

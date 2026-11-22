
; uint8_t hbios_a_de_hl(uint16_t func_device, uint16_t arg, void * buffer) __z88dk_callee

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_a_de_hl_callee

EXTERN asm_hbios_a

._hbios_a_de_hl_callee

    pop af
    pop bc
    pop de
    pop hl
    push af

    jp asm_hbios_a

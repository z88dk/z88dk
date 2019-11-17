
; uint8_t hbios_e_de(uint16_t func_device, uint16_t arg) __z88dk_callee

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_e_de_callee

EXTERN asm_hbios_e

._hbios_e_de_callee

    pop af
    pop bc
    pop de

    push af

    jp asm_hbios_e


; uint8_t hbios_e_dehl(uint16_t func_device, uint32_t arg) __z88dk_callee

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_e_dehl_callee

EXTERN asm_hbios_e

._hbios_e_dehl_callee

    pop af
    pop bc
    pop hl
    pop de

    push af

    jp asm_hbios_e

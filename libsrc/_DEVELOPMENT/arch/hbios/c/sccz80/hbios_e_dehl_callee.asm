
; uint8_t hbios_e_dehl(uint16_t func_device, uint32_t arg) __smallc __z88dk_callee

SECTION code_clib
SECTION code_arch

PUBLIC hbios_e_dehl_callee

EXTERN asm_hbios_e

.hbios_e_dehl_callee

    pop af
    pop hl
    pop de
    pop bc

    push af

    jp asm_hbios_e

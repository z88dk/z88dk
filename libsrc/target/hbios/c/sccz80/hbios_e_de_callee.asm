
; uint8_t hbios_e_de(uint16_t func_device, uint16_t arg) __smallc __z88dk_callee

SECTION code_clib
SECTION code_arch

PUBLIC hbios_e_de_callee

EXTERN asm_hbios_e

.hbios_e_de_callee

    pop af
    pop de
    pop bc

    push af

    jp asm_hbios_e

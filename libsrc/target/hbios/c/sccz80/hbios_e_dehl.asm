
; uint8_t hbios_e_dehl(uint16_t func_device, uint32_t arg) __smallc

SECTION code_clib
SECTION code_arch

PUBLIC hbios_e_dehl

EXTERN asm_hbios_e

.hbios_e_dehl

    pop af
    pop hl
    pop de
    pop bc

    push bc
    push de
    push hl
    push af

    jp asm_hbios_e

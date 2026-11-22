
; uint8_t hbios_a_dehl(uint16_t func_device, uint32_t arg) __smallc

SECTION code_clib
SECTION code_arch

PUBLIC hbios_a_dehl

EXTERN asm_hbios_a

.hbios_a_dehl

    pop af
    pop hl
    pop de
    pop bc

    push bc
    push de
    push hl
    push af

    jp asm_hbios_a

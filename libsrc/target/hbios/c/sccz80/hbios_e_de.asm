
; uint8_t hbios_e_de(uint16_t func_device, uint16_t arg) __smallc

SECTION code_clib
SECTION code_arch

PUBLIC hbios_e_de

EXTERN asm_hbios_e

.hbios_e_de

    pop af
    pop de
    pop bc

    push bc
    push de
    push af

    jp asm_hbios_e

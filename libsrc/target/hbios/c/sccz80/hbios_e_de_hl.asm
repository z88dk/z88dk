
; uint8_t hbios_e_de_hl(uint16_t func_device, uint16_t arg, void * buffer) __smallc

SECTION code_clib
SECTION code_arch

PUBLIC hbios_e_de_hl

EXTERN asm_hbios_e

.hbios_e_de_hl

    pop af
    pop hl
    pop de
    pop bc

    push bc
    push de
    push hl
    push af

    jp asm_hbios_e

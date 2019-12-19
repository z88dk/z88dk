
; uint8_t hbios_e_de_hl(uint16_t func_device, uint16_t arg, void * buffer)

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_e_de_hl

EXTERN asm_hbios_e

._hbios_e_de_hl

    pop af
    pop bc
    pop de
    pop hl

    push hl
    push de
    push bc
    push af

    jp asm_hbios_e


; uint8_t hbios_e(uint16_t func_device)

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_e

EXTERN asm_hbios_e

._hbios_e

    pop af
    pop bc

    push bc
    push af

    jp asm_hbios_e

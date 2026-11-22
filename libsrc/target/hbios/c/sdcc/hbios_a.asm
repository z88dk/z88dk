
; uint8_t hbios_a(uint16_t func_device)

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_a

EXTERN asm_hbios_a

._hbios_a

    pop af
    pop bc

    push bc
    push af

    jp asm_hbios_a


; int hbios_hl(unsigned uint func_device, unsigned int arg, void * buffer)

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_hl

EXTERN asm_hbios_hl

._hbios_hl

    pop af
    pop hl
    pop de
    pop bc

    push bc
    push de
    push hl
    push af

    jp asm_hbios_hl

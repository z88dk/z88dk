
; int hbios_hl(unsigned uint func_device, unsigned int arg, void * buffer)

SECTION code_clib
SECTION code_arch

PUBLIC hbios_hl

EXTERN asm_hbios_hl

.hbios_hl

    pop af
    pop bc
    pop de
    pop hl

    push hl
    push de
    push bc
    push af

    jp asm_hbios_hl

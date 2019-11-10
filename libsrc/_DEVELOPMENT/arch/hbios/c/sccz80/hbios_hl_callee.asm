
; int hbios_hl(unsigned uint func_device, unsigned int arg, void * buffer)
; callee

SECTION code_clib
SECTION code_arch

PUBLIC hbios_hl_callee

EXTERN asm_hbios_hl

.hbios_hl_callee

    pop af
    pop bc
    pop de
    pop hl
    push af

    jp asm_hbios_hl


; int hbios_hl(unsigned uint func_device, unsigned int arg, void * buffer)
; callee

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_hl_callee

EXTERN asm_hbios_hl

._hbios_hl_callee

    pop af
    pop hl
    pop de
    pop bc
    push af

    jp asm_hbios_hl

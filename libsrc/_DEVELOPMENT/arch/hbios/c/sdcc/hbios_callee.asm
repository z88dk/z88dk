
; void hbios(unsigned int func_device, unsigned int arg, void * buffer)
; callee

SECTION code_clib
SECTION code_arch

PUBLIC _hbios_callee

EXTERN asm_hbios

._hbios_callee

    pop af
    pop hl
    pop de
    pop bc
    push af

    jp asm_hbios

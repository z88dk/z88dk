
; void hbios(unsigned int func_device, unsigned int arg, void * buffer)
; callee

SECTION code_clib
SECTION code_arch

PUBLIC hbios_callee

EXTERN asm_hbios

.hbios_callee

    pop af
    pop bc
    pop de
    pop hl
    push af

    jp asm_hbios


; void hbios(unsigned int func_device, unsigned int arg, void * buffer)

SECTION code_clib
SECTION code_arch

PUBLIC hbios

EXTERN asm_hbios

.hbios

    pop af
    pop bc
    pop de
    pop hl

    push hl
    push de
    push bc
    push af

    jp asm_hbios

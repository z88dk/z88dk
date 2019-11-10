
; void hbios(unsigned int func_device, unsigned int arg, void * buffer)

SECTION code_clib
SECTION code_arch

PUBLIC _hbios

EXTERN asm_hbios

._hbios

    pop af
    pop hl
    pop de
    pop bc

    push bc
    push de
    push hl
    push af

    jp asm_hbios


; ===============================================================
; @feilipu 2019
; ===============================================================
; 
; int hbios_hl(unsigned uint func_device, unsigned int arg, void * buffer)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_hbios_hl

EXTERN HB_INVOKE

.asm_hbios_hl

    ; enter : bc = hbios function << 8 || hbios device
    ;         de = argument
    ;         hl = void *
    ;
    ; exit  : hl = sign extended register A (returned by hbios)

    call HB_INVOKE

    ld l,a
    rla
    sbc a,a
    ld h,a

    ret

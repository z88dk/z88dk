
; ===============================================================
; @feilipu 2019
; ===============================================================
; 
; uint8_t hbios_e(uint16_t func_device, uint16_t arg, void * buffer)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_hbios_e

EXTERN __HB_INVOKE

.asm_hbios_e

    ; enter : bc = hbios function << 8 || hbios device
    ;         de = argument
    ;         hl = void *
    ;
    ; exit  : registers set by hbios
    ;       : hl = register E (returned by hbios)

    call __HB_INVOKE

    ld h,0
    ld l,e
    ret

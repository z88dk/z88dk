
; ===============================================================
; @feilipu 2019
; ===============================================================
; 
; uint32_t hbios(uint16_t func_device, uint16_t arg, void * buffer)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_hbios

EXTERN __HB_INVOKE

    ; enter : bc = hbios function << 8 || hbios device
    ;         de = argument
    ;         hl = void *
    ;
    ; exit  : registers set by hbios (DEHL)

defc asm_hbios = __HB_INVOKE

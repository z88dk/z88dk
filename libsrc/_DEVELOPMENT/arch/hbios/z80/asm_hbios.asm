
; ===============================================================
; @feilipu 2019
; ===============================================================
; 
; void hbios(unsigned int func_device, unsigned int arg, void * buffer)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_hbios

EXTERN HB_INVOKE

; enter : bc = hbios function << 8 || hbios device
;         de = argument
;
; exit  : registers set by hbios


defc asm_hbios = HB_INVOKE


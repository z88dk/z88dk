; ===============================================================
; 2017
; ===============================================================
; 
; unsigned int zxn_read_sysvar_bank_state(void)
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zxn_read_sysvar_bank_state

asm_zxn_read_sysvar_bank_state:

   ; read system variables BANKM and BANK678
   ; (convenience function)
   ;
   ; enter : none
   ;
   ; exit  : h = BANK678
   ;         l = BANKM
   ;
   ; uses  : a, hl
   
   ld hl,(__SYSVAR_BANKM)
   
   ld a,(__SYSVAR_BANK678)
   ld h,a
   
   ret

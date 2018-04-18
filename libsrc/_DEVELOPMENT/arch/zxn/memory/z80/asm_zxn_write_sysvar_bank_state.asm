; ===============================================================
; 2017
; ===============================================================
; 
; void zxn_write_sysvar_bank_state(unsigned int state)
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zxn_write_sysvar_bank_state

asm_zxn_write_sysvar_bank_state:

   ; write system variables BANKM and BANK678
   ; (convenience function)
   ;
   ; enter : h = BANK678
   ;         l = BANKM
   ;
   ; uses  : a
   
   ld a,h
   ld (__SYSVAR_BANK678),a
   
   ld a,l
   ld (__SYSVAR_BANKM),a

   ret

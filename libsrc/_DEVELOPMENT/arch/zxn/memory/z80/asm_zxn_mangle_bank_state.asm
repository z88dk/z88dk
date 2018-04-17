; ===============================================================
; 2017
; ===============================================================
; 
; unsigned int zxn_mangle_bank_state(unsigned int state)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zxn_mangle_bank_state

asm_zxn_mangle_bank_state:

   ; mangle 1ffd,7ffd value for use with SWAP in system variables area
   ;
   ; enter :  h = new value for port 1ffd (BANK678)
   ;          l = new value for port 7ffd (BANKM)
   ;
   ; exit  :  h = mangled value for port 1ffd (BANK678) for use with routine SWAP
   ;          l = mangled value for port 7ffd (BANKM) for use with routine SWAP
   ;
   ; uses  : af, hl
   
   ld a,h
   xor $04
   ld h,a
   
   ld a,l
   xor $10
   ld l,a
   
   ret

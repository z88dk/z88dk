; ===============================================================
; 2017
; ===============================================================
; 
; void zxn_write_bank_state(unsigned int state)
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zxn_write_bank_state

asm_zxn_write_bank_state:

   ; write to ports 1ffd, 7ffd to set legacy bank state
   ; port dffd is written 0
   ;
   ; enter :  h = new value for port 1ffd (BANK678)
   ;          l = new value for port 7ffd (BANKM)
   ;
   ; exit  : bc = $dffd
   ;          a = 0
   ;
   ; uses  : af, bc
   
   ld bc,__IO_1FFD
   out (c),h

   xor a
   ld b,__IO_DFFD/256          ; must precede 7ffd in case of locking
   out (c),a

   ld b,__IO_7FFD/256
   out (c),l

   ld b,__IO_DFFD/256          ; preserve output conditions
   ret

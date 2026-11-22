; ===============================================================
; Stefano Bodrato
; aralbrec: accommodate nmos z80 bug
; ===============================================================
;
; unsigned char z180_get_int_state(void)
;
; Retrieve the current ei/di status.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_z180

PUBLIC asm_z180_get_int_state
PUBLIC asm_cpu_get_int_state

asm_z180_get_int_state:
asm_cpu_get_int_state:

   ; exit  : l = ei/di status
   ;
   ; uses  : af, hl

   ld a,i

   push af
   pop hl

   ret

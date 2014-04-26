
; ===============================================================
; Apr 2014
; ===============================================================
; 
; void in_wait_nokey(void)
;
; Busy wait until no keys are pressed.
;
; ===============================================================

XLIB asm_in_wait_nokey

asm_in_wait_nokey:

   ; uses : af
   
   xor a
   in a,($fe)
   
   and $1f
   cp 31
   jr nz, asm_in_wait_nokey
   
   ret

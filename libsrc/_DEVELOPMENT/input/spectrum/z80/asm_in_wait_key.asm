
; ===============================================================
; Apr 2014
; ===============================================================
; 
; void in_wait_key(void)
;
; Busy wait until a key is pressed.
;
; ===============================================================

XLIB asm_in_wait_key

asm_in_wait_key:

   ; uses : af
   
   xor a
   in a,($fe)
   
   and 31
   cp 31
   jr z, asm_in_wait_key
   
   ret

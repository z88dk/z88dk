
; ===============================================================
; May 2014
; ===============================================================
; 
; int in_test_key(void)
;
; Return true if a key is currently pressed.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_test_key

asm_in_test_key:

   ; exit : nz flag set if a key is pressed
   ;         z flag set if no key is pressed
   ;
   ; uses : af
   
   xor a
   in a,($fe)
   
   and $1f
   cp $1f
   
   ret

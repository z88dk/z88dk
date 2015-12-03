
; ===============================================================
; Aug 2015
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
   
   ld a,9

test_loop:

   out ($b5),a
   in a,($b5)
   
   cp $ff
   ret nz
   
   dec a
   jp p, test_loop
   
   xor a
   ret


; ===============================================================
; Apr 2014
; ===============================================================
; 
; void in_wait_key(void)
;
; Busy wait until a key is pressed.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_wait_key

EXTERN asm_in_test_key

asm_in_wait_key:

   ; uses : af

   call asm_in_test_key
   jr z, asm_in_wait_key
   
   ret

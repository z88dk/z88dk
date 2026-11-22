
; ===============================================================
; Apr 2014
; ===============================================================
; 
; void in_wait_nokey(void)
;
; Busy wait until no keys are pressed.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_wait_nokey

EXTERN asm_in_test_key

asm_in_wait_nokey:

   ; uses : af

   call asm_in_test_key
   jr nz, asm_in_wait_nokey
   
   ret

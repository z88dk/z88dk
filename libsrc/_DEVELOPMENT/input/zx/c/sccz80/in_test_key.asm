
; int in_test_key(void)

SECTION seg_code_input

PUBLIC in_test_key

EXTERN asm_in_test_key

in_test_key:

   call asm_in_test_key
   
   ld hl,1
   ret nz
   
   dec l
   
   scf
   ret

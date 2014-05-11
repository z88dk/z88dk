
; int in_test_key(void)

PUBLIC _in_test_key

EXTERN asm_in_test_key

_in_test_key:

   call asm_in_test_key
   
   ld hl,1
   ret nz
   
   dec l
   
   scf
   ret

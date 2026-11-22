
; _Noreturn void quick_exit(int status)

SECTION code_clib
SECTION code_stdlib

PUBLIC _quick_exit

EXTERN asm_quick_exit

_quick_exit:

   pop af
   pop hl
   
   jp asm_quick_exit

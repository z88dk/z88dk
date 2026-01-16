
; _Noreturn void exit(int status)

SECTION code_clib
SECTION code_stdlib

PUBLIC _exit

EXTERN asm_exit

_exit:

   pop af
   pop hl
   
   jp asm_exit

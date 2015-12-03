
; int atexit(void (*func)(void))

SECTION code_clib
SECTION code_stdlib

PUBLIC _atexit

EXTERN asm_atexit

_atexit:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_atexit

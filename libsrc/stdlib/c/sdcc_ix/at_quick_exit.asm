
; int at_quick_exit(void (*func)(void))

SECTION code_clib
SECTION code_stdlib

PUBLIC _at_quick_exit

EXTERN asm_at_quick_exit

_at_quick_exit:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_at_quick_exit


; int system(const char *string)

SECTION code_clib
SECTION code_stdlib

PUBLIC _system

EXTERN asm_system

_system:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_system

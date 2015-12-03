
; int system(const char *string)

SECTION code_clib
SECTION code_stdlib

PUBLIC _system

EXTERN _system_fastcall

_system:

   pop af
   pop hl
   
   push hl
   push af

   jp _system_fastcall

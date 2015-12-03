
; int system_fastcall(const char *string)

SECTION code_clib
SECTION code_stdlib

PUBLIC _system_fastcall

EXTERN asm_system

_system_fastcall:
   
   push ix
   
   call asm_system
   
   pop ix
   ret

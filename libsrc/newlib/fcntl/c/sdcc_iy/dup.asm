
; int dup(int fd)

SECTION code_clib
SECTION code_fcntl

PUBLIC _dup

EXTERN asm_dup

_dup:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_dup


; int dup(int fd)

SECTION code_clib
SECTION code_fcntl

PUBLIC _dup

EXTERN _dup_fastcall

_dup:

   pop af
   pop hl
   
   push hl
   push af

   jp _dup_fastcall

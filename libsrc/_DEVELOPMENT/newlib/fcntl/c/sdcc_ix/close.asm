
; int close(int fd)

SECTION code_clib
SECTION code_fcntl

PUBLIC _close

EXTERN _close_fastcall

_close:

   pop af
   pop hl
   
   push hl
   push af

   jp _close_fastcall


; int close(int fd)

SECTION code_clib
SECTION code_fcntl

PUBLIC _close

EXTERN asm_close

_close:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_close


; _Noreturn void _exit(int status)

SECTION code_fcntl

PUBLIC __exit

EXTERN __Exit

__exit:

   pop hl
   pop hl
   
   jp __Exit

INCLUDE "fcntl/z80/asm__exit.asm"


; _Noreturn void _exit(int status)

SECTION code_fcntl

PUBLIC _exit

EXTERN __Exit

defc _exit = __Exit

INCLUDE "fcntl/z80/asm__exit.asm"

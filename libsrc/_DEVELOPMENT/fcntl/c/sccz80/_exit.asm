
; _Noreturn void _exit(int status)

SECTION seg_code_fcntl

PUBLIC _exit

EXTERN __Exit

defc _exit = __Exit

INCLUDE "fcntl/z80/asm__exit.asm"

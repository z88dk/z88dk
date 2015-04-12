
; _Noreturn void _exit_fastcall(int status)

SECTION code_fcntl

PUBLIC __exit_fastcall

EXTERN __Exit

defc __exit_fastcall = __Exit

INCLUDE "fcntl/z80/asm__exit.asm"

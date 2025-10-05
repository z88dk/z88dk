
; _Noreturn void _exit(int status)

SECTION code_clib
SECTION code_fcntl

PUBLIC _exit

EXTERN __Exit

defc _exit = __Exit

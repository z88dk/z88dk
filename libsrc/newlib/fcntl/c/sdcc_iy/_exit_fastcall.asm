
; _Noreturn void _exit_fastcall(int status)

SECTION code_clib
SECTION code_fcntl

PUBLIC __exit_fastcall

EXTERN __Exit

defc __exit_fastcall = __Exit

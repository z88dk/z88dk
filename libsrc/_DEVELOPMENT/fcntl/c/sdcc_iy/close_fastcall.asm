
; int close_fastcall(int fd)

SECTION code_fcntl

PUBLIC _close_fastcall

EXTERN asm_close

defc _close_fastcall = asm_close


; int close(int fd)

SECTION code_fcntl

PUBLIC close

EXTERN asm_close

defc close = asm_close

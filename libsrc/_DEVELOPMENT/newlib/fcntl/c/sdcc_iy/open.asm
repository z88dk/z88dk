
; int open(const char *path, int oflag, ...)

SECTION code_clib
SECTION code_fcntl

PUBLIC _open

EXTERN asm_open

defc _open = asm_open

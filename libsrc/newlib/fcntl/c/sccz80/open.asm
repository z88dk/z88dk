
; int open(const char *path, int oflag, ...)

SECTION code_clib
SECTION code_fcntl

PUBLIC open

EXTERN asm_open

defc open = asm_open

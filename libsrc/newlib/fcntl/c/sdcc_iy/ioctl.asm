
; int ioctl(int fildes, int request, ...)

SECTION code_clib
SECTION code_fcntl

PUBLIC _ioctl

EXTERN asm_ioctl

defc _ioctl = asm_ioctl

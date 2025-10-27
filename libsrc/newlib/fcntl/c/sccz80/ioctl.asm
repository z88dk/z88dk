
; int ioctl(int fildes, int request, ...)

SECTION code_clib
SECTION code_fcntl

PUBLIC ioctl

EXTERN asm_ioctl

defc ioctl = asm_ioctl

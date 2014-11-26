
; int ioctl(int fildes, int request, ...)

SECTION seg_code_fcntl

PUBLIC ioctl

ioctl:

   INCLUDE "fcntl/z80/asm_ioctl.asm"

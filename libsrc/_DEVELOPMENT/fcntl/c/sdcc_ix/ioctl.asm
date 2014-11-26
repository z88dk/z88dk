
; int ioctl(int fildes, int request, ...)

SECTION seg_code_fcntl

PUBLIC _ioctl

_ioctl:

   push ix
   
   call asm_ioctl
   
   pop ix
   ret

   INCLUDE "fcntl/z80/asm_ioctl.asm"

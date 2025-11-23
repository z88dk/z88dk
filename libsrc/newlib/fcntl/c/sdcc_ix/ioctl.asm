
; int ioctl(int fildes, int request, ...)

SECTION code_clib
SECTION code_fcntl

PUBLIC _ioctl

EXTERN asm_ioctl

_ioctl:

   push ix
   
   call asm_ioctl
   
   pop ix
   ret

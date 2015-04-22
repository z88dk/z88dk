
; int vioctl_callee(int fd, uint16_t request, void *arg)

SECTION code_fcntl

PUBLIC _vioctl_callee, l0_vioctl_callee

_vioctl_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af

l0_vioctl_callee:

   push ix
   
   call asm_vioctl
   
   pop ix
   ret
   
   INCLUDE "fcntl/z80/asm_vioctl.asm"

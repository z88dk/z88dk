
; int vioctl_callee(int fd, uint16_t request, void *arg)

SECTION code_fcntl

PUBLIC _vioctl_callee

_vioctl_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "fcntl/z80/asm_vioctl.asm"

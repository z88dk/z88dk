
; int vioctl(int fd, uint16_t request, void *arg)

SECTION code_fcntl

PUBLIC vioctl_callee

vioctl_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "fcntl/z80/asm_vioctl.asm"


; int vioctl_callee(int fd, uint16_t request, void *arg)

SECTION code_clib
SECTION code_fcntl

PUBLIC _vioctl_callee, l0_vioctl_callee

EXTERN asm_vioctl

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

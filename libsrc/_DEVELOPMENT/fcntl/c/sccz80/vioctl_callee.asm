
; int vioctl(int fd, uint16_t request, void *arg)

SECTION code_clib
SECTION code_fcntl

PUBLIC vioctl_callee

EXTERN asm_vioctl

vioctl_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_vioctl

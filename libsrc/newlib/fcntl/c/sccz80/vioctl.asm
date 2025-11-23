
; int vioctl(int fd, uint16_t request, void *arg)

SECTION code_clib
SECTION code_fcntl

PUBLIC vioctl

EXTERN asm_vioctl

vioctl:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_vioctl

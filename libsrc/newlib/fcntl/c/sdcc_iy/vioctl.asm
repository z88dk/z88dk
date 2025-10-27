
; int vioctl(int fd, uint16_t request, void *arg)

SECTION code_clib
SECTION code_fcntl

PUBLIC _vioctl

EXTERN asm_vioctl

_vioctl:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_vioctl



; int vioctl(int fd, uint16_t request, void *arg)

SECTION seg_code_fcntl

PUBLIC _vioctl

_vioctl:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "fcntl/z80/asm_vioctl.asm"

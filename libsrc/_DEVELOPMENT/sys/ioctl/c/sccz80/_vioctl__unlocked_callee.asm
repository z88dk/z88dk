
; int _vioctl__unlocked_callee(FILE *stream, uint16_t command, void *arg)

PUBLIC _vioctl__unlocked_callee

_vioctl__unlocked_callee:

   pop af
   pop bc
   pop de
   pop ix
   
   push af
   
   INCLUDE "sys/ioctl/z80/asm__vioctl__unlocked.asm"


; int _vioctl__unlocked(FILE *stream, uint16_t command, void *arg)

PUBLIC __vioctl__unlocked

__vioctl__unlocked:

   pop af
   pop ix
   pop de
   pop bc
   
   push bc
   push de
   push ix
   push af
   
   INCLUDE "sys/ioctl/z80/asm__vioctl__unlocked.asm"

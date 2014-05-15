
; int _ioctl__unlocked(FILE *stream, uint16_t command, ...)

PUBLIC __ioctl__unlocked

__ioctl__unlocked:

   push ix
   
   call asm__ioctl__unlocked
   
   pop ix
   ret

   INCLUDE "sys/ioctl/z80/asm__ioctl__unlocked.asm"

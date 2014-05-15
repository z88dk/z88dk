
; int _vioctl__unlocked(FILE *stream, uint16_t command, void *arg)

PUBLIC __vioctl__unlocked

__vioctl__unlocked:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   push ix
   
   ld ixl,e
   ld ixh,d
   
   ex de,hl
   call asm__vioctl__unlocked
   
   pop ix
   ret
   
   INCLUDE "sys/ioctl/z80/asm__vioctl__unlocked.asm"

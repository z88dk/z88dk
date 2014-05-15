
; int _vioctl__unlocked(FILE *stream, uint16_t command, void *arg)

PUBLIC _vioctl__unlocked

EXTERN asm__vioctl__unlocked

_vioctl__unlocked:

   pop af
   pop bc
   pop de
   pop ix
   
   push ix
   push de
   push bc
   push af
   
   jp asm__vioctl__unlocked

; ulong esxdos_f_seek(uchar handle, ulong dist, uchar whence)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_seek

EXTERN asm_esxdos_f_seek

esxdos_f_seek:

   pop af
   pop ix
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push de
   push af
   
   ld a,l

   push ix
   pop hl

   jp asm_esxdos_f_seek

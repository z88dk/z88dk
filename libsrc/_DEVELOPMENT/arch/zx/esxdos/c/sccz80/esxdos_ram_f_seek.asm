; ulong esxdos_f_seek(uchar handle, ulong dist, uchar whence)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_ram_f_seek

EXTERN asm_esxdos_f_seek

esxdos_ram_f_seek:

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
   jp asm_esxdos_f_seek

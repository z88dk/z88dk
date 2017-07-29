; uchar esxdos_f_readdir(uchar handle, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_readdir

EXTERN asm_esxdos_f_readdir

esxdos_f_readdir:

   pop af
   pop ix
   pop hl
   
   push hl
   push hl
   push af
   
   ld a,l
   jp asm_esxdos_f_readdir

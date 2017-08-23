; uchar esxdos_f_readdir(uchar handle, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_readdir_callee

EXTERN asm_esxdos_f_readdir

esxdos_f_readdir_callee:

   pop af
   pop hl
   pop de
   push af
   
   ld a,e
   jp asm_esxdos_f_readdir

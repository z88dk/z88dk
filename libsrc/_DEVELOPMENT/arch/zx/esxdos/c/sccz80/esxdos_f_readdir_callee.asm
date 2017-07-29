; uchar esxdos_f_readdir(uchar handle, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_readdir_callee

EXTERN asm_esxdos_f_readdir

esxdos_f_readdir_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   ld a,l
   jp asm_esxdos_f_readdir

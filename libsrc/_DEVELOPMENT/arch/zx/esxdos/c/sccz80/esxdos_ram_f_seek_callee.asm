; ulong esxdos_f_seek(uchar handle, ulong dist, uchar whence)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_ram_f_seek_callee

EXTERN asm_esxdos_f_seek

esxdos_ram_f_seek_callee:

   pop hl
   pop ix
   pop de
   pop bc
   ex (sp),hl
   
   ld a,l
   jp asm_esxdos_f_seek

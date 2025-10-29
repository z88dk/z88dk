; ulong esxdos_f_seek(uchar handle, ulong dist, uchar whence)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_seek_callee

EXTERN asm_esxdos_f_seek

esxdos_f_seek_callee:

   pop hl
   pop ix
   pop de
   pop bc
   ex (sp),hl
   
   ld a,l

   push ix
   pop hl

   jp asm_esxdos_f_seek

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_f_seek_callee
defc _esxdos_f_seek_callee = esxdos_f_seek_callee
ENDIF


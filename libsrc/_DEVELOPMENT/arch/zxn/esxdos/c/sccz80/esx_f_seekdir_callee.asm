; unsigned char esx_f_seekdir(unsigned char handle,uint32_t pos)

SECTION code_esxdos

PUBLIC esx_f_seekdir_callee

EXTERN asm_esx_f_seekdir

esx_f_seekdir_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   ld a,l
   jp asm_esx_f_seekdir

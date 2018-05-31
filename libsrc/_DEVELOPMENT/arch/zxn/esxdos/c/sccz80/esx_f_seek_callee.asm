; uint32_t esx_f_seek(unsigned char handle, uint32_t distance, unsigned char whence)

SECTION code_esxdos

PUBLIC esx_f_seek_callee

EXTERN asm_esx_f_seek

esx_f_seek_callee:

   pop ix
   pop hl
   pop de
   pop bc
   ex (sp),ix
   
   ld a,ixl
   jp asm_esx_f_seek

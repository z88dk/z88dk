; uint32_t esx_f_seek(unsigned char handle, uint32_t distance, unsigned char whence)

SECTION code_esxdos

PUBLIC _esx_f_seek_callee
PUBLIC l0_esx_f_seek_callee

EXTERN asm_esx_f_seek

_esx_f_seek_callee:

   pop hl
   dec sp
   pop af
   pop de
   pop bc
   dec sp
   ex (sp),hl

l0_esx_f_seek_callee:

   ld l,h
   
   push ix

   call asm_esx_f_seek

   pop ix
   ret

; unsigned char esx_f_open(unsigned char *filename,unsigned char mode)

SECTION code_esxdos

PUBLIC esx_f_open_callee

EXTERN asm_esx_f_open

esx_f_open_callee:

   pop hl
   pop de
   ex (sp),hl
   
   ld a,e
   jp asm_esx_f_open

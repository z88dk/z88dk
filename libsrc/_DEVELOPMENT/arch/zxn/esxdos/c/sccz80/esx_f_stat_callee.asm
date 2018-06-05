; unsigned char esx_f_stat(unsigned char *filename,struct esx_stat *es)

SECTION code_esxdos

PUBLIC esx_f_stat_callee

EXTERN asm_esx_f_stat

esx_f_stat_callee:

   pop hl
   pop de
   ex (sp),hl

   jp asm_esx_f_stat

; unsigned char esx_f_fstat(unsigned char handle, struct esx_stat *es)

SECTION code_esxdos

PUBLIC esx_f_fstat_callee

EXTERN asm_esx_f_fstat

esx_f_fstat_callee:

   pop af
   pop hl
   pop de
   push af
   
   ld a,e
   jp asm_esx_f_fstat

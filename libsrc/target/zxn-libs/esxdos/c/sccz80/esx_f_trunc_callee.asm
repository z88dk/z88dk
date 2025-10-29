; unsigned char esx_f_trunc(unsigned char *filename,uint32_t size)

SECTION code_esxdos

PUBLIC esx_f_trunc_callee

EXTERN asm_esx_f_trunc

esx_f_trunc_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl

   jp asm_esx_f_trunc

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_trunc_callee
defc _esx_f_trunc_callee = esx_f_trunc_callee
ENDIF


; unsigned char esx_f_opendir_ex(unsigned char *dirname,uint8_t mode)

SECTION code_esxdos

PUBLIC esx_f_opendir_ex_callee

EXTERN asm_esx_f_opendir_ex

esx_f_opendir_ex_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   ld b,c
   jp asm_esx_f_opendir_ex

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_opendir_ex_callee
defc _esx_f_opendir_ex_callee = esx_f_opendir_ex_callee
ENDIF


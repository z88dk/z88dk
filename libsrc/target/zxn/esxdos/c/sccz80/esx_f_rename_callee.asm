; unsigned char esx_f_rename(unsigned char *old, unsigned char *new)

SECTION code_esxdos

PUBLIC esx_f_rename_callee

EXTERN asm_esx_f_rename

esx_f_rename_callee:

   pop hl
   pop de
   ex (sp),hl

   jp asm_esx_f_rename

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_rename_callee
defc _esx_f_rename_callee = esx_f_rename_callee
ENDIF


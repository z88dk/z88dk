; unsigned char esx_f_stat(unsigned char *filename,struct esx_stat *es)

SECTION code_esxdos

PUBLIC esx_f_stat

EXTERN asm_esx_f_stat

esx_f_stat:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp asm_esx_f_stat

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_stat
defc _esx_f_stat = esx_f_stat
ENDIF


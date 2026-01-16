; unsigned char esx_f_rename(unsigned char *old, unsigned char *new)

SECTION code_esxdos

PUBLIC esx_f_rename

EXTERN asm_esx_f_rename

esx_f_rename:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp asm_esx_f_rename

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_rename
defc _esx_f_rename = esx_f_rename
ENDIF


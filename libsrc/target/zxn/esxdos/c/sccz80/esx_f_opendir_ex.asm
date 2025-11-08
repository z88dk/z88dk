; unsigned char esx_f_opendir_ex(unsigned char *dirname,uint8_t mode)

SECTION code_esxdos

PUBLIC esx_f_opendir_ex

EXTERN asm_esx_f_opendir_ex

esx_f_opendir_ex:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   ld b,c
   jp asm_esx_f_opendir_ex

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_opendir_ex
defc _esx_f_opendir_ex = esx_f_opendir_ex
ENDIF


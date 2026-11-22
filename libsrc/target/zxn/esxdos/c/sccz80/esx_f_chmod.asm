; unsigned char esx_f_chmod(unsigned char *filename, uint8_t attr_mask, uint8_t attr)

SECTION code_esxdos

PUBLIC esx_f_chmod

EXTERN asm_esx_f_chmod

esx_f_chmod:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af

   ld b,e
   jp asm_esx_f_chmod

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_chmod
defc _esx_f_chmod = esx_f_chmod
ENDIF


; unsigned char esx_f_trunc(unsigned char *filename,uint32_t size)

SECTION code_esxdos

PUBLIC esx_f_trunc

EXTERN asm_esx_f_trunc

esx_f_trunc:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af

   jp asm_esx_f_trunc

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_trunc
defc _esx_f_trunc = esx_f_trunc
ENDIF


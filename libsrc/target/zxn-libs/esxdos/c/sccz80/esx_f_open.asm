; unsigned char esx_f_open(unsigned char *filename,unsigned char mode)

SECTION code_esxdos

PUBLIC esx_f_open

EXTERN asm_esx_f_open

esx_f_open:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld a,e
   jp asm_esx_f_open

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_open
defc _esx_f_open = esx_f_open
ENDIF


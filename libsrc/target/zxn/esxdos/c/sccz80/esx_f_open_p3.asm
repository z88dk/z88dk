; unsigned char esx_f_open_p3(unsigned char *filename,unsigned char mode,struct esx_p3_hdr *h)

SECTION code_esxdos

PUBLIC esx_f_open_p3

EXTERN asm_esx_f_open_p3

esx_f_open_p3:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   ld a,c
   jp asm_esx_f_open_p3

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_open_p3
defc _esx_f_open_p3 = esx_f_open_p3
ENDIF


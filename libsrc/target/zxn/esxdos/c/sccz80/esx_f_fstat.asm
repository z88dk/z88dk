; unsigned char esx_f_fstat(unsigned char handle, struct esx_stat *es)

SECTION code_esxdos

PUBLIC esx_f_fstat

EXTERN asm_esx_f_fstat

esx_f_fstat:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld a,e
   jp asm_esx_f_fstat

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_fstat
defc _esx_f_fstat = esx_f_fstat
ENDIF


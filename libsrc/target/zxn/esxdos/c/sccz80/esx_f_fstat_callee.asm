; unsigned char esx_f_fstat(unsigned char handle, struct esx_stat *es)

SECTION code_esxdos

PUBLIC esx_f_fstat_callee

EXTERN asm_esx_f_fstat

esx_f_fstat_callee:

   pop af
   pop hl
   pop de
   push af
   
   ld a,e
   jp asm_esx_f_fstat

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_fstat_callee
defc _esx_f_fstat_callee = esx_f_fstat_callee
ENDIF


; int esxdos_f_fstat(uchar handle, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_fstat

EXTERN asm_esxdos_f_fstat

esxdos_f_fstat:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   ld a,c
   jp asm_esxdos_f_fstat

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_f_fstat
defc _esxdos_f_fstat = esxdos_f_fstat
ENDIF


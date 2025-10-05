; int esxdos_f_read(uchar handle, void *dst, size_t nbyte)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_read_callee

EXTERN asm_esxdos_f_read

esxdos_f_read_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   ld a,e
   jp asm_esxdos_f_read

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_f_read_callee
defc _esxdos_f_read_callee = esxdos_f_read_callee
ENDIF


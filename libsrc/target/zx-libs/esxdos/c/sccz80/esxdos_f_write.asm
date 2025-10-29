; int esxdos_f_write(uchar handle, void *src, size_t nbyte)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_write

EXTERN asm_esxdos_f_write

esxdos_f_write:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   ld a,e
   jp asm_esxdos_f_write

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_f_write
defc _esxdos_f_write = esxdos_f_write
ENDIF


; int esxdos_f_fstat(uchar handle, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_ram_f_fstat

EXTERN asm_esxdos_f_fstat

esxdos_ram_f_fstat:

   pop af
   pop ix
   pop hl
   
   push hl
   push hl
   push af
   
   ld a,l
   jp asm_esxdos_f_fstat

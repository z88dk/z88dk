; int esxdos_f_write(uchar handle, void *src, size_t nbyte)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_ram_f_write

EXTERN asm_esxdos_f_write

esxdos_ram_f_write:

   pop af
   pop bc
   pop ix
   pop hl
   
   push hl
   push hl
   push bc
   push af
   
   ld a,l
   jp asm_esxdos_f_write

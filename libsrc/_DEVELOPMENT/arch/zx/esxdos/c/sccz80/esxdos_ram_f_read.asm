; int esxdos_f_read(uchar handle, void *dst, size_t nbyte)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_ram_f_read

EXTERN asm_esxdos_f_read

esxdos_ram_f_read:

   pop af
   pop bc
   pop ix
   pop hl
   
   push hl
   push hl
   push bc
   push af
   
   ld a,l
   jp asm_esxdos_f_read

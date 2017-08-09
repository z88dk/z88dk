; int esxdos_f_write(uchar handle, void *src, size_t nbyte)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_ram_f_write_callee

EXTERN asm_esxdos_f_write

esxdos_ram_f_write_callee:

   pop hl
   pop bc
   pop ix
   ex (sp),hl
   
   ld a,l
   jp asm_esxdos_f_write

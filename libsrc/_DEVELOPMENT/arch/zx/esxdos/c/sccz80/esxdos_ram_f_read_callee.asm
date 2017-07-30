; int esxdos_f_read(uchar handle, void *dst, size_t nbyte)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_ram_f_read_callee

EXTERN asm_esxdos_f_read

esxdos_ram_f_read_callee:

   pop hl
   pop bc
   pop ix
   ex (sp),hl
   
   ld a,l
   jp asm_esxdos_f_read

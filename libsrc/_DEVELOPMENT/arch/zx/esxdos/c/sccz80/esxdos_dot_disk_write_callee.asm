; int esxdos_disk_write(uchar device, ulong position, void *src)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_dot_disk_write_callee

EXTERN asm_esxdos_disk_write

esxdos_dot_disk_write_callee:

   pop hl
   pop ix
   pop de
   pop bc
   ex (sp),hl
   
   ld a,l

   push ix
   pop hl

   jp asm_esxdos_disk_write

; int esxdos_disk_read(uchar device, ulong position, void *dst)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_ram_disk_read_callee

EXTERN asm_esxdos_disk_read

esxdos_ram_disk_read_callee:

   pop hl
   pop ix
   pop de
   pop bc
   ex (sp),hl
   
   ld a,l
   jp asm_esxdos_disk_read

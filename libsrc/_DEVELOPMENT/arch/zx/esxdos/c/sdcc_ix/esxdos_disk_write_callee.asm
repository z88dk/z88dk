; int esxdos_disk_write(uchar device, ulong position, void *src)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_disk_write_callee
PUBLIC l0_esxdos_disk_write_callee

EXTERN asm_esxdos_disk_write

_esxdos_disk_write_callee:

   pop hl
   dec sp
   pop af
   pop de
   pop bc
   ex (sp),hl

l0_esxdos_disk_write_callee:

   push ix
   push iy
   
   call asm_esxdos_disk_write

   pop iy
   pop ix
   ret

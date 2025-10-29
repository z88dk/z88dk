; int esxdos_disk_read(uchar device, ulong position, void *dst)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_disk_read_callee
PUBLIC l0_esxdos_disk_read_callee

EXTERN asm_esxdos_disk_read

_esxdos_disk_read_callee:

   pop hl
   dec sp
   pop af
   pop de
   pop bc
   ex (sp),hl

l0_esxdos_disk_read_callee:

   push iy
   
   call asm_esxdos_disk_read

   pop iy
   ret

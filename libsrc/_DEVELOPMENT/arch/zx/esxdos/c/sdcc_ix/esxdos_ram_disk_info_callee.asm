; int esxdos_disk_info(uchar device, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_ram_disk_info_callee
PUBLIC l0_esxdos_ram_disk_info_callee

EXTERN asm_esxdos_disk_info

_esxdos_ram_disk_info_callee:

   pop hl
   dec sp
   pop af
   ex (sp),hl

l0_esxdos_ram_disk_info_callee:

   push hl
   ex (sp),ix
   push iy
   
   call asm_esxdos_disk_info

   pop iy
   pop ix
   ret

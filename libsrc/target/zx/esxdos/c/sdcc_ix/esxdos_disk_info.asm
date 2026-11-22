; int esxdos_disk_info(uchar device, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_disk_info

EXTERN l0_esxdos_disk_info_callee

_esxdos_disk_info:

   pop bc
   dec sp
   pop af
   pop hl
   
   push hl
   dec sp
   push bc
   
   jp l0_esxdos_disk_info_callee

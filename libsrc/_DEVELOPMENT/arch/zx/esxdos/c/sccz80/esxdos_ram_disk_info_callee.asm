; int esxdos_disk_info(uchar device, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_ram_disk_info_callee

EXTERN asm_esxdos_disk_info

esxdos_ram_disk_info_callee:

   pop af
   pop ix
   pop bc
   push af
   
   ld a,c
   jp asm_esxdos_disk_info

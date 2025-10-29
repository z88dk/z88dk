; int esxdos_disk_info(uchar device, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_disk_info_callee

EXTERN asm_esxdos_disk_info

esxdos_disk_info_callee:

   pop af
   pop hl
   pop bc
   push af
   
   ld a,c
   jp asm_esxdos_disk_info

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_disk_info_callee
defc _esxdos_disk_info_callee = esxdos_disk_info_callee
ENDIF


; int esxdos_disk_write(uchar device, ulong position, void *src)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_disk_write_callee

EXTERN asm_esxdos_disk_write

esxdos_disk_write_callee:

   pop hl
   pop ix
   pop de
   pop bc
   ex (sp),hl
   
   ld a,l

   push ix
   pop hl

   jp asm_esxdos_disk_write

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_disk_write_callee
defc _esxdos_disk_write_callee = esxdos_disk_write_callee
ENDIF


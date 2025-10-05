; int esxdos_disk_read(uchar device, ulong position, void *dst)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_disk_read_callee

EXTERN asm_esxdos_disk_read

esxdos_disk_read_callee:

   pop hl
   pop ix
   pop de
   pop bc
   ex (sp),hl
   
   ld a,l

   push ix
   pop hl

   jp asm_esxdos_disk_read

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_disk_read_callee
defc _esxdos_disk_read_callee = esxdos_disk_read_callee
ENDIF


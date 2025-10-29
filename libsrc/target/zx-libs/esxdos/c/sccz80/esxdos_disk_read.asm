; int esxdos_disk_read(uchar device, ulong position, void *dst)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_disk_read

EXTERN asm_esxdos_disk_read

esxdos_disk_read:

   pop hl
   pop ix
   pop de
   pop bc
   dec sp
   pop af
   
   dec sp
   push bc
   push de
   push hl
   push hl
   
   push ix
   pop hl
   
   jp asm_esxdos_disk_read

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_disk_read
defc _esxdos_disk_read = esxdos_disk_read
ENDIF


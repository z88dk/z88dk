; int esxdos_disk_write(uchar device, ulong position, void *src)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_disk_write

EXTERN asm_esxdos_disk_write

esxdos_disk_write:

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

   jp asm_esxdos_disk_write

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_disk_write
defc _esxdos_disk_write = esxdos_disk_write
ENDIF


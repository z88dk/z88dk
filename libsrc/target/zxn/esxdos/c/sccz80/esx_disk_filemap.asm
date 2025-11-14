; unsigned char esx_disk_filemap(uint8_t handle,struct esx_filemap *fmap)

SECTION code_esxdos

PUBLIC esx_disk_filemap

EXTERN asm_esx_disk_filemap

esx_disk_filemap:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld a,e
   jp asm_esx_disk_filemap

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_disk_filemap
defc _esx_disk_filemap = esx_disk_filemap
ENDIF


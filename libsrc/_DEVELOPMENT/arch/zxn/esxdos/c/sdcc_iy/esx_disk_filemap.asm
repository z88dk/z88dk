; unsigned char esx_disk_filemap(uint8_t handle,struct esx_filemap *fmap)

SECTION code_esxdos

PUBLIC _esx_disk_filemap

EXTERN asm_esx_disk_filemap

_esx_disk_filemap:

   pop de
   dec sp
   pop af
   pop hl
   
   push hl
   push af
   inc sp
   push de

   jp asm_esx_disk_filemap

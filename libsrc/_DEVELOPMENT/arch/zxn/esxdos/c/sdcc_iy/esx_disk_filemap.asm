; unsigned char esx_disk_filemap(uint8_t handle,struct esx_filemap *fmap)

SECTION code_esxdos

PUBLIC _esx_disk_filemap

EXTERN l0_esx_disk_filemap_callee

_esx_disk_filemap:

   pop de
   dec sp
   pop af
   pop hl
   
   push hl
   push af
   inc sp
   push de

   jp l0_esx_disk_filemap_callee

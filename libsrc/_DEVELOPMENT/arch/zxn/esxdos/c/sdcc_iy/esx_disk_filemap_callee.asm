; unsigned char esx_disk_filemap(uint8_t handle,struct esx_filemap *fmap)

SECTION code_esxdos

PUBLIC _esx_disk_filemap_callee

EXTERN asm_esx_disk_filemap

_esx_disk_filemap_callee:

   pop hl
   dec sp
   pop af
   ex (sp),hl
   
   jp asm_esx_disk_filemap

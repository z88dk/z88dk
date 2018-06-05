; unsigned char esx_disk_stream_start(struct esx_filemap_entry *entry)

SECTION code_esxdos

PUBLIC _esx_disk_stream_start

EXTERN asm_esx_disk_stream_start

_esx_disk_stream_start:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_esx_disk_stream_start

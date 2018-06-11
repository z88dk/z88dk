; unsigned char esx_disk_stream_start(struct esx_filemap_entry *entry)

SECTION code_esxdos

PUBLIC _esx_disk_stream_start

EXTERN _esx_disk_stream_start_fastcall

_esx_disk_stream_start:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esx_disk_stream_start_fastcall

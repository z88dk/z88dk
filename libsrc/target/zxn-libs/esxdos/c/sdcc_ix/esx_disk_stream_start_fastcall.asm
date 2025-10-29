; unsigned char esx_disk_stream_start(struct esx_filemap_entry *entry)

SECTION code_esxdos

PUBLIC _esx_disk_stream_start_fastcall

EXTERN asm_esx_disk_stream_start

_esx_disk_stream_start_fastcall:

   push ix

   call asm_esx_disk_stream_start

   pop ix
   ret

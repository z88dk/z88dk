; unsigned char esx_disk_stream_start(struct esx_filemap_entry *entry)

SECTION code_esxdos

PUBLIC esx_disk_stream_start

EXTERN asm_esx_disk_stream_start

defc esx_disk_stream_start = asm_esx_disk_stream_start

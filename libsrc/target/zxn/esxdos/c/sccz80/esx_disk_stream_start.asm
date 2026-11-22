; unsigned char esx_disk_stream_start(struct esx_filemap_entry *entry)

SECTION code_esxdos

PUBLIC esx_disk_stream_start

EXTERN asm_esx_disk_stream_start

defc esx_disk_stream_start = asm_esx_disk_stream_start

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_disk_stream_start
defc _esx_disk_stream_start = esx_disk_stream_start
ENDIF


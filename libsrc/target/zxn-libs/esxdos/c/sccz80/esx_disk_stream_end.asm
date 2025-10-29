; unsigned char esx_disk_stream_end(void)

SECTION code_esxdos

PUBLIC esx_disk_stream_end

EXTERN asm_esx_disk_stream_end

defc esx_disk_stream_end = asm_esx_disk_stream_end

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_disk_stream_end
defc _esx_disk_stream_end = esx_disk_stream_end
ENDIF


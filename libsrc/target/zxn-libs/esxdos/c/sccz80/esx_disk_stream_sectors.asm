; void *esx_disk_stream_sectors(void *dst,uint8_t sectors)

SECTION code_esxdos

PUBLIC esx_disk_stream_sectors

EXTERN asm_esx_disk_stream_sectors

esx_disk_stream_sectors:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_esx_disk_stream_sectors

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_disk_stream_sectors
defc _esx_disk_stream_sectors = esx_disk_stream_sectors
ENDIF


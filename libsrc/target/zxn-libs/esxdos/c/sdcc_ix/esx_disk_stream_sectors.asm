; void *esx_disk_stream_sectors(void *dst,uint8_t sectors)

SECTION code_esxdos

PUBLIC _esx_disk_stream_sectors

EXTERN asm_esx_disk_stream_sectors

_esx_disk_stream_sectors:

   pop af
   pop hl
   dec sp
   pop de
   
   push de
   inc sp
   push hl
   push af
   
   ld e,d
   jp asm_esx_disk_stream_sectors

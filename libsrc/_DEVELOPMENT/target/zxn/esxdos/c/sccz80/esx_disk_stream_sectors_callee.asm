; void *esx_disk_stream_sectors(void *dst,uint8_t sectors)

SECTION code_esxdos

PUBLIC esx_disk_stream_sectors_callee

EXTERN asm_esx_disk_stream_sectors

esx_disk_stream_sectors_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_esx_disk_stream_sectors

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_disk_stream_sectors_callee
defc _esx_disk_stream_sectors_callee = esx_disk_stream_sectors_callee
ENDIF


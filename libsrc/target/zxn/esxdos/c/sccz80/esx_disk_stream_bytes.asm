; void *esx_disk_stream_bytes(void *dst,uint16_t len)

SECTION code_esxdos

PUBLIC esx_disk_stream_bytes

EXTERN asm_esx_disk_stream_bytes

esx_disk_stream_bytes:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_esx_disk_stream_bytes

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_disk_stream_bytes
defc _esx_disk_stream_bytes = esx_disk_stream_bytes
ENDIF


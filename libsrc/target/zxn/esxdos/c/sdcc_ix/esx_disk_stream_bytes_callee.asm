; void *esx_disk_stream_bytes(void *dst,uint16_t len)

SECTION code_esxdos

PUBLIC _esx_disk_stream_bytes_callee

EXTERN asm_esx_disk_stream_bytes

_esx_disk_stream_bytes_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_esx_disk_stream_bytes

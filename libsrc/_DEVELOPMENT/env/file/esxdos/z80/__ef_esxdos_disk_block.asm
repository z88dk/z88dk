SECTION code_env

PUBLIC __ef_esxdos_disk_block
PUBLIC __ef_esxdos_disk_block_end
PUBLIC __ef_esxdos_disk_block_offset_0

EXTERN __ef_esxdos_jp_open
EXTERN __ef_esxdos_jp_close
EXTERN __ef_esxdos_jp_seek
EXTERN __ef_esxdos_jp_size
EXTERN __ef_esxdos_jp_read
EXTERN __ef_esxdos_jp_write
EXTERN __ef_esxdos_jp_unlink

__ef_esxdos_disk_block:

   defb 0                      ; ix-5  file handle
   defb 0                      ; ix-4  flags
   defb 0                      ; ix-3  error code
   defw 0                      ; ix-1,-2  char *filename

__ef_esxdos_disk_block_offset_0:

   defb 195                    ; ix+0  jp open
   defw __ef_esxdos_jp_open
   
   defb 195                    ; ix+3  jp close
   defw __ef_esxdos_jp_close
   
   defb 195
   defw __ef_esxdos_jp_seek    ; ix+6  jp seek
   
   defb 195
   defw __ef_esxdos_jp_size    ; ix+9  jp size
   
   defb 195                    ; ix+12 jp read
   defw __ef_esxdos_jp_read

   defb 195                    ; ix+15 jp write
   defw __ef_esxdos_jp_write 
   
   defb 195                    ; ix+18 jp unlink
   defw __ef_esxdos_jp_unlink

__ef_esxdos_disk_block_end:

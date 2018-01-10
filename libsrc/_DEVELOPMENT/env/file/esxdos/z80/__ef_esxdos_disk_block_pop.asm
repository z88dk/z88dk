SECTION code_env

PUBLIC __ef_esxdos_disk_block_pop

EXTERN __ef_esxdos_disk_block
EXTERN __ef_esxdos_disk_block_end

__ef_esxdos_disk_block_pop:

   ; pop disk io block from stack
   ; must be called
   ;
   ; enter : stack = junk word, disk io block, ret
   ;
   ; uses : f', ix
   
   ex af,af'
   
   ld ix,__ef_esxdos_disk_block_end - __ef_esxdos_disk_block + 2
   add ix,sp                   ; ix = & junk word
   
   ld (ix+0),l
   ld (ix+1),h
   
   pop hl                      ; hl = return address
   
   ld sp,ix
   ex (sp),hl
   
   ex af,af'
   ret

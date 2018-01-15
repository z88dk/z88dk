SECTION code_env

PUBLIC __ef_esxdos_disk_block_push

EXTERN __ef_esxdos_disk_block
EXTERN __ef_esxdos_disk_block_end
EXTERN __ef_esxdos_disk_block_offset_0

__ef_esxdos_disk_block_push:

   ; push esxdos disk io block onto stack
   ; must be called
   ;
   ; exit : ix = & esxdos disk io block
   ;        stack = junk word, disk io block
   ;
   ; uses : f, ix
   
   ld ix,+(__ef_esxdos_disk_block - __ef_esxdos_disk_block_end) & 0xffff
   add ix,sp
   ld sp,ix
   
   push hl
   push de
   push bc
   
   push ix
   pop de

   ld hl,__ef_esxdos_disk_block
   ld bc,__ef_esxdos_disk_block_end - __ef_esxdos_disk_block
   
   ldir                        ; copy disk io block to stack

   ld bc,__ef_esxdos_disk_block_offset_0 - __ef_esxdos_disk_block
   add ix,bc                   ; ix = & disk io block
   
   ld l,(ix+21)
   ld h,(ix+22)                ; hl = return address
   
   pop bc
   pop de
   ex (sp),hl
   
   ret

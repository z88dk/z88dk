
; void *fzx_buffer_partition(void *buf, uint len, uint width)

XLIB fzx_buffer_partition

LIB asm_fzx_buffer_partition

fzx_buffer_partition:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_fzx_buffer_partition

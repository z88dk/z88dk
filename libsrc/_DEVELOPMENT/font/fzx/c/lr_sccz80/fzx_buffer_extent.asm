
; uint fzx_buffer_extent(void *buf, uint len)

XLIB fzx_buffer_extent

LIB asm_fzx_buffer_extent

fzx_buffer_extent:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_fzx_buffer_extent


; uint fzx_buffer_extent(void *buf, uint len)

SECTION seg_code_fzx

PUBLIC fzx_buffer_extent

EXTERN asm_fzx_buffer_extent

fzx_buffer_extent:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_fzx_buffer_extent

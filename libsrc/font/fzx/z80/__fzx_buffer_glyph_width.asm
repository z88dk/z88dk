
SECTION code_font
SECTION code_font_fzx

PUBLIC __fzx_buffer_glyph_width

EXTERN asm_fzx_glyph_width

__fzx_buffer_glyph_width:

   push bc                     ; save buflen
   push hl                     ; save allowed width

   push ix
   pop hl                      ; hl = struct fzx_font *
   
   call asm_fzx_glyph_width

   inc a
   add a,(ix+1)                ; a = glyph width + tracking
   
   pop hl                      ; hl = allowed width
   
   ld c,a
   ld b,0
   
   sbc hl,bc
   jr c, end_buffer            ; if allowed width exceeded

   pop bc                      ; bc = buflen
   ret

end_buffer:

   add hl,bc

   pop bc
   ret

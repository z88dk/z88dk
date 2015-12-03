
; void *fzx_string_partition_ww(struct fzx_font *ff, char *s, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC asm_fzx_string_partition_ww

EXTERN __fzx_string_glyph_width, __fzx_partition_width_adjust, l_inc_sp

asm_fzx_string_partition_ww:

   ; find longest prefix of string without splitting words
   ; that has pixel extent <= to the allowed pixel extent
   ;
   ; enter : ix = struct fzx_font *
   ;         hl = allowed width in pixels
   ;         de = char *s
   ;
   ; exit  : hl = s + prefix_len
   ;         de = remaining allowed width
   ;         carry set if allowed width exceeded
   ;
   ; uses  : af, bc, de, hl

   call __fzx_partition_width_adjust

next_spaces:

   push de                     ; save allowed prefix
   push hl                     ; save allowed width remaining

consume_spaces_loop:

   ld a,(de)
   or a
   jr z, end_string_accept
   
   cp ' '
   jr nz, consume_word_loop

   call __fzx_string_glyph_width
   jr c, end_string            ; if allowed width exceeded
   
   inc de
   jr consume_spaces_loop
   
consume_word_loop:

   call __fzx_string_glyph_width
   jr c, end_string            ; if allowed width exceeded

   inc de
   
   ld a,(de)
   or a
   jr z, end_string_accept
   
   cp ' '
   jr nz, consume_word_loop
   
   ; word ends
   
   pop bc                      ; junk last save point
   pop bc

   jr next_spaces

end_string_accept:

   ex de,hl
   jp l_inc_sp - 6             ; junk last save point

end_string:

   pop de                      ; de = saved allowed width remaining
   pop hl                      ; hl = saved s + prefix_len
   
   ret

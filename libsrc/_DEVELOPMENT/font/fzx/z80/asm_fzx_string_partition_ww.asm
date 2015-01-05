
; void *fzx_string_partition_ww(struct fzx_font *ff, char *s, uint16_t allowed_width)

SECTION code_font_fzx

PUBLIC asm_fzx_string_partition_ww

EXTERN __fzx_string_glyph_width, l_inc_sp

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

consume_spaces_loop:

   ld a,(de)
   or a
   jr z, end_string_spaces
   
   cp ' '
   jr nz, next_word

consume_spaces_loop_join:

   call __fzx_string_glyph_width
   jr c, end_string_spaces     ; if allowed width exceeded
   
   inc de
   jr consume_spaces_loop

next_word:

   push de                     ; save allowed prefix
   push hl                     ; save allowed width remaining
   
consume_word_loop:

   call __fzx_string_glyph_width
   jr c, end_string_word       ; if allowed width exceeded

   inc de
   ld a,(de)

   or a
   jr z, end_word                ; if string ends
   
   cp ' '
   jr nz, consume_word_loop
   
   ; word ends

end_word:
   
   call l_inc_sp - 4           ; junk two items on stack

   or a
   jr nz, consume_spaces_loop_join

end_string_spaces:

   ; de = s + prefix_len
   ; hl = allowed width
   
   ex de,hl
   ret

end_string_word:

   pop de                      ; de = saved allowed width remaining
   pop hl                      ; hl = saved s + prefix_len
   
   ret

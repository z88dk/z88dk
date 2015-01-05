
; void *fzx_buffer_partition_ww(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font_fzx

PUBLIC asm_fzx_buffer_partition_ww

EXTERN __fzx_buffer_glyph_width, l_inc_sp

asm_fzx_buffer_partition_ww:

   ; find longest prefix of buffer without splitting words
   ; that has pixel extent <= to the allowed pixel extent
   ;
   ; enter : ix = struct fzx_font *
   ;         hl = allowed width in pixels
   ;         de = char *buf
   ;         bc = unsigned int buflen
   ;
   ; exit  : hl = buf + prefix_len
   ;         bc = remaining buflen
   ;         de = remaining allowed width
   ;         carry set if allowed width exceeded
   ;
   ; uses  : af, bc, de, hl

consume_spaces_loop:

   ld a,b
   or c
   jr z, end_buffer_spaces
   
   ld a,(de)
   
   cp ' '
   jr nz, next_word

consume_spaces_loop_join:

   call __fzx_buffer_glyph_width
   jr c, end_buffer_spaces     ; if allowed width exceeded
   
   dec bc
   inc de
   
   jr consume_spaces_loop

next_word:

   push bc                     ; save allowed buflen
   push de                     ; save allowed prefix
   push hl                     ; save allowed width remaining

consume_word_loop:

   call __fzx_buffer_glyph_width
   jr c, end_buffer_word       ; if allowed width exceeded

   dec bc
   inc de
   
   ld a,b
   or c
   jr z, end_word              ; if buffer ends
   
   ld a,(de)
   
   cp ' '
   jr nz, consume_word_loop

   ; word ends
   
   call l_inc_sp - 6           ; junk three items on stack
   jr consume_spaces_loop_join
   
end_word:

   call l_inc_sp - 6           ; junk three items on stack

end_buffer_spaces:

   ; de = buf + prefix_len
   ; bc = remaining buflen
   ; hl = remaining allowed width

   ex de,hl
   ret

end_buffer_word:

   pop de                      ; de = saved allowed width
   pop hl                      ; hl = saved buf + prefix_len
   pop bc                      ; bc = saved remaining buflen

   ret


; void *fzx_buffer_partition_ww(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC asm_fzx_buffer_partition_ww

EXTERN __fzx_buffer_glyph_width, __fzx_partition_width_adjust, l_inc_sp

asm_fzx_buffer_partition_ww:

   ; Find longest prefix of buffer without splitting words
   ; that has pixel extent <= to the allowed pixel extent.
   ; The prefix will not end in a space.
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

   call __fzx_partition_width_adjust

next_spaces:

   push bc                     ; save remaining buflen
   push de                     ; save allowed prefix
   push hl                     ; save allowed width remaining

consume_spaces_loop:

   ld a,b
   or c
   jr z, end_buffer_accept

   ld a,(de)
   
   cp ' '
   jr nz, consume_word_loop

   call __fzx_buffer_glyph_width
   jr c, end_buffer            ; if allowed width exceeded
   
   dec bc
   inc de
   
   jr consume_spaces_loop

consume_word_loop:

   call __fzx_buffer_glyph_width
   jr c, end_buffer            ; if allowed width exceeded

   dec bc
   inc de
   
   ld a,b
   or c
   jr z, end_buffer_accept
   
   ld a,(de)
   
   cp ' '
   jr nz, consume_word_loop

   ; word ends
   
   pop af                      ; junk last save point
   pop af
   pop af

   jr next_spaces

end_buffer_accept:

   ex de,hl
   jp l_inc_sp - 6             ; junk last save point

end_buffer:

   pop de                      ; de = saved allowed width
   pop hl                      ; hl = saved buf + prefix_len
   pop bc                      ; bc = saved remaining buflen

   ret

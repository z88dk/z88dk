
; void *fzx_buffer_partition(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC asm_fzx_buffer_partition

EXTERN __fzx_buffer_glyph_width, __fzx_partition_width_adjust

asm_fzx_buffer_partition:

   ; find longest prefix of buffer that has pixel extent
   ; less than or equal to the allowed pixel extent
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

partition_loop:

   ld a,b
   or c
   jr z, end_buffer
   
   ld a,(de)
   
   call __fzx_buffer_glyph_width
   jr c, end_buffer
   
   dec bc
   inc de
   
   jr partition_loop

end_buffer:

   ; de = buf + prefix
   ; bc = remaining buflen
   ; hl = remaining allowed width
   ; carry set if allowed width exceeded
   
   ex de,hl
   ret

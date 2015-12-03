
; void *fzx_string_partition(struct fzx_font *ff, char *s, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC asm_fzx_string_partition

EXTERN __fzx_string_glyph_width, __fzx_partition_width_adjust

asm_fzx_string_partition:

   ; find longest prefix of string that has pixel extent
   ; less than or equal to the allowed pixel extent
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

partition_loop:

   ld a,(de)
   or a
   jr z, end_string_0
   
   call __fzx_string_glyph_width
   jr c, end_string_1          ; if allowed width exceeded
   
   inc de
   jr partition_loop

end_string_1:

   add hl,bc   

end_string_0:

   ; de = s + prefix_len
   ; hl = remaining allowed width
   ; carry set if allowed width exceeded

   ex de,hl
   ret

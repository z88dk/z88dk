
SECTION code_font_fzx

PUBLIC __fzx_puts_newline

__fzx_puts_newline:

   ; uses : af, de, hl

   ld a,(ix+17)
   ld (ix+5),a
   ld a,(ix+18)
   ld (ix+6),a                 ; x = fzx_state.left_margin
   
   ld l,(ix+3)
   ld h,(ix+4)                 ; hl = struct fzx_font *
   
   ld e,(hl)
   ld d,0                      ; de = font height
   
   ld l,(ix+7)
   ld h,(ix+8)                 ; hl = fzx_state.y
   
   add hl,de
   
   ld (ix+7),l
   ld (ix+8),h                 ; update y coord

   ret

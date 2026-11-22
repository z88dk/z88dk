
SECTION code_font
SECTION code_font_fzx

PUBLIC __fzx_puts_newline
PUBLIC __fzx_puts_newline_set_y

EXTERN __fzx_puts_single_spacing

__fzx_puts_newline:

   ; execute newline by updating coordinates
   ;
   ; enter : ix = struct fzx_state *
   ;
   ; exit  : de = font height
   ;         hl = new_y = y + font_height
   ;
   ; uses : af, de, hl

   ld a,(ix+17)
   ld (ix+5),a
   ld a,(ix+18)
   ld (ix+6),a                 ; x = fzx_state.left_margin

   call __fzx_puts_single_spacing

__fzx_puts_newline_set_y:

   ld (ix+7),l
   ld (ix+8),h                 ; update y coord

   ret


SECTION code_font_fzx

PUBLIC asm_fzx_state_init

EXTERN __fzx_draw_or, l_setmem_hl

asm_fzx_state_init:

   ; initialize cross-platform portion of fzx_state
   ;
   ; enter : hl = struct fzx_state *
   ;         bc = struct fzx_font *
   ;         de = struct r_Rect16 *
   ;
   ; exit  : hl = & fzx_state.left_margin + 2b
   ;
   ; uses  : af, bc, de, hl
   
   ld (hl),195
   inc hl
   ld (hl),__fzx_draw_or % 256
   inc hl
   ld (hl),__fzx_draw_or / 256
   inc hl
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   
   xor a
   call l_setmem_hl - 8
   
   ex de,hl
   
   ld bc,8
   ldir
   
   ex de,hl
   
   ld (hl),3
   inc hl
   ld (hl),a
   inc hl
   
   ret

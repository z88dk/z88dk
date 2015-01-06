
; char *fzx_char_metrics(struct fzx_font *ff, struct fzx_cmetric *fm, int c)

SECTION code_font_fzx

PUBLIC _fzx_char_metrics

_fzx_char_metrics:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   ld a,c
   call asm_fzx_char_metrics
   
   ex de,hl                    ; de = bitmap address, hl = struct fzx_cmetric *
   
   ld (hl),a
   inc hl
   
   inc b
   ld (hl),b
   inc hl
   
   ld (hl),c
   inc hl
   
   ld (hl),e
   inc hl
   ld (hl),d
   
   ex de,hl                    ; return bitmap address
   ret

   INCLUDE "font/fzx/z80/asm_fzx_char_metrics.asm"


; char *fzx_char_metrics(struct fzx_font *ff, struct fzx_cmetric *fm, int c)

SECTION code_font_fzx

PUBLIC fzx_char_metrics_callee, fzx0_char_metrics_callee

fzx_char_metric_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

fzx0_char_metrics_callee:
   
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

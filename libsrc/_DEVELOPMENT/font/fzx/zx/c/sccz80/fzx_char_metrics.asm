
; int fzx_char_metrics(struct fzx_cmetric *m, uchar c)

SECTION code_font_fzx

PUBLIC fzx_char_metrics

EXTERN asm_fzx_char_metrics

fzx_char_metrics:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld a,l
   
   jp asm_fzx_char_metrics

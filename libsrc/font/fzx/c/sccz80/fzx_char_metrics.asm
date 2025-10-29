
; char *fzx_char_metrics(struct fzx_font *ff, struct fzx_cmetric *fm, int c)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_char_metrics

EXTERN fzx0_char_metrics_callee

fzx_char_metrics:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp fzx0_char_metrics_callee


; char *fzx_char_metrics(struct fzx_font *ff, struct fzx_cmetric *fm, int c)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_char_metrics

EXTERN l0_fzx_char_metrics_callee

_fzx_char_metrics:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp l0_fzx_char_metrics_callee

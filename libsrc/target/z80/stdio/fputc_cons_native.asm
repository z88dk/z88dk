;
; Noop implementation of printing to console

SECTION code_clib

EXTERN l_ret
PUBLIC fputc_cons_native
PUBLIC _fputc_cons_native


defc fputc_cons_native = l_ret
defc _fputc_cons_native = fputc_cons_native


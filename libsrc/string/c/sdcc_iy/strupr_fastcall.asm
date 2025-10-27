
; char *strupr_fastcall(char *s)

SECTION code_clib
SECTION code_string

PUBLIC _strupr_fastcall

EXTERN asm_strupr

defc _strupr_fastcall = asm_strupr

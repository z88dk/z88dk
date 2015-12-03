
; long labs_fastcall(long j)

SECTION code_clib
SECTION code_stdlib

PUBLIC _labs_fastcall

EXTERN asm_labs

defc _labs_fastcall = asm_labs


; long labs(long j)

SECTION code_stdlib

PUBLIC labs

EXTERN asm_labs

defc labs = asm_labs

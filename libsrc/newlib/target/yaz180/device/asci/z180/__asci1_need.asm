
; Generate references to any portions of asci1
; code that must be part of every compile that
; uses the asci1.

PUBLIC asm_asci1_need

EXTERN asm_asci1_init

defc asm_asci1_need = asm_asci1_init

; The asci1 must be initialized before main is called

SECTION code_crt_init
call asm_asci1_init

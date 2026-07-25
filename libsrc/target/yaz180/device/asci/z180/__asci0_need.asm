
; Generate references to any portions of asci0
; code that must be part of every compile that
; uses the asci0.

PUBLIC asm_asci0_need

EXTERN asm_asci0_init

defc asm_asci0_need = asm_asci0_init

; The asci0 must be initialized before main is called

SECTION code_crt_init
call asm_asci0_init

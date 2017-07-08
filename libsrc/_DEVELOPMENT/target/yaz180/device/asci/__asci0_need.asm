
; Generate references to any portions of asci0
; code that must be part of every compile that
; uses the asci0.

PUBLIC _asci0_need

EXTERN _asci0_init

defc _asci0_need = _asci0_init

; The asci0 must be initialized before main is called

SECTION code_crt_init
call _asci0_init

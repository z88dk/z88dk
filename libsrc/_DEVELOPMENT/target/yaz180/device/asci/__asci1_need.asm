
; Generate references to any portions of asci1
; code that must be part of every compile that
; uses the asci1.

PUBLIC _asci1_need

EXTERN _asci1_init

defc _asci1_need = _asci1_init

; The asci1 must be initialized before main is called

SECTION code_crt_init
call _asci1_init

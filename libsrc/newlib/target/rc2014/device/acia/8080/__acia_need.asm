
; Generate references to any portions of ACIA
; code that must be part of every compile that
; uses the ACIA.

PUBLIC _acia_need

EXTERN _acia_init

defc _acia_need = _acia_init

; The ACIA must be initialized before main is called

SECTION code_crt_init
call _acia_init

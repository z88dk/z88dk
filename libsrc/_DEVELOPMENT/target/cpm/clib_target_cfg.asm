
IF !_CLIB_TARGET_CFG_ASM_
defc _CLIB_TARGET_CFG_ASM_ = 1

; **********************************
; IF YOU MAKE CHANGES TO THIS FILE
; YOU MUST RECOMPILE THE CPM LIBRARY
; **********************************

;;;;;;;;;;;;;;;;;;;;;;;;;;
; Target CPM Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;
;; ARCHITECTURE CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;

defc __cpm        = 1
defc __model      = 0

defc __z80_nmos   = 1                  ; nmos z80 (set to 1 if unknown)
defc __clock_freq = 4000000            ; Hz


ENDIF

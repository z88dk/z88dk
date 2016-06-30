
IF !_CLIB_TARGET_CFG_ASM_
defc _CLIB_TARGET_CFG_ASM_ = 1

; *********************************************************************
; IF YOU MAKE CHANGES TO THIS FILE YOU MUST RECOMPILE THE CPM LIBRARIES
; *********************************************************************

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EMBEDDED - TARGET CLIB CONFIGURATION ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;--------------------------------------------------------------
;-- ARCHITECTURE CONSTANTS ------------------------------------
;--------------------------------------------------------------

defc __cpm          = 22               ; cpm 2.2
defc __clock_freq   = 4000000          ; Hz

defc __z80_cpu_info = $01

; bit 0 = $01 = if set indicates an nmos z80 (if unsure set it)
; bit 1 = $02 = allow undocumented instruction "sll r"

;--------------------------------------------------------------
;-- SOUND/BIT -------------------------------------------------
;--------------------------------------------------------------

; 1-bit sound constants
; cpm does not specify any audio hardware so these constants
; are garbage but could be fixed if audio is present

defc __sound_bit_method       = 1      ; 1 = port_8, 2 = port_16, 3 = memory
defc __sound_bit_port         = $fe    ; port or memory address
defc __sound_bit_toggle       = $10    ; bits to toggle to make noise
defc __sound_bit_toggle_pos   = 4      ; bit position to test state of output
defc __sound_bit_read_mask    = $17    ; part of state byte to be used in output
defc __sound_bit_write_mask   = $e8    ; part of state byte to be preserved on write

ENDIF

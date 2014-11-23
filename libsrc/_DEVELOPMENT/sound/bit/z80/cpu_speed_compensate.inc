
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FAST CPU COMPENSATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Insert constant T-state delay to match wall-clock
; passage of time equivalent to NOMINAL_T T states
; at cpu frequency NOMINAL_CLOCK.

; enter : NOMINAL_CLOCK = nominal cpu speed in Hz
;         NOMINAL_T     = nominal T states
;
;         TARGET_CLOCK  = actual cpu speed in Hz
;
; uses  : f

; TARGET_T (extra) = TARGET_CLOCK * NOMINAL_T / NOMINAL_CLOCK - NOMINAL_T
; warning: computation is done in 32 bits

defc TARGET_T = (TARGET_CLOCK / 1000) * NOMINAL_T / (NOMINAL_CLOCK / 1000)

IF (TARGET_T > NOMINAL_T)

   defc TARGET_T = TARGET_T - NOMINAL_T
   
   IF (TARGET_T >= 36) & (TARGET_T < 214) 
   
      push bc
      ld b,#(TARGET_T - 23) / 13
      djnz ASMPC - 2
      pop bc
      
      defc TARGET_T = TARGET_T - 23 - (13 * ((TARGET_T - 23) / 13))

   ENDIF

   IF (TARGET_T >= 214)
   
      EXTERN asm_z80_delay_tstate
   
      push af
      push bc
      push hl
      
      ld hl,TARGET_T - 73
      call asm_z80_delay_tstate
      
      pop hl
      pop bc
      pop af
      
      defc TARGET_T = 0
      
   ENDIF

   ; small corrections
   
   IF TARGET_T >= 4
   
      nop
   
   ENDIF
   
   IF TARGET_T >= 8
   
      nop
   
   ENDIF

   IF TARGET_T >= 12
   
      nop
   
   ENDIF

   IF TARGET_T >= 16
   
      nop
   
   ENDIF

   IF TARGET_T >= 20
   
      nop
   
   ENDIF

   IF TARGET_T >= 24
   
      nop
   
   ENDIF

   IF TARGET_T >= 28
   
      nop
   
   ENDIF

   IF TARGET_T >= 32
   
      nop
   
   ENDIF

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

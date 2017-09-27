
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt rules for V-Tech Genius Leader ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   ; Define Memory Banks
;   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   IFNDEF CRT_ORG_DTX
;      defc CRT_ORG_DTX     = 0x8000
;   ENDIF
;
;   IFNDEF CRT_ORG_BANK_00
;      defc CRT_ORG_BANK_00 = 0xc000
;   ENDIF
;
;   IFNDEF CRT_ORG_BANK_01
;      defc CRT_ORG_BANK_01 = 0xc000
;   ENDIF
;
;   IFNDEF CRT_ORG_BANK_02
;      defc CRT_ORG_BANK_02 = 0xc000
;   ENDIF
;
;   IFNDEF CRT_ORG_BANK_03
;      defc CRT_ORG_BANK_03 = 0xc000
;   ENDIF
;
;   IFNDEF CRT_ORG_BANK_04
;      defc CRT_ORG_BANK_04 = 0xc000
;   ENDIF
;
;   IFNDEF CRT_ORG_BANK_05
;      defc CRT_ORG_BANK_05 = 0xc000
;   ENDIF
;
;   IFNDEF CRT_ORG_BANK_06
;      defc CRT_ORG_BANK_06 = 0xc000
;   ENDIF
;
;   IFNDEF CRT_ORG_BANK_07
;      defc CRT_ORG_BANK_07 = 0xc000
;   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; Input Terminal Settings
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IFNDEF CRT_ITERM_TERMINAL_FLAGS
      defc CRT_ITERM_TERMINAL_FLAGS = 0x03b0
   ENDIF

   ; buffer size must be available to m4 (requires special case in zcc)
   
   ifdef(`M4__CRT_ITERM_EDIT_BUFFER_SIZE',,`define(`M4__CRT_ITERM_EDIT_BUFFER_SIZE', 32)')

   IFNDEF CRT_ITERM_EDIT_BUFFER_SIZE
      defc CRT_ITERM_EDIT_BUFFER_SIZE = M4__CRT_ITERM_EDIT_BUFFER_SIZE
   ENDIF


   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; Output Terminal Settings
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IFNDEF CRT_OTERM_TERMINAL_FLAGS
      defc CRT_OTERM_TERMINAL_FLAGS = 0x2370
   ENDIF

   ;
   ; Terminal Window Dimensions in Characters
   ;

   IFNDEF CRT_OTERM_WINDOW_X
      defc CRT_OTERM_WINDOW_X = 0           ; ZX: multiplied by two in 64 col terminals
   ENDIF
   
   IFNDEF CRT_OTERM_WINDOW_WIDTH
      defc CRT_OTERM_WINDOW_WIDTH = 20      ; ZX: multiplied by two in 64 col terminals
   ENDIF
   
   IFNDEF CRT_OTERM_WINDOW_Y
      defc CRT_OTERM_WINDOW_Y = 0
   ENDIF
   
   IFNDEF CRT_OTERM_WINDOW_HEIGHT
      defc CRT_OTERM_WINDOW_HEIGHT = 4  ; 1 for MODEL 1000, 2 for 2000/P/C, 4 for 400x
   ENDIF

;; end crt rules ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

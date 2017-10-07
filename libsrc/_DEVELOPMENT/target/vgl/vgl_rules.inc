
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


   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; Input Terminal Settings
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IFNDEF CRT_ITERM_TERMINAL_FLAGS
      ; bit hex  default meaning
      ; 15  8000         reserved (includes some state for driver base class)
      ; 14  4000         reserved (includes some state for driver base class)
      ; 13  2000         reserved (includes some state for driver base class)
      ; 12  1000         reserved (includes some state for driver base class)
      ; 11  0800         reserved (includes some state for driver base class)
      ; 10  0400         reserved (includes some state for driver base class)
      ;  9  0200 default = 1 to enable printed cursor
      ;  8  0100 default = 1 to enable crlf conversion (will be filtered to generate lf only)
      ;
      ;  7  0080 default = 1 to echo typed input characters
      ;  6  0040         = 1 to enable password mode (input printed as *)
      ;  5  0020 default = 1 to enable line mode (input is edited before being delivered)
      ;  4  0010 default = 1 to enable cook mode (input characters are interpreted in some way)
      ;  3  0008         = 1 for caps lock
      ;  2  0004         reserved (device state)
      ;  1  0002         reserved (device state)
      ;  0  0001         reserved (device state)
      ; zx default: 0x03b0
      ;defc CRT_ITERM_TERMINAL_FLAGS = 0x0390
      ;                                 cook       line       echo     crlf     curs
      defc CRT_ITERM_TERMINAL_FLAGS = 0x0010 + 0*0x0020 + 1*0x0080 + 0x0100 + 0x0200
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
      ; bit hex  default  meaning
      ; 15  8000          is currently reading input
      ; 14  4000          is readline
      ; 13  2000 default  cls on page
      ; 12  1000          ?
      ; 11  0800          ?
      ; 10  0400          ?
      ;  9  0200 default  print cursor
      ;  8  0100 default  ?crlf conversion (2)
      ;
      ;  7  0080          page mode
      ;  6  0040 default  pause when screen is full
      ;  5  0020 default  cook
      ;  4  0010 default  ?cr/lf onverion
      ;  3  0008          ?
      ;  2  0004          ?
      ;  1  0002          ?
      ;  0  0001          ?
      ; zx default: 0x2370
      ; defc CRT_OTERM_TERMINAL_FLAGS = 0x2330 ; 0x2330 = 0x2370 - 0x0040=pause
      ;                                 crlf     cook     crlf     curs      cls
      defc CRT_OTERM_TERMINAL_FLAGS = 0x0010 + 0x0020 + 0x0100 + 0x0200 + 0x2000
   ENDIF

   ;
   ; Terminal Window Dimensions in Characters
   ;

   IFNDEF CRT_OTERM_WINDOW_X
      defc CRT_OTERM_WINDOW_X = 0           ; ZX: multiplied by two in 64 col terminals
   ENDIF
   
   IFNDEF CRT_OTERM_WINDOW_WIDTH
      defc CRT_OTERM_WINDOW_WIDTH = 20      ; 20 for all models 1000...4004QL
   ENDIF
   
   IFNDEF CRT_OTERM_WINDOW_Y
      defc CRT_OTERM_WINDOW_Y = 0
   ENDIF
   
   IFNDEF CRT_OTERM_WINDOW_HEIGHT
      IF __VGL_MODEL = 1000
         defc CRT_OTERM_WINDOW_HEIGHT = 1
      ENDIF
      IF __VGL_MODEL = 2000
         defc CRT_OTERM_WINDOW_HEIGHT = 2
      ENDIF
      IF __VGL_MODEL = 4000
         defc CRT_OTERM_WINDOW_HEIGHT = 4
      ENDIF
   ENDIF

;; end crt rules ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

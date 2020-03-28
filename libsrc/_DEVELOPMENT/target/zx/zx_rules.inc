
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt rules for zx ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; Define Memory Banks
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Z88DK_FOR(`LOOP', `0', `7',
`
   IFNDEF CRT_ORG_BANK_`'LOOP
      defc CRT_ORG_BANK_`'LOOP = 0xc000
   ENDIF
')

Z88DK_FOR(`LOOP', `0', `63',
`
   IFNDEF CRT_ORG_DIV_`'LOOP
      defc CRT_ORG_DIV_`'LOOP = 0x2000
   ENDIF
')

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; ESXDOS dotx commands
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IFNDEF CRT_ORG_MAIN
      defc CRT_ORG_MAIN = 0x8000
   ENDIF

   ; DOTX_RAMTOP can be set to alter ramtop check

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; Input Terminal Settings
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IFNDEF CRT_ITERM_TERMINAL_FLAGS
      defc CRT_ITERM_TERMINAL_FLAGS = 0x03b0
   ENDIF

   ; buffer size must be available to m4 (requires special case in zcc)
   
   ifdef(`M4__CRT_ITERM_EDIT_BUFFER_SIZE',,`define(`M4__CRT_ITERM_EDIT_BUFFER_SIZE', 64)')

   IFNDEF CRT_ITERM_EDIT_BUFFER_SIZE
      defc CRT_ITERM_EDIT_BUFFER_SIZE = M4__CRT_ITERM_EDIT_BUFFER_SIZE
   ENDIF

   ;
   ; LASTK Input Terminal Only
   ;

   IFNDEF CRT_ITERM_LASTK_ADDRESS
      defc CRT_ITERM_LASTK_ADDRESS = 23560
   ENDIF

   ;
   ; INKEY Input Terminal Only (used by supplied CRTs)
   ;

   IFNDEF CRT_ITERM_INKEY_DEBOUNCE
      defc CRT_ITERM_INKEY_DEBOUNCE = 1
   ENDIF

   IFNDEF CRT_ITERM_INKEY_REPEAT_START
      defc CRT_ITERM_INKEY_REPEAT_START = 500
   ENDIF

   IFNDEF CRT_ITERM_INKEY_REPEAT_RATE
      defc CRT_ITERM_INKEY_REPEAT_RATE = 15
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
      defc CRT_OTERM_WINDOW_X = 0           ; multiplied by two in 64 col terminals
   ENDIF
   
   IFNDEF CRT_OTERM_WINDOW_WIDTH
      defc CRT_OTERM_WINDOW_WIDTH = 32      ; multiplied by two in 64 col terminals
   ENDIF
   
   IFNDEF CRT_OTERM_WINDOW_Y
      defc CRT_OTERM_WINDOW_Y = 0
   ENDIF
   
   IFNDEF CRT_OTERM_WINDOW_HEIGHT
      defc CRT_OTERM_WINDOW_HEIGHT = 24
   ENDIF

   ;
   ; Terminal Text Colour
   ;

   IFNDEF CRT_OTERM_TEXT_COLOR
      defc CRT_OTERM_TEXT_COLOR = 0x38
   ENDIF
   
   IFNDEF CRT_OTERM_TEXT_COLOR_MASK
      defc CRT_OTERM_TEXT_COLOR_MASK = 0x00
   ENDIF

   IFNDEF CRT_OTERM_BACKGROUND_COLOR
      defc CRT_OTERM_BACKGROUND_COLOR = 0x38
   ENDIF

   ;  
   ; FZX Proportional Font Output Terminals
   ;

   ; The terminal window contains the paper into
   ; which fzx characters are drawn

   IFNDEF CRT_OTERM_FZX_PAPER_X
      defc CRT_OTERM_FZX_PAPER_X = 0
   ENDIF

   IFNDEF CRT_OTERM_FZX_PAPER_WIDTH
      defc CRT_OTERM_FZX_PAPER_WIDTH = 256
   ENDIF

   IFNDEF CRT_OTERM_FZX_PAPER_Y
      defc CRT_OTERM_FZX_PAPER_Y = 0
   ENDIF

   IFNDEF CRT_OTERM_FZX_PAPER_HEIGHT
      defc CRT_OTERM_FZX_PAPER_HEIGHT = 192
   ENDIF

   ; draw mode must be available to m4 (requires special case in zcc)
   ; 0 = OR, 1 = XOR, 2 = CLEAR

   ifdef(`M4__CRT_OTERM_FZX_DRAW_MODE',,`define(`M4__CRT_OTERM_FZX_DRAW_MODE', 1)')

   IFNDEF CRT_OTERM_FZX_DRAW_MODE
      defc CRT_OTERM_FZX_DRAW_MODE = M4__CRT_OTERM_FZX_DRAW_MODE
   ENDIF

   ; 0 = single, 1 = 1.5, 2 = double

   IFNDEF CRT_OTERM_FZX_LINE_SPACING
      defc CRT_OTERM_FZX_LINE_SPACING = 0
   ENDIF

   ; left margin in pixels to allow kerning

   IFNDEF CRT_OTERM_FZX_LEFT_MARGIN
      defc CRT_OTERM_FZX_LEFT_MARGIN = 3
   ENDIF

   ; space character width expansion in pixels

   IFNDEF CRT_OTERM_FZX_SPACE_EXPAND
      defc CRT_OTERM_FZX_SPACE_EXPAND = 0
   ENDIF

   ;
   ; FONT SELECTION
   ; use pragam redirect to change font
   ;
   ; #pragam redirect CRT_OTERM_FONT_8X8 = _font_8x8_rom        ; 32-col font definition in rom
   ; #pragma redirect CRT_OTERM_FONT_8X8 = _font_8x8_zx_system  ; 32-col font
   ; #pragma redirect CRT_OTERM_FONT_4X8 = _font_4x8_default    ; 64-col font
   ; #pragma redirect CRT_OTERM_FONT_FZX = _ff_ind_Termino      ; fzx proportional font

;; end crt rules ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

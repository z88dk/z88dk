
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt rules for zx ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; Define Memory Banks
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IFNDEF CRT_ORG_BANK_02
      defc CRT_ORG_BANK_02 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_03
      defc CRT_ORG_BANK_03 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_04
      defc CRT_ORG_BANK_04 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_05
      defc CRT_ORG_BANK_05 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_06
      defc CRT_ORG_BANK_06 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_07
      defc CRT_ORG_BANK_07 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_08
      defc CRT_ORG_BANK_08 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_09
      defc CRT_ORG_BANK_09 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0A
      defc CRT_ORG_BANK_0A = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0B
      defc CRT_ORG_BANK_0B = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0C
      defc CRT_ORG_BANK_0C = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0D
      defc CRT_ORG_BANK_0D = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0E
      defc CRT_ORG_BANK_0E = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0F
      defc CRT_ORG_BANK_0F = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_10
      defc CRT_ORG_BANK_10 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_11
      defc CRT_ORG_BANK_11 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_12
      defc CRT_ORG_BANK_12 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_13
      defc CRT_ORG_BANK_13 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_14
      defc CRT_ORG_BANK_14 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_15
      defc CRT_ORG_BANK_15 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_16
      defc CRT_ORG_BANK_16 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_17
      defc CRT_ORG_BANK_17 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_18
      defc CRT_ORG_BANK_18 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_19
      defc CRT_ORG_BANK_19 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1A
      defc CRT_ORG_BANK_1A = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1B
      defc CRT_ORG_BANK_1B = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1C
      defc CRT_ORG_BANK_1C = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1D
      defc CRT_ORG_BANK_1D = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1E
      defc CRT_ORG_BANK_1E = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1F
      defc CRT_ORG_BANK_1F = 0x8000
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; Output Terminal Settings
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IFNDEF CRT_OTERM_TERMINAL_FLAGS
      defc CRT_OTERM_TERMINAL_FLAGS = 0x2370
   ENDIF

   ; Terminal Window Dimensions in Characters

   IFNDEF CRT_OTERM_WINDOW_X
      defc CRT_OTERM_WINDOW_X = 0
   ENDIF
   
   IFNDEF CRT_OTERM_WINDOW_WIDTH
      defc CRT_OTERM_WINDOW_WIDTH = 32
   ENDIF
   
   IFNDEF CRT_OTERM_WINDOW_Y
      defc CRT_OTERM_WINDOW_Y = 0
   ENDIF
   
   IFNDEF CRT_OTERM_WINDOW_HEIGHT
      defc CRT_OTERM_WINDOW_HEIGHT = 24
   ENDIF

   ; Initial Font Must Match Terminal Type

   IFNDEF CRT_OTERM_TEXT_COLOR
      defc CRT_OTERM_TEXT_COLOR = 0x38
   ENDIF
	
	IFNDEEF CRT_OTERM_TEXT_COLOR_MASK
      defc CRT_OTERM_TEXT_COLOR_MASK = 0x00
   ENDIF

   IFNDEF CRT_OTERM_BACKGROUND_COLOR
      defc CRT_OTERM_BACKGROUND_COLOR = 0x38
   ENDIF

   ; Font Selection is Terminal Type Dependent

   IFNDEF CRT_OTERM_FONT_8X8
      defc CRT_OTERM_FONT_8X8 = _font_8x8_rom, _font_8x8_zx_system
		_font_4x8_default, _ff_ind_Termino
   ENDIF

   ;
   ; 32 Column Mode Output Terminals
   ;

   IFNDEF CRT_OTERM_FONT_8X8
      defc CRT_OTERM_FONT_8X8 = _font_8x8_rom
   ENDIF

   ;
   ; 32 Column Mode Output Terminals for Cartridge
   ;    Cannot use the ROM font
   ;

   IFNDEF CRT_OTERM_FONT_8X8_CART
      defc CRT_OTERM_FONT_8X8_CART = _font_8x8_zx_system
   ENDIF

   ;
   ; 64 Column Mode Output Terminals
   ;

   IFNDEF CRT_OTERM_FONT_4X8
      defc CRT_OTERM_FONT_4X8 = _font_4x8_default
   ENDIF

   ;	
   ; FZX Proportional Font Output Terminals
   ;

   IFNDEF CRT_OTERM_FONT_FZX
      defc CRT_OTERM_FONT_FZX = _ff_ind_Termino
   ENDIF

   IFNDEF CRT_OTERM_FZX_PAPER_X
      defc CRT_OTERM_FZX_PAPER_X = 
   ENDIF

   IFNDEF CRT_OTERM_FZX_PAPER_WIDTH
      defc CRT_OTERM_FZX_PAPER_WIDTH = 
   ENDIF

   IFNDEF CRT_OTERM_FZX_PAPER_Y
      defc CRT_OTERM_FZX_PAPER_Y = 
   ENDIF

   IFNDEF CRT_OTERM_FZX_PAPER_HEIGHT
      defc CRT_OTERM_FZX_PAPER_HEIGHT = 
   ENDIF

   IFNDEF CRT_OTERM_FZX_DRAW_MODE
      defc CRT_OTERM_FZX_DRAW_MODE = 
   ENDIF

   IFNDEF CRT_OTERM_FZX_LINE_SPACING
      defc CRT_OTERM_FZX_LINE_SPACING = 
   ENDIF

   IFNDEF CRT_OTERM_FZX_LEFT_MARGIN = 
      defc CRT_OTERM_FZX_LEFT_MARGIN = 
   ENDIF

   IFNDEF CRT_OTERM_FZX_SPACE_EXPAND
      defc CRT_OTERM_FZX_SPACE_EXPAND = 
   ENDIF

;; end crt rules ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

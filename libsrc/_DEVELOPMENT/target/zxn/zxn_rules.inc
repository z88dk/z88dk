
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt rules for zx next ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; Define Memory Banks
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Z88DK_FOR(`LOOP', `0', `111',
`
   IFNDEF CRT_ORG_BANK_`'LOOP
      defc CRT_ORG_BANK_`'LOOP = 0xc000
   ENDIF
   
   IFNDEF CRT_ORG_BANK_`'LOOP`'_L
      defc CRT_ORG_BANK_`'LOOP`'_L = 0xc000
   ENDIF
   
   IFNDEF CRT_ORG_BANK_`'LOOP`'_H
      defc CRT_ORG_BANK_`'LOOP`'_H = 0xe000
   ENDIF
')

Z88DK_FOR(`LOOP', `0', `223',
`
   IFNDEF CRT_ORG_PAGE_`'LOOP
      defc CRT_ORG_PAGE_`'LOOP = ifelse(eval(LOOP&0x01),0,0xc000,0xe000)
   ENDIF
')

Z88DK_FOR(`LOOP', `0', `15',
`
   IFNDEF CRT_ORG_DIV_`'LOOP
      defc CRT_ORG_DIV_`'LOOP = 0x2000
   ENDIF
')

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; VERSION CHECKS (0 = no check)
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;; core version = MMmmSSS (major, minor, sub) in decimal
   ;;    v 1.10.51 =  110051

   PUBLIC __CRT_CORE_VERSION

   IFNDEF CRT_CORE_VERSION
      defc CRT_CORE_VERSION = 0
   ENDIF
   
   defc __CRT_CORE_VERSION = CRT_CORE_VERSION
   
   ;; nextos version = MMmm (major, minor) in decimal
   ;;         v 1.94 =  194

   PUBLIC __NEXTOS_VERSION

   IFNDEF NEXTOS_VERSION
      defc NEXTOS_VERSION = -1
   ENDIF
   
   defc __NEXTOS_VERSION = NEXTOS_VERSION
   
   ;; esxdos version
   ;; currently non-zero checks for presence (use 1)

   PUBLIC __ESXDOS_VERSION

   IFNDEF ESXDOS_VERSION
      defc ESXDOS_VERSION = 0
   ENDIF
   
   defc __ESXDOS_VERSION = ESXDOS_VERSION
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; MAIN location for dotx and dotn commands
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IFNDEF CRT_ORG_MAIN
      defc CRT_ORG_MAIN = 0x8000
   ENDIF
   
   ; DOTX_RAMTOP can be set to alter ramtop check

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; NextOS dotn
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;; temporary stack location in divmmc
   
   IFNDEF DOTN_REGISTER_SP
      defc DOTN_REGISTER_SP = 0x4000
   ENDIF
   
   ;; last ram page in page table
   
   PUBLIC __DOTN_LAST_PAGE
   
   IFNDEF DOTN_LAST_PAGE
      defc DOTN_LAST_PAGE = __ZXNEXT_LAST_PAGE
   ENDIF
   
   IF DOTN_LAST_PAGE < 11
      error "DOTN_LAST_PAGE must be at least 11"
   ELSE
      IF DOTN_LAST_PAGE > __ZXNEXT_LAST_PAGE
         error "DOTN_LAST_PAGE cannot exceed 223"
      ELSE
         defc __DOTN_LAST_PAGE = DOTN_LAST_PAGE
      ENDIF
   ENDIF

   ;; last divmmc page in divmmc table
   
   PUBLIC __DOTN_LAST_DIVMMC
   
   IFNDEF DOTN_LAST_DIVMMC
      defc DOTN_LAST_DIVMMC = -1
   ENDIF
   
   IF DOTN_LAST_DIVMMC > __ZXNEXT_LAST_DIVMMC
      error "DOTN_LAST_DIVMMC cannot exceed 15"
   ELSE
      defc __DOTN_LAST_DIVMMC = DOTN_LAST_DIVMMC
   ENDIF

   ;; number of extra ram pages to allocate
   
   PUBLIC __DOTN_NUM_EXTRA
   
   IFNDEF DOTN_NUM_EXTRA
      defc DOTN_NUM_EXTRA = 0
   ENDIF
   
   defc __DOTN_NUM_EXTRA = DOTN_NUM_EXTRA
   
   ;; set bits indicate mmus that should be allocated in the main bank
   
   PUBLIC __DOTN_MAIN_OVERLAY_MASK
   
   IFNDEF DOTN_MAIN_OVERLAY_MASK
      defc DOTN_MAIN_OVERLAY_MASK = 0
   ENDIF
   
   defc __DOTN_MAIN_OVERLAY_MASK = DOTN_MAIN_OVERLAY_MASK & 0xff
   
   ;; set bits indicates mmus that should not be allocated in the main bank
   
   PUBLIC __DOTN_MAIN_ABSOLUTE_MASK
   
   IFNDEF DOTN_MAIN_ABSOLUTE_MASK
      defc DOTN_MAIN_ABSOLUTE_MASK = 0
   ENDIF
   
   defc __DOTN_MAIN_ABSOLUTE_MASK = DOTN_MAIN_ABSOLUTE_MASK & 0xff

   ;; non-zero to load up alternate implementation in /dot/extra
   
   PUBLIC __DOTN_ENABLE_ALTERNATE
   
   IFNDEF DOTN_ENABLE_ALTERNATE
      defc DOTN_ENABLE_ALTERNATE = 0
   ENDIF
   
   defc __DOTN_ENABLE_ALTERNATE = DOTN_ENABLE_ALTERNATE

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; NextOS EXE
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;; last ram page in page table
   
   PUBLIC __EXE_LAST_PAGE
   
   IFNDEF EXE_LAST_PAGE
      defc EXE_LAST_PAGE = __ZXNEXT_LAST_PAGE
   ENDIF
   
   IF EXE_LAST_PAGE < 11
      defc __EXE_LAST_PAGE = 11
   ELSE
      IF EXE_LAST_PAGE > __ZXNEXT_LAST_PAGE
         defc __EXE_LAST_PAGE = __ZXNEXT_LAST_PAGE
      ELSE
         defc __EXE_LAST_PAGE = EXE_LAST_PAGE
      ENDIF
   ENDIF
   
   ;; last divmmc page in divmmc table
   
   PUBLIC __EXE_LAST_DIVMMC
   
   IFNDEF EXE_LAST_DIVMMC
      defc EXE_LAST_DIVMMC = -1
   ENDIF
   
   IF EXE_LAST_DIVMMC > __ZXNEXT_LAST_DIVMMC
      defc __EXE_LAST_DIVMMC = __ZXNEXT_LAST_DIVMMC
   ELSE
      defc __EXE_LAST_DIVMMC = EXE_LAST_DIVMMC
   ENDIF

   ;; number of extra ram pages to allocate
   
   PUBLIC __EXE_NUM_EXTRA
   
   IFNDEF EXE_NUM_EXTRA
      defc EXE_NUM_EXTRA = 0
   ENDIF
   
   defc __EXE_NUM_EXTRA = EXE_NUM_EXTRA
   
   ;; set bits indicate mmus that should be allocated in the main bank
   
   PUBLIC __EXE_MAIN_OVERLAY_MASK
   
   IFNDEF EXE_MAIN_OVERLAY_MASK
      defc EXE_MAIN_OVERLAY_MASK = 0
   ENDIF
   
   defc __EXE_MAIN_OVERLAY_MASK = EXE_MAIN_OVERLAY_MASK & 0xff
   
   ;; set bits indicates mmus that should not be allocated in the main bank
   
   PUBLIC __EXE_MAIN_ABSOLUTE_MASK
   
   IFNDEF EXE_MAIN_ABSOLUTE_MASK
      defc EXE_MAIN_ABSOLUTE_MASK = 0
   ENDIF
   
   defc __EXE_MAIN_ABSOLUTE_MASK = EXE_MAIN_ABSOLUTE_MASK & 0xff

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
   ; Terminal Window Dimensions in Characters for Timex Hi-Res
   ;

   IFNDEF CRT_OTERM_TSHR_WINDOW_X
      defc CRT_OTERM_TSHR_WINDOW_X = 0           ; multiplied by two in 128 col terminals
   ENDIF
   
   IFNDEF CRT_OTERM_TSHR_WINDOW_WIDTH
      defc CRT_OTERM_TSHR_WINDOW_WIDTH = 64      ; multiplied by two in 128 col terminals
   ENDIF
   
   IFNDEF CRT_OTERM_TSHR_WINDOW_Y
      defc CRT_OTERM_TSHR_WINDOW_Y = 0
   ENDIF
   
   IFNDEF CRT_OTERM_TSHR_WINDOW_HEIGHT
      defc CRT_OTERM_TSHR_WINDOW_HEIGHT = 24
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

   ; The terminal window for Timex Hi-Res
   
   IFNDEF CRT_OTERM_FZX_TSHR_PAPER_X
      defc CRT_OTERM_FZX_TSHR_PAPER_X = 0
   ENDIF

   IFNDEF CRT_OTERM_FZX_TSHR_PAPER_WIDTH
      defc CRT_OTERM_FZX_TSHR_PAPER_WIDTH = 512
   ENDIF

   IFNDEF CRT_OTERM_FZX_TSHR_PAPER_Y
      defc CRT_OTERM_FZX_TSHR_PAPER_Y = 0
   ENDIF

   IFNDEF CRT_OTERM_FZX_TSHR_PAPER_HEIGHT
      defc CRT_OTERM_FZX_TSHR_PAPER_HEIGHT = 192
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
   ; #pragma redirect CRT_OTERM_FONT_8X8 = _font_8x8_zx_system  ; 32-col font, timex hi-res 64-col font
   ; #pragma redirect CRT_OTERM_FONT_4X8 = _font_4x8_default    ; 64-col font, timex hi-res 128-col font
   ; #pragma redirect CRT_OTERM_FONT_FZX = _ff_ind_Termino      ; fzx proportional font

;; end crt rules ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

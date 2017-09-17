; A minimal implementation of V-Tech Genius Leader text output driver

SECTION code_driver
;SECTION code_driver_terminal_output
SECTION code_driver_character_output

PUBLIC vgl_output_char

;EXTERN ITERM_MSG_BELL, ITERM_MSG_PRINT_CURSOR, STDIO_MSG_ICTL
;EXTERN OTERM_MSG_PRINTC
;EXTERN OTERM_MSG_SCROLL, OTERM_MSG_CLS
;EXTERN OTERM_MSG_PAUSE, OTERM_MSG_BELL
EXTERN OCHAR_MSG_PUTC

;EXTERN console_01_output_terminal_char
EXTERN character_00_output

;EXTERN vgl_output_char_oterm_msg_printc
;EXTERN zx_01_output_char_32_iterm_msg_print_cursor
;EXTERN zx_01_output_char_32_iterm_msg_bell, zx_01_output_char_32_stdio_msg_ictl
;EXTERN zx_01_output_char_32_oterm_msg_scroll, zx_01_output_char_32_oterm_msg_cls
;EXTERN zx_01_output_char_32_oterm_msg_pause, zx_01_output_char_32_oterm_msg_bell

vgl_output_char:

;   cp OTERM_MSG_PRINTC
;   jp z, vgl_output_char_oterm_msg_printc

;   cp ITERM_MSG_PRINT_CURSOR
;   jp z, zx_01_output_char_32_iterm_msg_print_cursor
;   
;   cp ITERM_MSG_BELL
;   jp z, zx_01_output_char_32_iterm_msg_bell
;   
;   cp STDIO_MSG_ICTL
;   jp z, zx_01_output_char_32_stdio_msg_ictl
;
;   cp OTERM_MSG_SCROLL
;   jp z, zx_01_output_char_32_oterm_msg_scroll
;
;   jp c, console_01_output_terminal_char  ; forward to library
;
;   cp OTERM_MSG_CLS
;   jp z, zx_01_output_char_32_oterm_msg_cls
;   
;   cp OTERM_MSG_PAUSE
;   jp z, zx_01_output_char_32_oterm_msg_pause
;   
;   cp OTERM_MSG_BELL
;   jp z, zx_01_output_char_32_oterm_msg_bell

;   jp console_01_output_terminal_char     ; forward to library


   cp OCHAR_MSG_PUTC
   jp nz, character_00_output  ; forward other messages to library

    ; Put to VRAM
   ld hl, 	0xdca0+8	; VRAM start
   ld (hl), c
   
   ; Refresh row(s)
   ld hl,0xdcf0	;+row-num
   ld (hl),0x01
   
   ret
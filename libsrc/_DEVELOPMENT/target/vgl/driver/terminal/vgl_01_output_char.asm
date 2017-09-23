
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VGL_01_OUTPUT_CHAR
; romless driver for standard 32x24 output
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Windowed output terminal for fixed width fonts.
;
; ;;;;;;;;;;;;;;;;;;;;
; DRIVER CLASS DIAGRAM
; ;;;;;;;;;;;;;;;;;;;;
;
; CONSOLE_01_OUTPUT_TERMINAL (root, abstract)
; CONSOLE_01_OUTPUT_TERMINAL_CHAR (abstract)
; VGL_01_OUTPUT_CHAR (concrete)
;
; Can be instantiated to implement a CONSOLE_01_OUTPUT_TERMINAL.
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM STDIO
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * STDIO_MSG_PUTC
;   Generates multiple OTERM_MSG_PUTC messages.
;
; * STDIO_MSG_WRIT
;   Generates multiple OTERM_MSG_PUTC messages.
;
; * STDIO_MSG_SEEK -> no error, do nothing
; * STDIO_MSG_FLSH -> no error, do nothing
; * STDIO_MSG_ICTL
; * STDIO_MSG_CLOS -> no error, do nothing
;
; Any other messages are reported as errors via
; error_enotsup_zc
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM CONSOLE_01_OUTPUT_TERMINAL
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   * OTERM_MSG_PUTC
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM CONSOLE_01_INPUT_TERMINAL
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   * ITERM_MSG_PUTC
;   * ITERM_MSG_PRINT_CURSOR - cursor changed to L or C
;   * ITERM_MSG_BS
;   * ITERM_MSG_BS_PWD
;   * ITERM_MSG_ERASE_CURSOR
;   * ITERM_MSG_ERASE_CURSOR_PWD
;   * ITERM_MSG_READLINE_BEGIN
;   * ITERM_MSG_READLINE_END
;   * ITERM_MSG_BELL
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM CONSOLE_01_OUTPUT_TERMINAL_CHAR
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * OTERM_MSG_PRINTC
; * OTERM_MSG_BELL
; * OTERM_MSG_SCROLL
; * OTERM_MSG_CLS
; * OTERM_MSG_PAUSE
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES GENERATED FOR DERIVED DRIVERS
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * OTERM_MSG_TTY (optional)
;
;     enter  :  c = char to output
;     exit   :  c = char to output (possibly modified)
;               carry reset if tty emulation absorbs char
;     can use:  af, bc, de, hl
;
;     The driver should call the tty emulation module.
;     If not implemented characters are output without processing.
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; IOCTLs UNDERSTOOD BY THIS DRIVER
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   * IOCTL_OTERM_CRLF
;     enable / disable crlf processing
;
;   * IOCTL_OTERM_BELL
;     enable / disable terminal bell
;
;   * IOCTL_OTERM_SIGNAL
;     enable / disable signal bell
;
;   * IOCTL_OTERM_COOK
;     enable / disable cook mode (tty emulation)
;
;   * IOCTL_OTERM_PAUSE
;     enable / disable pause when window filled
;
;   * IOCTL_OTERM_PAGE
;     select scroll or page mode
;
;   * IOCTL_OTERM_CLEAR
;     enable / disable clear window when in page mode
;
;   * IOCTL_OTERM_CLS
;     clear window, set (x,y) = (0,0)
;
;   * IOCTL_OTERM_RESET_SCROLL
;     reset scroll count
;
;   * IOCTL_OTERM_GET_WINDOW_COORD
;     get coord of top left corner of window
;
;   * IOCTL_OTERM_SET_WINDOW_COORD
;     set coord of top left corner of window
;
;   * IOCTL_OTERM_GET_WINDOW_RECT
;     get window size
;
;   * IOCTL_OTERM_SET_WINDOW_RECT
;     set window size
;
;   * IOCTL_OTERM_GET_CURSOR_COORD
;
;   * IOCTL_OTERM_SET_CURSOR_COORD
;
;   * IOCTL_OTERM_GET_OTERM
;
;   * IOCTL_OTERM_SCROLL
;
;   * IOCTL_OTERM_FONT
;
;   * IOCTL_OTERM_BCOLOR
;
;   * IOCTL_OTERM_FCOLOR
;
;   * IOCTL_OTERM_FMASK
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
; BYTES RESERVED IN FDSTRUCT
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; offset (wrt FDSTRUCT.JP)  description
;
;  8..13                    mutex
;   14                      x coordinate
;   15                      y coordinate
;   16                      window.x
;   17                      window.width
;   18                      window.y
;   19                      window.height
;   20                      scroll_limit
; 21..22                    font address
;   23                      text colour
;   24                      text colour mask (set bits = keep bgnd)
;   25                      background colour (cls colour)

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC vgl_01_output_char

EXTERN ITERM_MSG_BELL, ITERM_MSG_PRINT_CURSOR, STDIO_MSG_ICTL
EXTERN OTERM_MSG_PRINTC, OTERM_MSG_SCROLL, OTERM_MSG_CLS
EXTERN OTERM_MSG_PAUSE, OTERM_MSG_BELL

EXTERN console_01_output_terminal_char
;EXTERN zx_01_output_char_32_oterm_msg_printc, zx_01_output_char_32_iterm_msg_print_cursor
;EXTERN zx_01_output_char_32_iterm_msg_bell, zx_01_output_char_32_stdio_msg_ictl
;EXTERN zx_01_output_char_32_oterm_msg_scroll, zx_01_output_char_32_oterm_msg_cls
;EXTERN zx_01_output_char_32_oterm_msg_pause, zx_01_output_char_32_oterm_msg_bell

vgl_01_output_char:

   cp OTERM_MSG_PRINTC
   jp z, vgl_01_output_char_oterm_msg_printc
;
;   cp ITERM_MSG_PRINT_CURSOR
;   jp z, zx_01_output_char_32_iterm_msg_print_cursor
;   
;   cp ITERM_MSG_BELL
;   jp z, zx_01_output_char_32_iterm_msg_bell
;   
;   cp STDIO_MSG_ICTL
;   jp z, zx_01_output_char_32_stdio_msg_ictl
;
   cp OTERM_MSG_SCROLL
   jp z, vgl_01_output_char_oterm_msg_scroll
    
   jp c, console_01_output_terminal_char  ; forward to library
    
   cp OTERM_MSG_CLS
   jp z, vgl_01_output_char_oterm_msg_cls
   
;   cp OTERM_MSG_PAUSE
;   jp z, zx_01_output_char_32_oterm_msg_pause
;   
;   cp OTERM_MSG_BELL
;   jp z, zx_01_output_char_32_oterm_msg_bell

   jp console_01_output_terminal_char     ; forward to library



vgl_01_output_char_oterm_msg_printc:
    ;   enter  :  c = ascii code
    ;             b = parameter (foreground colour, 255 if none specified)
    ;             l = absolute x coordinate
    ;             h = absolute y coordinate
    ;   can use:  af, bc, de, hl
    
    ; Store HL (coordinates) for later
    ex de, hl
    
    ; Put to VRAM at 0xdca0 + (Y*COLS) + X
    
    ; a = Y*20
    ld a, h
    ;add a	; *2
    ;add a	; *4
    ;add a	; *8
    ;add a	; *16
    ld b, 4
    sla b
    add h	; *17
    add h	; *18
    add h	; *19
    add h	; *20
    ; To VRAM 0xdca0
    add 0xa0
    ld h, 0xdc
    add l	; Add X
    ld l, a
    
    ld (hl), c	; Put character
    
    jp vgl_01_output_char_refresh

vgl_01_output_char_refresh:
    ; Refresh all row(s)
    ;@TODO: Use a bulk-load opcode
    ld hl,0xdcf0
    ld a,0x01
    ld (hl),a
    inc l
    ld (hl),a
    inc l
    ld (hl),a
    inc l
    ld (hl),a
    
    ;	; Refresh only that row
    ;	ex de, hl	; Restore HL (coordinates)
    ;	ld a, h	; get Y coordinate
    ;	; Convert to 0xdcf0 + Y
    ;	add 0xf0
    ;	ld l, a
    ;	ld h, 0xdc
    ;	; Put "1" there
    ;	ld a, 1
    ;	ld (hl), a
    
    
    ;	; Output via ports 0x0b and 0x0a
    ;	ld a,c
    ;	out(0x0b),a
    ;	
    ;	
    ;	;Delay 1fff
    ;	;call _delay_1fff
    ;	push	hl
    ;	ld	hl, 1fffh
    ;	vgl_00_output_char_delay_1fff_loop:
    ;	dec	l
    ;	jr	nz, vgl_00_output_char_delay_1fff_loop
    ;	dec	h
    ;	jr	nz, vgl_00_output_char_delay_1fff_loop
    ;	pop	hl
    ret


vgl_01_output_char_oterm_msg_scroll:
    ;   enter  :   c = number of rows to scroll
    ;   can use:  af, bc, de, hl
    ;
    ;   Scroll the window upward 'C' character rows.
    
    ; Move everything up by one row
    ;@TODO: Implement scrolling by C rows
    ld	bc, 20*(4-1)	;(_screen_scrollSize)
    ld	hl, 0xdca0 + 1*20	;_LCD_VRAM_ROW1
    ld	de, 0xdca0 + 0*20	;_LCD_VRAM_ROW0
    ldir	; Copy BC chars from (HL) to (DE)
    
    ; Now clear the last row with spaces
    ; DE, HL should already be at the right position
    ld hl, 0xdca0 + (4-1)*20
    ld de, 0xdca0 + (4-1)*20 + 1
    
    
    ld (hl), 0x40	;0x20	; Character to use
    ld bc, 20-1	; columns-1
    ldir	; Copy BC bytes from (HL) to (DE)
    
    jp vgl_01_output_char_refresh
    ;ret


vgl_01_output_char_oterm_msg_cls:
   ; clear the window
   ;
   ; can use : af, bc, de, hl
   
   ; Use LDIR to fill it
   ld hl, 0xdca0
   ld de, 0xdca0 + 1
   ld bc, 20*4 - 1
   ld (hl), 0x20	; Character to use
   ldir	; Copy BC bytes from (HL) to (DE)
    
   jp vgl_01_output_char_refresh
   ;ret
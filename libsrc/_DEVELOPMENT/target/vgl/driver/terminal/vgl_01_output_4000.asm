SECTION data_arch

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VGL_01_OUTPUT_4000
; driver for V-Tech Genius Leader 4000q/4004ql
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
; X 21..22                    font address
; X   23                      text colour
; X   24                      text colour mask (set bits = keep bgnd)
; X   25                      background colour (cls colour)

INCLUDE "config_private.inc"
; Uses constants __VGL_*  from config/config_target.m4

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC vgl_01_output_4000
PUBLIC vgl_01_output_4000_refresh
PUBLIC vgl_01_output_4000_set_cursor_coord

;EXTERN ITERM_MSG_BELL, ITERM_MSG_PRINT_CURSOR, STDIO_MSG_ICTL
;EXTERN OTERM_MSG_PRINTC
;EXTERN OTERM_MSG_SCROLL, OTERM_MSG_CLS, EXTERN OTERM_MSG_PAUSE, OTERM_MSG_BELL
;EXTERN STDIO_MSG_WRIT
;EXTERN IOCTL_OTERM_SET_CURSOR_COORD

EXTERN vgl_01_output_2000_iterm_msg_bell
EXTERN vgl_01_output_4000_iterm_msg_print_cursor

EXTERN vgl_01_output_2000_oterm_msg_bell
EXTERN vgl_01_output_4000_oterm_msg_cls
EXTERN vgl_01_output_4000_oterm_msg_pause
EXTERN vgl_01_output_4000_oterm_msg_printc
EXTERN vgl_01_output_4000_oterm_msg_scroll
EXTERN vgl_01_output_4000_stdio_msg_writ

EXTERN console_01_output_terminal_char


vgl_01_output_4000:
   
   ;@TODO: Implement "WRIT" so the LCD does not need to refresh after every single character
   
   cp OTERM_MSG_PRINTC
   jp z, vgl_01_output_4000_oterm_msg_printc
   
   ; Use fast (And experimental) output (only refresh after whole string)
   ;cp STDIO_MSG_WRIT
   ;jp z, vgl_01_output_4000_stdio_msg_writ
   
   cp ITERM_MSG_PRINT_CURSOR
   jp z, vgl_01_output_4000_iterm_msg_print_cursor
   
   cp ITERM_MSG_BELL
   jp z, vgl_01_output_2000_iterm_msg_bell
   
   ;cp IOCTL_OTERM_SET_CURSOR_COORD
   ;jp z, vgl_01_output_4000_ioctl_oterm_set_cursor_coord
   ;cp STDIO_MSG_ICTL
   ;jp z, vgl_01_output_4000_stdio_msg_ictl
   
   cp OTERM_MSG_SCROLL
   jp z, vgl_01_output_4000_oterm_msg_scroll
   
   ;jp c, console_01_output_terminal_char  ; forward to library
   
   cp OTERM_MSG_CLS
   jp z, vgl_01_output_4000_oterm_msg_cls
   
   cp OTERM_MSG_PAUSE
   jp z, vgl_01_output_4000_oterm_msg_pause
   
   cp OTERM_MSG_BELL
   jp z, vgl_01_output_2000_oterm_msg_bell

   jp console_01_output_terminal_char     ; forward to library


vgl_01_output_4000_refresh:
   ; Refresh all row(s)
   ld a, 1
   ld (__VGL_4000_DISPLAY_REFRESH_ADDRESS+0),a
   ld (__VGL_4000_DISPLAY_REFRESH_ADDRESS+1),a
   ld (__VGL_4000_DISPLAY_REFRESH_ADDRESS+2),a
   ld (__VGL_4000_DISPLAY_REFRESH_ADDRESS+3),a
   
   ;@TODO: Refresh only one specified row
   ;	ex de, hl	; Restore HL (coordinates)
   ;	ld a, h	; get Y coordinate
   ;	; Convert to 0xdcf0 + Y
   ;	add __VGL_2000_DISPLAY_REFRESH_ADDRESS & 0x00ff
   ;	ld l, a
   ;	ld h, __VGL_2000_DISPLAY_REFRESH_ADDRESS >> 8
   ;	; Put "1" there
   ;	ld a, 1
   ;	ld (hl), a
   ret

vgl_01_output_4000_set_cursor_coord:
   ;   enter  :  c = ascii code
   ;             b = parameter (foreground colour, 255 if none specified)
   ;             l = absolute x coordinate
   ;             h = absolute y coordinate
   ;   can use:  af, bc, de, hl
   
   ; Show cursor on screen
   ld a, l
   ;inc a    ;@FIXME: I have to add one!
   ld (__VGL_4000_DISPLAY_CURSOR_X_ADDRESS), a
   ld a, h
   ld (__VGL_4000_DISPLAY_CURSOR_Y_ADDRESS), a
   ret


;; Testing
;vgl_01_output_4000_ioctl_oterm_set_cursor_coord:
;   
;   ; Show cursor on screen
;   ld a, (ix+35)
;   ld (__VGL_4000_DISPLAY_CURSOR_X_ADDRESS), a
;   ld a, (ix+37)
;   ld (__VGL_4000_DISPLAY_CURSOR_Y_ADDRESS), a
;   
;   ret
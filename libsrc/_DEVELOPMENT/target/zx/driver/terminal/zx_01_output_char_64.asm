
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ZX_01_OUTPUT_CHAR_64
; romless driver for 64x24 output
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Windowed output terminal for fixed width fonts.
; 64 columns is achieved by using a 4x8 pixel font.
;
; The window terminal is constrained to be located
; on an even x coordinate and to be an even number
; of characters wide.
;
; Driver class diagram:
;
; CONSOLE_01_OUTPUT_TERMINAL (root, abstract)
; CONSOLE_01_OUTPUT_TERMINAL_CHAR (abstract)
; ZX_01_OUTPUT_CHAR_64 (concrete)
;
; Can be instantiated to implement a CONSOLE_01_OUTPUT_TERMINAL.
;
; Messages consumed from stdio:
;
; * STDIO_MSG_ICTL
;
;   Forwarded to CONSOLE_01_OUTPUT_TERMINAL_CHAR
;
; Messages consumed from CONSOLE_01_INPUT_TERMINAL:
;
; * ITERM_MSG_BELL
;
;   Generates a short signal beep on beeper.
;
; Messages consumed from CONSOLE_01_OUTPUT_TERMINAL_CHAR
;
; * OTERM_MSG_PRINTC
;
;   Prints character to screen.
;
; * OTERM_MSG_SCROLL
;
;   Scrolls window upward.
;
; * OTERM_MSG_CLS
;
;   Clears window.
;
; * OTERM_MSG_PAUSE
;
;   Called when the screen is full.  Waits for no keypress,
;   followed by keypress, followed by no keypress.  The
;   key detection functions from the input library are used.
;   This may have to be changed in a multi-threading situation.
;
; * OTERM_MSG_BELL
;
;   Generates a tone in response to terminal BEL character.
;   Higher tone and longer duration than ITERM_MSG_BELL.
;
; Because the tty terminal message is not serviced, instantiations
; of this driver will not interpret control sequences.
;
; IOCTLs understood by this driver (in addition to base class):
;
; * IOCTL_OTERM_GET_FONT
; * IOCTL_OTERM_SET_FONT
;   select new font
;
; * IOCTL_OTERM_GET_BCOLOR
; * IOCTL_OTERM_SET_BCOLOR
;   set terminal's background colour
;
; * IOCTL_OTERM_GET_FCOLOR
; * IOCTL_OTERM_SET_FCOLOR
;   set terminal's current text colour
;
; * IOCTL_OTERM_GET_MASK
; * IOCTL_OTERM_SET_MASK
;   set terminal's current text attribute mask
;
; This driver reserves extra bytes in the FDSTRUCT:
;
; offset (wrt FDSTRUCT.JP)  description
;
;   21..22                  font address
;   23                      text colour
;   24                      text colour mask (set bits = keep bgnd)
;   25                      background colour (cls colour)
;   

SECTION code_fcntl

PUBLIC zx_01_output_char_64

EXTERN ITERM_MSG_BELL, ITERM_MSG_PRINT_CURSOR, STDIO_MSG_ICTL
EXTERN OTERM_MSG_PRINTC, OTERM_MSG_SCROLL, OTERM_MSG_CLS
EXTERN OTERM_MSG_PAUSE, OTERM_MSG_BELL

EXTERN console_01_output_terminal_char
EXTERN zx_01_output_char_64_oterm_msg_printc
EXTERN zx_01_output_char_32_iterm_msg_bell, zx_01_output_char_64_stdio_msg_ictl
EXTERN zx_01_output_char_64_oterm_msg_scroll, zx_01_output_char_64_oterm_msg_cls
EXTERN zx_01_output_char_32_oterm_msg_pause, zx_01_output_char_32_oterm_msg_bell

zx_01_output_char_64:

   cp OTERM_MSG_PRINTC
   jp z, zx_01_output_char_64_oterm_msg_printc
   
   cp ITERM_MSG_BELL
   jp z, zx_01_output_char_32_iterm_msg_bell
   
   cp STDIO_MSG_ICTL
   jp z, zx_01_output_char_64_stdio_msg_ictl

   cp OTERM_MSG_SCROLL
   jp z, zx_01_output_char_64_oterm_msg_scroll

   jp c, console_01_output_terminal_char  ; forward to library

   cp OTERM_MSG_CLS
   jp z, zx_01_output_char_64_oterm_msg_cls
   
   cp OTERM_MSG_PAUSE
   jp z, zx_01_output_char_32_oterm_msg_pause
   
   cp OTERM_MSG_BELL
   jp z, zx_01_output_char_32_oterm_msg_bell

   jp console_01_output_terminal_char     ; forward to library

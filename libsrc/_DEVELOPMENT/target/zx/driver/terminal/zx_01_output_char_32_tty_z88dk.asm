
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ZX_01_OUTPUT_CHAR_32_TTY_Z88DK
; implemented tty_z88dk terminal emulation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Windowed output terminal for fixed width fonts.
; Implements tty_z88dk terminal emulation.
;
; Driver class diagram:
;
; CONSOLE_01_OUTPUT_TERMINAL (root, abstract)
; CONSOLE_01_OUTPUT_TERMINAL_CHAR (abstract)
; ZX_01_OUTPUT_CHAR_32 (concrete)
; ZX_01_OUTPUT_CHAR_32_TTY_Z88DK (concrete)
;
; Can be instantiated to implement a CONSOLE_01_OUTPUT_TERMINAL.
;
; Messages consumed from stdio:
;
; * STDIO_MSG_FLSH
;
;   Resets the tty state machine.
;   Not forwarded to base classes (no implementation there).
;
; Messages consumed from CONSOLE_01_OUTPUT_TERMINAL_CHAR:
;
; * OTERM_MSG_TTY
;
;   TTY_Z88DK terminal emulation is applied to the output char.
;
; This driver reserves extra bytes in the FDSTRUCT:
;
; offset (wrt FDSTRUCT.JP)  description
;
;   26                      tty_z88dk.
;

SECTION code_fcntl

PUBLIC zx_01_output_char_32_tty_z88dk

EXTERN OTERM_MSG_TTY, STDIO_MSG_FLSH

EXTERN zx_01_output_char_32
EXTERN zx_01_output_char_32_tty_z88dk_oterm_msg_tty
EXTERN zx_01_output_char_32_tty_z88dk_stdio_msg_flsh

zx_01_output_char_32_tty_z88dk:

   cp OTERM_MSG_TTY
   jp z, zx_01_output_char_32_tty_z88dk_oterm_msg_tty

   cp STDIO_MSG_FLSH
   jp z, zx_01_output_char_32_tty_z88dk_stdio_msg_flsh
   
   jp zx_01_output_char_32     ; forward to library

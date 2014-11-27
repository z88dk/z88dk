
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSOLE_01_OUTPUT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CONSOLE_01_OUTPUT is library code that can be inherited to
implement terminal output drivers.  CONSOLE_01_OUTPUT devices
are written to understand the messages delivered from
CONSOLE_01_INPUT terminals so that the two can be paired to
form a complete i/o terminal.

The library output terminal driver reserves bytes stored in
the FDSTRUCT following the FDSTRUCT base.

offset_abs   offset_jp   description

  11..         8..       ??




offset_abs is the absolute offset from the beginning of the
FDSTRUCT.  offset_jp is the offset from & FDSTRUCT.JP which
is the value loaded into ix when the driver runs.

Drivers that further inherit from console_01_output can append
their own reserved state.

Communication from the input terminal to the output terminal
is unidirectional from input to output.  The output terminal
must service the following messages from the input terminal:

; * ITERM_MSG_READLINE
;
; informs the output terminal that the input terminal
; is reading a new line.
;
; * ITERM_MSG_PUTC
;
; enter : c = char to output
; exit  : carry set on error (ignored)
; use   : af, bc, de, hl, ix
;
; source of character is input terminal
;
; * ITERM_MSG_PRINT_CURSOR
;
; enter : c = cursor char (CHAR_CURSOR_UC or CHAR_CURSOR_LC)
; exit  : carry set on error (ignored)
; use   : af, bc, de, hl, ix
;
; * ITERM_MSG_ERASE_CURSOR
;
; enter : de = char *edit_buffer
;         bc = int edit_buffer_len
; use   : af, bc, de, hl, ix
;
; cursor does not appear in edit_buffer
;
; * ITERM_MSG_BS
;
; enter : de = char *edit_buffer
;         bc = int edit_buffer_len
; use   : af, bc, de, hl, ix
;
; last char in edit_buffer is the one being deleted.
;
; * ITERM_MSG_BS_PWD
;
; enter :  e = CHAR_PASSWORD
;         bc = int edit_buffer_len
; use   : af, bc, de, hl, ix
;
; all output is CHAR_PASSWORD, delete last one 

These messages allow line editing to be done in the terminal
window.  Most drivers can treat many of these messages simply
but some drivers, eg proportional font drivers, may need
to perform more complex tasks to allow line editing and these
messages are designed to supply enough information to do them.

Further, the driver can optionally forward two stdio messages
to the library:

; * STDIO_MSG_PUTC
;
; if forwarded to the library one OTERM_MSG_PUTC message per
; character output will be generated.
;
; * STDIO_MSG_WRIT
;
; if forwarded to the library one OTERM_MSG_PUTC message per
; character output will be generated.

If there is no advantage to printing entire strings at a time
or you want to keep the driver simple, you can forward these
messages to the library.  If you do so, your driver must
service one additional message:

; * OTERM_MSG_PUTC (only if putc or writ go to stub)
;
; enter : c = char to output
; exit  : carry set on error
; use   : af, bc, de, hl
;
; source of the character is stdio.


*** TTY EMULATION

*** EXAMPLE CODE

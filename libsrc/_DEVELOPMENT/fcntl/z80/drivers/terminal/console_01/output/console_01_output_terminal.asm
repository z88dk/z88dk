
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONSOLE_01
; library driver for output terminals
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; A specific device driver can forward messages to this stub
; to gain some console_01 output terminal features.
;
; The device driver itself can optionally service:
;
; * STDIO_MSG_PUTC
;
; if forwarded to this stub, the stub will generate
; one OTERM_MSG_PUTC message per character output.
;
; * STDIO_MSG_WRIT
;
; if forwarded to this stub, the stub will generate
; one OTERM_MSG_PUTC message per character output.
;
; The device driver must service these messages:
;
; * OTERM_MSG_PUTC (only if putc or writ go to stub)
;
; enter : c = char to output
; exit  : carry set on error
;
; source of the character is stdio.
;
; * ITERM_MSG_READLINE
;
; informs the output terminal that the input terminal
; is reading a new line.
;
; * ITERM_MSG_PUTC
;
; enter : c = char to output
; exit  : carry set on error (ignored)
;
; source of character is input terminal
;
; * ITERM_MSG_PRINT_CURSOR
;
; enter : c = cursor char (CHAR_CURSOR_UC or CHAR_CURSOR_LC)
; exit  : carry set on error (ignored)
;
; * ITERM_MSG_ERASE_CURSOR
;
; enter : de = char *edit_buffer
;         bc = int edit_buffer_len
;
; cursor does not appear in edit_buffer
;
; * ITERM_MSG_BS
;
; enter : de = char *edit_buffer
;         bc = int edit_buffer_len
;
; last char in edit_buffer is the one being deleted.

SECTION seg_code_fcntl

PUBLIC console_01_output_terminal

EXTERN STDIO_MSG_WRIT, STDIO_MSG_PUTC, STDIO_MSG_SEEK
EXTERN STDIO_MSG_FLSH, STDIO_MSG_CLOS

EXTERN console_01_output_stdio_msg_writ, console_01_output_stdio_msg_putc
EXTERN error_znc, error_lznc, error_enotsup_zc

console_01_output_terminal:

   cp STDIO_MSG_WRIT
   jp z, console_01_output_stdio_msg_writ
   
   cp STDIO_MSG_PUTC
   jp z, console_01_output_stdio_msg_putc
   
   cp STDIO_MSG_SEEK
   jp z, error_lznc            ; do nothing, report no error
   
   cp STDIO_MSG_FLSH
   jp z, error_znc             ; do nothing, report no error
   
   cp STDIO_MSG_CLOS
   jp z, error_znc             ; do nothing, report no error
   
   jp error_enotsup_zc         ; hl = 0 puts FILE stream in error state

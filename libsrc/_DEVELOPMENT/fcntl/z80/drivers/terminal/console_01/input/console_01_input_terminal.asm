
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONSOLE_01
; library driver for input terminals
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; A specific device driver can forward messages to this stub
; and gain all the console_01 input terminal features.
;
; The device driver itself must service at least one message:
;
; * ITERM_MSG_GETC
;
; exit:  a = char after character set translation
;        carry set on error with hl=0 or -1 (eof)
; uses:  af, bc, de, hl

SECTION seg_code_fcntl

PUBLIC console_01_input_terminal

EXTERN STDIO_MSG_GETC, STDIO_MSG_EATC, STDIO_MSG_READ
EXTERN STDIO_MSG_SEEK, STDIO_MSG_FLSH, STDIO_MSG_ICTL
EXTERN STDIO_MSG_CLOS

EXTERN console_01_input_stdio_msg_getc, console_01_input_stdio_msg_eatc
EXTERN console_01_input_stdio_msg_read, console_01_input_stdio_msg_seek
EXTERN console_01_input_stdio_msg_flsh, console_01_input_stdio_msg_ictl
EXTERN error_znc, error_enotsup_zc

console_01_input_terminal:

   cp STDIO_MSG_GETC
   jp z, console_01_input_stdio_msg_getc
   
   cp STDIO_MSG_EATC
   jp z, console_01_input_stdio_msg_eatc
   
   cp STDIO_MSG_READ
   jp z, console_01_input_stdio_msg_read
   
   cp STDIO_MSG_SEEK
   jp z, console_01_input_stdio_msg_seek
   
   cp STDIO_MSG_FLSH
   jp z, console_01_input_stdio_msg_flsh
   
   cp STDIO_MSG_ICTL
   jp z, console_01_input_stdio_msg_ictl
   
   cp STDIO_MSG_CLOS
   jp z, error_znc             ; do nothing and report no error
   
   jp error_enotsup_zc         ; hl = 0 puts FILE stream in error state

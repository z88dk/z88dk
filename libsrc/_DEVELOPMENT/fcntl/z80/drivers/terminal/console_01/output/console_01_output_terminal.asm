
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONSOLE_01_OUTPUT_TERMINAL
; library driver for output terminals
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; The root class of CONSOLE_01_OUTPUT terminals.
;
; This is an abstract class that CONSOLE_01_OUTPUT terminals
; can derive from to change stdio's STDIO_MSG_PUTC and
; STDIO_MSG_WRIT messages, which demand output of a buffer
; of characters, into multiple OTERM_MSG_PUTC messages, which
; demand output of a single char only.
;
; Other stdio messages are treated as errors or no-ops
; as appropriate.
; 
; Driver class diagram:
;
; CONSOLE_01_OUTPUT_TERMINAL (root, abstract)
;
; Generated messages for derived drivers:
;
;   * OTERM_MSG_PUTC
;
;     Source of character is stdio.
;     
;     enter   :  c = ascii code
;     can use : af, bc, de, hl
;
; Messages consumed from stdio:
;
;   * STDIO_MSG_PUTC
;     Generates multiple OTERM_MSG_PUTC messages.
;
;   * STDIO_MSG_WRIT
;     Generates multiple OTERM_MSG_PUTC messages.
;
;   * STDIO_MSG_SEEK
;   * STDIO_MSG_FLSH
;   * STDIO_MSG_CLOS
;
; Any other messages are reported as errors via
; error_enotsup_zc
;
; A connected CONSOLE_01_INPUT_TERMINAL generates
; more messages which are not consumed here.
;
; This driver reserves extra bytes in the FDSTRUCT:
;
; offset (wrt FDSTRUCT.JP)  description
;
;    8..13                  mutex

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

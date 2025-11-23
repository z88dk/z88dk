
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONSOLE_01_OUTPUT_TERMINAL
; library driver for output terminals
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; The root class of CONSOLE_01_OUTPUT terminals.
;
; This is an abstract class that CONSOLE_01_OUTPUT terminals
; can derive from to change stdio's STDIO_MSG_PUTC and
; STDIO_MSG_WRIT messages into multiple OTERM_MSG_PUTC messages
; which demand output of a single char only.
;
; Other stdio messages are treated as errors or no-ops
; as appropriate.
; 
; ;;;;;;;;;;;;;;;;;;;;
; DRIVER CLASS DIAGRAM
; ;;;;;;;;;;;;;;;;;;;;
;
; CONSOLE_01_OUTPUT_TERMINAL (root, abstract)
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
; * STDIO_MSG_CLOS -> no error, do nothing
;
; Any other messages are reported as errors via
; error_enotsup_zc
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES GENERATED FOR DERIVED DRIVERS
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * OTERM_MSG_PUTC
;
;   Source of character is stdio.
;     
;   enter   :  c = ascii code
;   can use : af, bc, de, hl, af'
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
; BYTES RESERVED IN FDSTRUCT
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; offset (wrt FDSTRUCT.JP)  description
;
;    8..13                  mutex

SECTION code_driver
SECTION code_driver_terminal_output

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CHARACTER_00_OUTPUT
; library driver for serial text & binary output
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ;;;;;;;;;;;;;;;;;;;;
; DRIVER CLASS DIAGRAM
; ;;;;;;;;;;;;;;;;;;;;
;
; CHARACTER_00_OUTPUT (root, abstract)
;
; The deriving driver must implement one message generated
; by this driver to complete an output driver.
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM STDIO
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * STDIO_MSG_PUTC  ;; generates multiple OCHAR_MSG_PUTC messages.
; * STDIO_MSG_WRIT  ;; generates multiple OCHAR_MSG_PUTC messages.
; * STDIO_MSG_SEEK  ;; no error, do nothing
; * STDIO_MSG_FLSH  ;; no error, do nothing
; * STDIO_MSG_ICTL
; * STDIO_MSG_CLOS  ;; no error, do nothing
;
; Others result in enotsup_zc.
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES GENERATED FOR DERIVED DRIVERS
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Exactly one of these messages should be
; implemented by derived drivers.
;
; * OCHAR_MSG_PUTC_BIN
;   for binary mode drivers
;   enter   :  c = char
;   exit    : carry set if error
;   can use : af, bc, de, hl, af'
;
; * OCHAR_MSG_PUTC
;   for text mode drivers
;   enter   :  c = char
;   exit    : carry set if error
;   can use : af, bc, de, hl, af'
;
; If one of these messages are implemented,
; the driver is complete.
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; IOCTLs UNDERSTOOD BY THIS DRIVER
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * IOCTL_OCHAR_CRLF
;   enable / disable crlf processing
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
; BYTES RESERVED IN FDSTRUCT
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; offset (wrt FDSTRUCT.JP)  description
;
;    8..13                  mutex

SECTION code_driver
SECTION code_driver_character_output

PUBLIC character_00_output

EXTERN STDIO_MSG_WRIT, STDIO_MSG_PUTC, STDIO_MSG_SEEK
EXTERN STDIO_MSG_FLSH, STDIO_MSG_CLOS, STDIO_MSG_ICTL
EXTERN OCHAR_MSG_PUTC_BIN

EXTERN character_00_output_stdio_msg_writ, character_00_output_stdio_msg_putc
EXTERN character_00_output_ochar_msg_putc_bin, character_00_output_stdio_msg_ictl
EXTERN error_znc, error_lznc, error_enotsup_zc

character_00_output:

   cp OCHAR_MSG_PUTC_BIN
   jp z, character_00_output_ochar_msg_putc_bin

   cp STDIO_MSG_WRIT
   jp z, character_00_output_stdio_msg_writ
   
   cp STDIO_MSG_PUTC
   jp z, character_00_output_stdio_msg_putc
   
   cp STDIO_MSG_SEEK
   jp z, error_lznc            ; do nothing, report no error
   
   cp STDIO_MSG_FLSH
   jp z, error_znc             ; do nothing, report no error

   cp STDIO_MSG_ICTL
   jp z, character_00_output_stdio_msg_ictl

   cp STDIO_MSG_CLOS
   jp z, error_znc             ; do nothing, report no error
   
   jp error_enotsup_zc         ; hl = 0 puts FILE stream in error state

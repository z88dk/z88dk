;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; rc_00_input_basic;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Input read from NASCOM Basic. RST10H.  Blocking read.
;
; ;;;;;;;;;;;;;;;;;;;;
; DRIVER CLASS DIAGRAM
; ;;;;;;;;;;;;;;;;;;;;
;
; CHARACTER_00_INPUT (root, abstract)
; RC_00_INPUT_BASIC (concrete)
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM STDIO
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * STDIO_MSG_GETC
; * STDIO_MSG_EATC
; * STDIO_MSG_READ
; * STDIO_MSG_SEEK
; * STDIO_MSG_FLSH
; * STDIO_MSG_ICTL
; * STDIO_MSG_CLOS
;
; Others result in enotsup_zc.
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM CHARACTER_00_INPUT
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * ICHAR_MSG_GETC
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; IOCTLs UNDERSTOOD BY THIS DRIVER
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * IOCTL_RESET
;
; * IOCTL_ICHAR_CRLF
;   enable / disable crlf processing
; 
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
; BYTES RESERVED IN FDSTRUCT
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; offset (wrt FDSTRUCT.JP)  description
;
;    8..13                  mutex

INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_character_input

PUBLIC rc_00_input_basic

EXTERN character_00_input, error_znc, error_mc

rc_00_input_basic:

   cp ICHAR_MSG_GETC
   jp nz, character_00_input   ; forward other messages to the library

rc_00_input_basic_ichar_msg_getc:

   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl

   rst 0x10                    ; get any characters available
                               ; if Rx buffer is empty, will block
   ; a = ascii code
   
   cp CHAR_CTRL_Z
   jp z, error_mc              ; generate EOF (ctrl-z is from cp/m)
   
   or a                        ; reset carry to indicate no error
   ret

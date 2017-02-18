
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; rc_00_input_acia ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Input read from acia.  Blocking read.
;
; ;;;;;;;;;;;;;;;;;;;;
; DRIVER CLASS DIAGRAM
; ;;;;;;;;;;;;;;;;;;;;
;
; CHARACTER_00_INPUT (root, abstract)
; RC_00_INPUT_ACIA (concrete)
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

PUBLIC rc_00_input_acia

EXTERN _acia_pollc, _acia_getc, _acia_flush_Rx_di
EXTERN character_00_input, error_znc, error_mc

rc_00_input_acia:

   cp ICHAR_MSG_GETC
   jr nz, no_match_0

rc_00_input_acia_ichar_msg_getc:

   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl

block_loop:

   call _acia_pollc            ; check whether any characters are in Rx buffer
   jr nc, block_loop           ; if Rx buffer is empty
   
   call _acia_getc
   
   ; l = ascii code
   
   ld a,l
   
   cp CHAR_CTRL_Z
   jp z, error_mc              ; generate EOF (ctrl-z is from cp/m)
   
   or a                        ; reset carry to indicate no error
   ret
   
no_match_0:
   
   cp STDIO_MSG_FLSH
   jp nz, character_00_input   ; forward other messages to library

rc_00_input_acia_stdio_msg_flsh:

   ; exit : carry set indicates error

   call _acia_flush_Rx_di
   jp error_znc                ; report success (library does nothing further)

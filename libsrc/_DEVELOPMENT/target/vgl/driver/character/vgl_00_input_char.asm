defc VGL_KEY_STATUS = 0xdb00
defc VGL_KEY_CURRENT = 0xdb01

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; vgl_00_input_char ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Input from keyboard V-Chip
;
; ;;;;;;;;;;;;;;;;;;;;
; DRIVER CLASS DIAGRAM
; ;;;;;;;;;;;;;;;;;;;;
;
; CHARACTER_00_INPUT (root, abstract)
; VGL_00_INPUT_CHAR (concrete)
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

PUBLIC vgl_00_input_char

EXTERN character_00_input, error_znc, error_mc

vgl_00_input_char:

   cp ICHAR_MSG_GETC
   jp nz, character_00_input   ; forward other messages to the library

vgl_00_input_char_ichar_msg_getc:
    ;     exit : a = keyboard char after character set translation
    ;            carry set on error, hl = 0 (stream error) or -1 (eof)
    ;
    ;  can use : af, bc, de, hl
    
    
    ld a, 0xc0
    ld (VGL_KEY_STATUS), a
    
    ; Wait for key press
getc_loop:
    
    
    
    ;@FIXME Intentionally loop forever, so I can see if this function is being called AT ALL
    ld a, 0x40
    out (0x0b), a
    jr getc_loop
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ld a, (VGL_KEY_STATUS)
    cp 0xd0
    jr nz, getc_loop
    
    ; Get current key
    ld a, (VGL_KEY_CURRENT)
    
    ; a = ascii code
    
    ;cp CHAR_CTRL_Z
    ;jp z, error_mc              ; generate EOF (ctrl-z is from cp/m)
    
    or a                        ; reset carry to indicate no error
    ret

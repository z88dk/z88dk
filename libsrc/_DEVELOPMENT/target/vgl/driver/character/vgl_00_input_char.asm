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

;for V-Tech:
; model 2000: 0xdce0/0xdce4
; model 4000: 0xdb00/0xdb01

	ld	a, 0c0h
	ld	(0xdb00), a	; _KEY_STATUS_MODEL4000: Prepare next getkey (4000)
	
	; Wait for key press
	_key_get_loop_MODEL4000:
		ld	a, (0xdb00)	; _KEY_STATUS_MODEL4000
		cp	0d0h
	jr	nz, _key_get_loop_MODEL4000
	
	; Get current key
	ld	a, (0xdb01)	; _KEY_CURRENT_MODEL4000

   ; a = ascii code
   
   cp CHAR_CTRL_Z
   jp z, error_mc              ; generate EOF (ctrl-z is from cp/m)
   
   or a                        ; reset carry to indicate no error
   ret

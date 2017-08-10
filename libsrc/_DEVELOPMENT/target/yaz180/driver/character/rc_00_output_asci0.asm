
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; rc_00_output_asci0 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Output via asci0 interface.  Blocking write.
;
; ;;;;;;;;;;;;;;;;;;;;
; DRIVER CLASS DIAGRAM
; ;;;;;;;;;;;;;;;;;;;;
;
; CHARACTER_00_OUTPUT (root, abstract)
; RC_00_OUTPUT_ASCI0 (concrete)
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM STDIO
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * STDIO_MSG_PUTC
; * STDIO_MSG_WRIT
; * STDIO_MSG_SEEK
; * STDIO_MSG_FLSH
; * STDIO_MSG_ICTL
; * STDIO_MSG_CLOS
;
; Others result in enotsup_zc.
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM CHARACTER_00_OUTPUT
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   * OCHAR_MSG_PUTC
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
;  8..13                    mutex

SECTION code_driver
SECTION code_driver_character_output

PUBLIC rc_00_output_asci0

EXTERN OCHAR_MSG_PUTC
EXTERN character_00_output, _asci0_putc

rc_00_output_asci0:

   cp OCHAR_MSG_PUTC
   jp nz, character_00_output  ; forward other messages to library

rc_00_output_asci0_ochar_msg_putc:

   ;   enter   :  c = char
   ;   exit    : carry set if error
   ;   can use : af, bc, de, hl, af'
   
block_loop:

   ld l,c
   call _asci0_putc
   
   dec l
   jr z, block_loop            ; if Tx buffer is full
   
   or a                        ; ensure the carry flag is cleared
   
   ret                         ; carry is reset

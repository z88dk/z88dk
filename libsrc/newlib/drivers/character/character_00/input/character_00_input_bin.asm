
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CHARACTER_00_INPUT_BIN
; library driver for serial binary input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ;;;;;;;;;;;;;;;;;;;;
; DRIVER CLASS DIAGRAM
; ;;;;;;;;;;;;;;;;;;;;
;
; CHARACTER_00_INPUT_BIN (root, abstract)
;
; The deriving driver must implement one message generated
; by this driver to complete an input terminal.
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM STDIO
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * STDIO_MSG_GETC
; * STDIO_MSG_EATC
; * STDIO_MSG_READ   ;; change to character-at-a-time input
; * STDIO_MSG_SEEK   ;; seek forward only else no error
; * STDIO_MSG_FLSH   ;; do nothing, return no error
; * STDIO_MSG_ICTL
; * STDIO_MSG_CLOS   ;; do nothing, return no error
;
; Others result in enotsup_zc.
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES GENERATED FOR DERIVED DRIVERS
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * ICHAR_MSG_GETC
;
;   Return one character from the input device.
;
;   enter:  ix = & FDSTRUCT.JP
;    exit:  a = char after character set translation
;           carry set on error with hl=0 (err) or -1 (eof)
; can use:  af, bc, de, hl
;
; If this message is implemented, the driver is complete.
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; IOCTLs UNDERSTOOD BY THIS DRIVER
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * IOCTL_RESET
; 
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
; BYTES RESERVED IN FDSTRUCT
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; offset (wrt FDSTRUCT.JP)  description
;
;    8..13                  mutex

SECTION code_driver
SECTION code_driver_character_input

PUBLIC character_00_input_bin

EXTERN STDIO_MSG_EATC, STDIO_MSG_READ, STDIO_MSG_SEEK
EXTERN STDIO_MSG_FLSH, STDIO_MSG_CLOS, STDIO_MSG_GETC
EXTERN STDIO_MSG_ICTL

EXTERN character_00_input_bin_stdio_msg_getc, character_00_input_stdio_msg_eatc
EXTERN character_00_input_bin_stdio_msg_read, character_00_input_stdio_msg_seek
EXTERN character_00_input_bin_stdio_msg_ictl, error_znc, error_enotsup_zc

character_00_input_bin:

   cp STDIO_MSG_GETC
   jp z, character_00_input_bin_stdio_msg_getc

   cp STDIO_MSG_EATC
   jp z, character_00_input_stdio_msg_eatc
   
   cp STDIO_MSG_READ
   jp z, character_00_input_bin_stdio_msg_read
   
   cp STDIO_MSG_SEEK
   jp z, character_00_input_stdio_msg_seek

   cp STDIO_MSG_FLSH
   jp z, error_znc             ; do nothing and report no error
   
   cp STDIO_MSG_ICTL
   jp z, character_00_input_bin_stdio_msg_ictl
   
   cp STDIO_MSG_CLOS
   jp z, error_znc             ; do nothing and report no error
   
   jp error_enotsup_zc         ; hl = 0 puts FILE stream in error state

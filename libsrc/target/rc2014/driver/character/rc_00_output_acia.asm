;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rc_00_output_acia ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Simplified serial output via ACIA device (_acia_putc).
; No terminal cooking beyond character_00 CRLF ioctl.
;
; CHARACTER_00_OUTPUT (root, abstract)
; RC_00_OUTPUT_ACIA (concrete)
;
; Implements: OCHAR_MSG_PUTC
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION code_driver
SECTION code_driver_character_output

PUBLIC rc_00_output_acia

EXTERN OCHAR_MSG_PUTC
EXTERN rc_00_output_acia_ochar_msg_putc, character_00_output

rc_00_output_acia:

   cp OCHAR_MSG_PUTC
   jp z, rc_00_output_acia_ochar_msg_putc

   jp character_00_output

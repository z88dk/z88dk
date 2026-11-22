;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rc_00_input_acia ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Simplified serial input via ACIA device (_acia_getc / poll).
; Blocking getc. No line editing (character_00, not console_01).
;
; CHARACTER_00_INPUT (root, abstract)
; RC_00_INPUT_ACIA (concrete)
;
; Messages from stdio: GETC, EATC, READ, SEEK, FLSH, ICTL, CLOS
; Implements: ICHAR_MSG_GETC
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION code_driver
SECTION code_driver_character_input

PUBLIC rc_00_input_acia

EXTERN ICHAR_MSG_GETC
EXTERN rc_00_input_acia_ichar_msg_getc, character_00_input

rc_00_input_acia:

   cp ICHAR_MSG_GETC
   jp z, rc_00_input_acia_ichar_msg_getc

   jp character_00_input

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC term_01_output_char_oterm_msg_pause

EXTERN l_ret

defc term_01_output_char_oterm_msg_pause = l_ret

;   * OTERM_MSG_PAUSE
;
;     can use:  af, bc, de, hl
;
;     The scroll count has reached zero so the driver
;     should pause the output somehow.
;
; A terminal mode bit has the driver pause text printing
; when the screen is filled with input.  This subroutine
; is called to implement the pause.  Drivers typically
; scan the keyboard directly and wait for a keypress before
; returning.  This default does not implement any pause.

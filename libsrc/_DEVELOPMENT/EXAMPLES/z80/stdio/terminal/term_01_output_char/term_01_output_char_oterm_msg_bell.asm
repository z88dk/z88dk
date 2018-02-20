SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC term_01_output_char_oterm_msg_bell

EXTERN l_ret

defc term_01_output_char_oterm_msg_bell = l_ret

;   * OTERM_MSG_BELL (optional)
;
;     can use:  af, bc, de, hl
;
;     Sound the terminal's bell (^G).
;
; Drivers that implement this message normally output
; a short beep.  This default implementation simply returns.

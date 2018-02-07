SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC term_01_output_char_iterm_msg_bell

EXTERN l_ret

defc term_01_output_char_iterm_msg_bell = l_ret

;   * ITERM_MSG_BELL (optional)
;
;     can use:  af, bc, de, hl
;
;     The input terminal generates this message to
;     indicate the edit buffer is either empty or full.
;     The output terminal generates this message to
;     indicate the output window is full and is being paused.
;
; Drivers that implement this message normally emit a short
; audible beep.  The default implementation here simply returns.

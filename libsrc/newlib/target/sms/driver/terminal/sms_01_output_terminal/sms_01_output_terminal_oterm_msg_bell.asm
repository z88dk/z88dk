SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_oterm_msg_bell

EXTERN l_ret

;sms_01_output_terminal_oterm_msg_bell:

   ; What should be done for the sms?
   ; Other targets emit an audible bell here.
   ;
   ;   can use:  af, bc, de, hl

;   bit 0,(ix+7)
;   ret z                       ; if bell disabled

defc sms_01_output_terminal_oterm_msg_bell = l_ret

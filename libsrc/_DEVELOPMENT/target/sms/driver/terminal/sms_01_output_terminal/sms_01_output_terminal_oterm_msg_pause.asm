SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_oterm_msg_pause

EXTERN asm_in_wait_key

;sms_01_output_terminal_oterm_msg_pause:

   ;   can use:  af, bc, de, hl
   ;
   ;   The scroll count has reached zero so the driver should
   ;   pause the output somehow.
   ;
   ;   If multiple threads are running this may have to be
   ;   done differently.
   
;   call asm_in_wait_nokey
;   call asm_in_wait_key
;   jp asm_in_wait_nokey

defc sms_01_output_terminal_oterm_msg_pause = asm_in_wait_key

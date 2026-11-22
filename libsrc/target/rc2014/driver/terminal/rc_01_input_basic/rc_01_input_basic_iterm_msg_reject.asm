SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC rc_01_input_basic_iterm_msg_reject

rc_01_input_basic_iterm_msg_reject:

   ;   Indicate whether typed character should be rejected.
   ;
   ;   enter:  c = ascii code
   ;    exit:  carry reset indicates the character should be rejected.
   ; can use:  af, bc, de, hl
   
   ; accept all for the moment
   ; put state machine here to eliminate pc keyboard escape sequences

   scf
   ret

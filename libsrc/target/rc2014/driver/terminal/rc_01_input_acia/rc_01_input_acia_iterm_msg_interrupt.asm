INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC rc_01_input_acia_iterm_msg_interrupt

EXTERN rc_01_input_basic_iterm_msg_interrupt

defc rc_01_input_acia_iterm_msg_interrupt = rc_01_input_basic_iterm_msg_interrupt

   ;   Indicate whether character should interrupt line editing.
   ;
   ;   enter:  c = ascii code
   ;    exit:  carry reset indicates line editing should terminate
   ; can use:  af, bc, de, hl

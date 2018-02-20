SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC rc_01_input_basic_dcio_iterm_msg_reject

EXTERN asm_isprint

rc_01_input_basic_dcio_iterm_msg_reject:

   ;   Indicate whether typed character should be rejected.
   ;
   ;   enter:  c = ascii code
   ;    exit:  carry reset indicates the character should be rejected.
   ; can use:  af, bc, de, hl

   ld a,c
   call asm_isprint            ; carry reset if in [32,126]
   
   ccf
   ret

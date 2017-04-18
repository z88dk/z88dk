
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_tty_z88dk_27_escape

EXTERN error_zc

sms_01_output_terminal_tty_z88dk_27_escape:

   ; output escaped char uninterpretted
   
   ; de = parameters *
   
   ld a,(de)
   ld c,a                      ; c = escaped char
   
   ; pop one return address from stack
   ; so that carry is not cleared
   
   jp error_zc - 1             ; carry set to deliver char to terminal

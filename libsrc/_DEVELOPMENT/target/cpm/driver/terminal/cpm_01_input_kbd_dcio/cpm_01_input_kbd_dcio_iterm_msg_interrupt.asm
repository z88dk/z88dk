
INCLUDE "clib_cfg.asm"

SECTION code_fcntl

PUBLIC cpm_01_input_kbd_dcio_iterm_msg_interrupt

EXTERN error_znc

cpm_01_input_kbd_dcio_iterm_msg_interrupt:

   ;   Indicate whether character should interrupt line editing.
   ;
   ;   enter:  c = ascii code
   ;    exit:  carry reset indicates line editing should terminate
   ; can use:  af, bc, de, hl

   ld a,c
   
   cp CHAR_CTRL_C
   jp z, error_znc             ; ctrl-c causes early exit
   
   scf
   ret

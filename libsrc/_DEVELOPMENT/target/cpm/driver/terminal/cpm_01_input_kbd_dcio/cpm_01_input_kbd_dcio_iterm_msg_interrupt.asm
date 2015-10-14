
INCLUDE "clib_cfg.asm"

SECTION code_fcntl

PUBLIC cpm_01_input_kbd_dcio_iterm_msg_interrupt

EXTERN asm_exit

cpm_01_input_kbd_dcio_iterm_msg_interrupt:

   ;   Indicate whether character should interrupt line editing.
   ;
   ;   enter:  c = ascii code
   ;    exit:  carry reset indicates line editing should terminate
   ; can use:  af, bc, de, hl

   ld a,c
   
   cp CHAR_CTRL_C
   
   scf
   ret nz                      ; continue editing if not ctrl-c
   
   ; users expect ctrl-c to terminate the program
   ; terminating the edit would return with carry reset
   
   ld hl,-1                    ; return status
   jp asm_exit                 ; will also close files

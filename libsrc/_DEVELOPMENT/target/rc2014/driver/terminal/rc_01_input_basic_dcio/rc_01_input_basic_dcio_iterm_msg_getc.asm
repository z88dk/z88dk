INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC rc_01_input_basic_dcio_iterm_msg_getc

EXTERN error_mc

rc_01_input_basic_dcio_iterm_msg_getc:

   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl

   rst 0x10                    ; get any characters available
                               ; if Rx buffer is empty, will block
   ; a = ascii code

   cp CHAR_CTRL_Z
   jp z, error_mc              ; generate EOF (ctr-z is from cp/m)
   
   or a                        ; reset carry to indicate success
   ret

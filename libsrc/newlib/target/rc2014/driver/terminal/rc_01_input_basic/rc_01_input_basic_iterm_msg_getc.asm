INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC rc_01_input_basic_iterm_msg_getc

rc_01_input_basic_iterm_msg_getc:

   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl

   rst 0x10                    ; get any characters available
                               ; if Rx buffer is empty, will block
   ; a = ascii code

   cp 32
   ret nc
   
   cp 10
   jr z, key_cr
   
   cp 13
   jr z, key_lf

   or a                        ; reset carry to indicate success
   ret

key_cr:

   ld a,CHAR_CR
   ret

key_lf:

   ld a,CHAR_LF
   ret

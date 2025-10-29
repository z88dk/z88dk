INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC rc_01_input_acia_iterm_msg_getc

EXTERN _acia_pollc, _acia_getc

rc_01_input_acia_iterm_msg_getc:

   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl

block_loop:

   call _acia_pollc            ; check whether any characters are in Rx buffer
   jr nc, block_loop           ; if Rx buffer is empty
   
   call _acia_getc
   
   ; l = ascii code
   
   ld a,l

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

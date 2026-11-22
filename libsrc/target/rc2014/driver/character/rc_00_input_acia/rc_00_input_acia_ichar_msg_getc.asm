INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_character_input

PUBLIC rc_00_input_acia_ichar_msg_getc

EXTERN _acia_getc

rc_00_input_acia_ichar_msg_getc:

   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl

.block_loop

   call _acia_getc             ; carry set if char in L/A
   jr nc, block_loop

   ; a = l = ascii code

   cp 32
   ret nc

   cp 10
   jr z, key_lf

   cp 13
   jr z, key_cr

   or a                        ; success
   ret

.key_cr

   ld a,CHAR_CR
   ret

.key_lf

   ld a,CHAR_LF
   ret

INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC rc_01_input_hbios0_iterm_msg_getc

EXTERN asm_hbios

rc_01_input_hbios0_iterm_msg_getc:

   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl

block_loop:

   ld bc,__BF_CIOIST<<8|0x00
   call asm_hbios               ; check for character in Rx buffer
   or a
   jr Z,block_loop

   ld bc,__BF_CIOIN<<8|0x00
   call asm_hbios               ; get character in Rx buffer

   ; e = ascii code

   ld a,e

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


INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_character_input

PUBLIC character_00_input_stdio_msg_getc

EXTERN device_return_error, device_set_error, l_jpix

character_00_input_stdio_msg_getc:

   ; enter : ix = & FDSTRUCT.JP
   ;
   ; exit  : success
   ;
   ;            a = hl = char
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0 on stream error, -1 on eof
   ;            carry set
   ;
   ; uses  : can modify af, bc, de, hl
   
   ld a,(ix+6)
   and $03                     ; check device state
   jp nz, device_return_error

reject_cr:

   ld a,ICHAR_MSG_GETC
   call l_jpix                 ; get char from device
   jp c, device_set_error

   ld l,a
   ld h,0

   cp CHAR_CR
   jr z, cr

   or a
   ret

cr:

   bit 0,(ix+7)
   ret z                       ; if not doing crlf conversion
   
   jr reject_cr

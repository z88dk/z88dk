INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC rc_01_output_basic_dcio_oterm_msg_putc
PUBLIC rc_01_output_basic_dcio_oterm_msg_putc_raw

EXTERN l_jpix

rc_01_output_basic_dcio_oterm_msg_putc:

   ; enter  : c = char to output
   ; can use: af, bc, de, hl
   
   ; char to print is coming from stdio
   
   bit 5,(ix+6)
   jr z, cooked                ; if cook is disabled

   ; tty emulation is enabled
   
   ld a,OTERM_MSG_TTY
   
   call l_jpix                 ; carry reset if tty absorbed char
   ret nc                      ; if tty absorbed char
   
   ld a,c
   
   cp CHAR_BELL
   jr nz, cooked

putchar_bell:

   ld a,OTERM_MSG_BELL
   jp (ix)

cooked:
rc_01_output_basic_dcio_oterm_msg_putc_raw:

   ; c = ascii code
   
   bit 4,(ix+6)
   jr z, crlf_done             ; if not processing crlf

   ld a,c
   
   cp CHAR_CR
   ret z                       ; ignore cr

   cp CHAR_LF
   jr nz, crlf_done

   ; send cr+lf
   
   ld c,13
   call crlf_done              ; send cr
   
   ld c,10

crlf_done:

   ; c = ascii code

   ld a,c
   rst 0x08
   ret

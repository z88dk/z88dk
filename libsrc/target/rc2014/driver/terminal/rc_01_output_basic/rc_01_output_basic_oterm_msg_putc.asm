INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC rc_01_output_basic_oterm_msg_putc
PUBLIC rc_01_output_basic_oterm_msg_putc_raw

EXTERN l_jpix

rc_01_output_basic_oterm_msg_putc:

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
rc_01_output_basic_oterm_msg_putc_raw:

   ; c = ascii code

   ld a,c

   bit 4,(ix+6)
   jp z, 0x08                  ; if not processing crlf

   cp CHAR_CR
   ret z                       ; ignore cr

   cp CHAR_LF
   jp nz, 0x08

   ; send cr+lf
   
   ld a,13
   rst 0x08                    ; send cr
   
   ld a,10
   jp 0x08

SECTION code_driver
SECTION code_driver_character_output

PUBLIC rc_00_output_acia_ochar_msg_putc

EXTERN _acia_putc

rc_00_output_acia_ochar_msg_putc:

   ;   enter   :  c = char
   ;   exit    : carry set if error
   ;   can use : af, bc, de, hl, af'

.retry

   ld l,c
   call _acia_putc             ; L = 1 if Tx buffer full
   ld a,l
   or a
   jr nz, retry                ; wait for space

   or a                        ; carry reset = success
   ret

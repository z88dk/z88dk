
SECTION code_driver
SECTION code_driver_character_output

PUBLIC cpm_00_output_punch_ochar_msg_putc

EXTERN __CPM_WPUN, asm_cpm_bdos_alt

cpm_00_output_punch_ochar_msg_putc:

   ;   enter   :  c = char
   ;   exit    : carry set if error
   ;   can use : af, bc, de, hl, af'

   ld e,c
   ld c,__CPM_WPUN
   
   call asm_cpm_bdos_alt
   
   or a
   ret


INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC cpm_01_output_dcio_oterm_msg_bell
PUBLIC cpm_01_output_dcio_oterm_msg_bell_0

EXTERN asm_cpm_bdos_alt

cpm_01_output_dcio_oterm_msg_bell:

   ;   can use:  af, bc, de, hl

   bit 0,(ix+7)
   ret z                       ; if bell disabled

cpm_01_output_dcio_oterm_msg_bell_0:

   ld c,__CPM_DCIO             ; bdos direct console i/o
   ld e,7
   jp asm_cpm_bdos_alt

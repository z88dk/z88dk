
INCLUDE "clib_cfg.asm"

SECTION code_fcntl

PUBLIC cpm_01_output_dcio_iterm_msg_bs

EXTERN asm_cpm_bdos_alt

cpm_01_output_dcio_iterm_msg_bs:

   ; backspace
   ; can use:  af, bc, de, hl, ix

   ld c,0x06                   ; bdos direct console i/o
   ld e,CHAR_BS
   jp asm_cpm_bdos_alt

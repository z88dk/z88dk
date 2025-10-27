
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC cpm_01_input_kbd_dcio_iterm_msg_getc

EXTERN asm_cpm_bdos_alt, error_mc

cpm_01_input_kbd_dcio_iterm_msg_getc:

   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl

   ld c,__CPM_DCIO             ; direct console i/o
   ld e,0xff                   ; input
   
   call asm_cpm_bdos_alt       ; exx and ix/iy preserved
   
   or a
   jr z, cpm_01_input_kbd_dcio_iterm_msg_getc
   
   ; A = ascii code

   cp CHAR_CTRL_Z
   jp z, error_mc              ; generate EOF

   ; for cpm swap CR/LF since return key only generates CR

   cp 13
   jr z, change_cr_to_lf
   
   cp 10
   jr z, change_lf_to_cr
   
   or a
   ret

change_cr_to_lf:

   ld a,CHAR_LF
   ret

change_lf_to_cr:

   ld a,CHAR_CR
   ret


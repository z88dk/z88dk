
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_character_input

PUBLIC cpm_00_input_reader_ichar_msg_getc

EXTERN asm_cpm_bdos_alt, error_mc

cpm_00_input_reader_ichar_msg_getc:

   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl

   ld c,__CPM_RRDR             ; reader input
   call asm_cpm_bdos_alt       ; exx and ix/iy preserved

   ; A = ascii code
   
   cp CHAR_CTRL_Z
   jp z, error_mc              ; generate EOF

   cp 13
   jr z, cr
   
   cp 10
   jr z, lf
   
   or a
   ret

lf:

   ld a,CHAR_LF
   ret

cr:

   ld a,CHAR_CR
   ret

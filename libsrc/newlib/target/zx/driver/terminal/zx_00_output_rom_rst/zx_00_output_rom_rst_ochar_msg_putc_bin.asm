
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_character_output

PUBLIC zx_00_output_rom_rst_ochar_msg_putc_bin

zx_00_output_rom_rst_ochar_msg_putc_bin:

   ; derived driver is in text mode
   ;
   ; enter   : c = char
   ;
   ; can use : af, bc, de, hl, af'
   
   bit 4,(ix+6)
   jr z, putchar               ; if not processing crlf
   
   ld a,c
   
   cp CHAR_CR
   ret z                       ; ignore cr
   
   cp CHAR_LF
   jr nz, putchar
   
   ; send code 13
   
   ld c,13

putchar:

   ; c = char
   
   push ix
   push iy
   
   ld a,c
   
   exx
   
   push bc
   push de
   push hl

IF __SDCC_IY

   ld ix,0x5c3a

ELSE

   ld iy,0x5c3a

ENDIF
   
   rst 0x10
   
   pop hl
   pop de
   pop bc
   
   exx
   
   pop iy
   pop ix
   
   or a
   ret

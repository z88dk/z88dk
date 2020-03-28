
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

   exx
   
   push bc
   push de
   push hl

   ld bc,__IO_NEXTREG_REG
   ld a,__REG_MMU6
   
   out (c),a
   
   inc b
   in l,(c)
   
   dec b
   inc a
   
   out (c),a
   
   inc b
   in h,(c)

   push hl                     ; save hl = mmu7,6
   
   exx
   
   push bc
   push de
   push hl

   ld a,c

IF __SDCC_IY

   ld ix,__SYS_IY

ELSE

   ld iy,__SYS_IY

ENDIF
   
   rst 0x10
   
   pop hl
   pop de
   pop bc
   
   exx

   pop hl                      ; hl = mmu7,6
   
   ld a,l
   mmu6 a
   
   ld a,h
   mmu7 a
   
   pop hl
   pop de
   pop bc
   
   exx

   pop iy
   pop ix
   
   or a
   ret

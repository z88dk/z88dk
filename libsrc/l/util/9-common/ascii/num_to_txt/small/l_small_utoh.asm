
SECTION code_clib
SECTION code_l

PUBLIC l_small_utoh

EXTERN l_hex_nibble_hi, l_hex_nibble_lo

l_small_utoh:

   ; write unsigned hexadecimal integer to ascii buffer in uppercase
   ; derived from section 5.2 of http://baze.au.com/misc/z80bits.html
   ;
   ; enter : hl = unsigned integer
   ;         de = char *buffer
   ;         carry set to write leading zeroes
   ;
   ; exit  : de = char *buffer (one byte past last char written)
   ;         carry set if in write loop (for l_ultoh)
   ;
   ; uses  : af, de
   
   ld a,h
   jr c, leading_zeroes

no_leading_zeroes:

   call l_hex_nibble_hi
   cp '0'
   jr nz, write_3
   
   ld a,h
   call l_hex_nibble_lo
   cp '0'
   jr nz, write_2
   
   ld a,l
   call l_hex_nibble_hi
   cp '0'
   jr nz, write_1
   
   ld a,l
   call l_hex_nibble_lo
   cp '0'
   jr nz, write_0
   
   jr write_00

leading_zeroes:

   call l_hex_nibble_hi

write_3:

   ld (de),a
   inc de
   
   ld a,h
   call l_hex_nibble_lo

write_2:

   ld (de),a
   inc de
   
   ld a,l
   call l_hex_nibble_hi

write_1:

   ld (de),a
   inc de
   
   ld a,l
   call l_hex_nibble_lo

write_0:

   scf

write_00:

   ld (de),a
   inc de
   
   ret

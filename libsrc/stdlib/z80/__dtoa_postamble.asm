
SECTION code_clib
SECTION code_stdlib

PUBLIC __dtoa_postamble

__dtoa_postamble:

   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer

   push ix
   pop de                      ; de = buffer *
   
   dec de
   ld a,(de)
   
   cp '0'
   jr nz, length
   inc de                      ; exclude carry digit
   
length:

   or a
   sbc hl,de
   
   ld c,l
   ld b,h                      ; bc = buffer_length

   ; bc = buffer length
   ; de = buffer *
   ; carry reset
   ;
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer

   ret

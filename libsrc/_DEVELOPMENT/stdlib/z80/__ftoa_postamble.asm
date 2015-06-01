
SECTION code_stdlib

PUBLIC __ftoa_postamble

__ftoa_postamble:

   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-5) = flags, bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz = 0
   ; (IX-2) = iz = 0
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
   ; (IX-5) = flags, bit 7='N', bit 4='#', bit 0=(precision==0), others unaffected
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = ignore

   ret

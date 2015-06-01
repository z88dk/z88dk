
SECTION code_stdlib

PUBLIC __ftoa_remove_zeroes

__ftoa_remove_zeroes:

   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-5) = flags, bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = '0' marks start of buffer

   bit 4,(ix-5)
   ret nz                      ; if # flag
   
   ld (ix-4),0                 ; eliminate trailing zeroes
   ld a,'0'

loop_zeroes:

   dec hl
   cp (hl)
   
   jr z, loop_zeroes
   
   ld a,'.'
   cp (hl)
   
   inc hl
   ret nz                      ; if not at decimal point
   
   ld (ix-3),0                 ; eliminate leading fraction zeroes
   
   bit 0,(ix-5)
   ret nz                      ; if precision != 0
   
   dec hl                      ; remove decimal point
   ret

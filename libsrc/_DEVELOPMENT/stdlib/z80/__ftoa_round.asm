
SECTION code_stdlib

PUBLIC __ftoa_round

__ftoa_round:

   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-5) = flags, bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = '0' marks start of buffer
   
   dec hl                      ; point at rounding digit
   ld a,(hl)

   cp '5'
   ret c                       ; if round down
   
   push hl
   
loop_round:

   dec hl
   ld a,(hl)
   
   cp '.'
   jr z, loop_round
   
   ld (hl),'0'

   cp '9'
   jr z, loop_round
   
   inc a
   ld (hl),a

   pop hl
   ret

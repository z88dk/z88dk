
SECTION code_clib
SECTION code_stdlib

PUBLIC __dtoa_round

__dtoa_round:

   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
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


SECTION code_stdlib

PUBLIC __ftoa_round, __ftoa_remove_zeroes

__ftoa_round:

   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-5) = flags, bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = '0' marks start of buffer

   ; exit with carry reset
   
   dec hl                      ; point at rounding digit
   push hl

   ld a,(hl)
   cp '5'
   jr c, round_done            ; if round down
   
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

round_done:

   pop hl

__ftoa_remove_zeroes:

   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-5) = flags, bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = '0' marks start of buffer

   bit 4,(ix-5)
   jr nz, exit_no_carry        ; if # flag

   ld (ix-4),0                 ; eliminate trailing zeroes
   ld a,'0'

loop_zeroes:

   dec hl
   cp (hl)
   
   jr z, loop_zeroes

   ld a,'.'
   cp (hl)
   
   inc hl
   jr nz, exit_no_carry        ; if not decimal point
   
   ld (ix-3),0                 ; eliminate inserted fraction zeroes

   bit 0,(ix-5)
   jr nz, exit_no_carry        ; if precision != 0

   dec hl                      ; remove decimal point

exit_no_carry:

   or a
   ret

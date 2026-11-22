
SECTION code_clib
SECTION code_stdlib

PUBLIC __dtoa_remove_zeroes

__dtoa_remove_zeroes:

   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 1 = %g, bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer

   bit 4,(ix-6)
   ret nz                      ; if # flag
   
   dec hl
   
   bit 0,(ix-6)
   ret nz                      ; if precision == 0, eliminate decimal point
   
   inc hl
   
   bit 1,(ix-6)
   ret z                       ; if not %g
   
   ld (ix-3),0                 ; eliminate trailing zeroes
   ld a,'0'

loop_zeroes:

   dec hl
   
   cp (hl)
   jr z, loop_zeroes
   
   ld a,'.'
   cp (hl)
   
   inc hl
   ret nz                      ; if not at decimal point
   
   ld (ix-4),0                 ; eliminate leading fraction zeroes
   
   dec hl                      ; remove decimal point
   ret

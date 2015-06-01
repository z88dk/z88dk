
SECTION code_stdlib

PUBLIC __ftoa_count

__ftoa_count:

   ;     bc = length of workspace
   ; (IX-5) = flags, bit 7='N', bit 4='#', bit 0=(precision==0), others unaffected
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = if not '0' must be included in decimal string
   ;
   ; exit : hl = length of output
   ;        de = 0

   ld a,(ix-5)
   and $e0                     ; 'N', '+', ' ' flags
   jr z, padding
   inc bc                      ; space for sign

padding:

   ld l,c
   ld h,b                      ; hl = workspace length

   ld d,0
   ld e,(ix-2)
   add hl,de                   ; add iz
   
   ld e,(ix-3)
   add hl,de                   ; add fz
   
   ld e,(ix-4)
   add hl,de                   ; add tz
   
   ld e,d
   ret


SECTION code_clib
SECTION code_stdlib

PUBLIC __dtoa_count

__dtoa_count:

   ;     bc = length of workspace
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer
   ;
   ; exit : hl = length of output
   ;        de = 0

   ld l,c
   ld h,b                      ; hl = workspace length

   ld a,(ix-6)
   and $e0                     ; 'N', '+', ' ' flags
   jr z, padding
   inc hl                      ; space for sign

padding:

   ld d,0
   ld e,(ix-5)
   add hl,de                   ; add iz
   
   ld e,(ix-4)
   add hl,de                   ; add fz
   
   ld e,(ix-3)
   add hl,de                   ; add tz
   
   ld e,d
   ret

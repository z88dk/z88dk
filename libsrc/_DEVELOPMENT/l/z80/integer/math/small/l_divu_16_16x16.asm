
XLIB l_divu_16_16x16
XDEF l0_divu_16_16x16

LIB error_divide_mc

l_divu_16_16x16:

   ; enter : hl = unsigned divisor
   ;         de = unsigned dividend
   ;
   ; exit  : hl = de/hl (quotient -- $ffff if divide by 0)
   ;         de = de%hl (remainder -- dividend if divide by 0)
   ;         on divide by zero, carry set and errno=EDOM
   ;
   ; uses  : af, bc, de, hl
   
   ld a,h
   or l
   jp z, error_divide_mc
   
   ex de,hl

l0_divu_16_16x16:              ; bypass divide by zero check

   ; enter : de = unsigned divisor
   ;         hl = unsigned dividend
   ;         (no divide by zero check!)
   ;
   ; exit  : hl = hl/de (quotient)
   ;         de = hl%de (remainder)
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl
   
   ld b,16
   
   ld a,h
   ld c,l
   
   ld hl,0
   
   ; ac = dividend
   ; de = divisor
   ; hl = 0 = quotient
   
   or a

div1:

   rl c
   rla
   adc hl,hl
   sbc hl,de
   jr nc, div2
   add hl,de

div2:

   ccf
   djnz div1
   
   rl c
   rla
   
   ld d,a
   ld e,c
   ex de,hl
   
   or a
   ret

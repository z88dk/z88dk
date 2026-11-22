
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC RIntersectIval16

; Returns the intersection of two 16-bit intervals.
; Since intervals can wrap across the 0-65535 boundary,
; the result of the intersection can be the empty
; interval (no intersection), a single interval or
; two intervals.  This routine will return one
; intersected interval.
;
; enter :  hl = interval 1 start coordinate
;          bc = interval 2 start coordinate
;          de = interval 2 width
;         de' = interval 1 width
;
; exit  : carry flag set = intersection detected and
;         bc = start coordinate, de = width of intersection
; uses  : af, bc, de, hl, hl', bc', de'

.RIntersectIval16

   push hl
   push bc
   
   or a
   sbc hl,bc
   or a
   sbc hl,de
   jr nc, checki2ini1
   
.i1ini2

   push hl
   exx
   pop bc
   xor a
   ld h,a
   ld l,a
   sbc hl,bc
   push hl
   or a
   sbc hl,de
   push de
   exx
   
   jr nc, w1smaller
   
   pop de
   pop de
   pop bc
   pop bc
   ret

.w1smaller

   pop de
   pop bc
   pop bc
   pop bc
   scf
   ret

.checki2ini1

   exx
   
   pop hl
   pop bc
   
   or a
   sbc hl,bc
   or a
   sbc hl,de
   jr nc, exit

   ex de,hl
   xor a
   ld h,a
   ld l,a
   sbc hl,de
   push hl
   exx
   
   pop hl
   push hl
   or a
   sbc hl,de
   jr nc, w2smaller
   
   pop de
   ret

.w2smaller

   scf
   ret

.exit

   exx
   ret

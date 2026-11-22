
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC RIsIvalInIval16

; Determine if two 16-bit intervals intersect.  Intervals
; can wrap across 0-65535 boundary.  Amazingly this test
; reduces to detecting whether either of the start points
; of each interval lie in the other interval.
;
; enter :  hl = interval 1 start coordinate
;          bc = interval 2 start coordinate
;          de = interval 2 width
;         de' = interval 1 width
;
; exit  : carry flag set = intersection detected
; uses  : f, hl, hl', bc'

.RIsIvalInIval16

   push hl
   push bc
   
   or a
   sbc hl,bc
   or a
   sbc hl,de
   jr c, cleanup
   
   exx
   
   pop hl
   pop bc
   
   or a
   sbc hl,bc
   or a
   sbc hl,de
   
   exx
   
   ret

.cleanup

   pop bc
   pop hl
   ret

; 04.2004 aralbrec

SECTION code_clib
PUBLIC BABlockCount
EXTERN _ba_qtbl

; Count the number of memory blocks available in a queue.
;
; enter: HL = queue number
; exit : BC = number of available blocks
; uses : F,BC,DE,HL

.BABlockCount
   add hl,hl
   ld bc,_ba_qtbl
   add hl,bc
   ld bc,0

.loop
   ld e,(hl)
   inc hl
   ld d,(hl)
   ld a,d
   or e
   ret z
   inc bc
   ex de,hl
   jp loop

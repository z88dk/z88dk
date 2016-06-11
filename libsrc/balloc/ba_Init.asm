; 04.2004 aralbrec

SECTION code_clib
PUBLIC ba_Init
PUBLIC _ba_Init
EXTERN _ba_qtbl

; Clears all memory queues to empty.
;
; enter: HL = number of queues
; uses : F,BC,DE,HL

.ba_Init
._ba_Init
   add hl,hl
   ld c,l
   ld b,h
   ld hl,_ba_qtbl
   ld de,_ba_qtbl+1
   ld (hl),0
   dec bc
   ldir
   ret

; 04.2004 aralbrec

SECTION code_clib
PUBLIC ba_Malloc
PUBLIC _ba_Malloc
EXTERN _ba_qtbl

; Returns block of memory from the indicated queue.
;
; enter: HL = queue number
; exit : HL = address of memory block (0 = fail)
;        Carry = success
; uses : AF,BC,DE,HL

.ba_Malloc
._ba_Malloc
   add hl,hl
   ld de,_ba_qtbl
   add hl,de
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl
   ld a,h
   or l
   ret z
   inc hl
   ldd
   ld a,(hl)
   ld (de),a
   scf
   ret

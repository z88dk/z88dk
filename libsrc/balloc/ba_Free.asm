; 04.2004 aralbrec

SECTION code_clib
PUBLIC ba_Free
PUBLIC _ba_Free
EXTERN _ba_qtbl

; Frees block of memory back to queues for reuse.
;
; enter: HL = address of block as returned by ba_malloc or ba_bestfit
; uses : AF,BC,DE,HL

.ba_Free
._ba_Free
   ld a,h
   or l
   ret z

   dec hl
   ld e,(hl)      ; E = queue number
   inc hl
   ex de,hl       ; DE = block address
   ld h,0         ; HL = queue number
   add hl,hl
   ld bc,_ba_qtbl
   add hl,bc      ; HL = index into queue table

   ld c,(hl)
   inc hl
   ld b,(hl)
   ld (hl),d
   dec hl
   ld (hl),e
   ex de,hl
   ld (hl),c
   inc hl
   ld (hl),b
   ret

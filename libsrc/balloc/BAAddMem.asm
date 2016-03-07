; 04.2004 aralbrec

SECTION code_clib
PUBLIC BAAddMem
EXTERN ba_Free

; Adds memory blocks to a queue
;
; enter:  B = number of blocks (>=1)
;         C = queue number
;        HL = address of free memory to create blocks from
;        DE = block size in bytes (>=2)
; exit : HL = address of next free byte of memory
; uses : AF,B,HL

.BAAddMem

   inc de              ; make space in free blocks for queue identifier

.loop

   ld (hl),c           ; store identifier into free block
   push bc
   push de
   push hl
   inc hl
   call ba_Free        ; freeing block adds it to queue
   pop hl
   pop de
   pop bc

   add hl,de
   djnz loop

   ret

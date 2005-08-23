; 04.2004 aralbrec

XLIB BAAddMem
XREF _ba_qtbl

; Adds memory blocks to a queue
;
; enter: BC = block size in bytes (>=2)
;        DE = address of free memory to create blocks from
;        HL = queue number
;        IXL= number of blocks (>=1)
; exit : DE = address of next free byte of memory
; uses : AF,BC,DE,HL,IXL

.BAAddMem
   inc bc
   push bc             ; stack = block size (+1)
   ld a,l              ;  A = queue number
   add hl,hl
   ld bc,_ba_qtbl
   add hl,bc           ; HL = index into queue table

   ;   A = queue number
   ;  DE = current block address
   ;  HL = index into queue table
   ; IXL = number of blocks (>1)
   ; stack = block size (+1)

   inc de              ; DE = current block + 1
   ld c,(hl)
   ld (hl),e
   inc hl
   ld b,(hl)           ; BC = first already existing free block in queue
   ld (hl),d
   pop hl
   push bc             ; stack = first existing free block
   ld c,l
   ld b,h              ; BC = block size (+1)

.loop
   ld l,c
   ld h,b              ; HL = block size (+1)
   add hl,de
   dec de
   ex de,hl

   ;   A = queue number
   ;  BC = block size (+1)
   ;  DE = next block address + 1
   ;  HL = current block address
   ; IXL = number of blocks (>=1)
   ; stack = first existing free block

   ld (hl),a           ; store queue num
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d           ; store next block ptr
   dec ixl
   jp nz, loop

   pop bc              ; BC = first existing free block
   ld (hl),b
   dec hl
   ld (hl),c
   dec de              ; DE = next free address in memory
   ret

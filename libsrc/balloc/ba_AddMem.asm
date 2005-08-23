; 05.2005 aralbrec

XLIB ba_AddMem
LIB BAAddMem

.ba_AddMem
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld a,(hl)
   ld ixl,a
   inc hl
   inc hl
   ld l,(hl)
   ld h,0
   call BAAddMem
   ex de,hl
   ret

; enter: BC = block size in bytes (>=2)
;        DE = address of free memory to create blocks from
;        HL = queue number
;        IXL= number of blocks (>=1)
; exit : DE = address of next free byte of memory
; uses : AF,BC,DE,HL,IXL

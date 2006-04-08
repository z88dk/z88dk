; 05.2005 aralbrec

XLIB ba_AddMem
LIB BAAddMem

.ba_AddMem
   ld hl,8
   add hl,sp
   ld c,(hl)
   dec hl
   dec hl
   ld b,(hl)
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   jp BAAddMem

; enter:  B = number of blocks (>=1)
;         C = queue number
;        HL = address of free memory to create blocks from
;        DE = block size in bytes (>=2)
; exit : HL = address of next free byte of memory
; uses : AF,B,HL

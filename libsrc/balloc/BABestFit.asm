; 04.2004 aralbrec

SECTION code_clib
PUBLIC BABestFit
EXTERN _ba_qtbl

; If the queues are arranged such that queue i contains memory blocks
; that are smaller than in queue j, with i<j, then this routine attempts
; to satisfy the memory request by allocating from pool HL, then pool HL+1,
; etc. up to pool HL+B-1, ensuring that the memory block returned will
; be at least as large as the block requested.
;
; enter: HL = starting queue number
;         B = number of queues to check
; exit : HL = address of memory block (0 = fail)
;        Carry = success
; uses : AF,BC,DE,HL

.BABestFit
   add hl,hl
   ld de,_ba_qtbl - 1
   add hl,de     ; HL = first index into table - 1

.loop
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ld a,d
   or e
   jr nz, found
   djnz loop
   ex de,hl
   ret

.found
   ex de,hl      ; HL = block, DE = index + 1
   inc hl
   ldd
   ld a,(hl)
   ld (de),a
   scf
   ret

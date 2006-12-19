; HeapRealloc
; 12.2006 aralbrec

XLIB MAHeapRealloc
LIB MAHeapAlloc, MAHeapFree

; Grab a new memory block from the heap specified,
; replacing the one passed in and possibly of different
; size.  Copy as much of the old block possible to
; the new memory block.  If reallocation is not
; possible a block the same size as the old block is
; returned.
;
; enter : hl = old block address (+2)
;         de = & heap pointer
;         bc = new block size request
; exit  : hl = address of memory block and carry set if successful
;              else address of block of same size as before and no carry
; used  : af, bc, de, hl

; strategy is to first free the old block then request
; a new one of given size, followed by a copy from old
; to new.  clearly this is not multithread safe.

.MAHeapRealloc

   ld a,h
   or l
   ret z

   push hl                   ; save old block address + 2 (data portion)
   push bc                   ; save new size request
   
   dec hl
   ld b,(hl)
   dec hl
   ld c,(hl)
   push bc                   ; save old block's size just in case
   inc hl
   inc hl
   
   push de                   ; save & heap pointer
   call MAHeapFree
   pop hl                    ; hl = & heap pointer
   pop de
   pop bc                    ; bc = new size request
   push de
   push bc
   push hl                   ; stack = old block addr, old block size, new size req, & heap pointer

   call MAHeapAlloc
   jr nc, blockfail          ; failed to get new block
   
.gotblock

   ; hl = new block address
   ; stack = old block addr, old block size, new size req, & heap pointer
   
   pop de                    ; junk heap pointer
   pop bc                    ; bc = new size
   pop de                    ; de = old size
   ex de,hl
   or a
   sbc hl,bc                 ; old size - new size
   jr nc, usenewsize
   add hl,bc
   ld c,l
   ld b,h                    ; use old size
   
.usenewsize

   ; bc = number of bytes to copy
   ; de = new block address
   ; stack = old block address
   
   pop hl
   push de                   ; save new block address
   ldir                      ; copy old block to new block
   pop hl                    ; hl = new block address
   scf
   ret

.blockfail

   ; stack = old block addr, old block size, new size req, & heap pointer

   pop hl                    ; hl = heap pointer
   pop bc
   pop bc                    ; bc = old block size
   push bc
   call MAHeapAlloc          ; must succeed since we just put in a memory block this size
   pop bc
   pop de
   ex de,hl                  ; hl = old block address + 2 (data portion), de = new block, bc = old block size
   push de
   ldir                      ; copy old block to new block
   pop hl
   or a
   ret

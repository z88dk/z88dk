
SECTION code_clib
PUBLIC MAHeapInfo

.MAHeapInfo

; Return total amount of available memory in bytes
; and largest single block in indicated heap.
;
; enter : hl = & heap pointer
; exit  : bc = largest single block size in bytes
;         de = total available bytes in heap
; uses  : af, bc, de, hl

   ld de,0                   ; de = total available bytes in heap
   ld bc,0                   ; bc = largest single block available
   
   inc hl
   inc hl
   
.loop

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                    ; hl = & block
   
   or h
   ret z                     ; if no more blocks, all done
   
   ld a,(hl)
   inc hl
   push hl                   ; save & block->size + 1b
   ld h,(hl)
   ld l,a                    ; hl = block size
   
   sbc hl,bc
   add hl,bc
   jr c, notbigger
   ld c,l
   ld b,h                    ; bc = new largest block size
   
.notbigger

   add hl,de
   ex de,hl                  ; de = add this block size into total bytes available
   
   pop hl
   inc hl
   jp loop

; void adt_HeapSiftUp(uint start, void **array, void *compare)
; 03.2003, 08.2005 aralbrec

SECTION code_clib
PUBLIC ADTHeapSiftUp
EXTERN l_jpix

; enter:  DE = start index * 2 (offset into array in bytes)
;         HL = &array[start] = bc + de
;         BC = array address
;         IX = compare(DE=&array[child], HL=&array[parent])
;              set carry if child < parent (min heap) -- MUST PRESERVE BC,DE,HL,IX
; uses :  AF,DE,HL,AF'

.ADTHeapSiftUp
   ld a,e
   and $fc
   or d
   ret z                  ; if start <= 2 we have reached root so return

   srl d
   rr e
   res 0,e
   push de                ; stack = parent(child=start) index
   ex de,hl               ; de = &array[child=start]
   add hl,bc              ; hl = &array[parent]

   call l_jpix            ; compare(child, parent)
   jr nc, done            ; if child >= parent, we are done

   ld a,(de)              ; swap(child, parent)
   ex af,af
   ld a,(hl)
   ld (de),a
   ex af,af
   ld (hl),a
   inc hl
   inc de
   ld a,(de)
   ex af,af
   ld a,(hl)
   ld (de),a
   ex af,af
   ld (hl),a

   dec hl                 ; hl = &array[parent]
   pop de                 ; de = parent index
   jp ADTHeapSiftUp       ; parent becomes child

.done
   pop de
   ret

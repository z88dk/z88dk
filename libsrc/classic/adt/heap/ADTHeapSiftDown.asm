; void adt_HeapSiftDown(uint start, void **array, uint n, void *compare)
; 03.2003, 08.2005 aralbrec

SECTION code_clib
PUBLIC ADTHeapSiftDown
EXTERN l_jpix

; enter:  DE = start index * 2 (offset into array in bytes)
;         BC = array address
;         IX = compare (de) < (hl)? set carry if true  MUST PRESERVE BC,DE,HL,IX
;         HL = N * 2 (number of items in array * 2)
; uses :  AF,DE,HL,AF'


.ADTHeapSiftDown
   push hl                     ; stack = N * 2
   ld l,e
   ld h,d
   add hl,hl
   ex de,hl                    ; de = child index * 2
   add hl,bc
   ex (sp),hl                  ; hl = N * 2, stack = &array[parent]

; de = child index * 2
; hl = N * 2
; bc = array address
; stack = &array[parent]

.while
   ld a,d                      ; if child < N not done yet
   cp h
   jr c, cont
   jr nz, done
   ld a,e
   cp l 
   jr nc, done

.cont
   ex (sp),hl
   push hl
   push de                     ; stack = N * 2, &array[parent], child index * 2

   ex de,hl
   add hl,bc
   ld e,l
   ld d,h                      ; de = &array[child]
   inc hl
   inc hl                      ; hl = &array[child+1]
   call l_jpix                 ; is child < child+1? (de) < (hl)?
   pop hl
   jr c, skip                  ; branch if child smaller
   inc hl
   inc hl                      ; hl = child+1 index * 2
   inc de
   inc de                      ; de = &array[child+1]

.skip                          ; hl = child index * 2; de = &array[child]; stack = N * 2, &array[parent]
   ex (sp),hl                  ; hl = &array[parent]; stack = N * 2, child index * 2
   call l_jpix                 ; is child < parent? (de) < (hl)
   jr nc, done2                ; if parent smaller it's in right place so done

   ld a,(de)                   ; swap(child, parent)
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

   pop hl
   add hl,hl                   ; hl = new child index * 2
   dec de                      ; de = &array[new parent which was old child]
   ex de,hl                    ; hl = &array[parent], de = child index * 2
   ex (sp),hl                  ; hl = N * 2, stack = &array[parent]
   jp while

.done                          ; one last item to worry about
   sbc hl,de                   ; carry reset at this point
   jr nz, reallydone           ; if child != N we are really done, otherwise one more compare to do

   ex de,hl
   add hl,bc                   ; hl = &array[child]
   pop de                      ; de = &array[parent]
   ex de,hl                    ; hl = &array[parent], de = &array[child]
   call l_jpix                 ; is child < parent? (de) < (hl)?
   ret nc                      ; if no, things are as they should be

   ld a,(de)                   ; swap(child, parent)
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
   ret

.done2
   pop af
.reallydone
   pop af
   ret

; void *adt_HeapExtract(void **array, uint n, void *compare)
; 08.2005 aralbrec

SECTION code_clib
PUBLIC ADTHeapExtract
EXTERN ADTHeapSiftDown

; enter:  DE = array address
;         HL = N (number of items in array, set to one less after calling)
;         IX = compare (de) < (hl)? set carry if true  MUST PRESERVE BC,DE,HL,IX
; exit :  no carry = empty heap, else: HL = extracted item and carry set
; uses :  AF,BC,DE,HL,AF'

.ADTHeapExtract
   ld a,h
   or l
   ret z                        ; return if no items in heap
   add hl,hl

   push hl                      ; stack = N * 2
   inc de
   add hl,de                    ; hl = &array[N] + 1b
   inc de
   ld c,e
   ld b,d
   inc de                       ; de = &array[1] + 1b

   ld a,(de)
   ex af,af
   ldd                          ; copy array[N] to front of array
   ld a,(de)
   ldd                          ; bc = array address

   ex de,hl
   inc de                       ; de = &array[N]
   ld (de),a                    ; write extracted item to end of array
   ld l,a                       ; copying extracted item to end of
   ex af,af                     ;   array gives a heapsort for free
   inc de                       ;   (well almost, we do pay 30 extra cycles for it)
   ld (de),a
   ld h,a
   ex (sp),hl                   ; hl = N * 2, stack = extracted item

   dec hl
   dec hl                       ; hl = (N-1)*2 one less item in heap now
   ld a,l
   and $fc
   or h
   jr z, done                   ; if one item or less left, don't bother sifting
   ld de,2                      ; de = top of heap -- sift item copied down the heap
   call ADTHeapSiftDown
.done
   pop hl                       ; hl = extracted item
   scf                          ; indicate item was extracted
   ret

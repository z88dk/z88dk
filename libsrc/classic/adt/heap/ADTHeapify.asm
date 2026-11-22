; void adt_Heapify(void **array, uint n, void *compare)
; 08.2005 aralbrec

SECTION code_clib
PUBLIC ADTHeapify
EXTERN ADTHeapSiftDown

; enter:  BC = array address
;         IX = compare (de) < (hl)? set carry if true  MUST PRESERVE BC,DE,HL,IX
;         HL = N (number of items in array)

.ADTHeapify
   ld a,l
   and $fe
   or h
   ret z                ; return if one or less items in array

   ld e,l
   ld d,h
   add hl,hl            ; hl = N * 2
   res 0,e              ; de = parent of last item in array (index * 2)

.while
   ld a,d
   or e
   ret z

   push de
   push hl
   call ADTHeapSiftDown
   pop hl
   pop de

   dec de
   dec de
   jp while

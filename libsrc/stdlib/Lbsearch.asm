; 05.2005 aralbrec
; binary search

PUBLIC Lbsearch
EXTERN l_jpix

; The ansi-C bsearch function searches an array of n-byte items.
; This is a 'little' version that searches arrays of 2-byte items.
; Those 2-byte items can be integers or pointers to objects.  The
; reason for the 'little' version is that a full ansi implementation
; would require either one multiply or one div operation for each
; array slice -- these are things that would be very time consuming
; on a z80 and hence not worthwhile implementing.  I have only ever
; used bsearch on arrays of pointers to objects and this z80 version
; will do that just fine.

; enter: bc = key
;        de = base address of array
;        hl = size of array
;        ix = cmp function (BC=key, HL=datum ; result in A (see ".compare"),
;                           MUST PRESERVE BC,DE,HL,IX registers)
; exit : hl = address of found item
;        carry set indicates item not found with HL=0
; uses : af, de, hl
;
; Call Lbsearch + 3 if you prefer to enter with hl = last item in array

.Lbsearch

   dec hl
   add hl,hl
   add hl,de        ; HL = right side

.loop               ; DE = left, HL = right
   ld a,d           ; is left <= right or are we done?
   cp h
   jr c, slice
   jr nz, done
   ld a,e
   cp l
   jr nc, done

.slice
   push hl          ; stack right side
   add hl,de        ; HL = left + right
   rr h
   rr l             ; HL = unrounded address of middle item

   ld a,l           ; shenanigans to ensure HL aligns on item
   xor e
   rra
   jr nc, compare
   dec hl

.compare            ; is key < datum?
   call l_jpix      ; returns A<0 for less, A==0 for equals, A>0 for greater
   or a
   jr z, caseEqual
   jp m, caseLess
.caseGreater
   pop de
   inc hl
   inc hl
   ex de,hl         ; middle becomes left, right is still right
   jp loop
.caseLess
   pop af           ; throw away stacked right side
   dec hl
   dec hl
   jp loop          ; middle becomes right, left is still left

.caseEqual
   pop de           ; clear stack
   ret              ; HL = address of found item

.done               ; failed to find
   scf
   ld hl,0
   ret

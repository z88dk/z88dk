; 05.2005 aralbrec
; binary search

SECTION code_clib
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

.Lbsearch
.loop
   ld a,h       ; Number of items still to check is 0? if so, return not found
   or l
   jr nz, slice
   scf
   ret

.slice
   push hl      ; Get the address at the halfway index + the base address
   ld a, $fe
   and l
   ld l,a
   add hl,de

.compare            ; is key < datum?
   call l_jpix      ; returns A<0 for less, A==0 for equals, A>0 for greater
   or a
   jr z, caseEqual
   jp m, caseLess
.caseGreater
   inc hl
   inc hl
   ex de,hl         ; update the base address to point to the upper half of the array
   pop hl
   dec hl
   sra h
   rr l
   jp loop
.caseLess
   pop hl
   sra h
   rr l
   jp loop

.caseEqual
   pop de           ; clear stack
   ret              ; HL = address of found item

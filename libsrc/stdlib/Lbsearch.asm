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
   cp 1
   ret c  ; return when HL == 0 with CF == 1

.slice
   push hl      ; Get the address at the halfway index + the base address

IF __CPU_INTEL__ || __CPU_GBZ80__
   ld a,$fe
   and l
   ld l,a
ELSE
   res 0,l      ; Integer division of hl by 2 (to get the midpoint item index) then multiply it 2 because each pointer is 2 bytes.
ENDIF

   add hl,de

.compare            ; is key < datum?

   call l_jpix      ; returns A<0 for less, A==0 for equals, A>0 for greater

   add a,$80
   cp $80
   jp c,caseLess
   jp z,caseEqual
.caseGreater
   inc hl
   inc hl
   ex de,hl         ; update the base address to point to the upper half of the array
   pop hl
   dec hl

IF __CPU_INTEL__ || __CPU_GBZ80__
   push af
   xor a
   ld a,h
   rra
   ld h,a
   ld a,l
   rra
   ld l,a
   pop af
ELSE
   sra h
   rr l
ENDIF

   jp loop
.caseLess
   pop hl

IF __CPU_INTEL__ || __CPU_GBZ80__
   push af
   xor a
   ld a,h
   rra
   ld h,a
   ld a,l
   rra
   ld l,a
   pop af
ELSE
   sra h
   rr l
ENDIF

   jp loop

.caseEqual
   pop de           ; clear stack
   ret              ; HL = address of found item

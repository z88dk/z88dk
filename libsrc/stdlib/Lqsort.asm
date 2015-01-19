; 05.2005 aralbrec
; iterative qsort, partition element taken from middle

PUBLIC Lqsort
EXTERN l_jpix

; The ansi-C qsort function sorts an array of n-byte items.
; This is a 'little' version that sorts arrays of 2-byte items.
; Those 2-byte items can be integers or pointers to objects.  The
; reason for the 'little' version is that a full ansi implementation
; would require either one multiply or one div operation for each
; array slice -- these are things that would be very time consuming
; on a z80 and hence not worthwhile implementing.  I have only ever
; used qsort on arrays of pointers to objects and this z80 version
; will do that just fine.

; enter: bc = base address of array
;        hl = size of array
;        ix = cmp function (DE=key, BC=datum ; result in A (see ".compare"),
;                           MUST PRESERVE BC,DE,HL,IX registers)
; uses : AF,BC,DE,HL,AF'
;
; If you prefer to enter with hl = last item in array, call Lqsort+3

.Lqsort

   dec hl
   add hl,hl
   add hl,bc
                          ; bc = left, hl = right
   ld de,0
   push de                ; mark end of qsort -- empty stack
   jp qsort2

.qsort1                   ; check stack for pending qsorts
   pop bc                 ; bc = left
   ld a,b
   or c
   ret z                  ; if 0, done
   pop hl                 ; hl = right

.qsort2                   ; qsort(bc=left,hl=right)
   ld a,b                 ; left < right?  bc < hl?
   cp h
   jr c, swap3
   jr nz, qsort1
   ld a,c
   cp l
   jr nc, qsort1
                          ; picking middle item as partition element
.swap3                    ; swap(left,(left+right)/2)
   ld e,l
   ld d,h                 ; de = right

   add hl,bc
   rr h
   rr l                   ; hl = unrounded (left+right)/2

   ld a,l                 ; shenanigans to ensure HL aligns on item
   xor c
   rra
   jr nc, doswap
   dec hl

.doswap                   ; move partition element to start of array
   ld a,(bc)
   ex af,af
   ld a,(hl)
   ld (bc),a
   ex af,af
   ld (hl),a
   inc hl
   inc bc                 ; bc = left+1b, de=right

   ld a,(bc)
   ex af,af
   ld a,(hl)
   ld (bc),a
   ex af,af
   ld (hl),a

   inc bc
   push bc                ; stack = left+1 = last+1
   ld l,c
   ld h,b
   ex de,hl               ; de = left+1, hl = right
   dec bc
   dec bc                 ; bc = left
   jp ent

; de = i, bc = left, hl = right, stack = last+1

.partition
   inc de                 ; i++
   inc de

.ent
   ld a,h                 ; i <= right?  de <= hl ?
   cp d
   jr c, endlp
   jr nz, compare
   ld a,l
   cp e
   jr c, endlp

.compare                  ; is v[i] < v[left]?  (de) < (bc) ?
   call l_jpix            ; returns A<0 for less, A==0 for equals, A>0 for greater
   or a
   jp p, partition

.swap1                    ; swap(i,++last)
   ex (sp),hl             ; hl = ++last, stack = right

   ld a,(de)
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
   inc hl
   inc de

   ex (sp),hl            ; hl = right, stack = last+1, de=i++
   jp ent

.endlp                   ; bc = left, hl = right, stack = last+1
   ex (sp),hl            ; hl = last+1
   push hl               ; qsort(l=last+1,r=right)  <==>  stack = right,last+1

.swap2                   ; swap(left,last)
   inc bc                ; bc = left+1b
   dec hl                ; hl = last+1b

   ld a,(bc)
   ex af,af
   ld a,(hl)
   ld (bc),a
   ex af,af
   ld (hl),a
   dec hl                ; hl = last
   dec bc                ; bc = left

   ld a,(bc)
   ex af,af
   ld a,(hl)
   ld (bc),a
   ex af,af
   ld (hl),a

   dec hl
   dec hl                ; hl = last-1

   jp qsort2             ; qsort(l=bc=left,r=hl=last-1)

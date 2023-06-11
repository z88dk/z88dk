; 05.2005 aralbrec
; iterative qsort, partition element taken from middle

SECTION code_clib
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
; uses : AF,BC,DE,HL
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
   jp c, swap3
   jp nz, qsort1
   ld a,c
   cp l
   jp nc, qsort1
                          ; picking middle item as partition element
.swap3                    ; swap(left,(left+right)/2)
   ld e,l
   ld d,h                 ; de = right

   add hl,bc

IF __CPU_GBZ80__ || __CPU_INTEL__
   ld a,h
   rra
   ld h,a
   ld a,l
   rra
   ld l,a                 ; hl = unrounded (left+right)/2
ELSE
   rr h
   rr l                   ; hl = unrounded (left+right)/2
   ld a,l                 ; shenanigans to ensure HL aligns on item
ENDIF

   xor c
   rra
   jp nc, doswap
   dec hl

.doswap                   ; move partition element to start of array
   push de
   ld a,(bc)

   ; ex af,af
   ld d,a

   ld a,(hl)
   ld (bc),a

   ; ex af,af
   ld e,a
   ld a,d

   ld (hl),a
   inc hl
   inc bc                 ; bc = left+1b, de=right

   ld a,(bc)

   ;ex af,af
   ld d,a
   ld a,e

   ld a,(hl)
   ld (bc),a

   ;ex af,af
   ld a,d

   ld (hl),a
   pop de

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
   jp c, endlp
   jp nz, compare
   ld a,l
   cp e
   jp c, endlp

.compare           ; is v[i] < v[left]?  (de) < (bc) ?
   call l_jpix            ; returns A<0 for less, A==0 for equals, A>0 for greater

   add a,$80
   cp $80
   jp c,swap1
   jp partition

.swap1                    ; swap(i,++last)
   ex (sp),hl             ; hl = ++last, stack = right

   push bc
   ld a,(de)

   ; ex af,af
   ld b,a

   ld a,(hl)
   ld (de),a

   ; ex af,af
   ld c,a
   ld a,b

   ld (hl),a
   inc hl
   inc de

   ld a,(de)

   ; ex af,af
   ld b,a
   ld a,c

   ld a,(hl)
   ld (de),a

   ; ex af,af
   ld a,b

   ld (hl),a
   pop bc

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

   push de
   ld a,(bc)

   ; ex af,af
   ld d,a

   ld a,(hl)
   ld (bc),a

   ; ex af,af
   ld e,a
   ld a,d

   ld (hl),a
   dec hl                ; hl = last
   dec bc                ; bc = left

   ld a,(bc)

   ; ex af,af
   ld d,a
   ld a,e

   ld a,(hl)
   ld (bc),a

   ; ex af,af
   ld a,d

   ld (hl),a
   pop de

   dec hl
   dec hl                ; hl = last-1

   jp qsort2             ; qsort(l=bc=left,r=hl=last-1)



; ===============================================================
; Jan 2014
; ===============================================================
; 
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))
;
; Sort the array using the comparison function supplied.
;
; Notes:
;
; The pivot is always selected as first item in each partition
; and this leads to worst case for sorted (and nearly sorted)
; arrays.  The code is constructed such that no swaps occur
; and no recursion occurs in this case but there will still be
; O(n^2) comparisons
;
; When each partition is divided in two, the smallest partition
; is pursued iteratively and the larger is always stacked.  This
; results in the lowest upper bound on stack usage at O(lg n).
; Four bytes per recursive iteration is reserved on the stack.
;
; The biggest improvement that can be made is to resort to
; insertion sort for few items, followed by selecting a pivot
; from a widespread sample of three or more pivot options.
;
; ===============================================================

PUBLIC asm_qsort

EXTERN l_mulu_16_16x16, asm0_memswap, l_jpix
EXTERN error_einval_zc, error_erange_zc

asm_qsort:

   ; enter : ix = int (*compar)(de=const void *, hl=const void *)
   ;         bc = void *base
   ;         hl = size_t nmemb
   ;         de = size_t size
   ;
   ; exit  : none
   ;
   ;         if an error below occurs, no sorting is done.
   ;
   ;         einval if size == 0
   ;         einval if array size > 64k
   ;         erange if array wraps 64k boundary
   ;
   ; uses  : af, bc, de, hl, compare function

   ld a,d
   or e
   jp z, error_einval_zc       ; if size == 0

   ld a,h
   or l
   ret z                       ; if no items
   dec hl
   
   push de                     ; save size
   push bc                     ; save base
   
   call l_mulu_16_16x16        ; hl = hl * de = (nmemb - 1) * size
   
   pop de                      ; de = lo (base)
   jp c, error_erange_zc - 1   ; if multiply overflowed
   
   add hl,de                   ; hl = hi (address of last item)
   pop bc                      ; bc = size
   
   jp c, error_erange_zc       ; if address out of range
   
   push hl
   ld hl,0                     ; mark end of stack with 0
   ex (sp),hl
   
while_lohi:

   ; partition to sort is interval [lo, hi]
   
   ; hl = hi
   ; de = lo
   ; bc = size
   ; ix = compare
   ; stack = 0, (hi,lo)*
   ; carry reset
   
   scf
   sbc hl,de
   jr nc, partition            ; if hi > lo

interval_done:

   ; retrieve next partition from stack
   
   ; bc = size
   ; ix = compare
   ; stack = 0, (hi,lo)*
   
   pop de
   
   ld a,d                      ; zero is end marker
   or e
   ret z

   pop hl
   jr while_lohi

partition:

   add hl,de
   inc hl

   ; first element (at lo) is taken as pivot to avoid multiplication
   
   push hl                     ; save hi
   push de                     ; save lo=pivot

left_squeeze_0:

   ex de,hl
   add hl,bc
   ex de,hl

   ; de = i
   ; hl = j
   ; bc = size
   ; ix = compare
   ; stack = hi, lo=pivot

   ; rearrange items so that all items less than the pivot are on
   ; the left and those greater than the pivot are on the right
   
   ; portion of partition still being investigated is [i,j]
   ; all items before i are <= pivot and all items after j are >= pivot

left_squeeze_1:

   ; de = i
   ; hl = j
   ; bc = size
   ; ix = compare
   ; stack = hi, lo=pivot
   ; carry reset
   
   sbc hl,de
   add hl,de
   jr c, partition_done_left   ; if i > j

   ; i <= j

   ex (sp),hl                  ; push j
   push hl                     ; push lo=pivot
   push bc                     ; push size
   push de                     ; push i
   push ix                     ; push compare

;******************************
IF __SDCC | __SDCC_IX | __SDCC_IY
;******************************

   push de
   push hl
   ex de,hl
   call l_jpix                 ; compare(de=lo=pivot, hl=i)
   ld a,h                      ; get result
   pop hl
   pop de

;******************************
ELSE
;******************************

   push hl
   push de
   ex de,hl
   call l_jpix                 ; compare(de=lo=pivot, hl=i)
   ld a,h                      ; get result
   pop de
   pop hl

;******************************
ENDIF
;******************************
   
   pop ix                      ; ix = compare
   pop de                      ; de = i
   pop bc                      ; bc = size
   pop hl
   ex (sp),hl                  ; hl = j,, stack = hi, lo=pivot

   rla
   jr nc, left_squeeze_0       ; if item[lo=pivot] >= item[i] continue

   or a
   ex de,hl
   
right_squeeze:

   ; de = j
   ; hl = i
   ; bc = size
   ; ix = compare
   ; carry reset
   ; stack = hi, lo=pivot

   sbc hl,de
   jr z, partition_done_right  ; if i == j
   add hl,de

   ; i < j

   ; de = j
   ; hl = i
   ; bc = size
   ; ix = compare
   ; stack = hi, lo=pivot
   
   ex (sp),hl                  ; push i
   push hl                     ; push lo=pivot
   push bc                     ; push size
   push de                     ; push j
   push ix                     ; push compare

;******************************
IF __SDCC | __SDCC_IX | __SDCC_IY
;******************************

   push hl
   push de
   call l_jpix                 ; compare(de=j, hl=lo=pivot)
   ld a,h                      ; get result
   pop de
   pop hl

;******************************
ELSE
;******************************

   push de
   push hl
   call l_jpix                 ; compare(de=j, hl=lo=pivot)
   ld a,h                      ; get result
   pop hl
   pop de

;******************************
ENDIF
;******************************

   pop ix                      ; ix = compare
   pop de                      ; de = j
   pop bc                      ; bc = size
   pop hl
   ex (sp),hl                  ; hl = i,, stack = hi, lo=pivot
   
   rla
   jr c, swap_ij               ; if item[j] < item[lo=pivot] stop
   
   ex de,hl
   sbc hl,bc                   ; j -= size
   ex de,hl

   jr right_squeeze

swap_ij:

   ; item[j] < item[pivot]
   ; item[i] > item[pivot]

   ; need to swap and then continue squeeze

   ; de = j
   ; hl = i
   ; bc = size
   ; ix = compare
   ; stack = hi, lo=pivot

   push de
   push bc
   call asm0_memswap           ; swap(i, j, size)
   pop bc
   
   add hl,bc                   ; i += size
   ex de,hl                    ; de = i
   pop hl
   sbc hl,bc                   ; j -= size
   
   jr left_squeeze_1

partition_done_right:

   ex de,hl
   
   ; hl = i
   ; bc = size
   ; ix = compare
   ; carry reset
   ; stack = hi, lo=pivot

   ; i == j
   ; item[i] > item[pivot]

   ; move pivot item into index (i-1)
   
   sbc hl,bc                   ; hl = "j" = i-1

partition_done_left:

   ; hl = j
   ; bc = size
   ; ix = compare
   ; stack = hi, lo=pivot

   ; i > j
   ; item[j] <= item[pivot]

   ; move pivot item into index j

partition_done:

   ; move pivot item to final position in index j
   ; create two new partitions to sort on left and right side of pivot
   
   ; hl = j = final position
   ; bc = size
   ; ix = compare
   ; stack = hi, lo=pivot

   or a
   pop de                      ; de = lo=pivot
   
   sbc hl,de
   jr z, left_partition_empty  ; if lo=pivot == j
   add hl,de

   ; swap pivot into final position
   
   ; hl = j
   ; de = lo=pivot
   ; bc = size
   ; stack = hi
   
   push bc
   push de

   call asm0_memswap           ; swap(j, lo=pivot, size)

   pop de
   ld c,l
   ld b,h
   pop hl
   ex (sp),hl
   push hl

   ; hl = hi
   ; bc = j=pivot
   ; de = lo
   ; ix = compare
   ; stack = size, hi
   
   ; lowest bound on stack usage is obtained if the
   ; smallest partition is pursued and the largest
   ; is stacked for later
   
   add hl,de
   rr h
   rr l                        ; hl = (hi+lo)/2

   or a
   sbc hl,bc                   ; carry set if (hi+lo) < j=pivot

   pop hl
   ex (sp),hl
   push de
   
   ld e,c
   ld d,b
   ld c,l
   ld b,h
   ld l,e
   ld h,d

   ; hl = j=pivot
   ; de = j=pivot
   ; bc = size
   ; ix = compare
   ; stack = hi, lo

   jr c, right_smallest        ; if pivot > middle

left_smallest:
   
   ; hl = j=pivot
   ; de = j=pivot
   ; bc = size
   ; ix = compare
   ; stack = hi, lo
   
   add hl,bc                   ; hl = j + size
   ex (sp),hl
   ex de,hl
   
   sbc hl,bc                   ; hl = j - size
   
   ; hl = j - size (new hi)
   ; de = lo (new lo)
   ; bc = size
   ; stack = (hi, j+size) = stacked right side (hi, lo)
   
   jp while_lohi               ; do left side

right_smallest:

   ; hl = j=pivot
   ; de = j=pivot
   ; bc = size
   ; ix = compare
   ; stack = hi, lo

   add hl,bc
   ex de,hl                    ; de = j + size
   sbc hl,bc                   ; hl = j - size
   
   pop af
   ex (sp),hl
   push af
   
   ; hl = hi (new hi)
   ; de = j + size (new lo)
   ; bc = size
   ; ix = compare
   ; stack = (j - size, lo) = stack left side (hi, lo)

   jp while_lohi               ; do right side

left_partition_empty:

   ; left side of partition is empty so only right side remains
   
   ex de,hl
   
   ; hl = lo=pivot
   ; bc = size
   ; ix = compare
   ; stack = hi
   
   pop de
   add hl,bc
   ex de,hl
   
   jp while_lohi

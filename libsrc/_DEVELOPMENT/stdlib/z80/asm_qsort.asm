
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

XLIB asm_qsort

LIB l_mulu_16_16x16, asm0_memswap, l_jpix, error_einval_zc, error_erange_zc
LIB l_ltu_de_hl, l_ltu_hl_de, l_ltu_bc_hl

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
   jp c, error_einval_zc - 1   ; if multiply overflowed
   
   add hl,de                   ; hl = hi (address of last item)
   pop bc                      ; bc = size
   
   jp c, error_erange_zc       ; if address out of range
   
   push hl
   ld hl,0                     ; mark end of stack with 0
   ex (sp),hl
   
while_lohi:

   ; partition to sort is interval [lo, hi]
   ; first element (at lo) is taken as pivot to avoid multiplication
   
   ; hl = hi
   ; de = lo
   ; bc = size
   ; ix = compare
   ; stack = 0, (hi,lo)*
   
   call l_ltu_de_hl            ; carry set if lo < hi
   jp nc, interval_done
   
   push hl                     ; save hi
   push de                     ; save lo

partition:

   ex de,hl
   add hl,bc
   ex de,hl

   ; rearrange items so that all items less than the pivot are on
   ; the left and those greater than the pivot are on the right
   
   ; portion of partition still being investigated is [i,j]
   ; all items before i are <= pivot and all items after j are >= pivot

left_squeeze:

   ; de = i
   ; hl = j
   ; bc = size
   ; ix = compare
   ; stack = hi, lo

   call l_ltu_de_hl            ; carry set if i < j
   jr nc, right_squeeze
   
   ex (sp),hl                  ; push j
   push hl                     ; push lo
   push bc                     ; push size
   push de                     ; push i
   push ix                     ; push compare

;******************************
IF __SDCC | __SDCC_IX | __SDCC_IY
;******************************

   push de
   push hl
   ex de,hl
   call l_jpix                 ; compare(de=lo, hl=i)
   ld a,h                      ; get result
   pop hl
   pop de

;******************************
ELSE
;******************************

   push hl
   push de
   ex de,hl
   call l_jpix                 ; compare(de=lo, hl=i)
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
   ex (sp),hl                  ; hl = j, stack = hi, lo

   rla
   jr nc, partition            ; if item[lo] >= item[i] continue

right_squeeze:

   ex de,hl
   
right_loop:

   ; de = j
   ; hl = i
   ; bc = size
   ; ix = compare
   ; stack = hi, lo

   call l_ltu_de_hl            ; carry set if j < i
   jr c, swap_ij
   
   ex (sp),hl                  ; push i
   push hl                     ; push lo
   push bc                     ; push size
   push de                     ; push j
   push ix                     ; push compare

;******************************
IF __SDCC | __SDCC_IX | __SDCC_IY
;******************************

   push hl
   push de
   call l_jpix                 ; compare(de=j, hl=lo)
   ld a,h                      ; get result
   pop de
   pop hl

;******************************
ELSE
;******************************

   push de
   push hl
   call l_jpix                 ; compare(de=j, hl=lo)
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
   ex (sp),hl                  ; hl = i, stack = lo
   
   rla
   jr c, swap_ij               ; if item[j] < item[lo] stop
   
   ex de,hl
   sbc hl,bc                   ; j -= size
   ex de,hl
   
   jr right_loop

swap_ij:

   ; if we haven't visited all items in the partition then
   ; i and j point to items that belong in the other half

   ; de = j
   ; hl = i
   ; bc = size
   ; ix = compare
   ; stack = hi, lo

   call l_ltu_hl_de            ; carry set if i < j
   jr nc, partition_done

   push de
   push bc
   call asm0_memswap           ; swap(i, j, size)
   pop bc
   
   add hl,bc                   ; i += size
   ex de,hl                    ; de = i
   pop hl
   sbc hl,bc                   ; j -= size
   
   jr partition

partition_done:

   ; move pivot item to final position
   ; create two new partitions to sort on left and right side of pivot
   
   ; de = j
   ; bc = size
   ; ix = compare
   ; stack = hi, lo

   pop hl
   call l_ltu_hl_de            ; carry set if lo < j
   jr nc, left_empty
   
   push bc
   push de
   call asm0_memswap           ; swap(j, lo, size)
   pop bc
   pop de
   
   ex de,hl
   ex (sp),hl
   push hl
   
   ; hl = hi
   ; bc = j
   ; de = lo
   ; ix = compare
   ; stack = size, hi
   
   ; lowest bound on stack usage is obtained if the
   ; smallest partition is pursued and the largest
   ; is stacked for later
   
   add hl,de
   rr h
   rr l                        ; hl = (hi+lo)/2
   
   call l_ltu_bc_hl            ; carry set if j < (hi+lo)/2
   
   pop hl
   ex (sp),hl
   push de
   
   ld e,c
   ld d,b
   ld c,l
   ld b,h
   ld l,e
   ld h,d
   
   jr nc, right_smallest

left_smallest:
   
   ; hl = j
   ; de = j
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
   ; stack = hi, j+size (hi, lo)
   
   jp while_lohi               ; do left side

right_smallest:

   ; hl = j
   ; de = j
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
   ; stack = j - size, lo (hi, lo)

   jp while_lohi               ; do right side

left_empty:

   ; left side of partition is empty so only right side is left
   
   ; hl = lo
   ; bc = size
   ; ix = compare
   ; stack = hi
   
   pop de
   add hl,bc
   ex de,hl
   
   jp while_lohi

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
   jp while_lohi

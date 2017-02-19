
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
; Pivot selection method is selectable via compile time option.
;
; * Middle Item:  This is the most common choice for simple
;   qsort implementations.  Qsort can degrade to a bubble
;   sort if the pivot selected from each partition is always
;   the smallest or largest item of the partition.  Quite
;   often arrays to be sorted are nearly sorted already so
;   using, eg, the first item of each partition as pivot can
;   quite often lead to nearly always selecting the smallest
;   item in all the partitions.  To avoid this common case,
;   the middle item is always chosen as pivot instead.  This
;   does not solve the problem that qsort can sometimes
;   degrade to bubble sort in performance, it only makes it
;   less likely for common unsorted array orderings.
;
; * Random Item:  The pivot is selected at random from the
;   partition.  It is highly unlikely that the pivot selected
;   will be the worst choice in all partitions.
;
; Final step insertion sort is selectable via compile time option.
;
; * Insertion sort is faster than quicksort for small arrays.
;   With this option selected, the arrays will be partitioned
;   into unsorted sub-arrays of 8-10 items each.  After that
;   an insertion sort is run to complete the sort.
;
; Equal items algorithm can be selected via compile time option.
;
; * If many items are equal in the unsorted array, the
;   partitioning process will place all equal items into the
;   same partition.  Partitioning no longer splits sub-arrays
;   in half in each step and performance can degrade to bubble
;   sort in the extreme case of sorting an array containing all
;   equal items.  With this option enabled, items equal to the
;   pivot are alternately added to the left and right partitions.
; 
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_quicksort

EXTERN __sort_parameters, asm0_memswap, l_compare_de_hl

asm_quicksort:

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

   call __sort_parameters
   ret c                       ; if error

   ; de = array_lo
   ; hl = array_hi
   ; bc = size
   ; ix = compare

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_SORT_QSORT & $04

   EXTERN asm0_insertion_sort

   push de
   push hl
   
   call quicksort              ; apply quicksort until partitions are small
   
   pop hl
   pop de

   ; de = array_lo
   ; hl = array_hi
   ; bc = size
   ; ix = compare

   jp asm0_insertion_sort      ; sort small partitions using insertion sort

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

quicksort:

   push hl
   ld hl,0
   ex (sp),hl                  ; mark end of stack with zero

while_lohi:

   ; current partition is interval [lo, hi]

   ; hl = hi
   ; de = lo
   ; bc = size
   ; ix = compare
   ; stack = 0, (hi,lo)*

   scf
   sbc hl,de
   jr nc, partition            ; if hi > lo

interval_done:

   ; retrieve the next partition from the stack
   
   ; bc = size
   ; ix = compare
   ; stack = 0, (hi,lo)*
   
   pop de
   
   ld a,d
   or e
   ret z                       ; zero is end marker
   
   pop hl
   jr while_lohi

partition:

   add hl,de
   inc hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF (__CLIB_OPT_SORT_QSORT & $03) = 0

   ; pivot = middle item

   ; de = i
   ; hl = j
   ; bc = size
   ; carry reset

   ; compute the address of the middle item k in the interval [i,j

   ; k = (i+j)/2 - ((j-i)/2)%size
   ;   = i + (j-i)/2 - ((j-i)/2)%size  (-- Einar Saukas)

   push hl                     ; save j
   push de                     ; save i
   push bc                     ; save size
   push hl                     ; save j
   push de                     ; save i

   sbc hl,de
   srl h
   rr l                        ; hl = (j-i)/2
   
   ld e,c
   ld d,b                      ; de = size
   
   push hl                     ; save (j-i)/2
   
   EXTERN l0_divu_16_16x16
   call l0_divu_16_16x16       ; de = hl % de = [(j-i)/2] % size

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   IF __CLIB_OPT_SORT_QSORT & $04
   
      ; insertion sort small partitions
      
      inc h
      dec h
      jr nz, partition_size_large
      
      ld a,l
      cp 5                     ; chosen by trial and error
      jr nc, partition_size_large
      
   partition_size_small:
   
      pop bc
      pop bc
      pop bc
      pop bc                   ; bc = size
      pop af
      pop af
   
      jr interval_done
   
   ENDIF
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

partition_size_large:

   pop hl                      ; hl = (j-i)/2
   sbc hl,de
   
   pop de                      ; de = i
   add hl,de                   ; hl = k = i + (j-i)/2 - ((j-i)/2)%size
   
   pop de                      ; de = j
   pop bc                      ; bc = size

   ex de,hl
   pop hl

   ; hl = i
   ; de = pivot
   ; bc = size
   ; stack = j

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ELSE

   ; pivot = random item
   ;
   ; k = rand() % (j-i)
   ; k = k - k % size + i

   ; de = i
   ; hl = j
   ; bc = size
   ; carry reset

   push hl                     ; save j
   push de                     ; save i
   push bc                     ; save size
   push bc                     ; save size
   
   sbc hl,de
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   IF __CLIB_OPT_SORT_QSORT & $04
   
      ; insertion sort small partitions
      
      ; do not have number of items so using
      ; byte size of interval as poor substitute
      
      inc h
      dec h
      jr nz, partition_size_large
      
      ld a,l
      cp 10
      jr nc, partition_size_large
      
   partition_size_small:

      pop bc
      pop bc                   ; bc = size
      pop af
      pop af
   
      jr interval_done
   
   ENDIF
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

partition_size_large:

   ld c,l
   ld b,h                      ; bc = (j-i)
   
   EXTERN asm_random_uniform_xor_32
   call asm_random_uniform_xor_32  ; hl = rand() != 0

   ld e,c
   ld d,b                      ; de = (j-i)
   
   EXTERN l0_divu_16_16x16
   call l0_divu_16_16x16
   
   ex de,hl                    ; hl = k = rand() % (j-i)
   pop de                      ; de = size
   
   push hl                     ; save k
   
   call l0_divu_16_16x16       ; de = k % size
   
   pop hl                      ; hl = k
   sbc hl,de                   ; hl = k - k % size
   
   pop bc                      ; bc = size
   pop de                      ; de = i
   
   add hl,de
   ex de,hl                    ; de = k - k % size + i
   
   ; de = pivot
   ; hl = i
   ; bc = size
   ; stack = j

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pivot_selected:

   ; move pivot to start of partition
   
   ; hl = i
   ; de = pivot
   ; bc = size
   ; stack = j

   push bc
   call asm0_memswap           ; swap(i, pivot, size)
   pop bc
   
   pop de
   ex de,hl
   
   ; de = i = pivot
   ; hl = j
   ; bc = size
   
   ; first element (at lo) is the pivot
   
   push hl                     ; save hi
   push de                     ; save lo = pivot

left_squeeze_0:

   ; move items < pivot to left and items > pivot to right

   ex de,hl
   add hl,bc                   ; i += size
   ex de,hl

left_squeeze_1:

   ; investigating [i,j

   ; items before i are <= pivot and items after j are >= pivot
   
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
   
   ex (sp),hl
   ex de,hl
   
   ; de = lo=pivot
   ; hl = i
   ; bc = size
   ; ix = compare
   ; stack = hi, j
   
   call l_compare_de_hl          ; compare(de=lo=pivot, hl=i)
   
   ex de,hl
   ex (sp),hl

   ; de = i
   ; hl = j
   ; bc = size
   ; ix = compare
   ; carry reset
   ; stack = hi, lo=pivot

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   IF __CLIB_OPT_SORT_QSORT & $08
   
      ; enable equality dispersal
   
      jp m, right_squeeze_0    ; if item[lo=pivot] < item[i]
      
      or a
      jr nz, left_squeeze_0    ; if item[lo=pivot] > item[i]
      
      ; item and pivot are equal
      
      ld a,r                   ; instruction count
      and 31                   ; use prime number
      jp pe, left_squeeze_0    ; if parity is even (random event)
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ELSE
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
      jp p, left_squeeze_0     ; if item[lo=pivot] >= item[i]

   ENDIF
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

right_squeeze_0:

   ex de,hl

right_squeeze_1:

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
   
   ex (sp),hl
   
   ; de = j
   ; hl = lo=pivot
   ; bc = size
   ; ix = compare
   ; stack = hi, i
   
   call l_compare_de_hl        ; compare(de=j, hl=lo=pivot)
   ex (sp),hl

   ; de = j
   ; hl = i
   ; bc = size
   ; ix = compare
   ; carry reset
   ; stack = hi, lo=pivot

   jp m, swap_ij               ; if item[j] < item[lo=pivot] stop

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   IF __CLIB_OPT_SORT_QSORT & $08
   
      ; enable equality dispersal

      or a
      jr nz, right_squeeze_2   ; if item[j] > item[lo=pivot]
      
      ; item and pivot are equal
      
      ld a,r                   ; instruction count
      and 31                   ; use prime number
      jp pe, swap_ij           ; if parity is even (random event)

   ENDIF
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

right_squeeze_2:

   ex de,hl
   sbc hl,bc
   ex de,hl
   
   jr right_squeeze_1

swap_ij:

   ; item[j] < item[pivot]
   ; item[i] > item[pivot]
   
   ; must swap and continue squeeze
   
   ; de = j
   ; hl = i
   ; bc = size
   ; ix = compare
   ; stack = hi, lo=pivot

   push de
   push bc
   
   call asm0_memswap           ; swap(i, j, size)
   
   pop bc
   add hl,bc
   
   ex de,hl                    ; de = i + size
   
   pop hl
   sbc hl,bc                   ; hl = j - size
   
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

   ; hl = j = final position
   ; bc = size
   ; ix = compare
   ; stack = hi, lo=pivot

   ; i > j
   ; item[j] <= item[pivot]
   
   pop de                      ; de = lo=pivot
   
   or a
   sbc hl,de
   
   jr z, left_partition_empty  ; if j == lo=pivot
   add hl,de
   
   ; swap pivot into final position
   
   ; hl = j
   ; de = lo=pivot
   ; bc = size
   ; stack = hi

   push bc
   push de
   
   call asm0_memswap
   
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
   
   ; lowest bound on stack usage occurs if the smallest partition is pursued
   
   add hl,de
   
   rr h
   rr l                        ; hl = (hi+lo)/2 = midpoint
   
   or a
   sbc hl,bc                   ; carry set if midpoint < j=pivot
   
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
   ; stack = hi,lo
   
   jr c, right_smallest        ; if midpoint < pivot

left_smallest:

   add hl,bc
   
   ex (sp),hl
   ex de,hl
   
   sbc hl,bc
   
   ; hl = pivot - size (new hi)
   ; de = lo (new lo)
   ; bc = size
   ; stack = (hi,pivot+size) = stacked right side (hi,lo)
   
   jp while_lohi

right_smallest:

   ; hl = j=pivot
   ; de = j=pivot
   ; bc = size
   ; ix = compare
   ; carry reset
   ; stack = hi,lo
   
   add hl,bc
   ex de,hl                    ; de = pivot + size
   sbc hl,bc                   ; hl = pivot - size
   
   pop af
   ex (sp),hl
   push af
   
   ; hl = hi (new hi)
   ; de = pivot + size (new lo)
   ; bc = size
   ; ix = compare
   ; stack = (pivot-size,lo) = stacked left side (hi,lo)
   
   jp while_lohi

left_partition_empty:

   ; only right side remains
   
   ex de,hl
   
   ; hl = lo=pivot
   ; bc = size
   ; ix = compare
   ; stack = hi
   
   pop de
   add hl,bc
   ex de,hl
   
   jp while_lohi

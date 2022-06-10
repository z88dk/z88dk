
; ===============================================================
; replacing newlib stdlib/z80/asm_qsort.asm file, to enable extra
; __CLIB_OPT_SORT == 3 for hand-written hard-coded assembly.
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_qsort

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

IF __CLIB_OPT_SORT = 0

   ; insertion sort selected

   EXTERN asm_insertion_sort
   defc asm_qsort = asm_insertion_sort

ENDIF

IF __CLIB_OPT_SORT = 1

   ; shellsort selected

   EXTERN asm_shellsort
   defc asm_qsort = asm_shellsort

ENDIF

IF __CLIB_OPT_SORT = 2

   ; quicksort selected

   EXTERN asm_quicksort
   defc asm_qsort = asm_quicksort

ENDIF

IF __CLIB_OPT_SORT = 3

   ; ===============================================================
   ; selecting the benchmark "extras", hand-written routine with
   ; fixed size=2 and uint16_t compare of elements, ignoring ix argument
   ; ===============================================================

   defc asm_qsort = asm_handwritten_qsort

asm_handwritten_qsort:

   ; enter : ~~ix = int (*compar)(de=const void *, hl=const void *)~~ (IGNORED!)
   ;         bc = void *base
   ;         hl = size_t nmemb
   ;         ~~de = size_t size~~  (must be two, otherwise error is reported)
   ;
   ; exit  : none
   ;
   ;         if an error below occurs, no sorting is done.
   ;
   ;         einval if size != 2
   ;         einval if array size > 64k
   ;         erange if array wraps 64k boundary
   ;
   ; uses  : af, bc, de, hl

EXTERN __sort_parameters

   ; handwritten qsort is hard-coded to size==2, if not de==2, report invalid arg
   ld a,e
   sub 2
   or d
   jr z, size_is_two          ; de == 2 -> ok
   ld de,0  ; make __sort_parameters fail on size
size_is_two:
   call __sort_parameters
   ret c                       ; if error

   ; de = array_lo
   ; hl = array_hi
   ; bc = size (2 enforced)
   ; ix = compare

quicksort_a:

    ; convert arguments to HL=A.begin(), DE=A.end() and continue with quicksort_a_impl
    ex      de,hl
    inc     de
    inc     de

;--------------------------------------------------------------------------------------------------------------------
; Quicksort implementation, inputs:
; HL = uint16_t* A.begin() (pointer to beginning of array)
; DE = uint16_t* A.end() (pointer beyond array)
; modifies: AF, A'F', BC, HL (DE is preserved)
quicksort_a_impl:
    ; array must be located within 0x0002..0xFFFD
    ld      c,l
    ld      b,h         ; BC = A.begin()
    ; if (len < 2) return; -> if (end <= begin+2) return;
    inc     hl
    inc     hl
    or      a
    sbc     hl,de       ; HL = -(2*len-2), len = (2-HL)/2
    ret     nc          ; case: begin+2 >= end <=> (len < 2)

    push    de          ; preserve A.end() for recursion
    push    bc          ; preserve A.begin() for recursion

    ; uint16_t pivot = A[len / 2];
    rr      h
    rr      l
    dec     hl
    res     0,l
    add     hl,de
    ld      a,(hl)
    inc     hl
    ld      l,(hl)
    ld      h,b
    ld      b,l
    ld      l,c
    ld      c,a         ; HL = A.begin(), DE = A.end(), BC = pivot

    ; flip HL/DE meaning, it makes simpler the recursive tail and (A[j] > pivot) test
    ex      de,hl       ; DE = A.begin(), HL = A.end(), BC = pivot
    dec     de          ; but keep "from" address (related to A[i]) at -1 as "default" state

    ; for (i = 0, j = len - 1; ; i++, j--) { ; DE = (A+i-1).hi, HL = A+j+1
find_next_swap:

    ; while (A[j] > pivot) j--;
find_j:
    dec     hl
    ld      a,b
    sub     (hl)
    dec     hl          ; HL = A+j (finally)
    jr      c,find_j    ; if cf=1, A[j].hi > pivot.hi
    jr      nz,j_found  ; if zf=0, A[j].hi < pivot.hi
    ld      a,c         ; if (A[j].hi == pivot.hi) then A[j].lo vs pivot.lo is checked
    sub     (hl)
    jr      c,find_j
j_found:

    ; while (A[i] < pivot) i++;
find_i:
    inc     de
    ld      a,(de)
    inc     de          ; DE = (A+i).hi (ahead +0.5 for swap)
    sub     c
    ld      a,(de)
    sbc     a,b
    jr      c,find_i    ; cf=1 -> A[i] < pivot

    ; if (i >= j) break; // DE = (A+i).hi, HL = A+j, BC=pivot
    sbc     hl,de       ; cf=0 since `jr c,.find_i`
    jr      c,swaps_done
    add     hl,de       ; DE = (A+i).hi, HL = A+j

    ; swap(A[i], A[j]);
    inc     hl
    ld      a,(de)
    ldd
    ex      af,af'
    ld      a,(de)
    ldi
    ex      af,af'
    ld      (hl),a      ; Swap(A[i].hi, A[j].hi) done
    dec     hl
    ex      af,af'
    ld      (hl),a      ; Swap(A[i].lo, A[j].lo) done

    inc     bc
    inc     bc          ; pivot value restored (was -=2 by ldd+ldi)
    ; --j; HL = A+j is A+j+1 for next loop (ready)
    ; ++i; DE = (A+i).hi is (A+i-1).hi for next loop (ready)
    jp      find_next_swap

swaps_done:
    ; i >= j, all elements were already swapped WRT pivot, call recursively for the two sub-parts
    dec     de          ; DE = A+i

    ; quicksort_c(A, i);
    pop     hl          ; HL = A
    call    quicksort_a_impl

    ; quicksort_c(A + i, len - i);
    ex      de,hl       ; HL = A+i
    pop     de          ; DE = end() (and return it preserved)
    jp      quicksort_a_impl

ENDIF

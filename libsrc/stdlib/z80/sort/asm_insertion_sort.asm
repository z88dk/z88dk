
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void insertion_sort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))
;
; Insertion sort the array using the comparison function supplied.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_insertion_sort
PUBLIC asm0_insertion_sort

EXTERN error_znc
EXTERN __sort_parameters, l_compare_de_hl, asm0_memswap

asm_insertion_sort:

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

asm0_insertion_sort:

   ; de = array_lo
   ; hl = array_hi
   ; bc = size
   ; ix = compare

   add hl,bc
   push hl                     ; save array_hi + 1
   
   ex de,hl
   
   add hl,bc
   ld e,l
   ld d,h                      ; hl = array_lo + 1, de = array_lo + 1 = i

array_loop:

   ; de = i
   ; hl = array_lo + 1
   ; bc = size
   ; ix = compare
   ; stack = array_hi + 1
   
   ex (sp),hl                  ; hl = array_hi + 1

   ld a,l
   cp e
   jr nz, begin_loop           ; if i != array_hi + 1
   
   ld a,h
   cp d
   jp z, error_znc - 1         ; finished if i == array_hi + 1

begin_loop:

   ex (sp),hl                  ; hl = array_lo + 1
   
   push de
   push hl   
   or a                        ; carry=0 for insert_loop

insert_loop:

   ; de = j
   ; bc = size
   ; ix = compare
   ; stack = array_hi + 1, i, array_lo + 1

   ld l,e
   ld h,d
   
   sbc hl,bc                   ; hl = j-1

   call l_compare_de_hl
   jp p, insert_exit           ; if array[j] >= array[j-1]

   push bc
   call asm0_memswap           ; swap(j, j-1, size)
   pop bc
   
   ex de,hl                    ; de = j-1
   
   pop hl                      ; hl = array_lo + 1
   push hl

   ld a,e
   sub l
   ld a,d
   sbc a,h

   jp nc, insert_loop          ; if more elements in array (j-1 >= array_lo + 1)

insert_exit:

   ; bc = size
   ; ix = compare
   ; stack = array_hi + 1, i, array_lo + 1

   pop de                      ; de = array_lo + 1
   pop hl                      ; hl = i
   
   add hl,bc
   ex de,hl
   
   jr array_loop

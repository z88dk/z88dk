
; ===============================================================
; Nov 2014
; ===============================================================
; 
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))
;
; Sort the array using the comparison function supplied and
; the sorting algorithm indicated in clib_cfg.
;
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

IF __CLIB_OPT_SORT >= 2

   ; quicksort selected
   
   EXTERN asm_quicksort
   defc asm_qsort = asm_quicksort
ENDIF

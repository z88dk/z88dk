
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void mtx_destroy(mtx_t *m)
;
; Release resources associated with mutex.
;
; ===============================================================

;;; should we unblock any blocked threads?
;;; standard specifically says we don't need to

SECTION code_clib
SECTION code_threads_mutex

PUBLIC asm_mtx_destroy

EXTERN l_setmem_hl

asm_mtx_destroy:

   xor a
   jp l_setmem_hl - 12         ; zeroed structure makes mtx_type invalid

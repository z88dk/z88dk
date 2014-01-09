
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void mtx_destroy(mtx_t *m)
;
; Release resources associated with mutex.
;
; ===============================================================

XLIB asm_mtx_destroy

asm_mtx_destroy:

   ret                         ; there are no resources associated with mutexes

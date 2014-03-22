
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void funlockfile(FILE *file)
;
; Reduce lock count of file by one.
;
; ===============================================================

XLIB asm_funlockfile

LIB asm_mtx_unlock

asm_funlockfile:

   ; Release the FILE lock
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ; uses  : none

   push af
   push bc
   push de
   push hl
   
   ld e,ixl
   ld d,ixh                    ; de = FILE *
   
   ld hl,7
   add hl,de                   ; hl = & FILE->mtx_t
   
   call asm_mtx_unlock

   pop hl
   pop de
   pop bc
   pop af
   
   ret

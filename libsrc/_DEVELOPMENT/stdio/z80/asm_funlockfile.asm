
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void funlockfile(FILE *file)
;
; Reduce lock count of file by one.
;
; ===============================================================

SECTION seg_code_stdio

PUBLIC asm_funlockfile
PUBLIC asm0_funlockfile

EXTERN asm_mtx_unlock

asm_funlockfile:

   ; Release the FILE lock
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ; uses  : none

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_funlockfile:

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

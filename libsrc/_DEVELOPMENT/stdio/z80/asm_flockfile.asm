
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void flockfile(FILE *file)
;
; Increase lock count on file by one.
;
; ===============================================================

INCLUDE "clib_cfg.asm"

PUBLIC asm_flockfile
PUBLIC asm0_flockfile

EXTERN asm_mtx_lock

asm_flockfile:

   ; Acquire the FILE lock
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry set if failed to acquire
   ;
   ; uses  : af

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_flockfile:

   push bc
   push de
   push hl
   
   ld e,ixl
   ld d,ixh                    ; de = FILE *
   
   ld hl,7
   add hl,de                   ; hl = & FILE->mtx_t
   
   call asm_mtx_lock           ; lock stream
   
   pop hl
   pop de
   pop bc

   ret

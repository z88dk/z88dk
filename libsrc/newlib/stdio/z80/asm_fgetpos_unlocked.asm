
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fgetpos_unlocked(FILE *stream, fpos_t *pos)
;
; Write current file position to pos.
;
; This implementation does not support multibyte character sets
; so the value written to pos is the same as returned by ftell().
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_fgetpos_unlocked
PUBLIC asm0_fgetpos_unlocked

EXTERN asm0_ftell_unlocked, error_mc, error_znc

asm_fgetpos_unlocked:

   ; enter : ix = FILE *
   ;         hl = fpos_t *pos
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;           hl = 0
   ;           carry reset
   ;
   ;         fail
   ;
   ;           hl = -1
   ;           carry set
   ;
   ; uses  : all except ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid
   
   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_fgetpos_unlocked:

   push hl                     ; save void *pos

   call asm0_ftell_unlocked    ; dehl = file position
   jp c, error_mc - 1
   
   ex de,hl                    ; de = LSW
   ex (sp),hl                  ; hl = void *pos
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   pop de                      ; de = MSW
   
   ld (hl),e
   inc hl
   ld (hl),d
   
   jp error_znc

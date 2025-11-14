
; ===============================================================
; Apr 2014
; ===============================================================
; 
; void rewind(FILE *stream)
;
; Clear any stream error and execute fseek(stream, 0L, SEEK_SET)
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_rewind_unlocked
PUBLIC asm0_rewind_unlocked

EXTERN asm0_fseek_unlocked

asm_rewind_unlocked:

   ; enter :   ix = FILE *
   ;
   ; exit  :   ix = FILE *
   ;
   ;         success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid
   
   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_rewind_unlocked:

   ld a,(ix+3)
   and $e7                     ; clear error and eof
   ld (ix+3),a
   
   ld hl,0
   ld e,l
   ld d,h                      ; dehl = 0L
   
   ld c,STDIO_SEEK_SET
   jp asm0_fseek_unlocked      ; rewind stream

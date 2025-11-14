
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void perror(const char *s)
;
; Write error message to stderr.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_perror

EXTERN _stderr, _errno
EXTERN asm_strerror, asm0_fputs_unlocked, asm0_fputc_unlocked

asm_perror:

   ; enter : hl = char *s
   ;
   ; exit  : ix = FILE *stderr
   ;         carry set on error
   ;
   ; uses  : all except ix
   
   ld ix,(_stderr)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   IF __CLIB_OPT_STDIO & $01

      EXTERN __stdio_verify_valid_lock
   
      call __stdio_verify_valid_lock
      ret c
   
   ELSE
   
      EXTERN __stdio_lock_acquire, error_mc
      
      call __stdio_lock_acquire
      jp c, error_mc

   ENDIF
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ELSE

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   IF __CLIB_OPT_STDIO & $01
   
      EXTERN __stdio_verify_valid
      
      call __stdio_verify_valid
      ret c
   
   ENDIF
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ld a,h
   or l
   jr z, errno_string          ; if no user string
   
   ld a,(hl)
   or a
   jr z, errno_string          ; if no user string

   ; output user string
   
   call asm0_fputs_unlocked
   
   ld hl,separator_s
   call asm0_fputs_unlocked

errno_string:
   
   ; output errno string
   
   ld hl,(_errno)
   call asm_strerror
   call asm0_fputs_unlocked
   
   ld e,CHAR_LF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02

   EXTERN __stdio_lock_release

   call asm0_fputc_unlocked
   jp __stdio_lock_release

ELSE

   jp asm0_fputc_unlocked

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

separator_s:

   defm ": "
   defb 0


; ===============================================================
; Jan 2014
; ===============================================================
; 
; unsigned long ftell_unlocked(FILE *stream)
;
; Return current file position.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_ftell_unlocked
PUBLIC asm0_ftell_unlocked

EXTERN STDIO_SEEK_CUR, STDIO_MSG_SEEK

EXTERN l_jpix, error_mc, l_decu_dehl

asm_ftell_unlocked:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;           dehl = current file position
   ;           carry reset
   ;
   ;         fail
   ;
   ;           dehl = -1
   ;           carry set
   ;
   ; uses  : all except ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   jr c, ftell_immediate_error_ebadf

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_ftell_unlocked:

   ld de,0
   ld l,e
   ld h,d                      ; dehl = 0
   
   ld c,STDIO_SEEK_CUR
   
   exx
   
   ld a,STDIO_MSG_SEEK
   ld c,STDIO_SEEK_CUR
   
   call l_jpix
   jr c, immediate_error
   
   ; presence of unget char alters current position
   
   ld a,(ix+4)
   inc a
   and $03                     ; check last op was read and unget char avail

   ret nz
   jp l_decu_dehl              ; if unget char present adjust position

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   PUBLIC ftell_immediate_error_ebadf
   ftell_immediate_error_ebadf:

ELSE

   PUBLIC ftell_immediate_error_enolck
   EXTERN error_enolck_mc
   
   ftell_immediate_error_enolck:
   
      call error_enolck_mc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

immediate_error:

   call error_mc
   
   ld e,l
   ld d,h                      ; dehl = -1
   ret

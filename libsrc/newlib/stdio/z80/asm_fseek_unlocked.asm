
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fseek_unlocked(FILE *stream, long offset, int whence)
;
; Move to new position in file indicated by the signed value
; offset.
;
; If whence is:
;
; STDIO_SEEK_SET (0) : offset is relative to start of file
; STDIO_SEEK_CUR (1) : offset is relative to current position
; STDIO_SEEK_END (2) : offset is relative to end of file
;
; For STDIO_SEEK_SET, offset is treated as unsigned.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_fseek_unlocked
PUBLIC asm0_fseek_unlocked

EXTERN STDIO_SEEK_CUR, STDIO_MSG_SEEK

EXTERN l_decs_dehl, error_mc, error_znc, error_einval_mc, l_jpix

asm_fseek_unlocked:

   ; enter :   ix = FILE *
   ;         dehl = offset
   ;            c = whence
   ;
   ; exit  :   ix = FILE *
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

asm0_fseek_unlocked:

   bit 3,(ix+3)
   jp nz, error_mc             ; if stream is in an error state

   ld a,c
   cp 3
   jp nc, error_einval_mc      ; if seek type is invalid
 
   cp STDIO_SEEK_CUR
   jr nz, absolute_seek

   ; presence of unget char alters relative seek
   
   ld a,(ix+4)
   inc a
   and $03                     ; check last op was read and unget char avail
   call z, l_decs_dehl         ; if unget char present adjust seek

   ld a,c
   
absolute_seek:

   exx
   
   ld c,a
   ld a,STDIO_MSG_SEEK
   call l_jpix
   
   jp c, error_mc
   
   res 0,(ix+4)                ; clear unget char
   res 4,(ix+3)                ; clear eof
   
   jp error_znc

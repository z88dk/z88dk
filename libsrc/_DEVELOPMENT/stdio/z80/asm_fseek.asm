
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fseek(FILE *stream, long offset, int whence)
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

XLIB asm_fseek
XDEF asm_fseek_unlocked

LIB l_decs_dehl, error_mc, error_znc
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

asm_fseek:

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

   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm_fseek_unlocked
   jp __stdio_lock_release

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

   bit 3,(ix+3)
   jp nz, error_mc             ; if stream is in an error state
   
   ld a,c
   cp STDIO_SEEK_CUR
   jr nz, absolute_seek

   ; presence of unget char alters relative seek
   
   ld a,(ix+4)
   inc a
   and $03                     ; check last op was read and unget char avail
   call z, l_decs_dehl         ; if unget char present adjust seek

absolute_seek:

   exx
   
   ld a,STDIO_MSG_SEEK
   call l_jpix
   
   jp c, error_mc
   
   res 0,(ix+4)                ; clear unget char
   res 4,(ix+3)                ; clear eof
   
   jp error_znc

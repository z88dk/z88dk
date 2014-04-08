
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fflush_unlocked(FILE *stream)
;
; Flush the stream.  For streams most recently written to, this
; means sending any buffered output to the device.  For streams
; most recently read from, this means seeking backward to unread
; any unconsumed input.
;
; If stream == 0, all streams are flushed.
;
; ===============================================================

XLIB asm_fflush_unlocked
XDEF asm0_fflush_unlocked

XREF STDIO_SEEK_CUR, STDIO_MSG_SEEK, STDIO_MSG_FLSH

LIB asm__fflushall_unlocked, l_jpix, error_mc, error_znc

asm_fflush_unlocked:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         if success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         if stream is in error state
   ;         if write failed
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : all except ix

   ld a,ixl
   or ixh
   jp z, asm__fflushall_unlocked

asm0_fflush_unlocked:

   bit 3,(ix+3)
   jp nz, error_mc             ; if stream is in an error state

   bit 1,(ix+4)
   jr z, last_was_write

last_was_read:

   ; last operation was a read
   
   bit 0,(ix+4)
   jr z, forward_flush
   
   ; unget char present
   
   res 0,(ix+4)                ; clear ungetchar
   res 4,(ix+3)                ; clear eof
   
   ld c,STDIO_SEEK_CUR
   ld a,c
   
   ld hl,$ffff
   ld e,l
   ld d,h                      ; dehl = -1
   
   exx
   
   ld c,a
   ld a,STDIO_MSG_SEEK
   
   call l_jpix                 ; seek backward one byte

last_was_write:

   ; last operation was write

forward_flush:

   ; forward flush message along stdio chain
   
   ld a,STDIO_MSG_FLSH
   call l_jpix
   
   jp nc, error_znc
   jp error_mc

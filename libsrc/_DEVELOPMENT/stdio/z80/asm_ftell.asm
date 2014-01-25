
; ===============================================================
; Jan 2014
; ===============================================================
; 
; long ftell(FILE *stream)
;
; Return current file position.
;
; ===============================================================

XLIB asm_ftell
XDEF asm_ftell_unlocked

LIB l_jpix, error_mc, l_decu_dehl
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

asm_ftell:

   ; enter :   ix = FILE *
   ;
   ; exit  :   ix = FILE *
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

   call __stdio_lock_acquire
   jr c, immediate_error_enolck
   
   call asm_ftell_unlocked
   jp __stdio_lock_release

asm_ftell_unlocked:

   ; enter :   ix = FILE *
   ;
   ; exit  :   ix = FILE *
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

   ld de,0
   ld l,e
   ld h,d                      ; dehl = 0
   
   ld c,STDIO_SEEK_CUR
   
   exx
   
   ld a,STDIO_MSG_SEEK
   call l_jpix
   
   jr c, immediate_error
   
   ; presence of unget char alters current position
   
   ld a,(ix+4)
   inc a
   and $03                     ; check last op was read and unget char avail

   ret nz
   jp l_decu_dehl              ; if unget char present adjust position

immediate_error_enolck:

   call error_enolck_mc

immediate_error:

   call error_mc
   
   ld e,l
   ld d,h                      ; dehl = -1
   ret


; ===============================================================
; Jan 2014
; ===============================================================
; 
; unsigned long ftell_unlocked(FILE *stream)
;
; Return current file position.
;
; ===============================================================

XLIB asm_ftell_unlocked
XDEF ftell_immediate_error_enolck

LIB l_jpix, error_mc, l_decu_dehl

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

   ld de,0
   ld l,e
   ld h,d                      ; dehl = 0
   
   ld c,STDIO_SEEK_CUR
   
   exx
   
   ld a,STDIO_MSG_SEEK
   ld c, STDIO_SEEK_CUR
   
   call l_jpix
   jr c, immediate_error
   
   ; presence of unget char alters current position
   
   ld a,(ix+4)
   inc a
   and $03                     ; check last op was read and unget char avail

   ret nz
   jp l_decu_dehl              ; if unget char present adjust position

ftell_immediate_error_enolck:

   call error_enolck_mc

immediate_error:

   call error_mc
   
   ld e,l
   ld d,h                      ; dehl = -1
   ret

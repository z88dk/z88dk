
; ===============================================================
; Apr 2014
; ===============================================================
; 
; void rewind(FILE *stream)
;
; Clear any stream error and execute fseek(stream, 0L, SEEK_SET)
; ===============================================================

XLIB asm_rewind_unlocked

LIB asm_fseek_unlocked

XREF STDIO_SEEK_SET

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

   res 3,(ix+3)                ; clear stream error state
   
   ld hl,0
   ld e,l
   ld d,h                      ; dehl = 0L
   
   ld c,STDIO_SEEK_SET
   jp asm_fseek_unlocked       ; rewind stream


; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fsetpos_unlocked(FILE *stream, const fpos_t *pos)
;
; Set the file position of stream according to pos.
;
; ===============================================================

XLIB asm_fsetpos_unlocked

XREF STDIO_SEEK_SET

LIB asm_fseek_unlocked

asm_fsetpos_unlocked:

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

   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ex de,hl                    ; dehl = file position
   
   ld c,STDIO_SEEK_SET
   jp asm_fseek_unlocked

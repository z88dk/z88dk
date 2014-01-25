
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fsetpos(FILE *stream, const fpos_t *pos)
;
; Set the file position of stream according to pos.
;
; ===============================================================

XLIB asm_fsetpos
XDEF asm_fsetpos_unlocked

LIB asm_fseek_unlocked
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

asm_fsetpos:

   ; enter :   ix = FILE *
   ;           hl = fpos_t *pos
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
   
   call asm_fsetpos_unlocked
   jp __stdio_lock_release

asm_fsetpos_unlocked:

   ; enter :   ix = FILE *
   ;           hl = fpos_t *pos
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

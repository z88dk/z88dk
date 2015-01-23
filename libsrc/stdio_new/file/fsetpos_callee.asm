; int __CALLEE__ fsetpos_callee(FILE *stream, fpos_t *pos)
; an fpos_t is a long
; 06.2008 aralbrec

PUBLIC fsetpos_callee
PUBLIC ASMDISP_FSETPOS_CALLEE

EXTERN fseek_callee
EXTERN ASMDISP_FSEEK_CALLEE

INCLUDE "../stdio.def"

.fsetpos_callee

   pop de
   pop hl
   pop ix
   push de

.asmentry

   ; enter : ix = FILE *stream
   ;         hl = long *pos
   ; exit  : hl = 0 and no carry for success
   ;              -1 and carry for fail

   ld e,(hl)                   ; get long file position
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ex de,hl                    ; dehl = file position

   ld c,STDIO_SEEK_SET
   jp fseek_callee + ASMDISP_FSEEK_CALLEE

defc ASMDISP_FSETPOS_CALLEE = # asmentry - fsetpos_callee

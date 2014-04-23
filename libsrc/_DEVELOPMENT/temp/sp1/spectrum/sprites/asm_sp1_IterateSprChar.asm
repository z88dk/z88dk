; void sp1_IterateSprChar(struct sp1_ss *s, void *hook1)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB asm_sp1_IterateSprChar

LIB l_jpix

asm_sp1_IterateSprChar:

; Iterate over all the struct sp1_cs contained in a sprite
; in row major order, calling the user function for each one.
;
; enter : hl = & struct sp1_ss
;         ix = user function
; uses  : af, bc, hl + whatever user function uses

   ld bc,15
   add hl,bc              ; hl = & struct sp1_ss.first

   ld c,b                 ; bc = sprite char counter = 0

iterloop:

   ld a,(hl)
   or a
   ret z

   inc hl
   ld l,(hl)
   ld h,a                 ; hl = & next struct sp1_cs
   push bc
   push hl
   call l_jpix            ; call userfunc(uint count, struct sp1_cs *c)
   pop hl
   pop bc
   inc bc
   jp iterloop

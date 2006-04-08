
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_Initialize(uchar iflag, uchar *idtypetbl, void *sprdrawtbl, uchar colour, uchar tile)

XLIB sp1_Initialize
LIB SP1Initialize

.sp1_Initialize

   ld hl,10
   add hl,sp
   ld a,(hl)
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld b,(hl)
   dec hl
   ld c,(hl)
   dec hl
   dec hl
   ex af,af
   ld a,(hl)
   dec hl
   dec hl
   ld l,(hl)
   ld h,a
   ex af,af
   jp SP1Initialize   

; enter :  h = startup background attribute
;          l = startup background tile
;         bc = & sprdraw table (table of sprite draw char functions indexed by type)
;         de = & idtype table (table of id/type pairs that associates id with type, ends in id=0)
;          a = flag, bit 0 = 1 if rotation table needed
; used  : af, bc, de, hl

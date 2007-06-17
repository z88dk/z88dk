; uint __CALLEE__ screenstr_callee(uchar row, uchar col)
; aralbrec 06.2007

; Sinclair Basic's SCREEN$() returns ascii code if the
; bit pattern on screen matches exactly the character
; set's bit pattern or its inverse.  This subroutine
; goes a little further and will conclude a match
; if the bit pattern contains a mixture of inverted
; and non-inverted bit patterns.

XLIB screenstr_callee
XDEF ASMDISP_SCREENSTR_CALLEE

LIB zx_cyx2saddr_callee
XREF ASMDISP_ZX_CYX2SADDR_CALLEE

.screenstr_callee

   pop hl
   pop de
   ex (sp),hl
   ld h,l
   ld l,e

.asmentry

   ; h = char Y 0..23
   ; l = char X 0..31
   ;
   ; exit : hl = ascii char code if match, else 0 and carry set

   call zx_cyx2saddr_callee + ASMDISP_ZX_CYX2SADDR_CALLEE
   
   ; hl = screen address
   
   ld c,96                     ; number of chars to match against
   ld de,$3d00                 ; character set in ROM

.charloop

   ld b,8                      ; match 8 pixel rows
   push hl

.mloop

   ld a,(de)
   xor (hl)
   jr z, cont                  ; jump if bit patterns match
   inc a
   jr nz, nomatch              ; jump if bit patterns are not inverses

.cont

   inc de
   inc h
   djnz mloop
   
.match

   pop hl
   
   ld a,128
   sub c

   ld l,a                      ; hl = ascii char code
   ld h,b
   ret
   
.nomatch

   ld a,8
   sub b
   add a,e
   ld e,a
   jp nc, cont
   inc d

.cont

   pop hl
   dec c
   jp nz, charloop
   
   ld l,c
   ld h,c                      ; return with 0 to indicate no match
   scf
   ret

DEFC ASMDISP_SCREENSTR_CALLEE = asmentry - screenstr_callee

; uint __CALLEE__ zx_screenstr_callee(uchar row, uchar col)
; aralbrec 06.2007

; Sinclair Basic's SCREEN$() returns ascii code if the
; bit pattern on screen matches exactly the character
; set's bit pattern or its inverse.  This subroutine
; goes a little further and will conclude a match
; if the bit pattern contains a mixture of inverted
; and non-inverted bit patterns.

SECTION code_clib
PUBLIC zx_screenstr_callee
PUBLIC _zx_screenstr_callee
PUBLIC asm_zx_screenstr

EXTERN asm_zx_cxy2saddr

.zx_screenstr_callee
._zx_screenstr_callee

   pop hl
   pop de
   ex (sp),hl
   ld h,l
   ld l,e

asm_zx_screenstr:
   ; h = char Y 0..23
   ; l = char X 0..31
   ;
   ; exit : hl = ascii char code if match, else 0 and carry set

   call asm_zx_cxy2saddr
   
   ; hl = screen address
   
   ld c,96                     ; number of chars to match against
   ld de,(23606)               ; use CHARS system variable to locate character set bitmap
   inc d

.charloop

   ld b,8                      ; match 8 pixel rows
   push hl

.mloop

   ld a,(de)
   xor (hl)
   jr z, cont1                 ; jump if bit patterns match
   inc a
   jr nz, nomatch              ; jump if bit patterns are not inverses

.cont1

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

   ld a,b			;Remaining rows in font left
   add a,e
   ld e,a
   jp nc, cont2
   inc d

.cont2

   pop hl
   dec c
   jp nz, charloop
   
   ld l,c
   ld h,c                      ; return with 0 to indicate no match
   scf
   ret


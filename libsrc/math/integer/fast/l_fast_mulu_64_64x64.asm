
; 2016 aralbrec
; fast optimization not complete

SECTION code_clib
SECTION code_math

PUBLIC l_fast_mulu_64_64x64

EXTERN l0_mulu_64_32x32
EXTERN l_mulu_32_32x32

l_fast_mulu_64_64x64:

   ; 64-bit multiplication

   ; enter :      +-------------------------------
   ;              | +15 
   ;              | ...  multiplicand AB (8 bytes)
   ;              | + 8 
   ;         ix = |-------------------------------
   ;              | + 7
   ;              | ...  multiplicand CD (8 bytes)
   ;              | + 0
   ;              +-------------------------------
   ;
   ; exit  : ix structure unchanged
   ;         dehl' dehl = 64-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   xor a

   ld bc,(ix+10)

   ld de,(ix+2)

   ld l,a
   ld h,a

   exx

   ld bc,(ix+8)

   ld de,(ix+0)

   ld l,a
   ld h,a

   call l0_mulu_64_32x32       ; bc'bc de'de = B*D

   exx

   push de
   push hl                     ; save LS32(B*D)
  
   ld de,(ix+14)
   ld hl,(ix+12)

   ld a,d
   or e
   or h
   or l

   exx

   or (ix+7)
   or (ix+6)
   or (ix+5)
   or (ix+4)

   jr z, finished              ; if multiplicands were 32 bit

   push de
   push hl                     ; save MS32(B*D)

   ld de,(ix+2)
   ld hl,(ix+0)

   push ix
   call l_mulu_32_32x32        ; dehl = LS32(A*D)
   pop ix

   push de
   push hl                     ; save LS32(A*D)

   ld de,(ix+10)
   ld hl,(ix+8)

   exx

   ld de,(ix+6)
   ld hl,(ix+4)

   push ix
   call l_mulu_32_32x32        ; dehl = LS32(B*C)
   pop ix

   pop bc
   add hl,bc
   ex de,hl
   pop bc
   adc hl,bc
   ex de,hl

   ; dehl = LS32(B*C) + LS32(A*D)

   pop bc
   add hl,bc
   ex de,hl
   pop bc
   adc hl,bc
   ex de,hl
 
finished:
 
   ; dehl = MS32(product) = LS32(B*C) + LS32(A*D) + MS32(B*D)
 
   exx

   pop hl
   pop de

   ; dehl = LS32(product) = LS32(B*D)

   or a
   ret

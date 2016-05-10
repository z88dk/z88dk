
; 2016 aralbrec

SECTION code_clib
SECTION code_math

PUBLIC l_small_mul_64_64x64

EXTERN l0_small_mul_64_32x32
EXTERN l0_small_mul_32_32x32

l_small_mul_64_64x64:

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
   
   ld b,(ix+11)
   ld c,(ix+10)
   
   ld d,(ix+3)
   ld e,(ix+2)
   
   ld l,a
   ld h,a
   
   exx
   
   ld b,(ix+9)
   ld c,(ix+8)
   
   ld d,(ix+1)
   ld e,(ix+0)
   
   ld l,a
   ld h,a
   
   call l0_small_mul_64_32x32  ; dehl dehl' = B*D
   
   exx
   
   push de
   push hl                     ; save LS32(B*D)
   
   ld b,(ix+13)
   ld c,(ix+12)
   
   ld d,(ix+1)
   ld e,(ix+0)
   
   ld hl,0
   
   ld a,b
   or c
   
   exx
   
   ld b,(ix+15)
   ld c,(ix+14)
   
   or b
   or c
   or (ix+7)
   or (ix+6)
   or (ix+5)
   or (ix+4)
   
   jr z, finished              ; if multiplicands were 32 bit
   
   push de
   push hl                     ; save MS32(B*D)

   ld d,(ix+3)
   ld e,(ix+2)
   
   ld hl,0
   
   call l0_small_mul_32_32x32  ; dehl = LS32(A*D)
   
   push de
   push hl                     ; save LS32(A*D)
   
   xor a
   
   ld b,(ix+9)
   ld c,(ix+8)
   
   ld d,(ix+5)
   ld e,(ix+4)
   
   ld l,a
   ld h,a
   
   exx
   
   ld b,(ix+11)
   ld c,(ix+10)
   
   ld d,(ix+7)
   ld e,(ix+6)
   
   ld l,a
   ld h,a
   
   call l0_small_mul_32_32x32  ; dehl = LS32(B*C)
   
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

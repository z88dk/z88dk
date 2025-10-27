
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __mullonglong_callee

EXTERN l_mulu_64_64x64, l_store_64_dehldehl_mbc

__mullonglong_callee:

   ; 64-bit multiplication
   ;
   ; enter :         +-------------------------------
   ;                 | +19 
   ;                 | ...  multiplicand AB (8 bytes)
   ;                 | +12
   ;         stack = |-------------------------------
   ;                 | +11
   ;                 | ...  multiplicand CD (8 bytes)
   ;                 | +4
   ;                 |-------------------------------
   ;                 | +3
   ;                 | +2   product *
   ;                 |-------------------------------
   ;                 | +1
   ;                 | +0   return address
   ;                 +-------------------------------
   ;
   ; exit  :         +-------------------------------
   ;                 | +17 
   ;                 | ...  multiplicand AB (8 bytes)
   ;                 | +10 
   ;         stack = |-------------------------------
   ;                 | +9
   ;                 | ...  multiplicand CD (8 bytes)
   ;                 | +2
   ;                 |-------------------------------
   ;                 | +1
   ;                 | +0   product *
   ;                 +-------------------------------
   ;
   ;         *product = product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   push ix
   
   ld ix,6
   add ix,sp                   ; ix = & multiplicand CD
   
   call l_mulu_64_64x64        ; dehl'dehl = product
   
   ld c,(ix-2)
   ld b,(ix-1)                 ; bc = product *
   
   call l_store_64_dehldehl_mbc

   pop ix                      ; restore ix
   pop de                      ; return address
   
   ld hl,18
   add hl,sp
   ld sp,hl                    ; clear stack
   
   ex de,hl
   jp (hl)

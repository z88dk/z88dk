;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __CALLEE__ vz_brick_callee(void *addr, char byte)

SECTION code_clib
PUBLIC vz_brick_callee
PUBLIC _vz_brick_callee
PUBLIC ASMDISP_VZ_BRICK_CALLEE

.vz_brick_callee
._vz_brick_callee

   pop hl
   pop bc
   pop de
   push hl
   
   ;  c = byte
   ; de = addr

.asmentry

   ld a,c                    ; bc = 6*c
   add a,a
   ld c,a
   add a,a
   add a,c
   ld c,a
   ld b,0
   
   ld hl,bricks
   add hl,bc
   
   ld c,6

.showit

   ldi
   ret po
   ld a,31
   add a,e
   ld e,a
   jp nc, showit
   inc d
   jp showit

.bricks

   ; 0

   defb 000, 000, 000, 000, 000, 000

   ; 1

   defb 085, 084, 085, 084, 085, 084
   
   ; 2

   defb 255, 252, 255, 252, 255, 252
   
   ; 3

   defb 087, 084, 087, 084, 087, 084

   ; 4

   defb 253, 252, 253, 252, 253, 252
   
   ; 5

   defb 085, 084, 255, 252, 085, 084

   ; 6
   
   defb 255, 252, 085, 084, 255, 252
   
   ; 7
   
   defb 245, 124, 245, 124, 245, 124

   ; 8
   
   defb 170, 168, 165, 104, 170, 168

   ; 9
   
   defb 170, 168, 175, 232, 170, 168

DEFC ASMDISP_VZ_BRICK_CALLEE = # asmentry - vz_brick_callee

;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Stefano Bodrato
;
;*****************************************************

; ----- int __CALLEE__ vz_point_callee(int x, int y)

SECTION code_clib
PUBLIC vz_point_callee
PUBLIC _vz_point_callee
PUBLIC cpoint_callee
PUBLIC _cpoint_callee
PUBLIC asm_vz_point
EXTERN base_graphics

.vz_point_callee
._vz_point_callee
.cpoint_callee
._cpoint_callee

   pop af
   pop de
   pop hl
   push af
   ld h,e

   ; l = x
   ; h = y

.asm_vz_point

   ld a,h
   cp 64
   ret nc
   
   ld a,l
   cp 128
   ret nc

   sla l                     ; calculate screen offset
   srl h
   rr l
   srl h
   rr l
   srl h
   rr l
   
   and $03                   ; pixel offset   
   inc a
   ld b,a   

   ld de,(base_graphics)
   add hl,de
 
   ld a,(hl)

.pset1
   rlca
   rlca
   djnz pset1

   and 3

	ld	h,0
	ld	l,a
   
   ret
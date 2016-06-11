;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __CALLEE__ vz_plot_callee(int x, int y, int c)

SECTION code_clib
PUBLIC vz_plot_callee
PUBLIC _vz_plot_callee
PUBLIC ASMDISP_VZ_PLOT_CALLEE
EXTERN scrbase

.vz_plot_callee
._vz_plot_callee

   pop af
   pop bc
   pop de
   pop hl
   push af
   ld h,e

   ; l = x
   ; h = y
   ; c = colour

.asmentry

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
   
   ld a,$fc

.pset1

   rrca
   rrca
   rrc c
   rrc c
   djnz pset1

   ld de,(scrbase)
   add hl,de
   and (hl)
   or c
   ld (hl),a
   
   ret

DEFC ASMDISP_VZ_PLOT_CALLEE = # asmentry - vz_plot_callee

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
PUBLIC cplot_callee
PUBLIC _cplot_callee
PUBLIC asm_vz_plot
EXTERN base_graphics

.vz_plot_callee
._vz_plot_callee
.cplot_callee
._cplot_callee

   pop af
   pop bc
   pop de
   pop hl
   push af
   ld h,e

   ; l = x
   ; h = y
   ; c = colour

.asm_vz_plot

   ld	a,c
   and 3
   ld	c,a

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

   ld de,(base_graphics)
   add hl,de
   and (hl)
   or c
   ld (hl),a
   
   ret


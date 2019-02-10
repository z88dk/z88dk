;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __CALLEE__ vz_gotoxy_callee(int x, int y)

SECTION code_clib
PUBLIC vz_gotoxy_callee
PUBLIC _vz_gotoxy_callee
PUBLIC ASMDISP_VZ_GOTOXY_CALLEE

.vz_gotoxy_callee
._vz_gotoxy_callee

   pop bc
   pop hl
   pop de
   push bc
   
   ; hl = y
   ; de = x
 
 .asmentry
 
   ld a,l
   cp 16                     ; y < 16?
   jr c, gxy_a
   ld hl,-1                  ; -1 + 16 -> 15
 
 .gxy_a
 
   ld bc,16
   add hl,bc
   
   add hl,hl                 ; * 32
   add hl,hl
   add hl,hl
   add hl,hl
   add hl,hl
   
   add hl,de
   ld ($7820),hl             ; set cursor position
   ret

DEFC ASMDISP_VZ_GOTOXY_CALLEE = # asmentry - vz_gotoxy_callee

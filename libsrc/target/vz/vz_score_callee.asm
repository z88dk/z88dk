;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __CALLEE__ vz_score_callee(void *addr, char byte)

SECTION code_clib
PUBLIC vz_score_callee
PUBLIC _vz_score_callee
EXTERN ASMDISP_VZ_SCORE_CALLEE

.vz_score_callee
._vz_score_callee

   pop hl
   pop bc
   pop de
   push hl
   
   ;  c = byte
   ; de = addr
   
.asmentry

   ld a,c                    ; bc = 5*c
   add a,a
   add a,c
   ld c,a
   ld b,0
   
   ld hl,numbers
   add hl,bc
   
   ld c,5
 
 .showit

   ldi
   ret po
   ld a,31
   add a,e
   ld e,a
   jp nc, showit
   inc d
   jp showit

.numbers

   ; 0

   defb $3f, $33, $33, $33, $3f

   ; 1
   
   defb $3c, $0c, $0c, $0c, $3f

   ; 2
   
   defb $3f, $03, $0c, $30, $3f

   ; 3
   
   defb $3f, $03, $0f, $03, $3f
 
   ; 4
    
   defb $33, $33, $3f, $03, $03

   ; 5
   
   defb $3f, $30, $0c, $03, $3f

   ; 6
   
   defb $3f, $30, $3f, $33, $3f

   ; 7
   
   defb $3f, $03, $03, $03, $03

   ; 8
   
   defb $3f, $33, $0c, $33, $3f

   ; 9
   
   defb $3f, $33, $3f, $03, $3f

DEFC ASMDISP_VZ_SCORE_CALLEE = # asmentry - vz_score_callee

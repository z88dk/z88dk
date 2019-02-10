;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __CALLEE__ vz_line_callee(int x1, int y1, int x2, int y2, int c)

SECTION code_clib
PUBLIC vz_line_callee
PUBLIC _vz_line_callee
PUBLIC ASMDISP_VZ_LINE_CALLEE

EXTERN vz_plot_callee
EXTERN ASMDISP_VZ_PLOT_CALLEE

.vz_line_callee
._vz_line_callee

   pop af
   pop bc
   pop de
   pop hl
   ld d,e
   ld e,l
   pop hl
   ex af,af
   ld a,l
   pop hl
   ld h,a
   ex af,af
   push af
   
   ; c = colour
   ; l = x1
   ; h = y1
   ; e = x2
   ; d = y2
   
.asmentry

   ld a,e
   cp l
   jr nc, line1
   ex de,hl                  ; swap so that x1 < x2

.line1

   ld a,e
   sub l                     ; dx
   ld e,a                    ; save dx

   ld a,d
   sub h
   jp c, lup                 ; negative (up)

.ldn

   ld d,a                    ; save dy
   cp e                      ; dy < dx ?
   jr c, ldnx

.ldny

   ld b,a                    ; count = dy
   srl a                     ; /2 -> overflow

.ldny1

   push af
   push bc
   push de
   push hl
   call vz_plot_callee + ASMDISP_VZ_PLOT_CALLEE
   pop hl
   pop de
   pop bc
   pop af
   
   dec b                     ; done?
   ret m

   inc h                     ; y++
   sub e                     ; overflow -= dx
   jr nc, ldny1
 
   inc l                     ; x++
   add a,d                   ; overflow += dy
   jp ldny1

.ldnx

   ld a,e                    ; get dx
   ld b,a                    ; count = dx
   srl a                     ; /2 -> overflow
   
.ldnx1

   push af
   push bc
   push de
   push hl
   call vz_plot_callee + ASMDISP_VZ_PLOT_CALLEE
   pop hl
   pop de
   pop bc
   pop af
   
   dec b                     ; done?
   ret m
   
   inc l                     ; x++
   sub d                     ; overflow -= dy
   jr nc, ldnx1

   inc h                     ; y++
   add a,e                   ; overflow += dx
   jp ldnx1

.lup

   neg                       ; make dy positive
   ld d,a                    ; save dy
   cp e                      ; dy < dx ?
   jr c, lupx

.lupy

   ld b,a                    ; count = dy
   srl a                     ; /2 -> overflow

.lupy1

   push af
   push bc
   push de
   push hl
   call vz_plot_callee + ASMDISP_VZ_PLOT_CALLEE
   pop hl
   pop de
   pop bc
   pop af

   dec b                     ; done?
   ret m

   dec h                     ; y--
   sub e                     ; overflow -= dx
   jr nc, lupy1

   inc l                     ; x++
   add a,d                   ; overflow += dy
   jp lupy1

.lupx

   ld a,e                    ; get dx
   ld b,a                    ; count = dx
   srl a                     ; /2 -> overflow

.lupx1

   push af
   push bc
   push de
   push hl
   call vz_plot_callee + ASMDISP_VZ_PLOT_CALLEE
   pop hl
   pop de
   pop bc
   pop af
   
   dec b                     ; done?
   ret m

   inc l                     ; x++
   sub d                     ; overflow -= dy
   jr nc, lupx1

   dec h                     ; y--
   add a,e                   ; overflow += dx
   jp lupx1

DEFC ASMDISP_VZ_LINE_CALLEE = # asmentry - vz_line_callee

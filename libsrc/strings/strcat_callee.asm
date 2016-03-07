; char __CALLEE__ *strcat_callee(char *dst, char *src)
; copy src to end of dst
; 12.2006 aralbrec

SECTION code_clib
PUBLIC strcat_callee
PUBLIC _strcat_callee
PUBLIC ASMDISP_STRCAT_CALLEE
EXTERN     rcmx_cpir


.strcat_callee
._strcat_callee

   pop hl
   pop de
   ex (sp),hl
   
   ; enter : de = char *src
   ;         hl = char *dst
   ; exit  : hl = char *dst
   ; uses  : af, bc, de
   
.asmentry

   push hl                   ; save char *dst
   
   xor a                     ; first find end of char *dst
   ld c,a
   ld b,a
   cpir
   dec hl
   
   ex de,hl
   
.loop                        ; next copy char *src to end of char *dst

   ld a,(hl)
   ldi
   or a
   jp nz, loop
   
   pop hl                    ; return with hl = char *s
   ret

DEFC ASMDISP_STRCAT_CALLEE = # asmentry - strcat_callee

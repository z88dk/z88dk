; char __CALLEE__ *strcmp_callee(char *s1, char *s2)
; compare strings s1 and s2
;
; Apr 25 1999 djm - Previously would return non
;  zero if the two strings matched (it ignored
;  the \0 at the end!) 
; 
; Jan 12 2002 Graham R. Cobb - Rewritten, 
;  previously strcmp("A","AB") would return 0. 
; 
; Mar 24 2002 Graham R. Cobb - Fix to above. 
;  Make sure positive return really is > 0 (not = 0) 
; 
; Jun 09 2002 Benjamin Green - Use CPI and
;  rearrange loop slightly 
;
; Dec 30 2006 aralbrec - Stop using cpi as that
;  is slower than cp (hl) + inc hl combination!

SECTION code_clib
PUBLIC strcmp_callee
PUBLIC _strcmp_callee
PUBLIC strcmp1

.strcmp_callee
._strcmp_callee

   pop hl
   pop de
   ex (sp),hl
   
   ; enter : hl = char *s1
   ;         de = char *s2
   ; exit : if s1==s2 : hl = 0, Z flag set
   ;        if s1<<s2 : hl < 0, NC+NZ flag set
   ;        if s1>>s2 : hl > 0, C+NZ flag set
   ; uses : af, de, hl

.asmentry
.strcmp1         

   ld a,(de)	
   cp (hl)                   ; compare with s1       
   jr nz,strcmp2

   inc de
   inc hl
   
   and a                     ; check for end of strings         
   jp nz, strcmp1
   
   ld l,a                    ; both strings ended simultaneously	
   ld h,a                    ; it's a match!
   ret 
   
.strcmp2                     ; strings are different

   ld h,$80 	
   ret nc 
   
   dec h 	
   ret


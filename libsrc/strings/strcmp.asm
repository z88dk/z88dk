; char *strcmp(char *s1, char *s2)
; compare strings s1 and s2

; Fixed djm 25/4/99 Previously would return non zero if the two 
; strings matched (it ignored the \0 at the end!) 
; 
; Rewritten Graham R. Cobb 12 January 2002 
; Previously strcmp("A","AB") would return 0. 
; 
; Fix to above fix: Graham R. Cobb 24 March 2002 
; Make sure positive return really is > 0 (not = 0) 
; 
; Incorporate optimisation suggested by Benjamin Green 9 June 2002 
; Use CPI and rearrange loop slightly 
;
; 12.2006 aralbrec - stop using cpi as that is slower than
; cp (hl) + inc hl combination

; exit : if s1==s2 : hl = 0, Z flag set
;        if s1<<s2 : hl < 0, NC flag set
;        if s1>>s2 : hl > 0, C flag set
; uses : asm : af, de, hl
;          c : af, bc, de, hl

XLIB strcmp  
XDEF ASMDISP_STRCMP

.strcmp

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

   ; de = char *s2
   ; hl = char *s1

.asmentry
.strcmp1         

   ld      a,(de)	
   
   ; Next char from s2         
   
   inc	de                   ; Ready for next char
   cp (hl)                   ; Compare with s1       
   jr      nz,strcmp2        ; Different!
   inc hl        
   and     a                 ; Check for end of strings         
   jp      nz,strcmp1        ; Round again 
   
   ; Both strings ended simultaneously  
   ; now we know *s1=*s2=0, return hl=0 	
   
   ld	l,a 	
   ld	h,a 	
   ret 
   
.strcmp2 

   ; At this point we know the two strings are different 
   ; The different byte may be within the string or may be the null 
   ; terminator for one of the strings -- it doesn't matter 	
   
   ld	h,$80 	
   ret	nc 
   
   ; OK, so now we know *s1 > *s2, return h=$7F (i.e. hl>0) 	
   
   dec	h 	
   ret

DEFC ASMDISP_STRCMP = asmentry - strcmp

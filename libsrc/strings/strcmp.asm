;
; Small C z88 String functions
;
; Compare strings:  s1>s2: >0 s1==s2: 0 s1<s2: <0
;
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
; $Id: strcmp.asm,v 1.5 2002-06-09 13:42:30 dom Exp $



                XLIB    strcmp

;strncmp(s1,s2) char *s1, *s2
;Stack on entry runs..
;return address, s2, s1


.strcmp
        ld      hl,2   
        add     hl,sp
        ld      e,(hl)  
        inc     hl
        ld      d,(hl)  ;de=s2
        inc     hl
        ld      a,(hl)
        inc     hl
        ld      h,(hl)  
        ld      l,a     ;hl=s1
.strcmp1
        ld      a,(de)	; Next char from s2
        inc	de	; Ready for next char
        cpi     	; Compare with s1 (and inc hl) -- does not set C flag
        jr      nz,strcmp2 ; Different!
        and     a	; Check for end of strings
        jr      nz,strcmp1 ; Round again
; Both strings ended simultaneously 
; now we know *s1=*s2=0, return hl=0
	ld	l,a
	ld	h,a
	ret
.strcmp2
; At this point we know the two strings are different
; The different byte may be within the string or may be the null
; terminator for one of the strings -- it doesn't matter
	dec	hl	; Undo inc hl done by CPI
	cp	(hl)	; Need to set C flag
; Assume *s1 < *s2: return h=$80 (i.e. hl<0)
	ld	h,$80
	ret	nc
; OK, so now we know *s1 > *s2, return h=$7F (i.e. hl>0)
	dec	h
	ret

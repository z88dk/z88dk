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
; $Id: strcmp.asm,v 1.3 2002-01-14 09:56:12 dom Exp $



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
        cp      (hl)	; Compare with s1
        jr      nz,strcmp2 ; Different!
        and     a	; Check for end of strings
        jr      z,strcmp4 ; Both strings ended simultaneously 
        inc     hl
        inc     de
        jp      strcmp1
.strcmp2
; At this point we know the two strings are different
; The different byte may be within the string or may be the null
; terminator for one of the strings -- it doesn't matter
	jr	c,strcmp5 ; jump if *s2 < *s1
; so we know *s1 < *s2, return h=$80 (i.e. hl<0)
	ld	h,$80
	ret
.strcmp5
; now we know *s1 > *s2, return h=0 (i.e. hl>0)
	ld	h,0
	ret
.strcmp4
; now we know *s1=*s2=0, return hl=0
	ld	l,a
	ld	h,a
	ret

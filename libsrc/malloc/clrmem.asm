;
;        Small C+ Library
; 
;       More Memory Functions
; 
;       Added to Small C+ 12/3/99 djm
; 
;       This one is writ by me!
; 
; 
;       void clrmem(void *addr, int size)
; 
;       Allocate memory for numsize and clear it (set to 0)
;
;
; $Id: clrmem.asm,v 1.3 2002-05-11 20:57:22 dom Exp $
;


                XLIB    clrmem

; Entry bc = length de = heap
.clrmem
        ld      a,b
        or      c
        ret     z       ;so no duff stuff!
        ld      l,e
        ld      h,d
        inc     de
        ld      (hl),0
        dec     bc
        ld      a,b
        or      c
        ret     z
        ldir            ;quick'n'easy
        ret
        

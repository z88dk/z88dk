;
; Small C z88 Character functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 22 August 1998
;

                XLIB    isspace


;isspace (c) char c
;return address, c

.isspace
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        ld      hl,1
        cp      32      ;space
        ret     z
        cp      7       ;tab
        ret     z
        cp      10      ;LF
        ret     z
        cp      13      ;CR
        ret     z
        dec     hl
        ret

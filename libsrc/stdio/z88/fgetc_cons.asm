;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>
;
;22/3/2000 - This was getkey() renamed to getchar
;
;1/4/2000  - Renamed to fgetc_cons

                INCLUDE "#stdio.def"

                XLIB    fgetc_cons
                LIB     getcmd  ;process command sequence


.fgetc_cons
.gkloop
        call_oz(os_in)
        jr      c,gkloop
        and     a
        jp      z,getcmd
        ld      l,a
        ld      h,0
        ret


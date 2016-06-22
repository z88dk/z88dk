;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double amin(double x,double y)  
;y is in the FA
;x is on the stack +8 (+2=y) 
;
;returns the larger of x and y

                SECTION  code_fp
                INCLUDE  "fpp.def"

                PUBLIC    amax

                EXTERN	fsetup
                EXTERN	stkequ2
                EXTERN    fa


.amax
        ld      ix,8
        add     ix,sp
        ld      l,(ix+1)
        ld      h,(ix+2)
        ld      de,(fa+1)
        exx                     ;main set
        ld      c,(ix+5)
        ld      l,(ix+3)
        ld      h,(ix+4)
        ld      de,(fa+3)
        ld      a,(fa+5)
        ld      b,a
        push    ix
        fpp(FP_CMP)     ;sets: de=y hl=x
        pop     ix
        ret     p       ;de > hl, so okay..
        ld      l,(ix+1)
        ld      h,(ix+2)
        exx
        ld      c,(ix+5)
        ld      l,(ix+3)
        ld      h,(ix+4)
        jp      stkequ2


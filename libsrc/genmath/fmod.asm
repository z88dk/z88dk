;
;
;       Generic Maths Library
;
;       Small C+ Library
;
;       Found this one about 7/12/98 djm
;
;       Don't know if it works correctly..let me know!


                XLIB    fmod
                XREF    pushfa
                XREF    fdiv
                XREF    floor
                XREF    fsub
		XREF	fmul


;
;       fmod(z,x) = z-x*floor(z/x)
;               if x>0 then  0 <= fmod(z,x) < x
;               if x<0 then  x < fmod(z,x) <= 0
;


.FMOD   POP     HL      ;return addr
        POP     DE      ;discard next number
        POP     DE      ; (already in FA)
        POP     DE
        POP     DE      ;fetch next number
        POP     IX      ; (1st operand, or "z")
        POP     BC
        PUSH    DE      ;restore stack
        PUSH    DE
        PUSH    DE
        PUSH    DE
        PUSH    DE
        PUSH    DE
        PUSH    HL      ;replace return addr
        PUSH    DE      ;save another copy of z
        PUSH    IX
        PUSH    BC
        CALL    PUSHFA  ;save a copy of 2nd operand ("x")
        CALL    FDIV    ;z/x
        CALL    FLOOR  ;floor(z/x)
        POP     BC
        POP     IX
        POP     DE
        CALL    FMUL    ;x*floor(z/x)
        POP     BC
        POP     IX
        POP     DE
;               to find mod(z,x)=z-x*floor(z/x), fall into...
        jp      FSUB



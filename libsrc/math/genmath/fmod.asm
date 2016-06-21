;
;
;       Generic Maths Library
;
;       Small C+ Library
;
;       Found this one about 7/12/98 djm
;
;       Don't know if it works correctly..let me know!


        SECTION code_fp
        PUBLIC    fmod
        EXTERN	pushfa
        EXTERN	fdiv
        EXTERN	floor
        EXTERN	fsub
        EXTERN	fmul


;
;       fmod(z,x) = z-x*floor(z/x)
;               if x>0 then  0 <= fmod(z,x) < x
;               if x<0 then  x < fmod(z,x) <= 0
;


.fmod   POP     HL      ;return addr
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
        CALL    pushfa  ;save a copy of 2nd operand ("x")
        CALL    fdiv    ;z/x
        CALL    floor  ;floor(z/x)
        POP     BC
        POP     IX
        POP     DE
        CALL    fmul    ;x*floor(z/x)
        POP     BC
        POP     IX
        POP     DE
;               to find mod(z,x)=z-x*floor(z/x), fall into...
        jp      fsub



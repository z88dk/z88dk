;
;
;       C Interface for Z88 Math Functions
;
;       These are very similar to the functions used by 
;       the generic routines - I've tried to keep as much as 
;       possible the same..
;
;       6/12/98
;
;
;       Most routines enter with one number on the stack and the
;       other kept in FA...FA+5
;
;       Of interest to use is FA+1 -> FA+4
;       FA5 is the exponent and FA4 is the MSB (with sign)


                INCLUDE "#fpp.def"

                LIB     fsetup

                XDEF    stkequ2
                XDEF    stkequ
                XDEF    dsub
                XDEF    dadd
                XDEF    dmul
                XDEF    ddiv
                XDEF    dge
                XDEF    dgt
                XDEF    dleq
                XDEF    dlt
                XDEF    deq
                XDEF    dne
                LIB     minusfa



; Subtract FA from value under stack
; divide value on stack by fa


; Store the FP number in FA after executing a routine

.stkequ2
        ld      (fa+3),hl
        ld      a,c
        ld      (fa+5),a
        exx
        ld      (fa+1),a
        xor     a
        ld      (fa),a
        ret

;Equalise the stack, and put the calculated value into FA

.stkequ
        ld      (fa+3),hl
        ld      a,c
        ld      (fa+5),a
        exx
        ld      (fa+1),hl
        xor     a
        ld      (fa),a
        pop     hl      ;ret to program
        pop     bc      ;get rid of fp number
        pop     bc
        pop     bc
        jp      (hl)    ;outa here back to program


;       Subtract FA from value on stack

.dsub
        call    fsetup
        fpp(FP_SUB)
        jr      stkequ

.dadd
        call    fsetup
        fpp(FP_ADD)
        jr      stkequ

.dmul
        call    fsetup
        fpp(FP_MUL)
        jr      stkequ

.ddiv
        call    fsetup
        fpp(FP_DIV)
        jr      stkequ

;       Comparision functions now..
;
;       Remember TOS gets put into hlhlb set of registers..
;
;       Return 0=FALSE 1=TRUE
;              nc      c

;TOS >= FA?
.dge
        call fsetup
        fpp(FP_GEQ)
.stkequcmp
        pop     de      ;return address
        pop     bc      ;dump number..
        pop     bc
        pop     bc
        push    de      ;put it back
        ld      a,h
        or      l       ;sets nc
        ret     z       
        ld      hl,1
        scf
        ret

;TOS > FA
.dgt
        call    fsetup
        fpp(FP_GT)
        jr      stkequcmp

;TOS <= FA?

.dleq
        call    fsetup
        fpp(FP_LEQ)
        jr      stkequcmp

;TOS < FA?
.dlt
        call    fsetup
        fpp(FP_LT)
        jr      stkequcmp


;TOS == FA?
.deq
        call    fsetup
        fpp(FP_EQ)
        jr      stkequcmp

;TOS != FA?

.dne
        call    fsetup
        fpp(FP_EQ)
;Invert the result, not particularly elegant, but it works!
        ex      de,hl
        ld      hl,0
        ld      a,e
        or      d
        jr      nz,stkequcmp
        inc     hl
        jr      stkequcmp








;       
;       Small C+ Compiler
;
;       The Maths Routines (essential ones!)
;
;       We have a set of generic files and then we have conditional
;       assembly to either pick up the Z88 math stubs or the
;       generic stubs..
;
;       NB. We have to remember to include the right library or all
;       hell well break out!
;
;       djm 7/12/98


        XDEF    fp_seed
        XDEF    extra
        XDEF    fa
        XDEF    fasign
;        XDEF    seed
        XDEF    dstore
        XDEF    dload
        XDEF    dldpsh
        XDEF    dpush
        XDEF    dpush2

        LIB     float
        LIB     ufloat
        LIB     ifix

;


;
;DIVZERO CALL   GRIPE
;        DEFB    'can''t /0',0
;OFLOW  CALL    GRIPE
;        DEFB    'Arithmetic overflow',0
;GRIPE  CALL    QERR    ;top word on stack points to message
;        JP      0       ;error was fatal
;
;       FA = (hl)
;

       ;(hl) = FA

.DSTORE LD      DE,FA
        LD      BC,6
        EX      DE,HL
        LDIR
        EX      DE,HL
        RET



.DLOAD
        LD      DE,FA
        LD      BC,6
        LDIR
        RET
;
;       load FA from (HL), and push FA onto stack
;
.DLDPSH
        LD      DE,FA
        LD      BC,6
        LDIR
;
;       push the floating point accumulator
;       (preserving return address)
;
.DPUSH
        POP     DE
        LD      HL,(FA+4)
        PUSH    HL
        LD      HL,(FA+2)
        PUSH    HL
        LD      HL,(FA)
        PUSH    HL
        EX      DE,HL
        JP      (HL)
;
;       push floating point accumulator
;       (preserve return address and next stacked word)
;
.DPUSH2 POP     DE      ;save return address
        POP     BC      ;save next word
        LD      HL,(FA+4)
        PUSH    HL
        LD      HL,(FA+2)
        PUSH    HL
        LD      HL,(FA)
        PUSH    HL
        EX      DE,HL
        PUSH    BC      ;restore next word
        JP      (HL)    ;return


; * * * * * HOPEFULLY THIS IS THE END OF THE GENERIC
; * * * * * ROUTINES NEEDED FOR BOTH mathz88 & genmath


IF NEED_mathz88
        INCLUDE "#mathz88.asm"
ELSE
        INCLUDE "#mathgen.asm"
ENDIF



;       Small C+ Math Library
;       tanh(x)
;       Compiled C hence hideous size!


        XLIB    sinh
        LIB    exp

	XREF	dldpsh
        XREF    dload
        XREF    dpush
        XREF    dstore
        LIB	ddiv
        LIB	dmul
        LIB	dsub
        LIB	dadd



.sinh 
        push    bc
        push    bc
        push    bc
        ld      hl,0
        add     hl,sp
        push    hl
        ld      hl,10
        add     hl,sp
        call    dldpsh
        call    exp
        pop     bc
        pop     bc
        pop     bc
        pop     hl
        call    dstore
        ld      hl,i_1+0
        call    dldpsh
        ld      hl,6
        add     hl,sp
        call    dldpsh
        ld      hl,i_1+6
        call    dldpsh
        ld      hl,18
        add     hl,sp
        call    dload
        call    ddiv
        call    dsub
        call    dmul
        pop     bc
        pop     bc
        pop     bc
        ret


.i_1 
        defb    0,0,0,0,0,-128,0,0,0,0
        defb    0,-127
        

        DEFVARS ASMPC
{
}

; --- End of Compilation ---

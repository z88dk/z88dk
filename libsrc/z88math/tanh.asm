;       Small C+ Math Library
;       tanh(x)
;       Compiled C hence hideous size!


        XLIB    tanh
        LIB    exp

        XREF    dload
        XREF    dpush
        XREF    dstore
        XREF    ddiv
        XREF    dadd
	XREF	dsub

.tanh 
        push    bc
        push    bc
        push    bc
        ld      hl,0
        add     hl,sp
        push    hl
        ld      hl,10
        add     hl,sp
        call    dload
        call    dpush
        call    exp
        pop     bc
        pop     bc
        pop     bc
        pop     hl
        call    dstore
        ld      hl,0
        add     hl,sp
        call    dload
        call    dpush
        ld      hl,i_1+0
        call    dload
        call    dpush
        ld      hl,12
        add     hl,sp
        call    dload
        call    ddiv
        call    dsub
        call    dpush
        ld      hl,6
        add     hl,sp
        call    dload
        call    dpush
        ld      hl,i_1+6
        call    dload
        call    dpush
        ld      hl,18
        add     hl,sp
        call    dload
        call    ddiv
        call    dadd
        call    ddiv
        pop     bc
        pop     bc
        pop     bc
        ret


.i_1 
        defb    0,0,0,0,0,-127,0,0,0,0
        defb    0,-127
        

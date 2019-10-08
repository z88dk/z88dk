;       Small C+ Math Library
;       sqrt(a) function, compiled C..hence the size!
;       Compiled using some inline optimizations (gchar etc)

;       Fine tuned by hand...so don't recompile!
;       Tuned to: only keep one zero constant
;       Pointer stuff made nicer..
;
;       But still not working!


        SECTION code_fp
        PUBLIC    sqrt

        EXTERN    dload
        EXTERN    dpush
        EXTERN    dstore
        EXTERN    dldpsh

        EXTERN     l_pint
        EXTERN     l_gint
        EXTERN     l_sxt
        EXTERN	ddiv
        EXTERN	dadd
        EXTERN	dleq
        EXTERN	dlt


.sqrt
        ld      hl,-12
        add     hl,sp
        ld      sp,hl
        ld      hl,14
        add     hl,sp
; call dload, dpush -> dldpsh
        call    dldpsh
        ld      hl,i_1+0
        call    dload
        call    dleq
        ld      a,h
        or      l
        jp      z,i_2
        ld      hl,i_1+0
        call    dload
        ld      hl,12
        add     hl,sp
        ld      sp,hl
        ret


.i_2
        ld      hl,4
        add     hl,sp
        push    hl
        ld      hl,16
        add     hl,sp
        pop     de
        call    l_pint
        ld      hl,6
        add     hl,sp
        pop     de
        pop     bc
        push    hl
        push    de
        ld      hl,6
        add     hl,sp
        push    hl
        ld      hl,i_1+6
        call    dload
        pop     hl
        call    dstore
;Fetch second into off stack optimized
        pop     bc
        pop     hl
        push    hl
        push    bc

        ld      de,5
        add     hl,de
        push    hl
        ld      hl,6
        add     hl,sp
        call    l_gint
        ld      de,5
        add     hl,de
        ld      a,(hl)
        call    l_sxt   ;sign extend
        rr      h
        rr      l
        ld      a,l
        xor     64
        pop     hl
        ld      (hl),a
        ld      hl,7
        pop     bc
        push    hl
.i_4
;Decrement int at top of stack (from j--)
        pop     hl
        dec     hl
        push    hl
        ld      a,h
        or      l
        jp      z,i_5
        ld      hl,6
        add     hl,sp
        push    hl              ;extra
; call dload, dpush -> dldpsh
        call    dldpsh
        ld      hl,22           ;x
        add     hl,sp
; call dload, dpush -> dldpsh
        call    dldpsh
        ld      hl,20           ;extra
        add     hl,sp
        call    dload
        call    ddiv            ;x/extra
        call    dadd            ;extra+fa
        pop     hl
        call    dstore
;divide by two
        pop     bc
        pop     hl
        push    hl
        push    bc
        ld      de,5
        add     hl,de
        dec     (hl)
        jp      i_4
.i_5
        ld      hl,6
        add     hl,sp
        call    dload
        ld      hl,12
        add     hl,sp
        ld      sp,hl
        ret

	SECTION rodata_clib
.i_1
        defb    0,0,0,0,0,0
        defb    18,-125,-64,-54,65,-128


;
;       Small C+ Compiler
;       
;       Long Support Library
;	"8080" mode
;
;       29/4/2002 - Stefano

;       This routine is used to push longs on the stack for a 
;       call to a function defined as a pointer.

                SECTION   code_crt0_sccz80
                PUBLIC lpush2

.lpush2 pop	bc
	ld	(retloc+1),bc
        pop     bc      ;save next item on stack
        push    de      ;dump our long
        push    hl
        push    bc      ;store back "next item on stack"
.retloc jp	0

;
;       Small C+ Compiler
;       
;       Long Support Library
;       "8080" mode
;
;       29/4/2002 - Stefano

;       This routine is used to push longs on the stack for a 
;       call to a function defined as a pointer.

SECTION code_crt0_sccz80

PUBLIC  lpush2
EXTERN  __retloc

.lpush2 
    ld      (__retloc),hl
    pop     hl      ;save next item on stack
    push    de      ;dump our long - MSW
    ex      de,hl   ;de is now return address
    ld      hl,(__retloc)
    push    hl
    ex      de,hl
    push    bc      ;store back "next item on stack"
    push    de
    ld      hl,(__retloc)
    ret

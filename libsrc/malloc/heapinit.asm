;
;       Small C+ Library Functions
;
;       Memory Functions
;
;       The routines in this directory are a little kludgey to say the
;       least, but at least they give you a heap from BBC BASIC
;
;       These routines were found on an MSX homepage from the net
;
;       Added to Z88dk archive 1/3/99
;
;       void initmem(size)
;
;
; $Id: heapinit.asm,v 1.3 2002-05-11 20:57:22 dom Exp $
;

                XLIB    heapinit 
                LIB     clrmem
                XREF    heapblocks
                XREF    heaplast
                XREF    _heap        ;the heap!

;
;       Initialise Memory
;

; Exit: hl=free memory

.heapinit
        pop     de
        pop     bc      ;heapsize
        push    bc 
        push    de
        push    bc      ;put size back on stack

        ld      de,_heap	;bc already holds size
        call    clrmem

        ld   hl,1
        ld   (HeapBlocks),hl    ; One free block fot starters
        ld   hl,_heap
        ld   (HeapLast),hl
        ld   (_heap),hl      ; First block points to itself
        pop     hl              ; heap size
        ld   (_heap+2),hl    ; Has size of whole heap
        ret

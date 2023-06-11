
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer

; It works only with a _heap pointer defined somewhere else in the crt0.
; Such (long) pointer will hold, at startup, the (word) value of __tail
; that points to the last used byte in the compiled program:

;IF DEFINED_USING_amalloc
;EXTERN __tail
;PUBLIC _heap
;._heap
;   defw __tail    ; Location of the last program byte
;   defw 0
;ENDIF


; $Id: amalloc.def,v 1.4 2016-07-14 17:44:17 pauloscustodio Exp $
IF DEFINED_USING_amalloc

IF CRT_MAX_HEAP_ADDRESS
    ld      hl,CRT_MAX_HEAP_ADDRESS
ELSE
    ld      hl,sp
ENDIF
    ; HL must hold SP or the end of free memory
    ex      de,hl

    ld      hl,_heap
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    inc     bc
    ; compact way to do "mallinit()"
    xor     a
    ld      (hl),a
    dec     hl
    ld      (hl),a

    ex      de,hl   ; sp or the end of free memory

IF __CPU_8085__
    sub     hl,bc   ; hl = total free memory
ELIF __CPU_8080__ || __CPU_GBZ80
    ld      a,l
    sub     c
    ld      l,a
    ld      a,h
    sbc     b
    ld      h,a
ELSE
    sbc     hl,bc   ; hl = total free memory
ENDIF

    ld      de,hl

IF __CPU_8085__
    sra     hl
    sra     hl
    ld      a,$3F
    and     h
    ld      h,a
    ex      de,hl
ELIF __CPU_8080__ || __CPU_GBZ80
    and     a
    ld      a,d
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a
    and     a
    ld      a,d
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a
ELSE
    srl     d
    rr      e
    srl     d
    rr      e
ENDIF

IF __CPU_INTEL__ || __CPU_GBZ80__

IF DEFINED_USING_amalloc_2
    ld      a,l     ;  leave 2/4 of the free memory for the stack
    sub     e
    ld      l,a
    ld      a,h
    sbc     d
    ld      h,a
IF DEFINED_USING_amalloc_1
    ld      a,l     ;  leave 3/4 of the free memory for the stack
    sub     e
    ld      l,a
    ld      a,h
    sbc     d
    ld      h,a
ENDIF
ENDIF
    ld      a,l     ;  leave 1/4 of the free memory for the stack
    sub     e
    ld      l,a
    ld      a,h
    sbc     d
    ld      h,a

ELSE

IF DEFINED_USING_amalloc_2
    sbc     hl,de   ;  leave 2/4 of the free memory for the stack
IF DEFINED_USING_amalloc_1
    sbc     hl,de   ;  leave 3/4 of the free memory for the stack
ENDIF
ENDIF
    sbc     hl,de   ;  leave 1/4 of the free memory for the stack

ENDIF

    push    bc      ; main address for malloc area
    push    hl      ; area size
    EXTERN  sbrk_callee
    call    sbrk_callee

ENDIF
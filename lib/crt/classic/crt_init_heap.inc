
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer

; It works only with a _heap pointer defined somewhere else in the crt0.
; Such (long) pointer will hold, at startup, the (word) value of __tail
; that points to the last used byte in the compiled program:

;IF DEFINED_CRT_HEAP_ENABLE
;EXTERN __tail
;PUBLIC _heap
;._heap
;   defw __tail    ; Location of the last program byte
;   defw 0
;ENDIF


MACRO MALLSUB_HLDE
  IF __CPU_INTEL__ || __CPU_GBZ80__
    ld      a,l     ;  leave 2/4 of the free memory for the stack
    sub     e
    ld      l,a
    ld      a,h
    sbc     d
    ld      h,a
  ELSE
    sbc     hl,de
  ENDIF
ENDM


IF DEFINED_CLIB_MALLOC_HEAP_SIZE && CLIB_MALLOC_HEAP_SIZE > 0
    ld      bc,__autoheap
    ld      hl,CLIB_MALLOC_HEAP_SIZE
    push    bc      ; main address for malloc area
    push    hl      ; area size
    EXTERN  sbrk_callee
    call    sbrk_callee
ELIF DEFINED_CRT_HEAP_ENABLE

  IF CRT_MAX_HEAP_ADDRESS
    ld      hl,CRT_MAX_HEAP_ADDRESS
    defc __crt_skip_heapsize_calcs = 1
  ELIFNDEF CRT_MAX_HEAP_ADDRESS_hl
    ld      hl,sp
  ELSE
    ;hl holds top address
    defc __crt_skip_heapsize_calcs = 1
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


  IFNDEF __crt_skip_heapsize_calcs
    ld      de,hl
; AMALLOC initialisation
; First of all find a 25% of the free memory
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


   ; Reduce to heap size to 75% of available memory
   MALLSUB_HLDE
   ; Reduce to 50% if needed
   IF CRT_HEAP_ENABLE & 2
   MALLSUB_HLDE
   ENDIF
  ; Reduce to 25% if needed
   IF CRT_HEAP_ENABLE & 4
   MALLSUB_HLDE
   ENDIF
  ENDIF
   
    push    bc      ; main address for malloc area
    push    hl      ; area size
    EXTERN  sbrk_callee
    call    sbrk_callee

ENDIF

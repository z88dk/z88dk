
; Heap setup. We have a few ways to setup the heap
;
; 1. -pragma-define:CLIB_MALLOC_HEAP_SIZE - creates a heap in BSS
; 2. -pragma-define:CRT_STACK_SIZE - leaves x for stack, rest is heap
; 3. -DAMALLOC etc - divides up the space. Last address either programmatic or defined by
; CRT_MAX_HEAP_ADDRESS
; 4. Some ports call in with fixed addresses to use
;
; For 2 and 3, heap runs from either _BSS_TAIL or CRT_HEAP_ADDRESS
;
; Note: This code must be called after crt0_init for two reasons:
; 1. The heap pointer is within bss (so would get wiped)
; 2. Some targets have a himem blob sitting after bss on load


MACRO MALLSUB_HLDE
  IF __CPU_INTEL__ || __CPU_GBZ80__
    ld      a,l
    sub     e
    ld      l,a
    ld      a,h
    sbc     d
    ld      h,a
  ELSE
    sbc     hl,de
  ENDIF
ENDM


IF __clib_malloc_heap_size > 0
    ;; The heap is in BSS section already, just need to register it
    ld      bc,__autoheap
    ld      hl,__clib_malloc_heap_size
    push    bc      ; main address for malloc area
    push    hl      ; area size
    EXTERN  sbrk_callee
    call    sbrk_callee
ELIF __crt_stack_size > 0
    ;; Support the newlib model where we set how much stack we want and then the rest is heap
    ld      hl,sp
    ld      de,__crt_stack_size
    and     a
    MALLSUB_HLDE
  IFDEF CRT_HEAP_ADDRESS
    ld      de,CRT_HEAP_ADDRESS
  ELSE
    ld      de,__BSS_END_tail
  ENDIF
    and     a
    MALLSUB_HLDE
    push    de      ; main address for malloc area
    push    hl      ; area size
    EXTERN  sbrk_callee
    call    sbrk_callee
ELIF DEFINED_CRT_HEAP_AMALLOC
  ;; -DAMALLOC handling 
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
  IFDEF CRT_HEAP_ADDRESS
    ld      bc,CRT_HEAP_ADDRESS
  ELSE
    ld      bc,__BSS_END_tail
  ENDIF

; hl = sp/end of heap
; bc = start of heap

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
   IF CRT_HEAP_AMALLOC & 2
   MALLSUB_HLDE
   ENDIF
  ; Reduce to 25% if needed
   IF CRT_HEAP_AMALLOC & 4
   MALLSUB_HLDE
   ENDIF
  ENDIF
   
    push    bc      ; main address for malloc area
    push    hl      ; area size
    EXTERN  sbrk_callee
    call    sbrk_callee

ENDIF

; Far heap set-up for the Rabbit crts.
;
; A far address is a physical address, so the far heap is a range of physical
; memory that nothing else uses. Include after the near heap is set up.
; Nothing is done unless a size is given:
;
;   CRT_RABBIT_FARHEAP_SIZE   size in bytes
;   CLIB_FARHEAP_BANKS        size in units of 16k, as on the other targets
;   CRT_RABBIT_FARHEAP_BASE   physical address of the start. The default is
;                             the first address after the code banks:
;                             0x10000 + CRT_RABBIT_BANKS * 0x2000
;
; sbrk_far() takes at most 64k, so a bigger heap is added in chunks of 64k,
; up to 64 of them (4MB). The Rabbit 2000 and 3000 reach the first 1MB, the
; Rabbit 4000 and later 16MB.

IF __CPU_RABBIT__

  IFDEF CRT_RABBIT_FARHEAP_SIZE
    defc    __rabbit_farheap_size = CRT_RABBIT_FARHEAP_SIZE
  ELIF DEFINED_CLIB_FARHEAP_BANKS
    defc    __rabbit_farheap_size = CLIB_FARHEAP_BANKS * 16384
  ELSE
    defc    __rabbit_farheap_size = 0
  ENDIF

  IFDEF CRT_RABBIT_FARHEAP_BASE
    defc    __rabbit_farheap_base = CRT_RABBIT_FARHEAP_BASE
  ELIF DEFINED_CRT_RABBIT_BANKS
    defc    __rabbit_farheap_base = 0x10000 + CRT_RABBIT_BANKS * 0x2000
  ELSE
    defc    __rabbit_farheap_base = 0x10000
  ENDIF

  IF __rabbit_farheap_size > 0
    EXTERN  sbrk_far

    ; Add chunk n of the heap, if the heap is that big
    MACRO RABBIT_FARHEAP_CHUNK n
      IF __rabbit_farheap_size > (n * 0x10000)
        ld      de,((__rabbit_farheap_base + n * 0x10000) / 65536) & 0xffff
        ld      hl,(__rabbit_farheap_base + n * 0x10000) & 0xffff
        push    de
        push    hl                  ; ptr
        ld      bc,(__rabbit_farheap_size - n * 0x10000 > 0xffff) ? 0xffff : (__rabbit_farheap_size - n * 0x10000)
        push    bc                  ; len
        call    sbrk_far
        pop     af
        pop     af
        pop     af
      ENDIF
    ENDM

    RABBIT_FARHEAP_CHUNK 0
    RABBIT_FARHEAP_CHUNK 1
    RABBIT_FARHEAP_CHUNK 2
    RABBIT_FARHEAP_CHUNK 3
    RABBIT_FARHEAP_CHUNK 4
    RABBIT_FARHEAP_CHUNK 5
    RABBIT_FARHEAP_CHUNK 6
    RABBIT_FARHEAP_CHUNK 7
    RABBIT_FARHEAP_CHUNK 8
    RABBIT_FARHEAP_CHUNK 9
    RABBIT_FARHEAP_CHUNK 10
    RABBIT_FARHEAP_CHUNK 11
    RABBIT_FARHEAP_CHUNK 12
    RABBIT_FARHEAP_CHUNK 13
    RABBIT_FARHEAP_CHUNK 14
    RABBIT_FARHEAP_CHUNK 15
    RABBIT_FARHEAP_CHUNK 16
    RABBIT_FARHEAP_CHUNK 17
    RABBIT_FARHEAP_CHUNK 18
    RABBIT_FARHEAP_CHUNK 19
    RABBIT_FARHEAP_CHUNK 20
    RABBIT_FARHEAP_CHUNK 21
    RABBIT_FARHEAP_CHUNK 22
    RABBIT_FARHEAP_CHUNK 23
    RABBIT_FARHEAP_CHUNK 24
    RABBIT_FARHEAP_CHUNK 25
    RABBIT_FARHEAP_CHUNK 26
    RABBIT_FARHEAP_CHUNK 27
    RABBIT_FARHEAP_CHUNK 28
    RABBIT_FARHEAP_CHUNK 29
    RABBIT_FARHEAP_CHUNK 30
    RABBIT_FARHEAP_CHUNK 31
    RABBIT_FARHEAP_CHUNK 32
    RABBIT_FARHEAP_CHUNK 33
    RABBIT_FARHEAP_CHUNK 34
    RABBIT_FARHEAP_CHUNK 35
    RABBIT_FARHEAP_CHUNK 36
    RABBIT_FARHEAP_CHUNK 37
    RABBIT_FARHEAP_CHUNK 38
    RABBIT_FARHEAP_CHUNK 39
    RABBIT_FARHEAP_CHUNK 40
    RABBIT_FARHEAP_CHUNK 41
    RABBIT_FARHEAP_CHUNK 42
    RABBIT_FARHEAP_CHUNK 43
    RABBIT_FARHEAP_CHUNK 44
    RABBIT_FARHEAP_CHUNK 45
    RABBIT_FARHEAP_CHUNK 46
    RABBIT_FARHEAP_CHUNK 47
    RABBIT_FARHEAP_CHUNK 48
    RABBIT_FARHEAP_CHUNK 49
    RABBIT_FARHEAP_CHUNK 50
    RABBIT_FARHEAP_CHUNK 51
    RABBIT_FARHEAP_CHUNK 52
    RABBIT_FARHEAP_CHUNK 53
    RABBIT_FARHEAP_CHUNK 54
    RABBIT_FARHEAP_CHUNK 55
    RABBIT_FARHEAP_CHUNK 56
    RABBIT_FARHEAP_CHUNK 57
    RABBIT_FARHEAP_CHUNK 58
    RABBIT_FARHEAP_CHUNK 59
    RABBIT_FARHEAP_CHUNK 60
    RABBIT_FARHEAP_CHUNK 61
    RABBIT_FARHEAP_CHUNK 62
    RABBIT_FARHEAP_CHUNK 63
  ENDIF

ENDIF

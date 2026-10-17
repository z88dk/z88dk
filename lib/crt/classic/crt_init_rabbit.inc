; Rabbit start-up common to every Rabbit crt0.
;
; Include before the stack is set up: a changed memory map must not move
; the code or the stack the crt is running from. Keep the crt in the root
; segment.
;
; Optional pragmas, each written only when defined:
;   CRT_RABBIT_DATASEG   DATASEG  (0x12)  physical offset of the data segment, 4k units
;   CRT_RABBIT_STACKSEG  STACKSEG (0x11)  physical offset of the stack segment, 4k units
;                        (R4K and later: 12 bits, via DATSEGL/H and STKSEGL/H)
;   CRT_RABBIT_SEGSIZE   SEGSIZE  (0x13)  bits 7:4 stack segment start, 3:0 data segment start
;   CRT_RABBIT_MB0CR..MB3CR       (0x14..0x17) memory bank control
;   CRT_RABBIT_XPC       XPC      initial window page (bank * 2)
; Without any of them only the R4K+ mode switch is emitted.

IF __CPU_RABBIT__

  IF __CPU_R4K__ || __CPU_R5K__ || __CPU_R6K__
    ; Enable R4K instruction mode (EDMR)
    ld      a,$c0
    ioi ld  ($0420),a
  ENDIF

  IFDEF CRT_RABBIT_MB0CR
    ld      a,CRT_RABBIT_MB0CR
    ioi ld  ($0014),a
  ENDIF
  IFDEF CRT_RABBIT_MB1CR
    ld      a,CRT_RABBIT_MB1CR
    ioi ld  ($0015),a
  ENDIF
  IFDEF CRT_RABBIT_MB2CR
    ld      a,CRT_RABBIT_MB2CR
    ioi ld  ($0016),a
  ENDIF
  IFDEF CRT_RABBIT_MB3CR
    ld      a,CRT_RABBIT_MB3CR
    ioi ld  ($0017),a
  ENDIF

  IF __CPU_R4K__ || __CPU_R5K__ || __CPU_R6K__
    ; 12 bit segment offsets: low byte and high nibble registers
    IFDEF CRT_RABBIT_DATASEG
      ld      a,CRT_RABBIT_DATASEG % 256
      ioi ld  ($001e),a
      ld      a,(CRT_RABBIT_DATASEG / 256) % 16
      ioi ld  ($001f),a
    ENDIF
    IFDEF CRT_RABBIT_STACKSEG
      ld      a,CRT_RABBIT_STACKSEG % 256
      ioi ld  ($001a),a
      ld      a,(CRT_RABBIT_STACKSEG / 256) % 16
      ioi ld  ($001b),a
    ENDIF
  ELSE
    IFDEF CRT_RABBIT_DATASEG
      ld      a,CRT_RABBIT_DATASEG
      ioi ld  ($0012),a
    ENDIF
    IFDEF CRT_RABBIT_STACKSEG
      ld      a,CRT_RABBIT_STACKSEG
      ioi ld  ($0011),a
    ENDIF
  ENDIF
  ; SEGSIZE last, so the segments move once their offsets are set
  IFDEF CRT_RABBIT_SEGSIZE
    ld      a,CRT_RABBIT_SEGSIZE
    ioi ld  ($0013),a
  ENDIF

  IFDEF CRT_RABBIT_XPC
    ld      a,CRT_RABBIT_XPC
    ld      xpc,a
  ENDIF

ENDIF

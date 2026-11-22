; Define the low memory for builds that start at 0x0000
;
; Allow overriding of:
; - All rsts
; - (including im1)
; - NMI (not 808x)

        defs    $0008-ASMPC
if (ASMPC<>$0008)
        defs    CODE_ALIGNMENT_ERROR
endif

IF ((__crt_enable_rst & $02) = $02)
    IF ((__crt_enable_rst & $0202) = $0002)
        EXTERN  _z80_rst_08h
    ENDIF
	jp	_z80_rst_08h
ELSE
        ret
ENDIF

        defs    $0010-ASMPC
if (ASMPC<>$0010)
        defs    CODE_ALIGNMENT_ERROR
endif

IF ((__crt_enable_rst & $04) = $04)
    IF ((__crt_enable_rst & $0404) = $0004)
        EXTERN  _z80_rst_10h
    ENDIF
        jp      _z80_rst_10h
ELSE
        ret
ENDIF
        defs    $0018-ASMPC
if (ASMPC<>$0018)
        defs    CODE_ALIGNMENT_ERROR
endif
IF ((__crt_enable_rst & $08) = $08)
    IF ((__crt_enable_rst & $0808) = $0008)
        EXTERN  _z80_rst_18h
    ENDIF
        jp      _z80_rst_18h
ELSE
        ret
ENDIF

        defs    $0020-ASMPC
if (ASMPC<>$0020)
        defs    CODE_ALIGNMENT_ERROR
endif
IF ((__crt_enable_rst & $10) = $10)
    IF ((__crt_enable_rst & $1010) = $0010)
        EXTERN  _z80_rst_20h
    ENDIF
        jp      _z80_rst_20h
ELSE
        ret
ENDIF

IF __CPU_8085__
    ; address = 0x0024
        defs        $0024-ASMPC
  if (ASMPC<>$0024)
        defs    CODE_ALIGNMENT_ERROR
  endif

  IF (CRT_ENABLE_TRAP = 1)
        EXTERN _8085_trap
        jp     _8085_trap
  ELIF (CRT_ENABLE_TRAP > 1)
        jp     __8085_trap
  ELSE
        ret
  ENDIF
ENDIF


        defs        $0028-ASMPC
if (ASMPC<>$0028)
        defs    CODE_ALIGNMENT_ERROR
endif

IF ((__crt_enable_rst & $20) = $20)
    IF ((__crt_enable_rst & $2020) = $0020)
        EXTERN  _z80_rst_28h
    ENDIF
        jp      _z80_rst_28h
ELSE
        ret
ENDIF


IF __CPU_8085__
        defs        $002c-ASMPC
  if (ASMPC<>$002c)
        defs        CODE_ALIGNMENT_ERROR
  endif

  IF (CRT_ENABLE_INT55 = 1)

        EXTERN _i8085_int55
        jp     _i8085_int55
  ELIF (CRT_ENABLE_INT55 > 1)
        jp    __i8085_int55
  ELSE
        ei
        ret
  ENDIF
ELIFDEF CRT_NSC800_RSTC
        defs        $002c-ASMPC
  if (ASMPC<>$002c)
        defs        CODE_ALIGNMENT_ERROR
  endif
  IF (CRT_NSC800_RSTC = 1)
        EXTERN _nsc800_rstc
        jp     _nsc800_rstc
  ELIF (CRT_NSC800_RSTC > 1)
        jp    _nsc800_rstc
  ELSE
        ei
        ret
  ENDIF
ENDIF


        defs    $0030-ASMPC
if (ASMPC<>$0030)
        defs    CODE_ALIGNMENT_ERROR
endif

IF ((__crt_enable_rst & $40) = $40)
    IF ((__crt_enable_rst & $4040) = $0040)
        EXTERN  _z80_rst_30h
    ENDIF
        jp      _z80_rst_30h
ELSE
        ret
ENDIF


IF __CPU_8085__
        defs        $0034-ASMPC
  if (ASMPC<>$0034)
        defs        CODE_ALIGNMENT_ERROR
  endif

  IF (CRT_ENABLE_INT65 = 1)
        EXTERN _i8085_int65
        jp     _i8085_int65
  ELIF (CRT_ENABLE_INT65 > 1)
        jp    __i8085_int65
  ELSE
        ei
        ret
  ENDIF
ELIFDEF CRT_NSC800_RSTB
        defs        $0034-ASMPC
  if (ASMPC<>$0034)
        defs        CODE_ALIGNMENT_ERROR
  endif
  IF (CRT_NSC800_RSTB = 1)
        EXTERN _nsc800_rstb
        jp     _nsc800_rstb
  ELIF (CRT_NSC800_RSTB > 1)
        jp    _nsc800_rstb
  ELSE
        ei
        ret
  ENDIF
ENDIF


        defs    $0038-ASMPC
if (ASMPC<>$0038)
        defs    CODE_ALIGNMENT_ERROR
endif

IF ((__crt_enable_rst & $80) = $80)
    IF ((__crt_enable_rst & $8080) = $0080)
        EXTERN  _z80_rst_38h
    ENDIF
        jp      _z80_rst_38h
ELSE
  IF __CPU_RABBIT__
        ipres
  ELSE
	ei
  ENDIF
  IF __CPU_INTEL__
  	ret
  ELSE
        reti
  ENDIF
ENDIF

IF __CPU_8085__
        defs        $003c-ASMPC
  if (ASMPC<>$003c)
        defs        CODE_ALIGNMENT_ERROR
  endif

  IF (CRT_ENABLE_INT75 = 1)

        EXTERN _i8085_int75
        jp     _i8085_int75
  ELIF (CRT_ENABLE_INT75 > 1)
        jp    __i8085_int75
  ELSE
        ei
        ret
  ENDIF
ELIFDEF CRT_NSC800_RSTA
        defs        $003c-ASMPC
  if (ASMPC<>$003c)
        defs        CODE_ALIGNMENT_ERROR
  endif
  IF (CRT_NSC800_RSTA = 1)
        EXTERN _nsc800_rsta
        jp     _nsc800_rsta
  ELIF (CRT_NSC800_RSTA > 1)
        jp    _nsc800_rsta
  ELSE
        ei
        ret
  ENDIF
ENDIF

IF !__CPU_INTEL__
  IF __crt_enable_nmi != 0
        defs    $0066-ASMPC
    IF (ASMPC<>$0066)
        defs    CODE_ALIGNMENT_ERROR
    ENDIF
    IF (__crt_enable_nmi > 1)
        EXTERN _z80_nmi
        jp _z80_nmi
    ELSE
      IF (__crt_enable_nmi = 1)
        jp _z80_nmi
      ELSE
       IF __CPU_RABBIT__
        ret
       ELSE
        retn
       ENDIF
      ENDIF
    ENDIF
  ENDIF
ENDIF

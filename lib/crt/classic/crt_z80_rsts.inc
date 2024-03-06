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

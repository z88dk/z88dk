
SECTION bss_fp_mbf32

PUBLIC  FPREG
PUBLIC  FPEXP
PUBLIC  SGNRES
PUBLIC  FPSIGN
PUBLIC  VALTYP
PUBLIC  SEED
PUBLIC  LSTRND

FPREG:
    defb    0
    defb    0
    defb    0
FPEXP:
    defb    0
SGNRES:
FPSIGN:
    defb    0
VALTYP:
    defb    0
SEED:
    defs    4
LSTRND:
    defs    4

IF __CPU_GBZ80__
    PUBLIC  ___mbf32_savea
    ___mbf32_savea:
        defb    0
ENDIF

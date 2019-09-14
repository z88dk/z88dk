
    SECTION code_fp_math32
    PUBLIC  floor

IF __CLASSIC
    EXTERN  cm32_sccz80_floor
    defc    floor = cm32_sccz80_floor

    ; SDCC bridge for Classic
    PUBLIC  _floor
    defc    _floor = floor
ELSE
    EXTERN  m32_floor_fastcall
    defc    floor = m32_floor_fastcall
ENDIF

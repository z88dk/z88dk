SECTION   code_fp_math32
PUBLIC    floor
EXTERN    _m32_floorf

IFNDEF __CLASSIC
defc   floor = _m32_floorf
ELSE

; Classic has a non-fastcall implementation

floor:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_floorf

; SDCC bridge for Classic
PUBLIC _floor
defc _floor = floor


; Clang bridge for Classic
PUBLIC _floorb
defc _floorb = floor

ENDIF

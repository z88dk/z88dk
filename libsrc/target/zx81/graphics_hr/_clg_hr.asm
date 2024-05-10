
    EXTERN  hr_rows

_clg_hr:
__clg_hr:
;----------------------------------------------------------------
;
; HRG_Tool_Clear
; hl = pointer to display array
;
; to fill hr_rows lines by 32 characters
; here we use the stack (!) to fill hr_rows x 8 x 16 words with push
;
;----------------------------------------------------------------

    ld      hl, (base_graphics)
    ld      a, (hr_rows)                ; 8, 24 or 48 (interlaced)

    ld      b, a                        ; * 256
    ld      c, 0
    add     hl, bc
    ld      (HRG_ClearSpReg), sp
    ld      sp, hl

    ld      hl, 0

    add     a                           ; 8, 24 or 48 (interlaced)
    add     a                           ; * 4
    ld      b, a

HRG_ClearLoop:
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    push    hl
    djnz    HRG_ClearLoop

    ld      sp, (HRG_ClearSpReg)

    ret

HRG_ClearSpReg:
    defw    0


; This is identical to l_cmp,
; but we need to have a moveable copy to deal with the video pages

        SECTION code_graphics

        PUBLIC  l_graphics_cmp

; signed compare of DE and HL
;   carry is sign of difference [set => DE < HL]
;   zero is zero/non-zero
l_graphics_cmp:
        ld      a, h
        add     $80
        ld      b, a
        ld      a, d
        add     $80
        cp      b
        ret     nz
        ld      a, e
        cp      l
        ret

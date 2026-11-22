
SECTION code_graphics

PUBLIC __aquarius_set_attribute

EXTERN __aquarius_attr
EXTERN xypos_BITMAP_ATTR

; Entry: VRAM paged in
;        b = character row
;        c = characer column
__aquarius_set_attribute:
    call    xypos_BITMAP_ATTR
    ld      a,(__aquarius_attr)
    ld      (hl),a
    ret


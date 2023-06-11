

SECTION code_video_vdp


PUBLIC __tms9918_text_cls
PUBLIC __tms9918_text_printc
PUBLIC __tms9918_text_scroll

EXTERN  __tms9918_pattern_name
EXTERN  LDIRMV
EXTERN  LDIRVM
EXTERN  FILVRM
EXTERN  __tms9918_scroll_buffer
EXTERN  __tms9918_text_xypos

EXTERN  __console_w
EXTERN  __console_h
EXTERN  l_mulu_16_8x8

__tms9918_text_cls:
    ld      hl,(__console_w)
    ld      e,h
    call    l_mulu_16_8x8
    ld      c,l
    ld      b,h
    ld      hl,(__tms9918_pattern_name)
    ld      a,32
    jp      FILVRM

; Entry: d = character
;        bc = xy coordinates
__tms9918_text_printc:
    push    de                ;Save character
    call    __tms9918_text_xypos
    pop     de
    ld      a,d
    ld      bc,1
    jp      FILVRM

__tms9918_text_scroll:
scroll_text:
    ld      bc,(__console_w)
    ld      b,0
    push    ix
    ld	    hl,(__tms9918_pattern_name)
    ld	    d,h
    ld	    e,l
    add	    hl,bc
    ld	    a,(__console_h)
    dec     a
scroll_text_1:
    push    af
    push    hl      ;Source
    push    de      ;Destination
    push	bc	;width
    ld      de,__tms9918_scroll_buffer
    call    LDIRMV
    pop	    bc
    pop     de
    push    de
    push	bc
    ld      hl,__tms9918_scroll_buffer
    call    LDIRVM
    pop	    bc	;width
    pop     de      ;Destination
    pop     hl
    add	    hl,bc
    ex	    de,hl
    add	    hl,bc
    ex	    de,hl
    pop     af
    dec	    a
    jr      nz,scroll_text_1
    ; And blank characters out
    push	bc		;width
    ld      a,(__console_h)
    dec     a
    ld      b,a
    ld      c,0
    call    __tms9918_text_xypos
    pop     bc
    ld      a,' '
    call    FILVRM
    pop     ix
    ret

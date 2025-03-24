;
; 	ANSI Video handling for the Sharp PC G-815
;
;	Stefano Bodrato - 2025
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char_815.asm $
;

    SECTION code_graphics

    EXTERN  __console_y
    EXTERN  __console_x
    EXTERN  _font_3x5_850

    EXTERN  plot
    EXTERN  unplot
    EXTERN  __graphics_end

    PUBLIC  ansi_CHAR

ansi_CHAR:

    sub     32
    ld      e,a

    ld      a, (__console_x)
    add     a
    add     a     ;x4
	inc     a               ; workaround to the current graphics bug on the 1st pixel column
    ld      (x_4x5),a
    ld      a, (__console_y)
    add     a
    ld      d,a
    add     a
    add     d     ; x6
    ld      (y_4x5),a


IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
ENDIF
IF  NEED_swapgfxbk=1
    call    swapgfxbk
ENDIF

    ld      d, 0    ; DE = current chr - 32

    ld      hl, _font_3x5_850
    add     hl, de
    add     hl, de
    add     hl, de                        ; x3

    ld      b, 3
rowloop:
    push    bc
    push    hl

    ld      a, (hl)

    ld      b, 5
    ld      c, a

    ld      a, (x_4x5)
    ld      d, 0
    ld      e, a

    ld      a, (y_4x5)
    ld      h, 0
    ld      l, a
colloop:
IF  __CPU_INTEL__
    ld      a, c
    rla
    ld      c, a
ELSE
    rr      c                           ; cy = pixel status
ENDIF
    push    bc
    push    de             ; x
    push    hl             ; y

    jr      nc, noplot
    call    plot
    jr      nores
noplot:
    call    unplot
nores:
    pop     hl
    inc     l
    pop     de

    pop     bc
    djnz    colloop

    ld      hl, x_4x5
    inc     (hl)

    pop     hl
    inc     hl         ; font ptr
    pop     bc
    djnz    rowloop


IF  NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF    !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF


    SECTION bss_graphics

x_4x5:  defb 0
y_4x5:  defb 0
chr:    defb 0


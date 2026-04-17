;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Copy a string to a BASIC variable
;
;	int __CALLEE__ zx_setstr_callee(char variable, char *value);
;
;
;	$Id: zx_setstr_callee.asm $
;

    SECTION code_clib
    PUBLIC  zx_setstr_callee
    PUBLIC  _zx_setstr_callee
    PUBLIC  asm_zx_setstr
    EXTERN  asctozx81

zx_setstr_callee:
_zx_setstr_callee:

    pop     bc
    pop     hl
    pop     de
    push    bc

; enter : hl = char *value
;          e = char variable

asm_zx_setstr:
    push    ix                          ;save callers ix (iy on zx81) - rom may corrupt it
    ld      a, e

    and     31
    add     69

    ld      d, a
    push    hl
    push    de

    ld      hl, ($4010)                 ; VARS

loop:

    ld      a, (hl)
    cp      128

    jr      z, store                    ; variable not found

morevar:

    cp      d
    jr      z, found

  IF    FORlambda
    EXTERN  __lambda_next_one
    call    __lambda_next_one
  ELSE
    call    $09F2                       ;get next variable start
  ENDIF
    ex      de, hl
    pop     de
    push    de
    jr      loop

found:
  IF    FORlambda
    EXTERN  __lambda_next_one
    call    __lambda_next_one
    EXTERN  __lambda_reclaim_space
    call    __lambda_reclaim_space
  ELSE
    call    $09F2                       ; get next variable start
    call    $0A60                       ; reclaim space (delete)
  ENDIF

store:

    pop     af                          ; swap var name and str. ptr into stack
    pop     de
    push    af
    push    de
    xor     a
    ld      b, a
    ld      c, a
    ex      de, hl
    cpir                                ; scan for zero
    ex      de, hl

    ld      a, b
    cpl
    ld      b, a
    ld      a, c
    cpl
    ld      c, a                        ; bc=str len

    push    hl
    push    bc
    inc     bc
    inc     bc
    inc     bc
  IF    FORlambda
    EXTERN  __lambda_make_room
    call    __lambda_make_room
  ELSE
    call    $099E                       ; MAKE-ROOM
  ENDIF
    pop     bc
    pop     hl

    pop     de                          ; get back str. ptr
    pop     af                          ; and var name
    ld      (hl), a
    inc     hl
    ld      (hl), c
    inc     hl
    ld      (hl), b

    ld      a, b                        ; handle 0 lenght strings (thank you Siggi!)
    or      c

    pop     ix

	ret     z
	
    inc     hl

    ex      de, hl
	;ldir
;-----------------------------
outloop:
    call    asctozx81
    ld      (de), a
    inc     hl
    inc     de
    dec     bc
    ld      a, b
    or      c
    jr      nz, outloop
;------------------------------

    ret


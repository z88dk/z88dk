;
;	Read character from console
;
;
;	int fgetc_cons()
;
;	djm 17/4/2000

;	On an nc100 we have to test for "yellow"

;
;	$Id: fgetc_cons.asm,v 1.4 2016-06-12 17:32:01 dom Exp $
;


    SECTION code_clib
    PUBLIC  fgetc_cons
    PUBLIC  _fgetc_cons
    PUBLIC  getk
    PUBLIC  _getk

    EXTERN  __Exit                   ;in crt0

getk:
_getk:
    call    $B9B3                       ;kmreadchar
    ld      hl, 0
    ret     nc                          ;no key pressed
    jr      normalise

fgetc_cons:
_fgetc_cons:
    call    $B9B3                       ;kmreadchar
    jr      nc, fgetc_cons              ;no key available...try again
    ld      a, b
    cp      3
    jr      z, fgetc_cons               ; timeout or unwanted chars ?
normalise:
  IF    STANDARDESCAPECHARS
    ld      a, c
    cp      13
    jr      nz, nocr
    ld      c, 10
nocr:
  ENDIF
    ld      l, c
    ld      h, b
    ld      a,b
    and     a
    ret     z                           ;no token
    sub     2
    ret     nz                          ;not b=2
    ld      h,0
    ld      a, c
    cp      $FC
    jr      z,check_yellow
    ld      l,12
    cp      0x7f                        ;0x27f= backspace
    ret     z
    ld      l,8
    cp      0xf2                        ;0x2f2 = left
    ret     z
    ld      l,9
    cp      0xf3                        ;0x2f3 = right
    ret     z
    ld      l,10
    cp      0xf1                        ;0x2f1 = down
    ret     z
    ld      l,11
    cp      0xf0                        ;0x2f0 = up
    ret     z
    ld      h,b
    ret


; We've got here so we have just received escape so check yellow
check_yellow:
    push    hl                          ;keep this in case
    call    $B8d2                       ;kmgetyellow
    pop     hl                          ;get it back
    ret     nc                          ;no yellow
    jp      __Exit                      ;was yellow so outta here




;
;Based on the SG C Tools 1.7
;(C) 1993 Steve Goldsmith
;

; Generic DAC version, must specify the output port, e.g.
;    $50 - Bondwell 12/14 (faster than the Bondwell specific implementation)
;    $dd - Covox on Scorpion ZS 256
;    $df - SpecDrum
;    $fb - Covox on Pentagon, DISCiPLE or many other centronics for ZX

;
;$Id: playzb4_dac.asm $
;

; extern void __LIB__ playzb4(uchar *SamStart, ushort SamLen);
; play 4 bit pulse wave encoded data using sid master volume

    SECTION code_clib

    PUBLIC  playzb4_dac
    PUBLIC  _playzb4_dac

playzb4_dac:
_playzb4_dac:
  IF    __CPU_GBZ80__||__CPU_INTEL__||__CPU_RABBIT__

     ret

  ELSE

;call    csv
;ld      l,(ix+6)        ;sample start addr
;ld      h,(ix+7)
;ld      e,(ix+8)        ;sample length
;ld      d,(ix+9)

    pop     af
    pop     de                          ;sample length
    pop     hl                          ;sample start addr
    pop     bc                          ;I/O port
    push    bc
    push    hl
    push    de
    push    af


rep1:
;; delay 1
	push    bc
    ld      b, 31
rep1b:                                  ;repeat
    djnz    rep1b
	pop     bc

    ld      a, (hl)                     ; a = sample byte
    and     $f0                         ; 4 bit nibble
    out     (c), a


;; delay 2
	push    bc
    ld      b, 31
rep2:                                   ;repeat
    djnz    rep2
	pop     bc

    ld      a, (hl)                     ; a = sample byte
    rlca                                ; a = a div 16
    rlca                                ;
    rlca                                ;
    rlca                                ;
    and     $f0                         ; 4 bit nibble
    out     (c), a

    inc     hl                          ; hl = hl+1
    dec     e                           ;
    jr      nz, rep1                    ;
    dec     d                           ; de = de-1
    jr      nz, rep1                    ;until de = 0

    ret
  ENDIF

;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley 
;       vz_drawtext(int x, int y, *addr str)
;       Draw text str at x,y in mode(1) graphics
;*****************************************************

; ----- void __CALLEE__ vz_drawtext(int x, int y, *addr str)

    SECTION code_clib
    PUBLIC  vz_drawtext_callee
    PUBLIC  _vz_drawtext_callee
    EXTERN vz_drawtext
    EXTERN  asm_vz_drawtext

    EXTERN  vz_printnum

vz_drawtext_callee:
_vz_drawtext_callee:
    pop     af
    pop     bc
    pop     de
    pop     hl
    push    af

   ;  bc = string pointer
   ;  e = y-coord byte
   ;  l = x-coord byte

asm_vz_drawtext:
    push bc     ; Save string pointer
    ld a,l
    cp $20
    ret nc  ; x-coord needs to be 0 => x => 31
    ld a,e
    cp $40
    ret nc  ; y-coords needs to be 0 => y => 63
    push hl ; Save HL = x
    ex de,hl ; de = x screen location
    ld b,$1f
screen_mult_dt:
    add hl,de ; Multiply height by 32
    djnz screen_mult_dt
    ld bc,$7000
    add hl,bc
    pop bc
    add hl,bc   ; Add x to screen location
    pop de
    push de     ; Save string pointer
    push hl     ; Save screen location

strngloop:
    ld a,(de)       ; Get string char
    cp $00          ; End of string?
    jp z,enddraw    ; Yes, stop drawing.
    sub $21         ; No, get index of fontdata for char
    ld d,$00
    ld e,a
    ld h,$00
    ld l,a   
    add hl,de
    add hl,de
    add hl,de
    add hl,de
    push hl
    pop bc
    ld hl,vz_font_data ; Start of fontdata to draw
    add hl,bc       ; hl points to correct letter to draw
    push hl
    ld a,$05        ; Number of lines down to draw font letter
drawloop: 
    ld (loopcnt),a
    ld a,(hl)
    push af         ; Save first byte to draw
    ld a,($7846)    ; Get colour to draw
    cp $00
    jp z,enddraw
    cp $01
    jr z,drawletter
    cp $02
    jr z,addblue
    pop af
    ld d,a
    sla a
    add a,d
    jr drawletter2  ; Font byte is coloured red
addblue:
    xor a
    pop af
    rl a
    jr drawletter2
drawletter:
    pop af
drawletter2 :  
    pop bc          ; Font data pointer          
    pop hl          ; Coords to display fontbyte
    ld d,a
    ld a,d
    ld (hl),a       ; Put it there
    ld de,$0020
    add hl,de       ; Move screen coords pointer down 1 line
    inc bc
    push hl         ; Screen pointer
    push bc         ; Font data pointer
    ld l,c          ; hl = font pointer
    ld h,b
    ld a,(loopcnt)
    dec a
    cp $00
    jr nz,drawloop  ; Works to here
    pop bc
    pop hl
    ld bc,$009f
    xor a
    sbc hl,bc
    pop de          ; String pointer
    inc de
    push de         ; Next char
    push hl         ; Screen pointer   
    jp strngloop

enddraw: 
    pop hl
    pop hl  ; Clear the stack!
    ret

vz_font_data:
    ;defb    $00,$00,$00,$00,$00
    defb    $10,$10,$10,$00,$10
    defb    $44,$44,$00,$00,$00
    defb    $44,$54,$44,$54,$44
    defb    $10,$54,$50,$14,$54
    defb    $44,$04,$10,$40,$44
    defb    $10,$44,$11,$44,$11
    defb    $10,$10,$00,$00,$00
    defb    $04,$10,$10,$10,$04
    defb    $40,$10,$10,$10,$40
    defb    $44,$10,$54,$10,$44
    defb    $00,$10,$54,$10,$00
    defb    $00,$00,$00,$10,$40
    defb    $00,$00,$54,$00,$00
    defb    $00,$00,$00,$00,$40
    defb    $04,$04,$10,$40,$40
    defb    $54,$44,$44,$44,$54
    defb    $10,$50,$10,$10,$54
    defb    $54,$04,$54,$40,$54
    defb    $54,$04,$14,$04,$54
    defb    $44,$44,$54,$04,$04
    defb    $54,$40,$54,$04,$54
    defb    $54,$40,$54,$44,$54
    defb    $54,$04,$04,$04,$04
    defb    $54,$44,$54,$44,$54
    defb    $54,$44,$54,$04,$04
    defb    $00,$40,$00,$40,$00
    defb    $00,$10,$00,$10,$40
    defb    $04,$10,$40,$10,$04
    defb    $00,$54,$00,$54,$00
    defb    $40,$10,$04,$10,$40
    defb    $54,$04,$10,$00,$10
    defb    $10,$44,$44,$40,$14
    defb    $10,$44,$54,$44,$44
    defb    $50,$44,$50,$44,$50
    defb    $14,$40,$40,$40,$14
    defb    $50,$44,$44,$44,$50
    defb    $54,$40,$50,$40,$54
    defb    $54,$40,$50,$40,$40
    defb    $14,$40,$44,$44,$14
    defb    $44,$44,$54,$44,$44
    defb    $54,$10,$10,$10,$54
    defb    $54,$04,$04,$44,$10
    defb    $44,$44,$50,$44,$44
    defb    $40,$40,$40,$40,$54
    defb    $44,$54,$44,$44,$44
    defb    $10,$44,$44,$44,$44
    defb    $10,$44,$44,$44,$10
    defb    $50,$44,$50,$40,$40
    defb    $10,$44,$44,$44,$14
    defb    $50,$44,$50,$44,$44
    defb    $14,$40,$10,$04,$50
    defb    $54,$10,$10,$10,$10
    defb    $44,$44,$44,$44,$14
    defb    $44,$44,$44,$44,$10
    defb    $44,$44,$44,$54,$44
    defb    $44,$44,$10,$44,$44
    defb    $44,$44,$44,$10,$10
    defb    $54,$04,$10,$40,$54
    defb    $54,$40,$40,$40,$54
    defb    $40,$40,$10,$04,$04
    defb    $54,$04,$04,$04,$54
    defb    $10,$44,$00,$00,$00
    defb    $00,$00,$00,$00,$54
    defb    $40,$10,$00,$00,$00
    defb    $00,$14,$44,$44,$14
    defb    $40,$50,$44,$44,$50
    defb    $00,$14,$40,$40,$14
    defb    $04,$14,$44,$44,$14
    defb    $10,$44,$50,$40,$14
    defb    $14,$10,$54,$10,$10
    defb    $10,$44,$14,$04,$50
    defb    $40,$40,$50,$44,$44
    defb    $10,$00,$10,$10,$10
    defb    $04,$00,$04,$44,$10
    defb    $40,$44,$50,$44,$44
    defb    $10,$10,$10,$10,$10
    defb    $00,$44,$54,$44,$44
    defb    $00,$10,$44,$44,$44
    defb    $00,$10,$44,$44,$10
    defb    $00,$10,$44,$50,$40
    defb    $00,$10,$44,$14,$04
    defb    $00,$10,$44,$40,$40
    defb    $00,$14,$50,$14,$50
    defb    $40,$50,$40,$44,$10
    defb    $00,$44,$44,$44,$14
    defb    $00,$44,$44,$44,$10
    defb    $00,$44,$44,$54,$44
    defb    $00,$44,$10,$10,$44
    defb    $00,$44,$14,$04,$10
    defb    $00,$54,$14,$50,$54
    defb    $14,$10,$40,$10,$14
    defb    $10,$10,$10,$10,$10
    defb    $50,$10,$04,$10,$50
    defb    $11,$44,$00,$00,$00

SECTION bss_clib

loopcnt:
    defb    $00
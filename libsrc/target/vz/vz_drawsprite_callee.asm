;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley 
;       vz_drawsprite(int x, int y, int number)
;       Draw sprite 'number' at x,y
;*****************************************************

; ----- void __CALLEE__ vz_drawsprite(int x, int y, int number)

    SECTION code_clib
    PUBLIC  vz_drawsprite_callee
    PUBLIC  _vz_drawsprite_callee
    EXTERN  vz_drawsprite
    EXTERN  vz_spritedata
    EXTERN  vz_sprite_width
    EXTERN  vz_sprite_height
    EXTERN  vz_sprite_datasize

vz_drawsprite_callee:
_vz_drawsprite_callee:
    pop     af
    pop     bc
    pop     de
    pop     hl
    push    af

   ;  c = sprite number byte
   ;  e = y-coord byte
   ;  l = x-coord byte

asm_vz_drawsprite:
    ld a,c
    ld (save_no),a  ; Save sprite number
    ld a,l
    cp $20
    ret nc  ; x-coord needs to be 0 => x => 31
    ld a,e
    cp $40
    ret nc  ; y-coords needs to be 0 => y => 63
    push hl ; Save HL = x
    ex de,hl
    ; de = sprite screen location
    ld b,$1f
screen_mult:
    add hl,de ; Multiply height by 32
    djnz screen_mult
    ld bc,$7000
    add hl,bc
    pop bc
    add hl,bc   ; Add x to screen location
    push hl     ; Save screen location
    ld a,(vz_sprite_height)
    ld (hcount),a            
    ld hl,(vz_spritedata)
    ld a,(save_no)
    ld c,a
    ld a,$00
    cp c
    jr z,displaysprite      ; if spriteno = 0, just display it
    ld a,(vz_sprite_datasize)  ; sprite data amount per sprite                
    ld e,a 
    ld b,$00
sprite_mult:                
    add hl,bc
    dec e
    jr nz,sprite_mult       ; hl = start of spriteno spritedata 
displaysprite:
    pop bc                  ; bc = sprite screen location
iterate_height:
    ld a,(vz_sprite_width)     ; sprite width
    ld d,a                  ; d = sprite width
iterate_width:
    ld a,(hl)
    ld (bc),a
    inc hl
    inc bc
    dec d
    jr nz,iterate_width     ; display all sprite data in x dimension
    push hl                 ; save hl (sprite data position) cos only hl can be used in 16bit adding
    ld hl,$0000
    add hl,bc               ; put screen location into hl
    ld de,$0020            
    add hl,de               ; add one screen line down
    ld a,(vz_sprite_width)  ; sprite width
    ld d,a                  ; d = sprite width
subtract_width:
    dec hl                  ; move hl=bc to start of new line
    dec d
    jr nz,subtract_width    
    push hl                 ; save screen location
    pop bc                  ; restore sprite screen location
    pop hl                  ; restore sprite data position
    ld a,(hcount)           ; sprite height counter
    dec a 
    ld (hcount),a
    jr nz,iterate_height
    ret
hcount:
    defb  $00  
save_no:
    defb  $00
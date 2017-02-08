        include ../build/define.asm
        include ../build/defmap.asm
; 0 black, 1 blue, 2 red, 3 magenta, 4 green, 5 cyan, 6 yellow, 7 white
; 8 none, 9-15 bright versions of 1-7
        DEFINE  scolor  0
        DEFINE  ccolor  0
        DEFINE  sylo    $66
      IF scolor=0
        DEFINE  syhi    $c0
      ELSE
        DEFINE  syhi    ($80 | scolor<<3&$78 | scolor&$07)
      ENDIF
        DEFINE  atrbar  (ccolor<<3&$78 | ccolor&$07)
        DEFINE  enems   $5b00
        DEFINE  mapbuf  $5b40
        DEFINE  screen  $5c00
        DEFINE  port    $5c01
        DEFINE  selbeg  $5c02
        DEFINE  selend  $5c03
        DEFINE  drwout  $5c06
        DEFINE  tiladdr $5c08+bullet*(8<<smooth)
        DEFINE  sprites $fe00
      IF  smooth=0
        DEFINE  final   $fd00+notabl
      ELSE
        DEFINE  final   $fc81+notabl
      ENDIF

		
; *************************************************************
; ** FASE MACROS **********************************************
; *************************************************************

define(`MULTSUB',
`
dnl#
dnl# $1 = first
dnl# $2 = second
dnl# $3 = data
dnl#
IF $3 & $1
   add hl,hl
   IF $3 & $2
	   add hl,de
	ENDIF
ENDIF
')

define(`MULT8X8',
`
dnl#
dnl# $1 = data
dnl#
IF $1 = 0
   ld hl,0
ELSE
   ld h,0
	ld l,e
	IF (($1 != 1) && ($1 != 2) && ($1 != 4) && ($1 != 8) && ($1 != 16) && ($1 != 32) && ($1 != 64) && ($1 != 128))
	   ld d,h
	ENDIF
   MULTSUB(%10000000, %01000000, $1)
	MULTSUB(%11000000, %00100000, $1)
	MULTSUB(%11100000, %00010000, $1)
	MULTSUB(%11110000, %00001000, $1)
	MULTSUB(%11111000, %00000100, $1)
	MULTSUB(%11111100, %00000010, $1)
	MULTSUB(%11111110, %00000001, $1)
ENDIF
')

define(`UPDREMOVE',
`
   ld a,h
	and $07
	jp nz, Z88DK_ULBL(_upd)
	ld a,l
	sub $20
	ld l,a
	jr c, Z88DK_CLBL(,_upd)
	ld a,h
	add a,$08
	ld h,a
Z88DK_CLBL(,_upd):
')

define(`UPDPAINT',
`
   ld a,h
	and $07
	jp nz, Z88DK_ULBL(_upd)
	ld a,l
	add a,$20
	ld l,a
	jr c, Z88DK_CLBL(,_upd)
	ld a,h
	sub $08
	ld h,a
Z88DK_CLBL(,_upd):
')

define(`UPDCLDN',
`
   ld a,h
	and $07
	jp nz, Z88DK_ULBL(_upd)
	IF (offsey+(scrh*2))&7
	   ld de,$f820
		add hl,de
	ELSE
	   ld a,l
		add a,$20
		ld l,a
		jr c, Z88DK_CLBL(,_upd)
		ld a,h
		sub $08
		ld h,a
	ENDIF
Z88DK_CLBL(,_upd):
')

define(`CELLP',
`
   pop de
   ld (hl), e
   inc h
   ld (hl), d
   inc h
   pop de
   ld (hl), e
   inc h
   ld (hl), d
   inc h
   pop de
   ld (hl), e
   inc h
   ld (hl), d
   inc h
   pop de
   ld (hl), e
   inc h
   ld (hl), d
')

define(`CELLPRINT',
`
dnl#
dnl# $1 = addition
dnl#
   CELLP
	ld de,$1
	add hl,de
')

define(`CELLPRIN1',
`
   CELLP
	inc h
	ld a,$1f
	add a,l
	ld l,a
	jr c, Z88DK_ULBL(_cell)
	ld a,$f8
	add a,h
	ld h,a
Z88DK_CLBL(,_cell):
')

define(`CELLPRIN2',
`
   CELLP
	ld de,$f8e1
	ld a,l
	add a,e
	jp c, Z88DK_ULBL(_cell)
	ld d,$f1
	add hl,de
Z88DK_CLBL(,_cell):
')

define(`TILEPRINT',
`
   IF offsey & 1
	   ld (Z88DK_ULBL(save)+1),a
		CELLPRINT($f901)
		CELLPRIN1
		CELLPRINT($f901)
		CELLPRIN2
Z88DK_CLBL(,save):
		ld a,0
	ELSE
	   CELLPRINT($f901)
		CELLPRINT($f91f)
		CELLPRINT($f901)
		CELLPRINT($f8e1)
	ENDIF
')


; *************************************************************
; **  **********************************************
; *************************************************************

; Paolo Ferraris' shortest loader, then we move all the code to $8000
        org     staspr+final-mapend-ASMPC
staspr: defw    draw_sprites+1
        nop
        include ../mus/effx.asm
do_sprites:
IF  machine=1
        ld      (drawz+1), sp
ELSE
dom:    ld      hl, effx1-1
        ld      (drawz+1), sp
        ld      a, $10
dom1:   ld      b, (hl)
        cp      b
        jr      z, dom4
        out     ($fe), a
dom2:   djnz    dom2
        and     a
        ld      a, b
        out     ($fe), a
        jp      m, dom3
        ld      a, $90
        bit     7, (hl)
        jr      z, dom1
dom3:   ld      hl, (dom+1)
        inc     hl
        ld      (dom+1), hl
dom4:
ENDIF
IF  machine=0                   ; if 48k doing sync with the sync bar (8 lines)
do0:    ld      bc, syhi | (sylo<<8)
do1:    in      a, ($ff)        ; first detect the syhi byte in the floating bus
        cp      b
        jp      nz, do1
        ld      b, 9            ; then wait for sylo in the next 9 readings
do2:    in      a, ($ff)
        cp      c
do3:    jr      z, do5
        djnz    do2
        jr      do0
ENDIF
IF  machine=1                   ; if not 48k sync with interrupt
        ld      hl, do1
        ei
do1:    jp      (hl)
        ld      bc, $7ffd
IF player
        ld      a, $11
        out     (c), a
ELSE
        ld      a, (port)       ; toggle port value between 00 and 80 every frame
        xor     $80
        ld      (port), a
        ld      a, $18          ; also toggle between bank 5 & 7 for the screen
        jr      z, do2          ; and 7 & 0 for the current paging at $c000
        dec     a               ; so we always show a screen and modify the other
do2:    out     (c), a
ENDIF
do3:    jr      update_complete
ENDIF
IF  machine=2
        ld      hl, do1         ; if not floating bus or 128k sync with
        ei                      ; the interrupt, so we'll have more cycles of
do1:    jp      (hl)            ; flickering
do3:    jr      update_complete
ENDIF
do5:    ld      a, +(update_complete-2-do3)&$ff
        ld      (do3+1), a
        jp      draw_sprites
IF  machine=1
do4     ld      a, +(update_complete-2-do3)&$ff
        ld      (do3+1), a
        jp      descd
ENDIF

;Complete background update
update_complete:
        ld      hl, screen      ; compare screen variable with $ff to detect
        ld      a, (hl)         ; if the user has written on it
        inc     a
        jp      z, delete_sprites
        ld      bc, $00ff       ; in this case read the value and write $ff
        ld      (hl), c         ; to this variable
        ld      hl, mapend+$fe
        ld      de, map         ; decompression stuff
desc1:  sbc     hl, bc
        ex      de, hl
        ld      c, (hl)
        ex      de, hl
        inc     de
        dec     a
        jr      nz, desc1
IF  machine=1
        ld      bc, $7ffd
        ld      a, (port)
        rla
        ld      e, $10
        jr      c, desc2
        ld      e, $1f
desc2:  out     (c), e
        ld      a, do4-2-do3
        ld      (do3+1), a
        ld      a, e
        xor     $07
        out     (c), a
        inc     b
ELSE
        ld      b, $80          ; marker bit
ENDIF
        ld      de, mapbuf+(scrw*scrh)-1
desc3:  ld      a, 256 >> bitsym
desc4:  call    gbit3           ; load bitsym bits (literal)
        jr      nc, desc4
IF bithlf=1
IF bitsym=1
        rrca
        jr      nc, desc5
        xor     a
        call    gbit3
        inc     a
ELSE
        rrca                    ; half bit implementation (ie 48 tiles)
        call    c, gbit1
ENDIF
ENDIF
desc5:  ld      (de), a         ; write literal
        dec     e               ; test end of file (map is always 150 bytes)
desc6:  ld      a, e
        cp      $3f
        jr      z, descd
        call    gbit3           ; read one bit
        rra
        jr      nc, desc3       ; test if literal or sequence
        push    de              ; if sequence put de in stack
        ld      a, 1            ; determine number of bits used for length
desc7:  call    nc, gbit3       ; (Elias gamma coding)
        and     a
        call    gbit3
        rra
        jr      nc, desc7       ; check end marker
        inc     a               ; adjust length
        ld      c, a            ; save lenth to c
        xor     a
        ld      de, scrw        ; initially point to scrw
        call    gbit3           ; get two bits
        call    gbit3
        jr      z, desca        ; 00 = 1
        dec     a
        call    gbit3
        jr      z, descc        ; 010 = 15
        bit     2, a
        jr      nz, desc8
IF  scrw>15
        call    gbit3           ; [011, 100, 101] xx = from 2 to 13
        dec     a
        call    gbit3
        jr      descb
desc8:  call    gbit3           ; [110, 111] xxxxxx = from 14-15, 17-142
        jr      nc, desc8
        cp      scrw-14
        sbc     a, -14
ELSE
IF  scrw=15
        add     a, $7c          ; [011, 100, 101] xx = from 2 to 13
        dec     e
desc8:  dec     e               ; [110, 111] xxxxxx = 14 and from 16 to 142
desc9:  call    gbit3
        jr      nc, desc9
        jr      z, descc
        add     a, e
ELSE
        call    gbit3           ; [011, 100, 101] xx = from 2 to 11 and from 13 to 14
        call    gbit3
        cp      scrw+2
        sbc     a, 2
        jr      desca
desc8:  call    gbit3           ; [110, 111] xxxxxx = from 15 to 142
        jr      nc, desc8
        add     a, 14
ENDIF
ENDIF
desca:  inc     a
descb:  ld      e, a
descc:  ld      a, b            ; save b (byte reading) on a
        ld      b, d            ; b= 0 because lddr moves bc bytes
        ex      (sp), hl        ; store source, restore destination
        ex      de, hl          ; HL = destination + offset + 1
        add     hl, de          ; DE = destination
        lddr
        pop     hl              ; restore source address (compressed data)
        ld      b, a            ; restore b register
        jr      desc6           ; jump to main loop
descd:
IF  tmode=3
        ld      a, +(mapbuf-1)&$ff ; end of decompression stuff
ELSE
        ld      a, mapbuf&$ff
ENDIF
        ld      (upco2+1), a    ; fill values to produce
        ld      a, scrh         ; full background
        ld      (upco3-1), a
        ld      a, scrw
        ld      (upco4-1), a
        ld      a, $40-(scrw*2)
        ld      (upco7+1), a
        ld      (upco8+1), a
        ld      bc, $5800+offsex+(offsey*32)
        ld      hl, $4000+offsex+((offsey<<5)&0xe0)+((offsey<<8)&0x1800)
upco1:                          ; from this we update a rectangular area
IF  machine=1                   ; of tiles that can be partial if update_partial
        ld      a, (port)       ; or complete if update_complete
        xor     b
        ld      b, a            ; if 128k put port variable into high bit of
        and     $80             ; B and H
        xor     h
        ld      h, a
ENDIF
        exx
IF  tmode=3                     ; save the pointer to the actual tile on BC
upco2:  ld      a, 0            ; or in upco5+1, depends if tmode is 3 or not
        ld      (upco5+1), a
ELSE
upco2:  ld      bc, mapbuf&$ff00
ENDIF
        ld      a, 0            ; inner and outer loop, if complete update we
upco3:  ex      af, af'         ; repeat the loop scrh*scrw times
        ld      a, 0
upco4:
IF  tmode=3
        ld      hl, upco5+1     ; increment pointer to actual tile
        inc     (hl)
upco5:  ld      hl, mapbuf
ELSE
        ld      h, b
        ld      l, c
ENDIF
        ld      l, (hl)         ; read tile value
        ld      h, 0
IF  tmode=0
        ld      d, h            ; if tmode=0 multiply by 36 and print the tile
        ld      e, l
        add     hl, hl
        add     hl, hl
        add     hl, hl
        add     hl, de
        add     hl, hl
        add     hl, hl
        ld      de, tiladdr
        add     hl, de
        ld      sp, hl
        exx
        TILEPRINT
ENDIF
IF  tmode=1
        ld      d, h            ; if tmode=1 multiply by 5
        ld      e, l            ; the first 4 bytes are attributes
        add     hl, hl          ; the last byte is a index to the bitmap
        add     hl, hl
        add     hl, de
        ld      de, tiladdr
        add     hl, de
        ld      (upco6+1), hl
        ld      de, 4
        add     hl, de
        ld      l, (hl)
        ld      h, d
        ld      de, tiladdr+(tiles*5)
        add     hl, hl
        add     hl, hl
        add     hl, hl
        add     hl, hl
        add     hl, hl
        add     hl, de
        ld      sp, hl
        exx
        TILEPRINT
upco6:  ld      sp, 0
ENDIF
IF  tmode=2
        ld      d, h            ; if tmode=2 multiply by 33
        ld      e, l            ; the first byte is index to attribute
        add     hl, hl          ; the last 32 bytes are the bitmap
        add     hl, hl
        add     hl, hl
        add     hl, hl
        add     hl, hl
        add     hl, de
        ld      de, tiladdr
        add     hl, de
        ld      e, (hl)
        inc     hl
        ld      sp, hl
        ex      de, hl
        ld      h, 0
        add     hl, hl
        add     hl, hl
        ld      de, tiladdr+(tiles*33)
        add     hl, de
        ld      (upco6+1), hl
        exx
        TILEPRINT
upco6:  ld      sp, 0
ENDIF
IF  tmode=3
        add     hl, hl          ; if tmode=3 we have indexed both
        ld      de, tiladdr     ; attribute and bitmap, so multiply by 2
        add     hl, de          ; to read from table and index
        ld      e, (hl)         ; separately attribute and bitmap
        inc     hl
        ld      l, (hl)
        ld      h, 0
        ld      d, h
        add     hl, hl
        add     hl, hl
        ld      bc, tiladdr+(tiles*2)+(bmaps*32)
        add     hl, bc
        ld      (upco6+1), hl
        ex      de, hl
        add     hl, hl
        add     hl, hl
        add     hl, hl
        add     hl, hl
        add     hl, hl
        ld      bc, tiladdr+(tiles*2)
        add     hl, bc
        ld      sp, hl
        exx
        TILEPRINT
upco6:  ld      sp, 0
ENDIF
        ex      de, hl          ; bitmap painted and sp points to attribute
        ld      h, b            ; source
        ld      l, c
        pop     bc
        ld      (hl), c         ; paint 4 bytes of attribute
        inc     l
        ld      (hl), b
        ld      bc, $001f
        add     hl, bc
        pop     bc
        ld      (hl), c
        inc     l
        ld      (hl), b
        ld      bc, $ffe1
        add     hl, bc
        ld      b, h
        ld      c, l
        ex      de, hl
        exx
IF  tmode<3
        inc     c
ENDIF
        dec     a
        jp      nz, upco4
        exx
        ex      de, hl
upco7:  ld      bc, 0
        add     hl, bc
        ld      b, h
        ld      c, l
        ex      de, hl
upco8:  ld      de, 0
        ld      a, l
        cp      $c0
        jr      c, upco9
        ld      d, 7
upco9:  add     hl, de
        exx
        ex      af, af'
        dec     a
        jp      nz, upco3
        jp      draw_sprites

;Restore background behind the sprites previously stored in draw_sprites
delete_sprites:
        ld      sp, 0
        pop     bc              ; all data is on stack, the first 2 values
        ld      ixl, b          ; pulled are BC and HL
        inc     b               ; HL is the screen position at the end of the paint
IF smooth=0                    ; B is number of patterns
        jr      z, del7         ; C is X offset (bits 0&1) and wide (bits 2&3)
ELSE
        jp      z, del7
ENDIF
del1:   pop     hl
del2:   pop     bc
        ld      a, c
IF smooth=1
        bit     0, h            ; this conditional assembly is when smooth=1
        jp      z, wel2         ; we can save some cycles width different
        and     %00001100       ; routines for even and odd lines
        jr      z, wel4
        jp      po, wel5
wel3:   pop     de
        dec     h
        ld      (hl), e
        inc     l
        ld      (hl), d
        inc     l
        pop     de
        ld      (hl), e
        UPDREMOVE
        dec     h
        ld      (hl), d
        dec     l
        pop     de
        ld      (hl), e
        dec     l
        ld      (hl), d
        djnz    wel3
        jp      del6
wel4:   pop     de
        dec     h
        ld      (hl), e
        inc     l
        ld      (hl), d
        UPDREMOVE
        dec     h
        pop     de
        ld      (hl), e
        dec     l
        ld      (hl), d
        djnz    wel4
        jr      del6
wel5:   pop     de
        dec     h
        ld      (hl), e
        UPDREMOVE
        dec     h
        ld      (hl), d
        djnz    wel5
        jr      del6
ENDIF
wel2:   and     %00001100       ; test wide
        jr      z, del4
        jp      po, del5
del3:   UPDREMOVE               ; wide=3
        pop     de
        dec     h
        ld      (hl), e
        inc     l
        ld      (hl), d
        inc     l
        pop     de
        ld      (hl), e
        dec     h
        ld      (hl), d
        dec     l
        pop     de
        ld      (hl), e
        dec     l
        ld      (hl), d
        djnz    del3
        jr      del6
del4:   UPDREMOVE               ; wide=2
        pop     de
        dec     h
        ld      (hl), e
        inc     l
        ld      (hl), d
        dec     h
        pop     de
        ld      (hl), e
        dec     l
        ld      (hl), d
        djnz    del4
        jr      del6
del5:   UPDREMOVE               ; wide=1
        pop     de
        dec     h
        ld      (hl), e
        dec     h
        ld      (hl), d
        djnz    del5
del6:   ld      a, c            ; add X offset to L
        cpl
        and     $03
        add     a, l
        sub     2
        ld      l, a
        dec     ixl             ; repeat IXl times
IF smooth=0
        jr      nz, del2
ELSE
        jp      nz, del2
ENDIF
        pop     bc              ; next sprite to delete
        ld      ixl, b
        inc     b
IF smooth=0
        jr      nz, del1
ELSE
        jp      nz, del1
ENDIF
del7:
IF bullet
        pop     hl              ; if bullet=1 after sprites we delete the bullets
        inc     h
IF smooth=0
        jr      z, update_partial
ELSE
        jp      z, update_partial
ENDIF
del8:   pop     de              ; similar code but simpler than the sprites code
        ld      (delf+1), sp
        dec     h               ; in this case we need only 2 values per bullet
        ld      sp, hl          ; HL= start of the bullet in screen memory
        ex      de, hl          ; SP= points to the sprite to read structure
        pop     bc              ; no need to store info behing the bullet
        ld      ixl, c          ; because is XORed with the background
        ld      iy, delf
        jp      draw_delete_bullet
delf:   ld      sp, 0
        pop     hl
        inc     h
IF smooth=0
        jr      nz, del8
ELSE
        jp      nz, del8
ENDIF
ENDIF

update_partial:
IF  machine=1
        jr      uppa3           ; if 128k we need to paint twice the same
        ld      a, +(uppa3-update_partial-2)&$ff
        ld      (update_partial+1), a
uppa1:  ld      l, 0            ; tile, one in each screen buffer
uppa2:  ld      c, 0
        jr      uppa5
ENDIF

uppa3:  ld      hl, selend      ; test if we need to repaint a rectangular
        ld      a, (hl)         ; area of tiles
        dec     l
        ld      c, (hl)
        sub     c
        jr      c, draw_sprites ; if not, jump to draw_sprites

;Partial background update
        ld      (hl), $ff
        ld      l, a
IF  machine=1
        ld      h, c            ; in this code we store the read
        ld      bc, $7ffd       ; values to use in the next frame
        ld      a, (port)
        rla
        ld      e, $10
        jr      c, uppa4
        ld      e, $1f
uppa4:  out     (c), e
        ld      (update_partial+1), a
        ld      a, l
        ld      (uppa1+1), a
        ld      a, h
        ld      (uppa2+1), a
        ld      a, e
        xor     $07
        out     (c), a
        ld      c, h
uppa5:  ld      a, l
ENDIF
        and     $0f             ; we basically extract the info
        inc     a               ; of the rectangular area that we want
        ld      (upco4-1), a    ; to repaint and fill the appropiate values
        add     a, a            ; when jump to upco1
        cpl
        sub     $bf
        ld      (upco7+1), a
        ld      (upco8+1), a
        ld      a, l
        rlca
        rlca
        rlca
        rlca
        and     $0f
        inc     a
        ld      (upco3-1), a
        ld      a, c            ; A= yyyyxxxx
        rlca
        rlca
        rlca
        rlca
        and     %00001111
        ld      e, a
        MULT8X8(scrw)
        ld      a, c
        and     %00001111
        add     a, l
IF  tmode=3
        add     a, +(mapbuf-1)&$ff
ELSE
        add     a, mapbuf&$ff
ENDIF
        ld      (upco2+1), a
        ld      a, c
        and     $f0             ; A= yyyy0000
IF  offsey>0
        add     a, offsey<<3
ENDIF
        ld      b, $58 >> 2     ; B= 00010110
        rla                     ; A= yyy00000
        rl      b               ; B= 0010110y
        rla                     ; A= yy000000
        rl      b               ; B= 010110yy
        rl      c               ; C= yyyxxxx0
        xor     c        
        and     %11100001       
        xor     c               ; A= yy0xxxx0
IF  offsex=1
        inc     a
ELSE
IF  offsex>1
        add     a, offsex
ENDIF
ENDIF
        ld      c, a
        ld      l, a
        ld      a, b
        rlca
        rlca
        rlca
        and     %01111000
        ld      h, a
        jp      upco1

;Draw the sprites, storing the background behind
draw_sprites:
IF bullet
        ld      hl, 0           ; in case of drawing first we start with bullets
        ld      (draw5+1), hl
        ld      a, $31          ; main loop we read up to 8 bullet from $5b30 to $5b3e
draw1:  ld      (draw8+1), a
        ld      l, a            ; in the bullets we only store 2 bytes, one of each
        ld      h, enems >> 8   ; coordinate (X and Y)
        ld      a, (hl)         ; read y
        cp      bulmiy&$ff      ; basically if the bullet is out of the screen
        jp      c, draw8        ; area we don't paint it
        cp      +(11+(scrh*16)-(2*bulmay))&$ff
        jp      nc, draw8       ; calculate the screen address
        dec     l               ; and the source of the sprite (bullet) in SP
        ld      a, (hl)         ; read x
        add     a, 4
IF safehr & (!cliphr)
        cp      8
        jp      c, draw8
        cp      +(scrw<<4)+1
        jp      nc, draw8
ENDIF
IF smooth=0
        and     $06
ELSE
        and     $07
        add     a, a
ENDIF
        add     a, 8
        ld      (draw2+2), a
        ld      a, (hl)         ; read x
        add     a, 4
        and     $f8
        rra
        rra
        rra
        ld      (draw4+1), a
draw2:  ld      sp, ($5c00)
        ld      (draw7+1), sp
        pop     de
        ld      ixl, e
        inc     l
        ld      a, (hl)         ; read y
IF smooth=0
        and     $fe
ENDIF
        add     a, d
IF notabl
        ld      l, a            ; A=L= RRrrrppp
        rrca
        rrca
        rrca                    ; A= pppRRrrr
        xor     l
        and     %00011000
        xor     l               ; A= RRrRRppp
        and     %00011111
        or      %01000000
        ld      h, a
        ld      a, l
        rlca
        rlca
        and     $e0
ELSE
        ld      (draw3+1), a
draw3:  ld      a, (lookt)
        ld      l, a            ; A=L= rrrRRppp
        and     %00011111
        ld      h, a            ;   H= 000RRppp
        set     6, h
        xor     l               ;   A= rrr00000
ENDIF
draw4:  add     a, 0
IF  offsex != 1
        add     a, offsex-1
ENDIF
        ld      l, a
IF  machine=1
        ld      a, (port)
        or      h
        ld      h, a
ENDIF
        ld      (draw6+1), hl
        ld      iy, draw5       ; this is the return address after next routine

draw_delete_bullet:
IF smooth=1
        bit     0, h            ; this code is the same for paint and delete
        jp      z, drde6        ; the bullet. We use IY as return address
drde1:  pop     bc              ; because stack is used by the routine
        ld      a, c
        rrca                    ; only 2 wide cases to treat
        jr      nc, drde3
        and     $03             ; wide=2
        add     a, l
        dec     a
        ld      l, a
drde2:  pop     de
        ld      a, (hl)
        xor     e
        ld      (hl), a
        inc     l
        ld      a, (hl)
        xor     d
        ld      (hl), a
        inc     h
        UPDPAINT
        pop     de
        ld      a, (hl)
        xor     e
        ld      (hl), a
        dec     l
        ld      a, (hl)
        xor     d
        ld      (hl), a
        inc     h
        djnz    drde2
        jr      drde5
drde3:  and     $03             ; wide=1
        add     a, l
        dec     a
        ld      l, a
drde4:  pop     de
        ld      a, (hl)
        xor     e
        ld      (hl), a
        inc     h
        UPDPAINT
        ld      a, (hl)
        xor     d
        ld      (hl), a
        inc     h
        djnz    drde4
drde5:  dec     ixl
        jr      nz, drde1
        jp      (iy)
ENDIF
drde6:  pop     bc
        ld      a, c
        rrca
        jr      nc, drde8
        and     $03
        add     a, l
        dec     a
        ld      l, a
drde7:  pop     de
        ld      a, (hl)
        xor     e
        ld      (hl), a
        inc     l
        ld      a, (hl)
        xor     d
        ld      (hl), a
        inc     h
        pop     de
        ld      a, (hl)
        xor     e
        ld      (hl), a
        dec     l
        ld      a, (hl)
        xor     d
        ld      (hl), a
        inc     h
        UPDPAINT
        djnz    drde7
        jr      drdea
drde8:  and     $03
        add     a, l
        dec     a
        ld      l, a
drde9:  pop     de
        ld      a, (hl)
        xor     e
        ld      (hl), a
        inc     h
        ld      a, (hl)
        xor     d
        ld      (hl), a
        inc     h
        UPDPAINT
        djnz    drde9
drdea:  dec     ixl
        jr      nz, drde6
        jp      (iy)            ; end of routine

draw5:  ld      sp, 0           ; continue here, we have painted the bullet
draw6:  ld      hl, 0           ; push the 2 calculated values
        push    hl              ; HL= origin address in the screen
draw7:  ld      hl, 0
        push    hl              ; HL= pointer to the sprite data
        ld      (draw5+1), sp
draw8:  ld      a, 0
        add     a, 2
        cp      $31+(bulmax*2)  ; repeat the loop bulmax times (up to 8 bullets)
        jp      nz, draw1
        ld      hl, (draw5+1)   ; these two lines are needed in case
        ld      sp, hl          ; of no bullet found
        ld      bc, $fffe       ; put a value on stack as bullet/sprite separator
        push    bc
        add     hl, bc
        ld      b, h
        ld      c, l            ; now BC points to SP
ELSE
        ld      bc, 0           ; in case of no bullet directly start with BC
ENDIF
        xor     a               ; end of bullet code, start of sprites code
draw9:  ld      (draww+1), a
        ld      l, a            ; read data from sprite table
        ld      h, enems >> 8
        ld      a, (hl)         ; first value is the sprite number
        add     a, a            ; if high bit is 1, the sprite is disabled
        jp      c, draww        ; so jump to draww
        add     a, a            ; use the rest of the bits to found
        add     a, a            ; a pointer to the actual sprite
        inc     l               ; and then calculate the X and Y coordinates
IF safehr & (!cliphr)           ; the lower bits of X also counts to calculate
        ex      af, af          ; the actual sprite because there are
        ld      a, (hl)         ; 4 (or 8 if smooth=1) rotated versions of the
        cp      9               ; same sprite
        jr      nc, drawa
        ld      a, 8
drawa:  cp      +(scrw<<4)-8
        jr      c, drawb
        ld      a, +(scrw<<4)-8
drawb:
IF smooth=0
        and     $fe
ENDIF
        ld      e, a
        ex      af, af
ELSE
        ld      e, (hl)
IF smooth=0
        res     0, e
ENDIF
ENDIF
        inc     l
        xor     e
        and     $f8
        xor     e
IF smooth=1
        add     a, a
ENDIF
        ld      (drawc+2), a
        ld      a, e
        and     $f8
        rra
        rra
        rra
        ld      (drawh+1), a
drawc:  ld      sp, (sprites)
        pop     de
        ld      a, (hl)
IF smooth=0
        and     $fe
ENDIF
IF safevr=1
IF clipdn=0
        cp      +(scrh*16)-7
        jr      c, drawd
        ld      a, +(scrh*16)-8
ELSE
        cp      +(scrh*16)+1
        jr      c, drawd
        ld      a, scrh*16
ENDIF
ENDIF
drawd:  add     a, d
IF clipup=0
IF (safevr=1) && (offsey>0)
        cp      offsey<<3
        jr      nc, drawe
        ld      a, offsey<<3
ENDIF
ELSE
IF clipup=2
IF offsey=0
        jp      nc, braw1
ELSE
        cp      offsey<<3
        jp      c, braw1
ENDIF
ENDIF
ENDIF
drawe:
IF clipdn=2
        cp      1+((offsey+(scrh*2)-2)<<3)
        jp      nc, craw1
ENDIF
IF notabl
        ld      l, a            ; A=L= RRrrrppp
IF offsey=0
        cp      192
        jr      nc, drawf
ENDIF
        rrca
        rrca
        rrca                    ; A= pppRRrrr
        xor     l
        and     %00011000
        xor     l               ; A= RRrRRppp
        and     %00011111
        or      %01000000
IF offsey=0
        jr      drawg
drawf:  rrca
        rrca
        rrca                    ; A= pppRRrrr
        xor     l
        and     %00011000
        xor     l               ; A= RRrRRppp
        and     %00011111
        or      %00100000
ENDIF
drawg:  ld      h, a
        ld      a, l
        rlca
        rlca
        and     $e0
ELSE
        ld      (drawf+1), a
IF offsey=0
        cp      192
drawf:  ld      a, (lookt)
        jr      nc, drawg
ELSE
drawf:  ld      a, (lookt)
ENDIF
        ld      l, a            ; A=L= rrrRRppp
        and     %00011111
        ld      h, a            ;   H= 000RRppp
        set     6, h
        xor     l               ;   A= rrr00000
IF offsey=0
        jr      drawh
drawg:  ld      l, a            ; A=L= rrrRRppp
        and     %00011111
        ld      h, a            ;   H= 000RRppp
        set     5, h
        xor     l               ;   A= rrr00000
ENDIF
ENDIF
drawh:  add     a, 0
IF  offsex != 1
        add     a, offsex-1
ENDIF
        ld      l, a
IF  machine=1
        ld      a, (port)
        or      h
        ld      h, a
ENDIF
        ld      a, e
        ld      (drawv+1), a
drawi:
IF smooth=1
        bit     0, h
        jp      z, drawn
        ex      af, af'
        pop     de
        ld      ixl, d
        ld      iyh, d
        ld      iyl, e
        ld      a, e
        and     $03
        add     a, l
        dec     a
        ld      l, a
        ld      a, e
drawj:  and     %00001100
        jr      z, drawl
        jp      po, drawm
drawk:  pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     l
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     l
        pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        UPDPAINT
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        dec     l
        pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        dec     l
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        dec     ixl
        jr      nz, drawk
        jp      draws
drawl:  pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     l
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        UPDPAINT
        pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        dec     l
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        dec     ixl
        jr      nz, drawl
        jp      draws
drawm:  pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        UPDPAINT
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        dec     ixl
        jr      nz, drawm
        jp      draws
ENDIF
drawn:  ex      af, af'
        pop     de
        ld      ixl, d
        ld      iyh, d
        ld      iyl, e
        ld      a, e
        and     $03
        add     a, l
        dec     a
        ld      l, a
        ld      a, e
drawo:  and     %00001100
        jr      z, drawq
        jp      po, drawr
drawp:  pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     l
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     l
        pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        dec     l
        pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        dec     l
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        UPDPAINT
        dec     ixl
        jr      nz, drawp
        jr      draws
drawq:  pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     l
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        dec     l
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        UPDPAINT
        dec     ixl
        jr      nz, drawq
        jr      draws
drawr:  pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        UPDPAINT
        dec     ixl
        jr      nz, drawr
draws:  ld      a, iyh
drawt:  dec     bc
        ld      (bc), a
        ld      a, iyl
        dec     c
        ld      (bc), a
        ex      af, af'
        dec     a
        jp      nz, drawi
drawu:  ld      a, h
        dec     bc
        ld      (bc), a
        ld      a, l
        dec     c
        ld      (bc), a
drawv:  ld      a, 0
        dec     bc
        ld      (bc), a
        dec     c
draww:  ld      a, 0
        add     a, 4
        cp      sprmax<<2
        jp      nz, draw9
IF  machine=1
        ld      (delete_sprites+1), bc
        ld      hl, (drwout)
        ld      a, h
        inc     a
        ld      sp, screen-1
        jr      z, drawx
***********************        call    $162c
        ld      a, ($5bff)
        xor     $ff
        jr      nz, drawx
        dec     a
        ld      (drwout+1), a
drawx:  ld      ($5bff), a
        ld      bc, $7ffd
        ld      a, (port)
        rla
        ld      a, $10
        jr      c, drawy
        ld      a, $18
drawy:  out     (c), a
drawz:  ld      sp, 0
        ret
ELSE
drawz:  ld      sp, 0
        ld      (delete_sprites+1), bc
        ld      hl, (drwout)
        ld      a, h
        inc     a
        ret     z
        ld      a, $ff
        ld      (drwout+1), a
        jp      (hl)
ENDIF

; This is a continuation of draw_sprite routine to deal with top edge clipping
IF clipup=2
braw1:  ld      (braw9+1), bc  
        ld      (braw2+1), a
        cpl
IF offsey>0
        sub     -(offsey<<3)-2
        rra
ELSE
        rra
        inc     a
ENDIF
        ld      ixh, a
IF notabl
braw2   ld      a, 0
        ld      l, a
        rrca
        rrca
        rrca                    ; A= pppRRrrr
        xor     l
        and     %00011000
        xor     l               ; A= RRrRRppp
        and     %00011111
IF offsey=0
        or      %00100000
ELSE
        or      %01000000
ENDIF
        ld      h, a
        ld      a, l
        rlca
        rlca
        and     $e0
ELSE
braw2:  ld      a, (lookt)
        ld      l, a            ; A=L= rrrRRppp
        and     %00011111
        ld      h, a            ;   H= 000RRppp
IF offsey=0
        set     5, h
ELSE
        set     6, h
ENDIF
        xor     l               ;   A= rrr00000
ENDIF
        ld      l, a            ;   L= rrr00000
        ld      a, (drawh+1)
IF  offsex != 1
        add     a, offsex-1
ENDIF
        or      l
        ld      l, a
IF  machine=1
        ld      a, (port)
        or      h
        ld      h, a
ENDIF
        ld      a, e
        ex      de, hl
braw3:  ex      af, af'
        pop     bc
        ld      a, c
        and     $03
        add     a, e
        dec     a
        ld      e, a
        ld      a, c
        and     %00001100
        jr      z, braw5
        jp      po, braw6
braw4:  ld      hl, 12
        add     hl, sp
        ld      sp, hl
        inc     d
        inc     d
        dec     ixh
        jr      z, brawa
        djnz    braw4
        jr      braw7
braw5:  ld      hl, 8
        add     hl, sp
        ld      sp, hl
        inc     d
        inc     d
        dec     ixh
        jr      z, brawa
        djnz    braw5
        jr      braw7
braw6:  pop     hl
        pop     hl
        inc     d
        inc     d
        dec     ixh
        jr      z, brawa
        djnz    braw6
braw7:  ex      af, af'
        dec     a
        jp      nz, braw3
        ld      bc, (braw9+1)
        jp      draww
braw8:  ld      ixl, b
        ld      iyh, b
        ld      iyl, c
        ex      af, af'
        ld      (drawv+1), a
        ex      af, af'
        ld      a, c
braw9:  ld      bc, 0
IF smooth=1
        bit     0, h
        jp      nz, drawj
ENDIF
        jp      drawo
brawa:
IF offsey&7
        ld      hl, $f820
        add     hl, de
ELSE
        ld      a, e
        add     a, $20
        ld      l, a
        ld      h, d
ENDIF
        djnz    braw8
        ld      bc, (braw9+1)
        ex      af, af'
        dec     a
        ld      (drawv+1), a
        jp      nz, drawi
        jp      draww
ENDIF

; And this one to deal with bottom edge clipping
IF clipdn=2
craw1:  ld      (craw2+1), a
        cpl
        sub     $ff-((offsey+(scrh*2))<<3)
        rra
        ld      ixh, a
IF notabl
craw2:  ld      a, 0
        ld      l, a
        rrca
        rrca
        rrca                    ; A= pppRRrrr
        xor     l
        and     %00011000
        xor     l               ; A= RRrRRppp
        and     %00011111
        or      %01000000
        ld      h, a
        ld      a, l
        rlca
        rlca
        and     $e0
ELSE
craw2:  ld      a, (lookt)
        ld      l, a            ; A=L= rrrRRppp
        and     %00011111
        ld      h, a            ;   H= 000RRppp
        set     6, h
        xor     l               ;   A= rrr00000
ENDIF
        ld      l, a            ;   L= rrr00000
        ld      a, (drawh+1)
IF  offsex != 1
        add     a, offsex-1
ENDIF
        or      l
        ld      l, a
IF  machine=1
        ld      a, (port)
        or      h
        ld      h, a
ENDIF
        ld      a, e
        ld      (drawv+1), a
craw3:  ex      af, af'
        pop     de
        ld      ixl, d
        ld      iyh, d
        ld      iyl, e
        ld      a, e
        and     $03
        add     a, l
        dec     a
        ld      l, a
        ld      a, e
        and     %00001100
        jr      z, craw5
        jp      po, craw6
craw4:  pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     l
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     l
        pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
IF smooth=1
        UPDCLDN
ENDIF
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        dec     l
        pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        dec     l
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        UPDCLDN
        dec     ixh
        jp      z, craw8
        dec     ixl
        jr      nz, craw4
IF smooth=0
        jr      craw7
ELSE
        jp      craw7
ENDIF
craw5:  pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     l
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
IF smooth=1
        UPDCLDN
ENDIF
        pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        dec     l
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        UPDCLDN
        dec     ixh
        jp      z, craw8
        dec     ixl
        jr      nz, craw5
        jr      craw7
craw6:  pop     de
        ld      a, (hl)
        dec     bc
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
IF smooth=1
        UPDCLDN
ENDIF
        pop     de
        ld      a, (hl)
        dec     c
        ld      (bc), a
        and     d
        or      e
        ld      (hl), a
        inc     h
        UPDCLDN
        dec     ixh
        jp      z, craw8
        dec     ixl
        jr      nz, craw6
craw7:  ld      a, iyh
        dec     bc
        ld      (bc), a
        ld      a, iyl
        dec     c
        ld      (bc), a
        ex      af, af'
        dec     a
        jp      nz, craw3
        jp      drawu
craw8:  ld      a, 1
        ex      af, af'
        ld      e, a
        ld      a, (drawv+1)
        sub     e
        inc     a
        ld      (drawv+1), a
        ld      a, iyh
        sub     ixl
        inc     a
        jp      drawt
ENDIF

; Initialisation code. The user call this routine to start the engine
; This will paint clipping bars
; In 48k also paint the sync bar
; In 128k we copy from RAM bank 0 to RAM bank 7
init:   ld      (ini8+1), sp
IF clipup=1
        ld      hl, $5800+offsex  -cliphr+((offsey-1)<<5)
        ld      de, $5800+offsex+1-cliphr+((offsey-1)<<5)
        ld      bc, +((scrw+cliphr)<<1)-1
IF atrbar=0
        ld      (hl), b
ELSE
        ld      (hl), atrbar
ENDIF
        ldir
ENDIF
IF clipdn=1
        ld      hl, $5800+offsex  -cliphr+((offsey+(2*scrh))<<5)
        ld      de, $5800+offsex+1-cliphr+((offsey+(2*scrh))<<5)
IF clipup=1
        ld      c, +((scrw+cliphr)<<1)-1
ELSE
        ld      bc, +((scrw+cliphr)<<1)-1
ENDIF
IF atrbar=0
        ld      (hl), b
ELSE
        ld      (hl), atrbar
ENDIF
        ldir
ENDIF
IF  (scrw=16) || (cliphr=0)
        xor     a
ELSE
IF  (scrw=15) & (offsex=1)
        ld      de, $0020
IF atrbar>0
        ld      a, 0+atrbar
        ld      ($5800+(offsey<<5)), a
        ld      ($5a7f+(offsey<<5)), a
        ld      b, a
        ld      c, a
ELSE
        ld      b, d
        ld      c, d
ENDIF
        ld      a, +(scrh*2)-1
        ld      hl, $5821+(offsey<<5)
ini1:   ld      sp, hl
        push    bc
        add     hl, de
        dec     a
        jr      nz, ini1
IF atrbar=0
        ld      ($5800+(offsey<<5)), a
        ld      ($5a7f+(offsey<<5)), a
ENDIF
ELSE
        ld      a, scrh*2
        ld      de, +(scrw*2)+1
        ld      bc, 31-(scrw*2)
        ld      hl, $5800+offsex-1+(offsey<<5)
IF atrbar=0
ini1:   ld      (hl), b
        add     hl, de
        ld      (hl), b
ELSE
ini1:   ld      (hl), atrbar
        add     hl, de
        ld      (hl), atrbar
ENDIF
        add     hl, bc
        dec     a
        jr      nz, ini1
ENDIF
ENDIF
IF  machine=0
        dec     a
        ld      (screen), a
        ld      (selbeg), a
        ld      (drwout+1), a
IF clipdn=1
        ld      sp, $4020+(((offsey+1+(2*scrh))<<5)&0xe0)+(((offsey+1+(2*scrh))<<8)&0x1800)
ELSE
        ld      sp, $4020+(((offsey+(2*scrh))<<5)&0xe0)+(((offsey+(2*scrh))<<8)&0x1800)
ENDIF
        ld      b, 16
ini2:   push    af
        djnz    ini2
IF clipdn=1
        ld      sp, $4120+(((offsey+1+(2*scrh))<<5)&0xe0)+(((offsey+1+(2*scrh))<<8)&0x1800)
ELSE
        ld      sp, $4120+(((offsey+(2*scrh))<<5)&0xe0)+(((offsey+(2*scrh))<<8)&0x1800)
ENDIF
        ld      de, sylo | (syhi<<8)
        ld      h, e
        ld      l, e
        ld      b, 10
ini3:   push    de
        djnz    ini3
        ld      b, 6
ini4:   push    hl
        djnz    ini4
IF clipdn=1
        ld      sp, $4220+(((offsey+1+(2*scrh))<<5)&0xe0)+(((offsey+1+(2*scrh))<<8)&0x1800)
ELSE
        ld      sp, $4220+(((offsey+(2*scrh))<<5)&0xe0)+(((offsey+(2*scrh))<<8)&0x1800)
ENDIF
        push    de
        push    de
        push    de
        ld      e, d
        ld      b, 13
ini5:   push    de
        djnz    ini5
IF clipdn=1
        ld      sp, $4320+(((offsey+1+(2*scrh))<<5)&0xe0)+(((offsey+1+(2*scrh))<<8)&0x1800)
ELSE
        ld      sp, $4320+(((offsey+(2*scrh))<<5)&0xe0)+(((offsey+(2*scrh))<<8)&0x1800)
ENDIF
        ld      b, 16
ini6:   push    de
        djnz    ini6
IF clipdn=1
        ld      sp, $5820+((offsey+1+(2*scrh))<<5)
ELSE
        ld      sp, $5820+((offsey+(2*scrh))<<5)
ENDIF
        ld      b, 16
ini7:   push    de
        djnz    ini7
        ld      a, do5-2-do3
        ld      (do3+1), a
ini8:   ld      sp, 0
        ret
ENDIF
IF  machine=1
        ld      (do3+1), a
        ld      (port), a

        ld      sp, $fff4
        ld      l, $23
        ex      (sp), hl
        ld      (exit+1), hl
        inc     sp
        ld      hl, $c3c9
        ex      (sp), hl
        ld      a, h
        ld      (exit1+1), a

        ld      sp, $5c06
        ld      hl, ini2
        ld      de, $5b00
IF atrbar=0
        ld      c, ini5-ini2
ELSE
        ld      bc, ini5-ini2
ENDIF
        ldir
        ld      hl, $db00
        call    $5b00
        ld      a, $ff
        ld      (screen), a
        ld      (selbeg), a
        ld      (drwout+1), a
;        dec     a
;        ld      i, a
;        im      2
ini8:   ld      sp, 0
        ret
ini2:   ld      c, +($ff+ini2-ini5)&$ff
        ldir
        ld      a, $17
        call    $5b00+ini4-ini2
        ld      c, +($ff+ini2-ini5)&$ff
        ex      de, hl
        dec     e
        dec     l
        lddr
        inc     e
        inc     l
        ex      de, hl
        ld      c, +($ff+ini2-ini5)&$ff
        add     hl, bc
        ld      a, $10
        call    $5b00+ini4-ini2
        jr      nc, ini2
        call    $5b00+ini3-ini2
        ld      hl, $4000
        ld      de, $c000
        ld      bc, $1b00
        ldir
ini3:   xor     $07
ini4:   push    bc
        ld      bc, $7ffd
        out     (c), a
        pop     bc
        ret
ini5:
exit:   ld      hl, 0
        ld      ($fff4), hl
exit1:  ld      a, 0
        ld      ($fff6), a

        ld      a, $10
        jr      ini4
ENDIF
IF  machine=2
        ld      (do3+1), a
        dec     a
        ld      (screen), a
        ld      (selbeg), a
        ld      (drwout+1), a
        dec     a
        ld      i, a
        im      2
ini8:   ld      sp, 0
        ret
ENDIF

; This code is part of the map compressor, exactly a get bit routine
IF (bithlf=1) && (bitsym>1)
gbit1:  sub     $80 - (1 << (bitsym - 2))
        defb    $da             ; second part of half bit implementation
ENDIF
gbit2:  ld      b, (hl)         ; load another group of 8 bits
        dec     hl
gbit3:  rl      b               ; get next bit
        jr      z, gbit2        ; no more bits left?
        adc     a, a            ; put bit in a
        ret

; This code is part of the loader. It tries if floating bus exists.
; It's here because loader is located in contened memory
IF  machine=2
        ld      c, 5
ini9:   in      a, ($ff)
        inc     a
        ret     nz
        djnz    ini9
        dec     c
        jr      nz, ini9
        ret
ENDIF

; Map file. Generated externally with TmxCompress.c from map.tmx
map:    binary "../build/map_compressed.bin"
mapend:

; Look up 256 bytes table and space to decompressor
        defs    final-ASMPC
IF smooth=0
IF notabl=0
lookt:  binary "asm/file1.bin"
ENDIF
        defs    $feff-ASMPC
        defb    $ff
ELSE
        defs    $7f
IF notabl=0
lookt:  binary "asm/file1.bin"
ENDIF
        defs    $100
ENDIF
        defb    $ff
        defs    $fff4-ASMPC
        inc     hl
        ret
        defb    $c9
IF machine=1
        defw    exit
ELSE
        defw    0
ENDIF
        jp      do_sprites
        jp      init
        defb    $18

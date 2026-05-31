adc (hl+)
adc (hl-)
adc a', (hl+)
adc a', (hl-)
adc hl, bc
adc.l a, (hl+)
adc.l a, (hl-)
add bc, 1+2*3
add bc, a
add hl, 1+2*3
add sp, 1+2*3
adi hl, 1+2*3
adi sp, 1+2*3
altd adc a, (hl+)
altd adc a, (hl-)
altd clr hl
altd ld a, (de+)
altd ld bc, de
and hl, bc
arhl
bool hl
bool ix
call (ix)
call c, lbl1
call eq, lbl1
call geu, lbl1
call gtu, lbl1
call leu, lbl1
call lo, lbl1
call ltu, lbl1
call lz, lbl1
call m, lbl1
call nc, lbl1
call ne, lbl1
call nz, lbl1
call p, lbl1
call pe, lbl1
call po, lbl1
call z, lbl1
call.il geu, lbl1
call.il gtu, lbl1
call.il leu, lbl1
call.il ltu, lbl1
call3 geu, lbl1
call3 gtu, lbl1
call3 leu, lbl1
call3 ltu, lbl1
clr (hl)
clr (ix+1+2*3)
clr (iy-1-2*3)
clr a
clr hl
clr hl'
cpd
cpdr
cpi
cpir
daa
dec (hl-)
dec.l (hl-)
djnz b, lbl1
djnz lbl1
dsub
ex (sp), hl
ex af', af
ex af, af
ex bc, hl
ex de, hl
ex hl', de
inc (hl+)
inc.l (hl+)
ioe adc a, (hl-)
ioe dec (hl-)
ioe ld (hl-), 1+2*3
ioe ld a, (de-)
ioi adc a, (hl+)
ioi inc (hl+)
ioi ld (hl+), 1+2*3
jp (bc)
jp eq, lbl1
jp ge, lbl1
jp geu, lbl1
jp gtu, lbl1
jp le, lbl1
jp leu, lbl1
jp lo, lbl1
jp ltu, lbl1
jp lz, lbl1
jp ne, lbl1
jp.il geu, lbl1
jp.il gtu, lbl1
jp.il leu, lbl1
jp.il ltu, lbl1
jp3 geu, lbl1
jp3 gtu, lbl1
jp3 leu, lbl1
jp3 ltu, lbl1
jr c, lbl1
jr eq, lbl1
jr geu, lbl1
jr gtu, lbl1
jr leu, lbl1
jr ltu, lbl1
jr nc, lbl1
jr ne, lbl1
jr nz, lbl1
jr z, lbl1
jre c, lbl1
jre eq, lbl1
jre geu, lbl1
jre gtu, lbl1
jre leu, lbl1
jre ltu, lbl1
jre nc, lbl1
jre ne, lbl1
jre nz, lbl1
jre z, lbl1
ld (1+2*3), de
ld (de), 1+2*3
ld (de), a
ld (de), hl
ld (hl+), 1+2*3
ld (hl+), bc
ld (hl-), 1+2*3
ld (ix+1+2*3), bc
ld (iy-1-2*3), de
ld a', (bc-)
ld a, (bc+)
ld a, (hld)
ld a, (hli)
ld bc', de ;'
ld bc, (1+2*3)
ld bc, (hl)
ld hl, bc
ld hl, sp+1+2*3
ld ix, iy
ld.l (bc+), a
ld.l (de+), 1+2*3
ldd
ldd a, (hl)
lddr
ldhi 1+2*3
ldi
ldi a, (hl)
ldir
ldsi 1+2*3
lhlde
lhlx
neg
neg b
neg bc
or ix, de
push bc'
rdel
ret eq
ret geu
ret gtu
ret leu
ret lo
ret ltu
ret lz
ret ne
ret.l c
ret.l eq
ret.l geu
ret.l gtu
ret.l leu
ret.l ltu
ret.l m
ret.l nc
ret.l ne
ret.l nz
ret.l p
ret.l pe
ret.l po
ret.l z
ret3 geu
ret3 gtu
ret3 leu
ret3 ltu
rl hl
rld
rlde
rr de
rrd
rrhl
shlde
sra bc
sub hl, bc
xchg
xthl

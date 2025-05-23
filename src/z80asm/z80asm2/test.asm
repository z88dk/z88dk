; backslash
ld\
a,\
25

; continuation lines
ld a,25:ld b,30\ld c,40

; equ
.v1 equ 10:v2: equ 20\v3 equ 30

; ## concatenating
ld a , xp ## to

; label
.l1 ld a,25
l2:ld a,25
ld a,25

; .ASSUME
.Assume 0:.Assume 1

; include file
include "xpto.inc"
include "test.inc"
include "./test.inc"
include ".\test.inc"
include 'test.inc'
Include "test.inc" error
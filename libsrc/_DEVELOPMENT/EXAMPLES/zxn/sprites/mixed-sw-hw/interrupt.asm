;; create 257-byte im2 vector table

SECTION VECTOR_TABLE
org 0xd000

defs 257, 0xd1

;; create jp to isr at im2 vector table target

SECTION VECTOR_TABLE_JP
org 0xd1d1

EXTERN _isr
jp     _isr

;; insert im2 initialization code into crt
;; this runs before main is called
;; interrupts will be enabled in main when things are set up

SECTION code_crt_init

EXTERN __VECTOR_TABLE_head

ld a,__VECTOR_TABLE_head / 256
ld i,a

im 2

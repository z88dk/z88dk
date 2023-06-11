; boot loader
; EOSDEF -- Library of essential routines for EOS
;
; Thanks to @tschak909 for the original


    SECTION     BOOTSTRAP

    EXTERN  __DATA_END_tail

    ORG     $C800

Boot:
    LD      A,B
    LD      (CurrentDev),A

start_loading:
    ld      a,@00000001     ;64k of intrinsic RAM everywhere
    out     ($7f),a

    ; Each block is 1k in size
    ld      b,+((__DATA_END_tail - CRT_ORG_CODE) / 1024) + 1
    ld      hl,CRT_ORG_CODE
    ld      de,1            ;Block number
load_loop:
    push    bc
    push    de
    push    hl
    ld      a,(CurrentDev)
    ld      bc,0
    call    Read1Block
    pop     hl
    ld      a,h
    add     4
    ld      h,a
    pop     de
    inc     de
    pop     bc
    djnz    load_loop
    LD      A,(CurrentDev)
    LD      B,A
    RST     0           ;Start the program

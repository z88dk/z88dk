; uint in_Inkey(void)

; Read current state of keyboard

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl
EXTERN __cpc_scan_allrows
EXTERN __cpc_keystate

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL

.in_Inkey
._in_Inkey
    call    __cpc_scan_allrows
    ld      de,__cpc_keystate
    ld      hl,rowmasks
    ld      bc,2560
scanloop: 
    ld      a,(de)
    cpl
    and     (hl)
    jr      nz,hitkey
    inc     de
    inc     hl
    ld      a,c
    add     8
    ld      c,a
    djnz    scanloop

nokey:
    ld      hl,0
    scf
    ret

hitkey:
; c = offset in table
; a = set keys
    ld      e,8
hitkey_loop:
    rlca
    jr      c,doneinc
    inc     c
    dec     e
    jr      nz,hitkey_loop
doneinc:
    ld      b,0
    ld      de,80
    ld      a,(__cpc_keystate+2)	;Row for shift + ctrl
    bit     5,a
    jr      z,done
    ld      de,160
    bit     7,a
    jr      z,done
    ld      de,0
done:
    ld      hl,in_keytranstbl
    add     hl,de
    add     hl,bc
    ld      a,(hl)
    cp      255
    jr      z,nokey
    ld      l,a
    ld      h,0
    and     a
    ret
    
rowmasks:
    defb    255,255,95,255,255,255,255,255,255,128

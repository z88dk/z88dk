; sccz80 crt0 library - 8085 version

SECTION code_crt0_sccz80
PUBLIC  l_asr
PUBLIC  l_asr_hl_by_e

.l_asr
    ex de,hl
.l_asr_hl_by_e
    dec e       ; 4
    ret M       ; 12/6

.l_asr1
    sra hl      ; 7
    dec e       ; 4
    jp P,l_asr1 ; 10/7  -> 21 per cycle 
    ret         ; 10    (shift by 1 -> 38 cycles)

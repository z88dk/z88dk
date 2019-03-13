;
;	Do the checksum for an IP packet
;
;	Assumes packet is fully built etc, fills in the appropriate field
;
;	djm 12/2/2001
;

        SECTION code_clib
	PUBLIC	IPHeaderCheck
	PUBLIC	_IPHeaderCheck


; void IPHeaderSum(ipheader_t *pkt)
.IPHeaderCheck
._IPHeaderCheck
	pop	de
	pop	hl
	push	hl
	push	de
               ld   bc,10
               add  hl,bc
               xor  a
               ld   (hl),a
               inc  hl
               ld   (hl),a         ; Set checksum to zero
               push hl
               scf
               sbc  hl,bc
               ld   a,(hl)
               and  $0f
               rlca
               rlca
               ld   c,a
               ld   b,0
               pop  hl
               ld   (hl),c
               dec  hl
               ld   (hl),b
	ret


.FastCSum      push hl
               push de
               ld   a,c
               ld   c,b       ;  swap b,c
               srl  c
               rra            ; adjust counter for words
               ld   b,a       ; (cb=#words)
               push af        ; save cary for a single byte
               ld   de,0      ; de=sum
               or   c         ; check for zero also clear carry
               jr   z,FastCsum_2   ; Only one or less bytes
               inc  c
               ld   a,b
               or   a
               jr   z,FastCsum_1b
.FastCsum_1              ; use counter c for outer loop
               ld   a,(hl)
               inc  hl
               adc  a,d
               ld   d,a
               ld   a,(hl)
               inc  hl
               adc  a,e
               ld   e,a
               djnz FastCsum_1     ; inner loop
.FastCsum_1b
               dec  c
               jr   nz,FastCsum_1  ; outer loop
               ld   a,d
               adc  a,0
               ld   d,a
               ld   a,e
               adc  a,0
               ld   e,a
               ld   a,d
               adc  a,0
               ld   d,a
.FastCsum_2
               pop  af        ; check for single byte
               jr   nc,FastCsum_3
               ld   a,(hl)
               add  a,d
               ld   d,a
               ld   a,e
               adc  a,0
               ld   e,a
               ld   a,d
               adc  a,0
               ld   d,a
               ld   a,e
               adc  a,0
               ld   e,a
.FastCsum_3
               ld   a,d
               cpl
               ld   b,a
               ld   a,e
               cpl
               ld   c,a
               pop  de
               pop  hl
               ret


;
;	ZX Spectrum specific routines
;	Stefano Bodrato - 5/2/2008
;
;	int opus_installed();
;
;	The result is:
;	- 0 (false) if the Opus Discovery Interface is missing
;	- 1 (true) if the Opus Discovery Interface is connected
;
;   New method: probe the results just attempting to page in the shadow ROM.
;
;	The old way: try to issue a POINT #0,1 command, to see if the syntax is accepted.
;	If so, try the short style command LOAD *PI;"A"
;	Shouldn't conflict with other interfaces, but still risky.
;
;	$Id: zx_opus.asm $
;

    SECTION code_clib
    PUBLIC  zx_opus
    PUBLIC  _zx_opus
;    EXTERN  zx_syntax


zx_opus:
_zx_opus:

    ; Check the base ROM: byte in $1708 must be 0x23 (INC HL)
    ld   a,($1708)
    cp   0x23
    jr   nz,no_opus       ; Incompatibile ROM

    ; If the shadow ROM won't intercept the code ta $1708
	; the ROM will eat the RETurn address and no_opus will be used on return
    ld   hl,no_opus
    push hl               ; used to jump over if page-in fails

	ld hl,k_ptr-1         ; ; ('K','S','P') can be used, they all will point to routine POP/RET
    call $1708            ; If OPUS is present: page-in e return here.
                          ; If no OPUS: CLOSE-2 -> INDEXER -> dummy "close" routine in ROM does POP HL/RET

    ; ---------- OPUS has been enabled ----------
    ; the CALL ended normally, no POP/RET on exit
    pop  hl               ; [no_opus]
    call $1748            ; PAGE_OUT
    ld   hl,1             ; Signal OPUS presence
    ret

    ; ---------- Standard ROM ----------
no_opus:
    ld   hl,0             ; Signal OPUS missing
    ret

k_ptr:
    defb 'K'

; ---------------------------------------
;  The old way:

;     ld      hl, testcmd
;     call    zx_syntax
;     xor     a
;     or      l
;     ret     z
;     ld      hl, testcmd2                ; further test (Disciple might accept "POINT")
;     jp      zx_syntax
; 
; 
; testcmd:
;     defb    169, 35, 195, 167, 44, 188, 167, 13
;                                         ; POINT # NOT PI,SGN PI <CR>
; testcmd2:
;     defb    239, 42, 167, 59, 34, 65, 34, 13
;                                         ; LOAD *PI;"A"


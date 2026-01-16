;
;   Visual 1050 specific code
;
;   Stefano Bodrato - 2023
;
;
;   $Id: v1050_sendchar.asm $
;

    SECTION code_clib
    PUBLIC  v1050_sendchar
    PUBLIC  _v1050_sendchar
    PUBLIC  v1050_sendchar_fast
    PUBLIC  _v1050_sendchar_fast

v1050_sendchar:
_v1050_sendchar:
v1050_sendchar_fast:
_v1050_sendchar_fast:

;; ..using the BIOS
;    push    bc
;    push    de
;    ld      c, l
;    ld      de, 9                       ; shift ptr to CONOUT
;    ld      hl, (1)                     ; WBOOT (BIOS)
;    add     hl, de
;    call    __chl
;    pop     de
;    pop     bc
;    ret
;
;__chl:
;    jp      (hl)


 ; ..direct I/O
     PUSH    BC
     LD  B,13                 ; workaround for a weakeness in the strobe signal, perhaps in the MAME emulator
 MDSPOT:
     ; Wait for display section to read previous byte
     IN      A, (86h)         ; Read port C
     AND     1                ; display ready?
     JR      Z, MDSPOT        ; No, PC0=0, loop and wait
     DJNZ    MDSPOT
 
     ; Output byte display section
     ld      a, l             ; A=the byte
     OUT     (85h), A         ; Output to port B
 
     ; Strobe PC7 from 1 to 0 andh back to 1
     LD      A,0Eh            ; Mask to reset port C bit 7
     OUT     (87h), A         ; reset it
     INC     A                ; A=0Fh, mask to set port C bit 7
     OUT     (87h), A         ; set it
     POP     BC
 
     ret

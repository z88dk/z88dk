;
;=============================================================
;
; int exycall();
;
;   Calls the Exidy Standard Monitor
;   using the monitor command found at MWA.
;   Returns 0 if illegal command (or no command)
;     or    1 if command successfully executed.
;
;   WARNING: This function may not return AT ALL if you
;   crash it in the Monitor itself! ;BE WARNED!
;

SECTION code_clib

PUBLIC exycall
PUBLIC _exycall


exycall:
_exycall:
    PUSH    IX          ;just in case!
    PUSH    IY          ;move IY
    POP     HL          ;  to HL
    call    0e225h      ;(scan the input buffer) get delims
    JP      Z,exyc5     ;NONE!

    LD      IX,0e312h	; Point to command table
exyc1:
    PUSH    HL
    PUSH    IX
    LD  b,2
exyc2:
    LD A,(IX+0)
    CP  (HL)
    JP  NZ,exyc4
    INC HL
    INC IX
    DEC b
    JP  NZ,exyc2
    POP DE
    POP DE
    LD  BC,exyc6
    PUSH    BC
exyc3:
    LD L,(IX+0)
    LD H,(IX+1)
    JP  (HL)

exyc4:
    POP IX
    POP HL
    INC IX
    INC IX
    INC IX
    INC IX
    LD A,(IX+0)
    OR  a
    JP  NZ,exyc1

exyc5:
    LD  HL,0
    POP IX
    ret

exyc6:
    LD  HL,1
    POP IX
    ret


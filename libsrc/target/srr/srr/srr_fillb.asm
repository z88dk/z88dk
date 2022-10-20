;
;=============================================================
;
; int srr_fillb(int a1, int a2, char c, int mode)
;
;   if (mode==0)
;     Fills memory from address a1 to address a2 (inclusive)
;     with the byte c.
;   else
;     Fills memory from address a1 for a2 bytes with byte c.
;

PUBLIC srr_fillb
PUBLIC _srr_fillb

EXTERN srr_arghak

EXTERN srr_arg1
EXTERN srr_arg2
EXTERN srr_arg3
EXTERN srr_arg4


srr_fillb:
_srr_fillb:

    call    srr_arghak
;   PUSH    BC

    LD  A,(srr_arg4)    ;"from/to" or "from/count"
    OR  a               ;"from/to" - jump
    JP  Z,fillb2
    LD  HL,(srr_arg2)   ;"COUNT" value
    PUSH    HL          ;move it to
    POP BC              ;BC
    JP  fillb4          ;and jump

fillb2:
    LD  HL,(srr_arg1)   ;"FROM" address
    LD  a,l             ;turn it
    CPL                 ;round
    LD  e,a             ;into the DE pair
    LD  a,h
    CPL
    LD  d,a             ;to form"1's comp"
    INC DE              ;and now"2's comp"
    LD  HL,(srr_arg2)   ;and now get"TO" addr
    ADD HL,DE           ;ie"TO" - "FROM" = range
    PUSH    HL          ;move it to
    POP BC              ;BC (bytes to fill)
    INC BC              ;include the end address too!

fillb4:
    LD  HL,(srr_arg1)   ;"FROM" address
    LD  A,(srr_arg3)    ;byte to fill with
    LD  e,a             ;just somewhere to put it!

fillb6:
    LD  (HL),a          ;and fill it in there!
    INC HL              ;point to next fill address
    DEC BC              ;one less to go!
    LD  a,b
    OR  c               ;finished ?
    JP  Z,fillb8        ;yes - jump
    LD  a,e             ;get fill byte again
    JP  fillb6          ;and fill with it

fillb8:
;   POP BC              ;all over
    ret


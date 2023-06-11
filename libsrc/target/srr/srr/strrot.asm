;==============================================================
;
; char *strrot(int mode,char *s)
;
;    Rotates the string (end around) pointed to by"s".
;    If mode==0 then rotate LEFT, and
;    if mode<>0 then rotate RIGHT.
;    Returns the address of the string.
;


SECTION code_clib

PUBLIC strrot
PUBLIC _strrot

EXTERN srr_arghak

EXTERN srr_arg1
EXTERN srr_arg2


strrot:
_strrot:
    call    srr_arghak
    ;PUSH   BC

    LD      HL,(srr_arg2)   ;point to string
    PUSH    HL
    POP     DE              ;in DE as well
    INC     DE              ;and point ahead one
    LD      c,0             ;a counter to zero!
    LD      A,(srr_arg1)    ;get MODE switch
    OR      a               ;rotate left ?
    JP      NZ,strr06       ;no - jump

    LD      a,(HL)          ;get char to rotate
    LD      b,a             ;and save it
strr02:
    LD      A,(DE)          ;get char
    OR      a               ;have we reached end of str
    JP      Z,strr04        ;yes - jump
    LD      (HL),a          ;rotate the char
    INC     HL              ;next please
    INC     DE
    JP      strr02          ;and back for more
strr04:
    LD      a,b             ;"the first shall be last.."
    LD      (HL),a
    JP      strr14

strr06:
    LD      a,(HL)          ;first scan for end
    INC     HL
    INC     c               ;chars in string
    OR      a               ;there yet ?
    JP      NZ,strr06       ;no - back we go
    DEC     HL              ;point back to the null
    DEC     HL              ;and then to last char
    DEC     c               ;we don't count the null
    PUSH    HL              ;and copy
    POP     DE              ;to DE
    DEC     DE              ;back one more
    LD      a,(HL)          ;the end char to save
    LD      b,a             ;in B
strr10:
    DEC     c               ;have we rotated enough ?
    JP      Z,strr12        ;yes - jump
    LD      A,(DE)          ;get char to rotate
    LD      (HL),a          ;and rotate it!
    DEC     HL              ;back one more
    DEC     DE
    JP      strr10          ;next please

strr12:
    LD      a,b             ;".and the last shall be first"
    LD      (HL),a
strr14:
    LD      HL,(srr_arg2)   ;return string address
    ;POP    BC
    ret


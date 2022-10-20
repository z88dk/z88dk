
;
;============================================================
;
; int cursor(x,y);
;
;   moves the cursor to position x (line), y (column) of
;   the Sorcerer screen. (if possible)!
;   Returns the offset from the beginning of the screen RAM
;   of the new cursor position.

SECTION code_clib

PUBLIC cursor
PUBLIC _cursor

EXTERN srr_arghak

EXTERN srr_arg1
EXTERN srr_arg2


cursor:
_cursor:
    call    srr_arghak      ;get the srr_arguements
    ;PUSH   BC      ;we need it!

    LD  A,(srr_arg2)        ;get the column
    OR  a
    JP  M,curses        ;you can't have a -ve column!
    CP  64
    JP  NC,curses       ;or one > 63
    LD  A,(srr_arg1)        ;get the line
    OR  a
    JP  M,curses        ;you can't have a -ve line!
    CP  30
    JP  NC,curses       ;or one > 29

    LD  A,(srr_arg1+1)
    OR  a
    JP  NZ,curses
    LD  A,(srr_arg2+1)
    OR  a
    JP  NZ,curses

    call    0e1a2h          ; Make IY point to work area (close to RAMPTOP)
    call    0e9e8h      ;remove the old cursor
    LD      A,(srr_arg1)
    LD      e,a             ;and multiply it be 64
    LD      d,0
    LD      b,6
cur04:
    sla     e
    rl      d
    DEC     b
    JP      NZ,cur04
    LD      (IY+68h),E  ;and save it in the MWA
    LD      (IY+69h),D  ;(both bytes)
    LD      A,(srr_arg2)    ;now get the column
    LD      (IY+6Ah),A  ;and save it too
    LD      (IY+6Bh),0  ;high byte is zero
    call    0e9cch      ;and put the cursor there!

curses:
    call    0e9d6h      ;find the cursor address, just in case we hadn't
    ;POP    BC          ;told you we'd need it

    ret         ;home we go


;
;============================================================= 
;
; char *srr_fill(int saddr,int eaddr,char *string,int opt)
;
;   If (opt==0)
;     Fills a contiguous block of RAM starting at saddr and 
;     ending at eaddr with the string pointed to by "string".
;   else
;     Fills a contiguous block of RAM starting at saddr of
;     length eaddr bytes with the string pointed to.
;
;   The string is reused until the fill is complete.
;   Returns the address of the fill string.
;

PUBLIC srr_fill
PUBLIC _srr_fill

EXTERN srr_arghak

EXTERN srr_arg1
EXTERN srr_arg2
EXTERN srr_arg3
EXTERN srr_arg4

srr_fill:
_srr_fill:
        call   srr_arghak
        ;PUSH   BC
		
        LD     A,(srr_arg4)   ;"from/to" or "from/count"
        OR     a
        jr     z,fill02       ;"from/to" - jump
        LD     HL,(srr_arg2)  ;get "COUNT"
        PUSH   HL             ;and move to
        POP    BC             ;BC
        jr     fill04         ;then jump
 
fill02: LD     HL,(srr_arg1)  ;"FROM" address
        LD     a,l            ;turn it
        CPL                   ;round
        LD     e,a            ;into the DE pair
        LD     a,h
        CPL
        LD     d,a            ;to form "1's comp"
        INC    DE             ;and now "2's comp"
        LD     HL,(srr_arg2)  ;and now get "TO" addr
        ADD    HL,DE          ;ie "TO" - "FROM" = range
        PUSH   HL             ;move it to
        POP    BC             ;BC (bytes to fill)
        INC    BC             ;include the end address too!
 
fill04: LD     HL,(srr_arg1)  ;"FROM" address
        EX     DE,HL          ;to DE
        LD     HL,(srr_arg3)  ;pointer to the "fill string"
        LD     a,(HL)         ;get first char to fill with
        OR     a              ;null string ?
        jr     z,fill08       ;if so then quit
 
fill06: LD     (DE),A         ;and fill it in there!
        INC    DE             ;point to next fill address
        INC    HL             ;and next "fill string" char
        DEC    BC             ;one less to go!
        LD     a,b
        OR     c              ;finished ?
        jr     z,fill08       ;yes - jump
        LD     a,(HL)         ;get the next char to fill with
        OR     a              ;is it a 0 (end of string)
        jr     nz,fill06      ;no - fill with it then
        LD     HL,(srr_arg3)  ;back to the start of string
        LD     a,(HL)         ;get the first char
        jr     fill06         ;and fill with it
 
fill08: LD    HL,(srr_arg3)   ;return addr of the fill str 
        ;POP     BC           ;all over
        ret

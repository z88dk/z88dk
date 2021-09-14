;
;       Small C+ Compiler
;       
;       Long Support Library
;       "8085" mode
;
;       August 2021 - feilipu

;       This routine is used to push longs on the stack for a 
;       call to a function defined as a pointer.

SECTION code_crt0_sccz80

PUBLIC  lpush2
EXTERN  __retloc

.lpush2
;   ld      (__retloc),hl   ;16 LSW
;   pop     hl              ;10 next item on stack (2nd return) to hl (XXX BUG? pop bc)
;   push    de              ;12 MSW to stack
;   ex      de,hl           ;4  de is now return address
;   ld      hl,(__retloc)   ;16 LSW in hl
;   push    hl              ;12 LSW to stack
;   ex      de,hl           ;4
;   push    bc              ;12 store back "next item on stack"
;   push    de              ;12
;   ld      hl,(__retloc)   ;16
;   ret                     ;10 -> 124

    pop bc          ;10 1st return to bc
    ex de,hl        ;4  MSW to hl
    ex (sp),hl      ;16 stack MSW, 2nd return to hl
    push de         ;12 LSW to stack
    push hl         ;12 2nd return to stack
    ld hl,bc        ;8  1st return to hl
    jp (hl)         ;4  -> 68


;lpush2:

;  pop ix           ;14

;  pop bc           ;10
;  push de          ;11
;  push hl          ;11
;  push bc          ;11

;  jp (ix)          ;8  -> 65

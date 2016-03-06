;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
PUBLIC l_long_add

.l_long_add

   ; dehl = primary
   ; stack = secondary, ret
   ; 76 cycles hurrah!
   
   pop ix           ; ix = ret addr
   
   pop bc           ; bc = secondary LSW
   add hl,bc
   ex de,hl         ; de = result LSW
   pop bc           ; bc = secondary MSW
   adc hl,bc
   ex de,hl         ; dehl = result
   
   jp (ix)

; dehl = primary
; stack = secondary, ret
; 123 cycles
;
;   pop bc           ; bc holds ret address
;   ex de,hl         ; primary = hlde
;   ex (sp),hl       ; hl = secondary LSW, stack = primary MSW
;   add hl,de        ; add LSWs
;   pop de           ; de = primary MSW
;   ex (sp),hl       ; hl = secondary MSW, stack = result LSW
;   adc hl,de        ; add MSWs
;   ex de,hl         ; de = result MSW
;   pop hl           ; hl = result LSW
;   push bc
;   ret

; This routine appears to cause horrendous crashes, but I'm not
; sure why...mysterious!

; 127 cycles

;.l_long_add
;        
;        ld      a,l
;        exx     ;2
;        pop     bc      ;ret address
;        pop     hl      ;secondary
;        pop     de
;        push    bc
;        add     a,l
;        ld      l,a
;        ld      a,h
;        exx     ;1
;        adc     a,h
;        exx     ;2
;        ld      h,a
;        ld      a,e
;        exx     ;1
;        adc     a,e
;        exx     ;2
;        ld      e,a
;        ld      a,d
;        exx     ;1
;        adc     a,d
;        exx     ;2
;        ld      d,a
;        ret

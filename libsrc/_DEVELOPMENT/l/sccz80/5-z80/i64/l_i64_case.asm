SECTION code_l_sccz80

PUBLIC  l_i64_case
EXTERN  __i64_acc

; Entry: 
;       ACC = value to compare against
l_i64_case:

   pop hl                      ; hl = & switch table

loop:

   ld a,(hl)
   inc hl
   or (hl)
   inc hl
   jr z, end                   ; if end of table
   
   ld de,__i64_acc

   push hl
   ld b,8
continue:
   ld a,(de)
   inc de
   cp (hl)
   inc hl
   jr nz,nomatch
   djnz continue
   pop hl
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
end:
   jp (hl)

nomatch:
   pop hl
   ld  bc,8
   add hl,bc
   jr loop

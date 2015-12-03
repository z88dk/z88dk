
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_proc_move_up_down

EXTERN l_divu_hl

zx_01_output_fzx_proc_move_up_down:

   ; helper for up/down functions
   ;
   ; on stack = return, function address

   ld l,(ix+37)
   ld h,(ix+38)                ; hl = y coord
   
   call l_divu_hl - 6          ; hl = y / 8
   ld d,l                      ; d = y coord in characters

   ld l,(ix+45)
   ld h,(ix+46)                ; hl = paper.height
   
   call l_divu_hl - 6
   ld b,l                      ; b = paper.height in characters
   
   ld hl,return
   ex (sp),hl
   
   jp (hl)                     ; call function address

return:

   ld l,d
   ld h,0                      ; hl = new y coord in characters
   
   add hl,hl
   add hl,hl
   add hl,hl                   ; hl = new y coord in pixels
   
   ld (ix+37),l
   ld (ix+38),h                ; store new y coord
   
   ret


SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_proc_move_left_right

EXTERN l_divu_hl

zx_01_output_fzx_proc_move_left_right:

   ; helper for left/right functions
   ;
   ; on stack = return, function address

   ld l,(ix+37)
   ld h,(ix+38)                ; hl = y coord
   
   call l_divu_hl - 6          ; hl = y / 8
   ld d,l                      ; d = y coord in characters

   ld l,(ix+35)
   ld h,(ix+36)                ; hl = x coord
   
   call l_divu_hl - 6          ; hl = x / 8
   ld e,l                      ; e = x coord in characters
   
   ld l,(ix+45)
   ld h,(ix+46)                ; hl = paper.height
   
   call l_divu_hl - 6
   ld b,l                      ; b = paper.height in characters

   ld l,(ix+41)
   ld h,(ix+42)                ; hl = paper.width

   call l_divu_hl - 6
   ld c,l                      ; c = paper.width in characters

   ld hl,return
   ex (sp),hl
   
   jp (hl)                     ; call function

return:

   ld l,e
   ld h,0                      ; hl = x coord in characters
   
   add hl,hl
   add hl,hl
   add hl,hl
   
   ld (ix+35),l
   ld (ix+36),h                ; set new x coord
   
   ld l,d                      ; hl = y coord in characters
   
   add hl,hl
   add hl,hl
   add hl,hl
   
   ld (ix+37),l
   ld (ix+38),h                ; set new y coord
   
   ret

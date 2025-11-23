
SECTION code_font
SECTION code_font_fzx

PUBLIC __fzx_partition_width_adjust

__fzx_partition_width_adjust:

   ; Partition functions always add tracking to each
   ; char's width when determining if a char will
   ; fit the allowed width.  The last char should not
   ; have tracking added so this function compensates
   ; by adding tracking to the allowed width.
   
   push bc
   
   ld c,(ix+1)
   ld b,0                      ; bc = tracking

;; inexplicably partitions are allowing one addition pixel
;; width than they should; this fix is empirical!
;; 
;;   inc c

   add hl,bc                   ; allowed_width += tracking + 1
   
   pop bc
   ret

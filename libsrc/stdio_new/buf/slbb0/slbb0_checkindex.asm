; slbb0_checkindex
; 08.2009 aralbrec

PUBLIC slbb0_checkindex

; check if an index value points to data within the buffer
;
; enter : hl = & struct slbb
;          a = index
; exit  : carry set   = in bounds index
;         carry reset = out of bounds index
;         z set       = one past end of data in buffer
; uses  : f

.slbb0_checkindex

   cp (hl)
   ret

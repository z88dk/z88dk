
      ; hl is typically pointing directly to a basic line,
      ; so for end marker you should check for $0D, ":" as well as 0.

      push de
      
      ld bc,0
      ld d,b                   ; d = quote indicator
      
   cmdline_len:
      
      ld a,(hl)
      
      inc d
      dec d
      
      jr z, cmdline_outside_quote
      
      cp d
      jr nz, cmdline_accept    ; if char is inside quote
      
      ld d,0                   ; end of quote seen
      jr cmdline_accept
      
   cmdline_outside_quote:
      
      cp ':'
      jr z, cmdline_len_end
      
      cp '"'
      jr nz, cmdline_accept
   
   cmdline_start_quote:
   
      ld d,a
   
   cmdline_accept:
   
      or a
      jr z, cmdline_len_end
      
      cp 0x0d
      jr z, cmdline_len_end
      
      inc hl
      inc bc
      
      jr cmdline_len

   cmdline_len_end:
   
      pop de

      ; bc = length (could be zero)
      ; carry flag reset

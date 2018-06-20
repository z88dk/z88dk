
      ; hl is typically pointing directly to a basic line,
      ; so for end marker you should check for $0D, ":" as well as 0.
      
      ld e,l
      ld d,h                   ; de = & command line
      
      ld bc,0
      
   cmdline_len:
      
      ld a,(hl)
      
      or a
      jr z, cmdline_len_end
      
      cp ':'
      jr z, cmdline_len_end
      
      cp 0x0d
      jr z, cmdline_len_end
      
      inc hl
      inc bc
      
      jr cmdline_len

   cmdline_len_end:

      ; de = & command line
      ; bc = length (could be zero)
      ; carry flag reset

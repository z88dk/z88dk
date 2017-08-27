/* altd djnz NN */
| label? _TK_ALTD _TK_DJNZ expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_jr(0x10); 
}

/* altd ld a,eir */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_EIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED57); 
}

/* altd ld a,iir */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED5F); 
}

/* altd ld a,xpc */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_XPC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED77); 
}

/* altd res 0,a */
/* altd res 1,a */
/* altd res 2,a */
/* altd res 3,a */
/* altd res 4,a */
/* altd res 5,a */
/* altd res 6,a */
/* altd res 7,a */
| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB87); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8F); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB97); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9F); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA7); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAF); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB7); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBF); 
  }
  else
    error_int_range(expr_value);

}

/* altd res 0,b */
/* altd res 1,b */
/* altd res 2,b */
/* altd res 3,b */
/* altd res 4,b */
/* altd res 5,b */
/* altd res 6,b */
/* altd res 7,b */
| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB80); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB88); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB90); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB98); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA0); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBA8); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB0); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBB8); 
  }
  else
    error_int_range(expr_value);

}

/* altd res 0,c */
/* altd res 1,c */
/* altd res 2,c */
/* altd res 3,c */
/* altd res 4,c */
/* altd res 5,c */
/* altd res 6,c */
/* altd res 7,c */
| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB81); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB89); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB91); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB99); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA1); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBA9); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB1); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBB9); 
  }
  else
    error_int_range(expr_value);

}

/* altd res 0,d */
/* altd res 1,d */
/* altd res 2,d */
/* altd res 3,d */
/* altd res 4,d */
/* altd res 5,d */
/* altd res 6,d */
/* altd res 7,d */
| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB82); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8A); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB92); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9A); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA2); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAA); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB2); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBA); 
  }
  else
    error_int_range(expr_value);

}

/* altd res 0,e */
/* altd res 1,e */
/* altd res 2,e */
/* altd res 3,e */
/* altd res 4,e */
/* altd res 5,e */
/* altd res 6,e */
/* altd res 7,e */
| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB83); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8B); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB93); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9B); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA3); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAB); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB3); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBB); 
  }
  else
    error_int_range(expr_value);

}

/* altd res 0,h */
/* altd res 1,h */
/* altd res 2,h */
/* altd res 3,h */
/* altd res 4,h */
/* altd res 5,h */
/* altd res 6,h */
/* altd res 7,h */
| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB84); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8C); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB94); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9C); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA4); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAC); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB4); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBC); 
  }
  else
    error_int_range(expr_value);

}

/* altd res 0,l */
/* altd res 1,l */
/* altd res 2,l */
/* altd res 3,l */
/* altd res 4,l */
/* altd res 5,l */
/* altd res 6,l */
/* altd res 7,l */
| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB85); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8D); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB95); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9D); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA5); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAD); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB5); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBD); 
  }
  else
    error_int_range(expr_value);

}

/* altd rl de */
| label? _TK_ALTD _TK_RL _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xF3); 
}

/* altd rr de */
| label? _TK_ALTD _TK_RR _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xFB); 
}

/* altd rr hl */
| label? _TK_ALTD _TK_RR _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xFC); 
}

/* altd set 0,a */
/* altd set 1,a */
/* altd set 2,a */
/* altd set 3,a */
/* altd set 4,a */
/* altd set 5,a */
/* altd set 6,a */
/* altd set 7,a */
| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC7); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCF); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD7); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDF); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE7); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEF); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF7); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFF); 
  }
  else
    error_int_range(expr_value);

}

/* altd set 0,b */
/* altd set 1,b */
/* altd set 2,b */
/* altd set 3,b */
/* altd set 4,b */
/* altd set 5,b */
/* altd set 6,b */
/* altd set 7,b */
| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC0); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBC8); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD0); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBD8); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE0); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBE8); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF0); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBF8); 
  }
  else
    error_int_range(expr_value);

}

/* altd set 0,c */
/* altd set 1,c */
/* altd set 2,c */
/* altd set 3,c */
/* altd set 4,c */
/* altd set 5,c */
/* altd set 6,c */
/* altd set 7,c */
| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC1); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBC9); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD1); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBD9); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE1); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBE9); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF1); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBF9); 
  }
  else
    error_int_range(expr_value);

}

/* altd set 0,d */
/* altd set 1,d */
/* altd set 2,d */
/* altd set 3,d */
/* altd set 4,d */
/* altd set 5,d */
/* altd set 6,d */
/* altd set 7,d */
| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC2); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCA); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD2); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDA); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE2); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEA); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF2); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFA); 
  }
  else
    error_int_range(expr_value);

}

/* altd set 0,e */
/* altd set 1,e */
/* altd set 2,e */
/* altd set 3,e */
/* altd set 4,e */
/* altd set 5,e */
/* altd set 6,e */
/* altd set 7,e */
| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC3); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCB); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD3); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDB); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE3); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEB); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF3); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFB); 
  }
  else
    error_int_range(expr_value);

}

/* altd set 0,h */
/* altd set 1,h */
/* altd set 2,h */
/* altd set 3,h */
/* altd set 4,h */
/* altd set 5,h */
/* altd set 6,h */
/* altd set 7,h */
| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC4); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCC); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD4); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDC); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE4); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEC); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF4); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFC); 
  }
  else
    error_int_range(expr_value);

}

/* altd set 0,l */
/* altd set 1,l */
/* altd set 2,l */
/* altd set 3,l */
/* altd set 4,l */
/* altd set 5,l */
/* altd set 6,l */
/* altd set 7,l */
| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC5); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCD); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD5); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDD); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE5); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBED); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF5); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFD); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,a */
/* bit 1,a */
/* bit 2,a */
/* bit 3,a */
/* bit 4,a */
/* bit 5,a */
/* bit 6,a */
/* bit 7,a */
| label? _TK_BIT const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB47); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB4F); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB57); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB5F); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB67); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB6F); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB77); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB7F); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,b */
/* bit 1,b */
/* bit 2,b */
/* bit 3,b */
/* bit 4,b */
/* bit 5,b */
/* bit 6,b */
/* bit 7,b */
| label? _TK_BIT const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB40); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB48); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB50); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB58); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB60); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB68); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB70); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB78); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,c */
/* bit 1,c */
/* bit 2,c */
/* bit 3,c */
/* bit 4,c */
/* bit 5,c */
/* bit 6,c */
/* bit 7,c */
| label? _TK_BIT const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB41); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB49); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB51); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB59); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB61); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB69); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB71); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB79); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,d */
/* bit 1,d */
/* bit 2,d */
/* bit 3,d */
/* bit 4,d */
/* bit 5,d */
/* bit 6,d */
/* bit 7,d */
| label? _TK_BIT const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB42); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB4A); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB52); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB5A); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB62); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB6A); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB72); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB7A); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,e */
/* bit 1,e */
/* bit 2,e */
/* bit 3,e */
/* bit 4,e */
/* bit 5,e */
/* bit 6,e */
/* bit 7,e */
| label? _TK_BIT const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB43); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB4B); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB53); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB5B); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB63); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB6B); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB73); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB7B); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,h */
/* bit 1,h */
/* bit 2,h */
/* bit 3,h */
/* bit 4,h */
/* bit 5,h */
/* bit 6,h */
/* bit 7,h */
| label? _TK_BIT const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB44); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB4C); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB54); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB5C); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB64); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB6C); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB74); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB7C); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,(hl) */
/* bit 1,(hl) */
/* bit 2,(hl) */
/* bit 3,(hl) */
/* bit 4,(hl) */
/* bit 5,(hl) */
/* bit 6,(hl) */
/* bit 7,(hl) */
| label? _TK_BIT const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB46); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB4E); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB56); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB5E); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB66); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB6E); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB76); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB7E); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,(ix) */
/* bit 1,(ix) */
/* bit 2,(ix) */
/* bit 3,(ix) */
/* bit 4,(ix) */
/* bit 5,(ix) */
/* bit 6,(ix) */
/* bit 7,(ix) */
| label? _TK_BIT const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0046); 
  }
  else {
    DO_stmt(0xFDCB0046); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB004E); 
  }
  else {
    DO_stmt(0xFDCB004E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0056); 
  }
  else {
    DO_stmt(0xFDCB0056); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB005E); 
  }
  else {
    DO_stmt(0xFDCB005E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0066); 
  }
  else {
    DO_stmt(0xFDCB0066); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB006E); 
  }
  else {
    DO_stmt(0xFDCB006E); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0076); 
  }
  else {
    DO_stmt(0xFDCB0076); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB007E); 
  }
  else {
    DO_stmt(0xFDCB007E); 
  }
  }
  else
    error_int_range(expr_value);

}

/* bit 0,(ix+DIS) */
/* bit 1,(ix+DIS) */
/* bit 2,(ix+DIS) */
/* bit 3,(ix+DIS) */
/* bit 4,(ix+DIS) */
/* bit 5,(ix+DIS) */
/* bit 6,(ix+DIS) */
/* bit 7,(ix+DIS) */
| label? _TK_BIT const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB46); 
  }
  else {
    DO_stmt_idx(0xFDCB46); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB4E); 
  }
  else {
    DO_stmt_idx(0xFDCB4E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB56); 
  }
  else {
    DO_stmt_idx(0xFDCB56); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB5E); 
  }
  else {
    DO_stmt_idx(0xFDCB5E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB66); 
  }
  else {
    DO_stmt_idx(0xFDCB66); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB6E); 
  }
  else {
    DO_stmt_idx(0xFDCB6E); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB76); 
  }
  else {
    DO_stmt_idx(0xFDCB76); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB7E); 
  }
  else {
    DO_stmt_idx(0xFDCB7E); 
  }
  }
  else
    error_int_range(expr_value);

}

/* bit 0,(iy) */
/* bit 1,(iy) */
/* bit 2,(iy) */
/* bit 3,(iy) */
/* bit 4,(iy) */
/* bit 5,(iy) */
/* bit 6,(iy) */
/* bit 7,(iy) */
| label? _TK_BIT const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0046); 
  }
  else {
    DO_stmt(0xDDCB0046); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB004E); 
  }
  else {
    DO_stmt(0xDDCB004E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0056); 
  }
  else {
    DO_stmt(0xDDCB0056); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB005E); 
  }
  else {
    DO_stmt(0xDDCB005E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0066); 
  }
  else {
    DO_stmt(0xDDCB0066); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB006E); 
  }
  else {
    DO_stmt(0xDDCB006E); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0076); 
  }
  else {
    DO_stmt(0xDDCB0076); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB007E); 
  }
  else {
    DO_stmt(0xDDCB007E); 
  }
  }
  else
    error_int_range(expr_value);

}

/* bit 0,(iy+DIS) */
/* bit 1,(iy+DIS) */
/* bit 2,(iy+DIS) */
/* bit 3,(iy+DIS) */
/* bit 4,(iy+DIS) */
/* bit 5,(iy+DIS) */
/* bit 6,(iy+DIS) */
/* bit 7,(iy+DIS) */
| label? _TK_BIT const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB46); 
  }
  else {
    DO_stmt_idx(0xDDCB46); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB4E); 
  }
  else {
    DO_stmt_idx(0xDDCB4E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB56); 
  }
  else {
    DO_stmt_idx(0xDDCB56); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB5E); 
  }
  else {
    DO_stmt_idx(0xDDCB5E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB66); 
  }
  else {
    DO_stmt_idx(0xDDCB66); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB6E); 
  }
  else {
    DO_stmt_idx(0xDDCB6E); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB76); 
  }
  else {
    DO_stmt_idx(0xDDCB76); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB7E); 
  }
  else {
    DO_stmt_idx(0xDDCB7E); 
  }
  }
  else
    error_int_range(expr_value);

}

/* bit 0,l */
/* bit 1,l */
/* bit 2,l */
/* bit 3,l */
/* bit 4,l */
/* bit 5,l */
/* bit 6,l */
/* bit 7,l */
| label? _TK_BIT const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB45); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB4D); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB55); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB5D); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB65); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB6D); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB75); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB7D); 
  }
  else
    error_int_range(expr_value);

}

/* call c,NN */
| label? _TK_CALL _TK_C _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(C); 
}

/* call lo,NN */
| label? _TK_CALL _TK_LO _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xEC); 
}

/* call lz,NN */
| label? _TK_CALL _TK_LZ _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xE4); 
}

/* call m,NN */
| label? _TK_CALL _TK_M _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(M); 
}

/* call nc,NN */
| label? _TK_CALL _TK_NC _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(NC); 
}

/* call nv,NN */
| label? _TK_CALL _TK_NV _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xE4); 
}

/* call nz,NN */
| label? _TK_CALL _TK_NZ _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(NZ); 
}

/* call p,NN */
| label? _TK_CALL _TK_P _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(P); 
}

/* call pe,NN */
| label? _TK_CALL _TK_PE _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(PE); 
}

/* call po,NN */
| label? _TK_CALL _TK_PO _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(PO); 
}

/* call v,NN */
| label? _TK_CALL _TK_V _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xEC); 
}

/* call z,NN */
| label? _TK_CALL _TK_Z _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(Z); 
}

/* call NN */
| label? _TK_CALL expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xCD); 
}

/* cpd */
| label? _TK_CPD _TK_NEWLINE @{
  DO_stmt_emul(0xEDA9, rcmx_cpd); 
}

/* cpdr */
| label? _TK_CPDR _TK_NEWLINE @{
  DO_stmt_emul(0xEDB9, rcmx_cpdr); 
}

/* cpi */
| label? _TK_CPI _TK_NEWLINE @{
  DO_stmt_emul(0xEDA1, rcmx_cpi); 
}

/* cpir */
| label? _TK_CPIR _TK_NEWLINE @{
  DO_stmt_emul(0xEDB1, rcmx_cpir); 
}

/* di */
| label? _TK_DI _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xF3); 
}

/* djnz b,NN */
| label? _TK_DJNZ _TK_B _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_jr(0x10); 
}

/* djnz b',NN */
| label? _TK_DJNZ _TK_B1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_jr(0x10); 
}

/* djnz NN */
| label? _TK_DJNZ expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_jr(0x10); 
}

/* ei */
| label? _TK_EI _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xFB); 
}

/* halt */
| label? _TK_HALT _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76); 
}

/* idet */
| label? _TK_IDET _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x5B); 
}

/* im 0 */
/* im 1 */
/* im 2 */
| label? _TK_IM const_expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xED46); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xED56); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xED5E); 
  }
  else
    error_int_range(expr_value);

}

/* in a,(c) */
| label? _TK_IN _TK_A _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED78); 
}

/* in a,(N) */
| label? _TK_IN _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xDB); 
}

/* in b,(c) */
| label? _TK_IN _TK_B _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED40); 
}

/* in c,(c) */
| label? _TK_IN _TK_C _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED48); 
}

/* in d,(c) */
| label? _TK_IN _TK_D _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED50); 
}

/* in e,(c) */
| label? _TK_IN _TK_E _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED58); 
}

/* in f,(c) */
| label? _TK_IN _TK_F _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED70); 
}

/* in h,(c) */
| label? _TK_IN _TK_H _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED60); 
}

/* in l,(c) */
| label? _TK_IN _TK_L _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED68); 
}

/* in0 a,(N) */
| label? _TK_IN0 _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED38); 
}

/* in0 b,(N) */
| label? _TK_IN0 _TK_B _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED00); 
}

/* in0 c,(N) */
| label? _TK_IN0 _TK_C _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED08); 
}

/* in0 d,(N) */
| label? _TK_IN0 _TK_D _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED10); 
}

/* in0 e,(N) */
| label? _TK_IN0 _TK_E _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED18); 
}

/* in0 f,(N) */
| label? _TK_IN0 _TK_F _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED30); 
}

/* in0 h,(N) */
| label? _TK_IN0 _TK_H _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED20); 
}

/* in0 l,(N) */
| label? _TK_IN0 _TK_L _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED28); 
}

/* ind */
| label? _TK_IND _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDAA); 
}

/* indr */
| label? _TK_INDR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDBA); 
}

/* ini */
| label? _TK_INI _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDA2); 
}

/* inir */
| label? _TK_INIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDB2); 
}

/* ioe ldd */
| label? _TK_IOE _TK_LDD _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xDBEDA8); 
}

/* ioe lddr */
| label? _TK_IOE _TK_LDDR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xDBEDB8); 
}

/* ioe ldi */
| label? _TK_IOE _TK_LDI _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xDBEDA0); 
}

/* ioe ldir */
| label? _TK_IOE _TK_LDIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xDBEDB0); 
}

/* ioi ldd */
| label? _TK_IOI _TK_LDD _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xD3EDA8); 
}

/* ioi lddr */
| label? _TK_IOI _TK_LDDR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xD3EDB8); 
}

/* ioi ldi */
| label? _TK_IOI _TK_LDI _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xD3EDA0); 
}

/* ioi ldir */
| label? _TK_IOI _TK_LDIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xD3EDB0); 
}

/* ipres */
| label? _TK_IPRES _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED5D); 
}

/* ipset 0 */
/* ipset 1 */
/* ipset 2 */
/* ipset 3 */
| label? _TK_IPSET const_expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xED46); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xED56); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xED4E); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xED5E); 
  }
  else
    error_int_range(expr_value);

}

/* jp c,NN */
| label? _TK_JP _TK_C _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xDA); 
}

/* jp (hl) */
| label? _TK_JP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xE9); 
}

/* jp (ix) */
| label? _TK_JP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDE9); 
  }
  else {
    DO_stmt(0xFDE9); 
  }
}

/* jp (iy) */
| label? _TK_JP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDE9); 
  }
  else {
    DO_stmt(0xDDE9); 
  }
}

/* jp lo,NN */
| label? _TK_JP _TK_LO _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xEA); 
}

/* jp lz,NN */
| label? _TK_JP _TK_LZ _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xE2); 
}

/* jp m,NN */
| label? _TK_JP _TK_M _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xFA); 
}

/* jp nc,NN */
| label? _TK_JP _TK_NC _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xD2); 
}

/* jp nv,NN */
| label? _TK_JP _TK_NV _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xE2); 
}

/* jp nz,NN */
| label? _TK_JP _TK_NZ _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xC2); 
}

/* jp p,NN */
| label? _TK_JP _TK_P _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xF2); 
}

/* jp pe,NN */
| label? _TK_JP _TK_PE _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xEA); 
}

/* jp po,NN */
| label? _TK_JP _TK_PO _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xE2); 
}

/* jp v,NN */
| label? _TK_JP _TK_V _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xEA); 
}

/* jp z,NN */
| label? _TK_JP _TK_Z _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xCA); 
}

/* jp NN */
| label? _TK_JP expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xC3); 
}

/* jr c,NN */
| label? _TK_JR _TK_C _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_jr(0x38); 
}

/* jr nc,NN */
| label? _TK_JR _TK_NC _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_jr(0x30); 
}

/* jr nz,NN */
| label? _TK_JR _TK_NZ _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_jr(0x20); 
}

/* jr z,NN */
| label? _TK_JR _TK_Z _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_jr(0x28); 
}

/* jr NN */
| label? _TK_JR expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_jr(0x18); 
}

/* ld a,eir */
| label? _TK_LD _TK_A _TK_COMMA _TK_EIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED57); 
}

/* ld a,i */
| label? _TK_LD _TK_A _TK_COMMA _TK_I _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED57); 
}

/* ld a,iir */
| label? _TK_LD _TK_A _TK_COMMA _TK_IIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED5F); 
}

/* ld a,r */
| label? _TK_LD _TK_A _TK_COMMA _TK_R _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED5F); 
}

/* ld a,xpc */
| label? _TK_LD _TK_A _TK_COMMA _TK_XPC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED77); 
}

/* ld a',eir */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_EIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED57); 
}

/* ld a',iir */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED5F); 
}

/* ld a',xpc */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_XPC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED77); 
}

/* ld eir,a */
| label? _TK_LD _TK_EIR _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED47); 
}

/* ld i,a */
| label? _TK_LD _TK_I _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED47); 
}

/* ld iir,a */
| label? _TK_LD _TK_IIR _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED4F); 
}

/* ld r,a */
| label? _TK_LD _TK_R _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED4F); 
}

/* ld xpc,a */
| label? _TK_LD _TK_XPC _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED67); 
}

/* ldd */
| label? _TK_LDD _TK_NEWLINE @{
  DO_stmt(0xEDA8); 
}

/* lddr */
| label? _TK_LDDR _TK_NEWLINE @{
  DO_stmt(0xEDB8); 
}

/* lddsr */
| label? _TK_LDDSR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED98); 
}

/* ldi */
| label? _TK_LDI _TK_NEWLINE @{
  DO_stmt(0xEDA0); 
}

/* ldir */
| label? _TK_LDIR _TK_NEWLINE @{
  DO_stmt(0xEDB0); 
}

/* ldisr */
| label? _TK_LDISR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED90); 
}

/* lsddr */
| label? _TK_LSDDR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDD8); 
}

/* lsdr */
| label? _TK_LSDR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDF8); 
}

/* lsidr */
| label? _TK_LSIDR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDD0); 
}

/* lsir */
| label? _TK_LSIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDF0); 
}

/* nop */
| label? _TK_NOP _TK_NEWLINE @{
  DO_stmt(0x00); 
}

/* otdm */
| label? _TK_OTDM _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED8B); 
}

/* otdmr */
| label? _TK_OTDMR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED9B); 
}

/* otdr */
| label? _TK_OTDR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDBB); 
}

/* otim */
| label? _TK_OTIM _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED83); 
}

/* otimr */
| label? _TK_OTIMR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED93); 
}

/* otir */
| label? _TK_OTIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDB3); 
}

/* out (c),a */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED79); 
}

/* out (c),b */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED41); 
}

/* out (c),c */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED49); 
}

/* out (c),d */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED51); 
}

/* out (c),e */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED59); 
}

/* out (c),h */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED61); 
}

/* out (c),l */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED69); 
}

/* out (c),0 */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA const_expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xED71); 
  }
  else
    error_int_range(expr_value);

}

/* out (N),a */
| label? _TK_OUT expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xD3); 
}

/* out0 (N),a */
| label? _TK_OUT0 expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED39); 
}

/* out0 (N),b */
| label? _TK_OUT0 expr _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED01); 
}

/* out0 (N),c */
| label? _TK_OUT0 expr _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED09); 
}

/* out0 (N),d */
| label? _TK_OUT0 expr _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED11); 
}

/* out0 (N),e */
| label? _TK_OUT0 expr _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED19); 
}

/* out0 (N),h */
| label? _TK_OUT0 expr _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED21); 
}

/* out0 (N),l */
| label? _TK_OUT0 expr _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED29); 
}

/* outd */
| label? _TK_OUTD _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDAB); 
}

/* outi */
| label? _TK_OUTI _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDA3); 
}

/* rdmode */
| label? _TK_RDMODE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED7F); 
}

/* res 0,a */
/* res 1,a */
/* res 2,a */
/* res 3,a */
/* res 4,a */
/* res 5,a */
/* res 6,a */
/* res 7,a */
| label? _TK_RES const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB87); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB8F); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB97); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB9F); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA7); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBAF); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB7); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBBF); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,a' */
/* res 1,a' */
/* res 2,a' */
/* res 3,a' */
/* res 4,a' */
/* res 5,a' */
/* res 6,a' */
/* res 7,a' */
| label? _TK_RES const_expr _TK_COMMA _TK_A1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB87); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8F); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB97); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9F); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA7); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAF); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB7); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBF); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,b */
/* res 1,b */
/* res 2,b */
/* res 3,b */
/* res 4,b */
/* res 5,b */
/* res 6,b */
/* res 7,b */
| label? _TK_RES const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB80); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB88); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB90); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB98); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA0); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBA8); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB0); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBB8); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,b' */
/* res 1,b' */
/* res 2,b' */
/* res 3,b' */
/* res 4,b' */
/* res 5,b' */
/* res 6,b' */
/* res 7,b' */
| label? _TK_RES const_expr _TK_COMMA _TK_B1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB80); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB88); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB90); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB98); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA0); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBA8); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB0); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBB8); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,c */
/* res 1,c */
/* res 2,c */
/* res 3,c */
/* res 4,c */
/* res 5,c */
/* res 6,c */
/* res 7,c */
| label? _TK_RES const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB81); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB89); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB91); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB99); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA1); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBA9); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB1); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBB9); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,c' */
/* res 1,c' */
/* res 2,c' */
/* res 3,c' */
/* res 4,c' */
/* res 5,c' */
/* res 6,c' */
/* res 7,c' */
| label? _TK_RES const_expr _TK_COMMA _TK_C1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB81); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB89); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB91); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB99); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA1); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBA9); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB1); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBB9); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,d */
/* res 1,d */
/* res 2,d */
/* res 3,d */
/* res 4,d */
/* res 5,d */
/* res 6,d */
/* res 7,d */
| label? _TK_RES const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB82); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB8A); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB92); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB9A); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA2); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBAA); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB2); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBBA); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,d' */
/* res 1,d' */
/* res 2,d' */
/* res 3,d' */
/* res 4,d' */
/* res 5,d' */
/* res 6,d' */
/* res 7,d' */
| label? _TK_RES const_expr _TK_COMMA _TK_D1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB82); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8A); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB92); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9A); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA2); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAA); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB2); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBA); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,e */
/* res 1,e */
/* res 2,e */
/* res 3,e */
/* res 4,e */
/* res 5,e */
/* res 6,e */
/* res 7,e */
| label? _TK_RES const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB83); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB8B); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB93); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB9B); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA3); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBAB); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB3); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBBB); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,e' */
/* res 1,e' */
/* res 2,e' */
/* res 3,e' */
/* res 4,e' */
/* res 5,e' */
/* res 6,e' */
/* res 7,e' */
| label? _TK_RES const_expr _TK_COMMA _TK_E1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB83); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8B); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB93); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9B); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA3); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAB); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB3); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBB); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,h */
/* res 1,h */
/* res 2,h */
/* res 3,h */
/* res 4,h */
/* res 5,h */
/* res 6,h */
/* res 7,h */
| label? _TK_RES const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB84); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB8C); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB94); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB9C); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA4); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBAC); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB4); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBBC); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,h' */
/* res 1,h' */
/* res 2,h' */
/* res 3,h' */
/* res 4,h' */
/* res 5,h' */
/* res 6,h' */
/* res 7,h' */
| label? _TK_RES const_expr _TK_COMMA _TK_H1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB84); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8C); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB94); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9C); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA4); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAC); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB4); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBC); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,(hl) */
/* res 1,(hl) */
/* res 2,(hl) */
/* res 3,(hl) */
/* res 4,(hl) */
/* res 5,(hl) */
/* res 6,(hl) */
/* res 7,(hl) */
| label? _TK_RES const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB86); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB8E); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB96); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB9E); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA6); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBAE); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB6); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBBE); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,(ix) */
/* res 1,(ix) */
/* res 2,(ix) */
/* res 3,(ix) */
/* res 4,(ix) */
/* res 5,(ix) */
/* res 6,(ix) */
/* res 7,(ix) */
| label? _TK_RES const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0086); 
  }
  else {
    DO_stmt(0xFDCB0086); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB008E); 
  }
  else {
    DO_stmt(0xFDCB008E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0096); 
  }
  else {
    DO_stmt(0xFDCB0096); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB009E); 
  }
  else {
    DO_stmt(0xFDCB009E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00A6); 
  }
  else {
    DO_stmt(0xFDCB00A6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00AE); 
  }
  else {
    DO_stmt(0xFDCB00AE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00B6); 
  }
  else {
    DO_stmt(0xFDCB00B6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00BE); 
  }
  else {
    DO_stmt(0xFDCB00BE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* res 0,(ix+DIS) */
/* res 1,(ix+DIS) */
/* res 2,(ix+DIS) */
/* res 3,(ix+DIS) */
/* res 4,(ix+DIS) */
/* res 5,(ix+DIS) */
/* res 6,(ix+DIS) */
/* res 7,(ix+DIS) */
| label? _TK_RES const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB86); 
  }
  else {
    DO_stmt_idx(0xFDCB86); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB8E); 
  }
  else {
    DO_stmt_idx(0xFDCB8E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB96); 
  }
  else {
    DO_stmt_idx(0xFDCB96); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB9E); 
  }
  else {
    DO_stmt_idx(0xFDCB9E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBA6); 
  }
  else {
    DO_stmt_idx(0xFDCBA6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBAE); 
  }
  else {
    DO_stmt_idx(0xFDCBAE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBB6); 
  }
  else {
    DO_stmt_idx(0xFDCBB6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBBE); 
  }
  else {
    DO_stmt_idx(0xFDCBBE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* res 0,(iy) */
/* res 1,(iy) */
/* res 2,(iy) */
/* res 3,(iy) */
/* res 4,(iy) */
/* res 5,(iy) */
/* res 6,(iy) */
/* res 7,(iy) */
| label? _TK_RES const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0086); 
  }
  else {
    DO_stmt(0xDDCB0086); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB008E); 
  }
  else {
    DO_stmt(0xDDCB008E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0096); 
  }
  else {
    DO_stmt(0xDDCB0096); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB009E); 
  }
  else {
    DO_stmt(0xDDCB009E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00A6); 
  }
  else {
    DO_stmt(0xDDCB00A6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00AE); 
  }
  else {
    DO_stmt(0xDDCB00AE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00B6); 
  }
  else {
    DO_stmt(0xDDCB00B6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00BE); 
  }
  else {
    DO_stmt(0xDDCB00BE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* res 0,(iy+DIS) */
/* res 1,(iy+DIS) */
/* res 2,(iy+DIS) */
/* res 3,(iy+DIS) */
/* res 4,(iy+DIS) */
/* res 5,(iy+DIS) */
/* res 6,(iy+DIS) */
/* res 7,(iy+DIS) */
| label? _TK_RES const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB86); 
  }
  else {
    DO_stmt_idx(0xDDCB86); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB8E); 
  }
  else {
    DO_stmt_idx(0xDDCB8E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB96); 
  }
  else {
    DO_stmt_idx(0xDDCB96); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB9E); 
  }
  else {
    DO_stmt_idx(0xDDCB9E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBA6); 
  }
  else {
    DO_stmt_idx(0xDDCBA6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBAE); 
  }
  else {
    DO_stmt_idx(0xDDCBAE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBB6); 
  }
  else {
    DO_stmt_idx(0xDDCBB6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBBE); 
  }
  else {
    DO_stmt_idx(0xDDCBBE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* res 0,l */
/* res 1,l */
/* res 2,l */
/* res 3,l */
/* res 4,l */
/* res 5,l */
/* res 6,l */
/* res 7,l */
| label? _TK_RES const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB85); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB8D); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB95); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB9D); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA5); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBAD); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB5); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBBD); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,l' */
/* res 1,l' */
/* res 2,l' */
/* res 3,l' */
/* res 4,l' */
/* res 5,l' */
/* res 6,l' */
/* res 7,l' */
| label? _TK_RES const_expr _TK_COMMA _TK_L1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB85); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8D); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB95); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9D); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA5); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAD); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB5); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBD); 
  }
  else
    error_int_range(expr_value);

}

/* ret */
| label? _TK_RET _TK_NEWLINE @{
  DO_stmt(0xC9); 
}

/* ret c */
| label? _TK_RET _TK_C _TK_NEWLINE @{
  DO_stmt(0xD8); 
}

/* ret lo */
| label? _TK_RET _TK_LO _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xE8); 
}

/* ret lz */
| label? _TK_RET _TK_LZ _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xE0); 
}

/* ret m */
| label? _TK_RET _TK_M _TK_NEWLINE @{
  DO_stmt(0xF8); 
}

/* ret nc */
| label? _TK_RET _TK_NC _TK_NEWLINE @{
  DO_stmt(0xD0); 
}

/* ret nv */
| label? _TK_RET _TK_NV _TK_NEWLINE @{
  DO_stmt(0xE0); 
}

/* ret nz */
| label? _TK_RET _TK_NZ _TK_NEWLINE @{
  DO_stmt(0xC0); 
}

/* ret p */
| label? _TK_RET _TK_P _TK_NEWLINE @{
  DO_stmt(0xF0); 
}

/* ret pe */
| label? _TK_RET _TK_PE _TK_NEWLINE @{
  DO_stmt(0xE8); 
}

/* ret po */
| label? _TK_RET _TK_PO _TK_NEWLINE @{
  DO_stmt(0xE0); 
}

/* ret v */
| label? _TK_RET _TK_V _TK_NEWLINE @{
  DO_stmt(0xE8); 
}

/* ret z */
| label? _TK_RET _TK_Z _TK_NEWLINE @{
  DO_stmt(0xC8); 
}

/* reti */
| label? _TK_RETI _TK_NEWLINE @{
  DO_stmt(0xED4D); 
}

/* retn */
| label? _TK_RETN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED45); 
}

/* rl de */
| label? _TK_RL _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xF3); 
}

/* rl de' */
| label? _TK_RL _TK_DE1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xF3); 
}

/* rr de */
| label? _TK_RR _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xFB); 
}

/* rr de' */
| label? _TK_RR _TK_DE1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xFB); 
}

/* rr hl */
| label? _TK_RR _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xFC); 
}

/* rr hl' */
| label? _TK_RR _TK_HL1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xFC); 
}

/* rr ix */
| label? _TK_RR _TK_IX _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDFC); 
  }
  else {
    DO_stmt(0xFDFC); 
  }
}

/* rr iy */
| label? _TK_RR _TK_IY _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDFC); 
  }
  else {
    DO_stmt(0xDDFC); 
  }
}

/* rst 0 */
/* rst 16 */
/* rst 24 */
/* rst 32 */
/* rst 40 */
/* rst 48 */
/* rst 56 */
/* rst 8 */
| label? _TK_RST const_expr _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if ((opts.cpu & CPU_ZILOG) == 0) { error_illegal_ident(); return FALSE; }
    DO_stmt(0xC7); 
  }
  else if (expr_value == 8) {
    if ((opts.cpu & CPU_ZILOG) == 0) { error_illegal_ident(); return FALSE; }
    DO_stmt(0xCF); 
  }
  else if (expr_value == 16) {
    DO_stmt(0xD7); 
  }
  else if (expr_value == 24) {
    DO_stmt(0xDF); 
  }
  else if (expr_value == 32) {
    DO_stmt(0xE7); 
  }
  else if (expr_value == 40) {
    DO_stmt(0xEF); 
  }
  else if (expr_value == 48) {
    if ((opts.cpu & CPU_ZILOG) == 0) { error_illegal_ident(); return FALSE; }
    DO_stmt(0xF7); 
  }
  else if (expr_value == 56) {
    DO_stmt(0xFF); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,a */
/* set 1,a */
/* set 2,a */
/* set 3,a */
/* set 4,a */
/* set 5,a */
/* set 6,a */
/* set 7,a */
| label? _TK_SET const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC7); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBCF); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD7); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBDF); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE7); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBEF); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF7); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBFF); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,a' */
/* set 1,a' */
/* set 2,a' */
/* set 3,a' */
/* set 4,a' */
/* set 5,a' */
/* set 6,a' */
/* set 7,a' */
| label? _TK_SET const_expr _TK_COMMA _TK_A1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC7); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCF); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD7); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDF); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE7); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEF); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF7); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFF); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,b */
/* set 1,b */
/* set 2,b */
/* set 3,b */
/* set 4,b */
/* set 5,b */
/* set 6,b */
/* set 7,b */
| label? _TK_SET const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC0); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBC8); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD0); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBD8); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE0); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBE8); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF0); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBF8); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,b' */
/* set 1,b' */
/* set 2,b' */
/* set 3,b' */
/* set 4,b' */
/* set 5,b' */
/* set 6,b' */
/* set 7,b' */
| label? _TK_SET const_expr _TK_COMMA _TK_B1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC0); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBC8); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD0); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBD8); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE0); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBE8); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF0); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBF8); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,c */
/* set 1,c */
/* set 2,c */
/* set 3,c */
/* set 4,c */
/* set 5,c */
/* set 6,c */
/* set 7,c */
| label? _TK_SET const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC1); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBC9); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD1); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBD9); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE1); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBE9); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF1); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBF9); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,c' */
/* set 1,c' */
/* set 2,c' */
/* set 3,c' */
/* set 4,c' */
/* set 5,c' */
/* set 6,c' */
/* set 7,c' */
| label? _TK_SET const_expr _TK_COMMA _TK_C1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC1); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBC9); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD1); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBD9); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE1); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBE9); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF1); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBF9); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,d */
/* set 1,d */
/* set 2,d */
/* set 3,d */
/* set 4,d */
/* set 5,d */
/* set 6,d */
/* set 7,d */
| label? _TK_SET const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC2); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBCA); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD2); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBDA); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE2); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBEA); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF2); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBFA); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,d' */
/* set 1,d' */
/* set 2,d' */
/* set 3,d' */
/* set 4,d' */
/* set 5,d' */
/* set 6,d' */
/* set 7,d' */
| label? _TK_SET const_expr _TK_COMMA _TK_D1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC2); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCA); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD2); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDA); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE2); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEA); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF2); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFA); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,e */
/* set 1,e */
/* set 2,e */
/* set 3,e */
/* set 4,e */
/* set 5,e */
/* set 6,e */
/* set 7,e */
| label? _TK_SET const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC3); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBCB); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD3); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBDB); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE3); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBEB); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF3); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBFB); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,e' */
/* set 1,e' */
/* set 2,e' */
/* set 3,e' */
/* set 4,e' */
/* set 5,e' */
/* set 6,e' */
/* set 7,e' */
| label? _TK_SET const_expr _TK_COMMA _TK_E1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC3); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCB); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD3); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDB); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE3); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEB); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF3); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFB); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,h */
/* set 1,h */
/* set 2,h */
/* set 3,h */
/* set 4,h */
/* set 5,h */
/* set 6,h */
/* set 7,h */
| label? _TK_SET const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC4); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBCC); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD4); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBDC); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE4); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBEC); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF4); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBFC); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,h' */
/* set 1,h' */
/* set 2,h' */
/* set 3,h' */
/* set 4,h' */
/* set 5,h' */
/* set 6,h' */
/* set 7,h' */
| label? _TK_SET const_expr _TK_COMMA _TK_H1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC4); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCC); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD4); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDC); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE4); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEC); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF4); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFC); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,(hl) */
/* set 1,(hl) */
/* set 2,(hl) */
/* set 3,(hl) */
/* set 4,(hl) */
/* set 5,(hl) */
/* set 6,(hl) */
/* set 7,(hl) */
| label? _TK_SET const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC6); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBCE); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD6); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBDE); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE6); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBEE); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF6); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBFE); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,(ix) */
/* set 1,(ix) */
/* set 2,(ix) */
/* set 3,(ix) */
/* set 4,(ix) */
/* set 5,(ix) */
/* set 6,(ix) */
/* set 7,(ix) */
| label? _TK_SET const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00C6); 
  }
  else {
    DO_stmt(0xFDCB00C6); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00CE); 
  }
  else {
    DO_stmt(0xFDCB00CE); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00D6); 
  }
  else {
    DO_stmt(0xFDCB00D6); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00DE); 
  }
  else {
    DO_stmt(0xFDCB00DE); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00E6); 
  }
  else {
    DO_stmt(0xFDCB00E6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00EE); 
  }
  else {
    DO_stmt(0xFDCB00EE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00F6); 
  }
  else {
    DO_stmt(0xFDCB00F6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00FE); 
  }
  else {
    DO_stmt(0xFDCB00FE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* set 0,(ix+DIS) */
/* set 1,(ix+DIS) */
/* set 2,(ix+DIS) */
/* set 3,(ix+DIS) */
/* set 4,(ix+DIS) */
/* set 5,(ix+DIS) */
/* set 6,(ix+DIS) */
/* set 7,(ix+DIS) */
| label? _TK_SET const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBC6); 
  }
  else {
    DO_stmt_idx(0xFDCBC6); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBCE); 
  }
  else {
    DO_stmt_idx(0xFDCBCE); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBD6); 
  }
  else {
    DO_stmt_idx(0xFDCBD6); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBDE); 
  }
  else {
    DO_stmt_idx(0xFDCBDE); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBE6); 
  }
  else {
    DO_stmt_idx(0xFDCBE6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBEE); 
  }
  else {
    DO_stmt_idx(0xFDCBEE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBF6); 
  }
  else {
    DO_stmt_idx(0xFDCBF6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBFE); 
  }
  else {
    DO_stmt_idx(0xFDCBFE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* set 0,(iy) */
/* set 1,(iy) */
/* set 2,(iy) */
/* set 3,(iy) */
/* set 4,(iy) */
/* set 5,(iy) */
/* set 6,(iy) */
/* set 7,(iy) */
| label? _TK_SET const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00C6); 
  }
  else {
    DO_stmt(0xDDCB00C6); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00CE); 
  }
  else {
    DO_stmt(0xDDCB00CE); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00D6); 
  }
  else {
    DO_stmt(0xDDCB00D6); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00DE); 
  }
  else {
    DO_stmt(0xDDCB00DE); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00E6); 
  }
  else {
    DO_stmt(0xDDCB00E6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00EE); 
  }
  else {
    DO_stmt(0xDDCB00EE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00F6); 
  }
  else {
    DO_stmt(0xDDCB00F6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00FE); 
  }
  else {
    DO_stmt(0xDDCB00FE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* set 0,(iy+DIS) */
/* set 1,(iy+DIS) */
/* set 2,(iy+DIS) */
/* set 3,(iy+DIS) */
/* set 4,(iy+DIS) */
/* set 5,(iy+DIS) */
/* set 6,(iy+DIS) */
/* set 7,(iy+DIS) */
| label? _TK_SET const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBC6); 
  }
  else {
    DO_stmt_idx(0xDDCBC6); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBCE); 
  }
  else {
    DO_stmt_idx(0xDDCBCE); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBD6); 
  }
  else {
    DO_stmt_idx(0xDDCBD6); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBDE); 
  }
  else {
    DO_stmt_idx(0xDDCBDE); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBE6); 
  }
  else {
    DO_stmt_idx(0xDDCBE6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBEE); 
  }
  else {
    DO_stmt_idx(0xDDCBEE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBF6); 
  }
  else {
    DO_stmt_idx(0xDDCBF6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBFE); 
  }
  else {
    DO_stmt_idx(0xDDCBFE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* set 0,l */
/* set 1,l */
/* set 2,l */
/* set 3,l */
/* set 4,l */
/* set 5,l */
/* set 6,l */
/* set 7,l */
| label? _TK_SET const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC5); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBCD); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD5); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBDD); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE5); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBED); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF5); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBFD); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,l' */
/* set 1,l' */
/* set 2,l' */
/* set 3,l' */
/* set 4,l' */
/* set 5,l' */
/* set 6,l' */
/* set 7,l' */
| label? _TK_SET const_expr _TK_COMMA _TK_L1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC5); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCD); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD5); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDD); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE5); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBED); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF5); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFD); 
  }
  else
    error_int_range(expr_value);

}

/* setusr */
| label? _TK_SETUSR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED6F); 
}

/* slp */
| label? _TK_SLP _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED76); 
}

/* sures */
| label? _TK_SURES _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED7D); 
}

/* syscall */
| label? _TK_SYSCALL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED75); 
}

/* tstio N */
| label? _TK_TSTIO expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xED74); 
}


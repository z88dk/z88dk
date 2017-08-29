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

/* tstio N */
| label? _TK_TSTIO expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xED74); 
}


| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x767E); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) { DO_stmt_nn(0x763A); } else { DO_stmt_n(0x763E); }  }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x767F); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7678); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7679); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x767A); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x767B); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x767C); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x767D); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7646); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0x7606); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7647); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7640); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7641); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7642); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7643); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7644); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7645); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x764E); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0x760E); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x764F); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7648); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7649); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x764A); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x764B); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x764C); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x764D); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7656); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0x7616); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7657); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7650); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7651); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7652); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7653); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7654); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7655); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x765E); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0x761E); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x765F); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7658); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7659); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x765A); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x765B); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x765C); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x765D); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7666); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0x7626); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7667); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7660); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7661); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7662); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7663); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7664); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7665); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x766E); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0x762E); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x766F); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7668); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7669); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x766A); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x766B); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x766C); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x766D); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x7E); }
| label? _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) { DO_stmt_nn(0x3A); } else { DO_stmt_n(0x3E); }  }
| label? _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x7F); }
| label? _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x78); }
| label? _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x79); }
| label? _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x7A); }
| label? _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x7B); }
| label? _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x7C); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD7C); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD7D); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD7C); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD7D); }
| label? _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x7D); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x767E); }
| label? _TK_LD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) { DO_stmt_nn(0x763A); } else { DO_stmt_n(0x763E); }  }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x767F); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7678); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7679); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x767A); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x767B); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x767C); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x767D); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x46); }
| label? _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) return FALSE; DO_stmt_n(0x06); }
| label? _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x47); }
| label? _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x40); }
| label? _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x41); }
| label? _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x42); }
| label? _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x43); }
| label? _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x44); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD44); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD45); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD44); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD45); }
| label? _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x45); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7646); }
| label? _TK_LD _TK_B1 _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0x7606); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7647); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7640); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7641); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7642); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7643); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7644); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7645); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x4E); }
| label? _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) return FALSE; DO_stmt_n(0x0E); }
| label? _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x4F); }
| label? _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x48); }
| label? _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x49); }
| label? _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x4A); }
| label? _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x4B); }
| label? _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x4C); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD4C); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD4D); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD4C); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD4D); }
| label? _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x4D); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x764E); }
| label? _TK_LD _TK_C1 _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0x760E); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x764F); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7648); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7649); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x764A); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x764B); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x764C); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x764D); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x56); }
| label? _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) return FALSE; DO_stmt_n(0x16); }
| label? _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x57); }
| label? _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x50); }
| label? _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x51); }
| label? _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x52); }
| label? _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x53); }
| label? _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x54); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD54); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD55); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD54); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD55); }
| label? _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x55); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7656); }
| label? _TK_LD _TK_D1 _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0x7616); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7657); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7650); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7651); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7652); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7653); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7654); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7655); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x5E); }
| label? _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) return FALSE; DO_stmt_n(0x1E); }
| label? _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x5F); }
| label? _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x58); }
| label? _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x59); }
| label? _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x5A); }
| label? _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x5B); }
| label? _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x5C); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD5C); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD5D); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD5C); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD5D); }
| label? _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x5D); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x765E); }
| label? _TK_LD _TK_E1 _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0x761E); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x765F); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7658); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7659); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x765A); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x765B); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x765C); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x765D); }
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x66); }
| label? _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) return FALSE; DO_stmt_n(0x26); }
| label? _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x67); }
| label? _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x60); }
| label? _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x61); }
| label? _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x62); }
| label? _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x63); }
| label? _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x64); }
| label? _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x65); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7666); }
| label? _TK_LD _TK_H1 _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0x7626); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7667); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7660); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7661); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7662); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7663); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7664); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7665); }
| label? _TK_LD _TK_IXH _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0xDD26); }
| label? _TK_LD _TK_IXH _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD67); }
| label? _TK_LD _TK_IXH _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD60); }
| label? _TK_LD _TK_IXH _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD61); }
| label? _TK_LD _TK_IXH _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD62); }
| label? _TK_LD _TK_IXH _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD63); }
| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD64); }
| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD65); }
| label? _TK_LD _TK_IXL _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0xDD2E); }
| label? _TK_LD _TK_IXL _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD6F); }
| label? _TK_LD _TK_IXL _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD68); }
| label? _TK_LD _TK_IXL _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD69); }
| label? _TK_LD _TK_IXL _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD6A); }
| label? _TK_LD _TK_IXL _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD6B); }
| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD6C); }
| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD6D); }
| label? _TK_LD _TK_IYH _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0xFD26); }
| label? _TK_LD _TK_IYH _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD67); }
| label? _TK_LD _TK_IYH _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD60); }
| label? _TK_LD _TK_IYH _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD61); }
| label? _TK_LD _TK_IYH _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD62); }
| label? _TK_LD _TK_IYH _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD63); }
| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD64); }
| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD65); }
| label? _TK_LD _TK_IYL _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0xFD2E); }
| label? _TK_LD _TK_IYL _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD6F); }
| label? _TK_LD _TK_IYL _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD68); }
| label? _TK_LD _TK_IYL _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD69); }
| label? _TK_LD _TK_IYL _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD6A); }
| label? _TK_LD _TK_IYL _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD6B); }
| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD6C); }
| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ( (opts.cpu & (CPU_Z80)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD6D); }
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x6E); }
| label? _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) return FALSE; DO_stmt_n(0x2E); }
| label? _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x6F); }
| label? _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x68); }
| label? _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x69); }
| label? _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x6A); }
| label? _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x6B); }
| label? _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x6C); }
| label? _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x6D); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x766E); }
| label? _TK_LD _TK_L1 _TK_COMMA expr _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } if (expr_in_parens) return FALSE; DO_stmt_n(0x762E); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x766F); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7668); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x7669); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x766A); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x766B); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x766C); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ( (opts.cpu & (CPU_RABBIT)) == 0 ) { error_illegal_ident(); return FALSE; } DO_stmt(0x766D); }

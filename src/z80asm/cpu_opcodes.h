| label? _TK_ADC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x8F); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x88); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x89); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x8A); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x8B); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x8C); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x8E); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x8E + P_IX) << 8); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x8E + P_IX)); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x8E + P_IY) << 8); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x8E + P_IY)); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x8C + P_IX)); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x8D + P_IX)); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x8C + P_IY)); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x8D + P_IY)); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x8D); }
| label? _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xCE); }
| label? _TK_ADC _TK_A _TK_NEWLINE @{ DO_stmt(0x8F); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8F); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x88); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x89); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8A); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8B); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8C); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8E); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x8E + P_IX) << 8); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x8E + P_IX)); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x8E + P_IY) << 8); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x8E + P_IY)); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8D); }
| label? _TK_ADC _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xCE); }
| label? _TK_ADC _TK_B _TK_NEWLINE @{ DO_stmt(0x88); }
| label? _TK_ADC _TK_C _TK_NEWLINE @{ DO_stmt(0x89); }
| label? _TK_ADC _TK_D _TK_NEWLINE @{ DO_stmt(0x8A); }
| label? _TK_ADC _TK_E _TK_NEWLINE @{ DO_stmt(0x8B); }
| label? _TK_ADC _TK_H _TK_NEWLINE @{ DO_stmt(0x8C); }
| label? _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x8E); }
| label? _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x8E + P_IX) << 8); }
| label? _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x8E + P_IX)); }
| label? _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x8E + P_IY) << 8); }
| label? _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x8E + P_IY)); }
| label? _TK_ADC _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x8C + P_IX)); }
| label? _TK_ADC _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x8D + P_IX)); }
| label? _TK_ADC _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x8C + P_IY)); }
| label? _TK_ADC _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x8D + P_IY)); }
| label? _TK_ADC _TK_L _TK_NEWLINE @{ DO_stmt(0x8D); }
| label? _TK_ADC expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xCE); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x87); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x80); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x81); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x82); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x83); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x84); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x86); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x86 + P_IX) << 8); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x86 + P_IX)); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x86 + P_IY) << 8); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x86 + P_IY)); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x84 + P_IX)); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x85 + P_IX)); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x84 + P_IY)); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x85 + P_IY)); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x85); }
| label? _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xC6); }
| label? _TK_ADD _TK_A _TK_NEWLINE @{ DO_stmt(0x87); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x87); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x80); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x81); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x82); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x83); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x84); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x86); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x86 + P_IX) << 8); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x86 + P_IX)); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x86 + P_IY) << 8); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x86 + P_IY)); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x85); }
| label? _TK_ADD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xC6); }
| label? _TK_ADD _TK_B _TK_NEWLINE @{ DO_stmt(0x80); }
| label? _TK_ADD _TK_C _TK_NEWLINE @{ DO_stmt(0x81); }
| label? _TK_ADD _TK_D _TK_NEWLINE @{ DO_stmt(0x82); }
| label? _TK_ADD _TK_E _TK_NEWLINE @{ DO_stmt(0x83); }
| label? _TK_ADD _TK_H _TK_NEWLINE @{ DO_stmt(0x84); }
| label? _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x86); }
| label? _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x86 + P_IX) << 8); }
| label? _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x86 + P_IX)); }
| label? _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x86 + P_IY) << 8); }
| label? _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x86 + P_IY)); }
| label? _TK_ADD _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x84 + P_IX)); }
| label? _TK_ADD _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x85 + P_IX)); }
| label? _TK_ADD _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x84 + P_IY)); }
| label? _TK_ADD _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x85 + P_IY)); }
| label? _TK_ADD _TK_L _TK_NEWLINE @{ DO_stmt(0x85); }
| label? _TK_ADD expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xC6); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8F); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x88); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x89); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8A); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8B); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8C); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8E); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x8E + P_IX) << 8); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x8E + P_IX)); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x8E + P_IY) << 8); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x8E + P_IY)); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8D); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xCE); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x87); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x80); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x81); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x82); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x83); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x84); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x86); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x86 + P_IX) << 8); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x86 + P_IX)); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x86 + P_IY) << 8); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x86 + P_IY)); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x85); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xC6); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA7); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA0); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA1); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA2); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA3); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA4); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA6); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xA6 + P_IX) << 8); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xA6 + P_IX)); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xA6 + P_IY) << 8); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xA6 + P_IY)); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA5); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xE6); }
| label? _TK_ALTD _TK_CCF _TK_F _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x3F); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBF); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB8); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB9); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBA); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBB); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBC); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBE); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xBE + P_IX) << 8); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xBE + P_IX)); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xBE + P_IY) << 8); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xBE + P_IY)); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBD); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xFE); }
| label? _TK_ALTD _TK_CPL _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x2F); }
| label? _TK_ALTD _TK_DEC _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x3D); }
| label? _TK_ALTD _TK_DEC _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x05); }
| label? _TK_ALTD _TK_DEC _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x0D); }
| label? _TK_ALTD _TK_DEC _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x15); }
| label? _TK_ALTD _TK_DEC _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x1D); }
| label? _TK_ALTD _TK_DEC _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x25); }
| label? _TK_ALTD _TK_DEC _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x2D); }
| label? _TK_ALTD _TK_INC _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x3C); }
| label? _TK_ALTD _TK_INC _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x04); }
| label? _TK_ALTD _TK_INC _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x0C); }
| label? _TK_ALTD _TK_INC _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x14); }
| label? _TK_ALTD _TK_INC _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x1C); }
| label? _TK_ALTD _TK_INC _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x24); }
| label? _TK_ALTD _TK_INC _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x2C); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x0A); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x1A); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x7E); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x7E + P_IX) << 8); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x7E + P_IX)); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x7E + P_IY) << 8); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x7E + P_IY)); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0x3A); } else { DO_stmt_n(0x3E); } }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x46); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x46 + P_IX) << 8); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x46 + P_IX)); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x46 + P_IY) << 8); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x46 + P_IY)); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x06); }
| label? _TK_ALTD _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0xED4B); } else { DO_stmt_nn(0x01); } }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x4E); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x4E + P_IX) << 8); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x4E + P_IX)); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x4E + P_IY) << 8); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x4E + P_IY)); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x0E); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x56); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x56 + P_IX) << 8); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x56 + P_IX)); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x56 + P_IY) << 8); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x56 + P_IY)); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x16); }
| label? _TK_ALTD _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0xED5B); } else { DO_stmt_nn(0x11); } }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x5E); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x5E + P_IX) << 8); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x5E + P_IX)); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x5E + P_IY) << 8); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x5E + P_IY)); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x1E); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x66); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x66 + P_IX) << 8); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x66 + P_IX)); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x66 + P_IY) << 8); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x66 + P_IY)); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x26); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE4 + P_IX) << 8); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xE4 + P_IX)); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xE4 << 8); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xE4); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE4 + P_IY) << 8); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xE4 + P_IY)); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IX _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x7C + P_IX)); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IY _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x7C + P_IY)); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0x2A); } else { DO_stmt_nn(0x21); } }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x6E); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x6E + P_IX) << 8); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x6E + P_IX)); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x6E + P_IY) << 8); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x6E + P_IY)); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x2E); }
| label? _TK_ALTD _TK_NEG _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xED44); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB7); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB0); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB1); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB2); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB3); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB4); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB6); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xB6 + P_IX) << 8); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xB6 + P_IX)); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xB6 + P_IY) << 8); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xB6 + P_IY)); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB5); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xF6); }
| label? _TK_ALTD _TK_POP _TK_AF _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xF1); }
| label? _TK_ALTD _TK_POP _TK_BC _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xC1); }
| label? _TK_ALTD _TK_POP _TK_DE _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xD1); }
| label? _TK_ALTD _TK_POP _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xE1); }
| label? _TK_ALTD _TK_POP _TK_IX _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE1 + P_IX)); }
| label? _TK_ALTD _TK_POP _TK_IY _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE1 + P_IY)); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9F); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x98); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x99); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9A); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9B); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9C); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9E); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x9E + P_IX) << 8); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x9E + P_IX)); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x9E + P_IY) << 8); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x9E + P_IY)); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9D); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xDE); }
| label? _TK_ALTD _TK_SCF _TK_F _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x37); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x97); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x90); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x91); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x92); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x93); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x94); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x96); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x96 + P_IX) << 8); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x96 + P_IX)); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x96 + P_IY) << 8); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x96 + P_IY)); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x95); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xD6); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAF); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA8); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA9); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAA); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAB); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAC); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAE); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xAE + P_IX) << 8); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xAE + P_IX)); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xAE + P_IY) << 8); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xAE + P_IY)); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAD); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xEE); }
| label? _TK_AND _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0xA7); }
| label? _TK_AND _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0xA0); }
| label? _TK_AND _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0xA1); }
| label? _TK_AND _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0xA2); }
| label? _TK_AND _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0xA3); }
| label? _TK_AND _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0xA4); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xA6); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xA6 + P_IX) << 8); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xA6 + P_IX)); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xA6 + P_IY) << 8); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xA6 + P_IY)); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xA4 + P_IX)); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xA5 + P_IX)); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xA4 + P_IY)); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xA5 + P_IY)); }
| label? _TK_AND _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0xA5); }
| label? _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xE6); }
| label? _TK_AND _TK_A _TK_NEWLINE @{ DO_stmt(0xA7); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA7); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA0); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA1); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA2); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA3); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA4); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA6); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xA6 + P_IX) << 8); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xA6 + P_IX)); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xA6 + P_IY) << 8); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xA6 + P_IY)); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA5); }
| label? _TK_AND _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xE6); }
| label? _TK_AND _TK_B _TK_NEWLINE @{ DO_stmt(0xA0); }
| label? _TK_AND _TK_C _TK_NEWLINE @{ DO_stmt(0xA1); }
| label? _TK_AND _TK_D _TK_NEWLINE @{ DO_stmt(0xA2); }
| label? _TK_AND _TK_E _TK_NEWLINE @{ DO_stmt(0xA3); }
| label? _TK_AND _TK_H _TK_NEWLINE @{ DO_stmt(0xA4); }
| label? _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xA6); }
| label? _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xA6 + P_IX) << 8); }
| label? _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xA6 + P_IX)); }
| label? _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xA6 + P_IY) << 8); }
| label? _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xA6 + P_IY)); }
| label? _TK_AND _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xA4 + P_IX)); }
| label? _TK_AND _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xA5 + P_IX)); }
| label? _TK_AND _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xA4 + P_IY)); }
| label? _TK_AND _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xA5 + P_IY)); }
| label? _TK_AND _TK_L _TK_NEWLINE @{ DO_stmt(0xA5); }
| label? _TK_AND expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xE6); }
| label? _TK_CCF _TK_F _TK_NEWLINE @{ DO_stmt(0x3F); }
| label? _TK_CCF _TK_F1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x3F); }
| label? _TK_CCF _TK_NEWLINE @{ DO_stmt(0x3F); }
| label? _TK_CP _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0xBF); }
| label? _TK_CP _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0xB8); }
| label? _TK_CP _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0xB9); }
| label? _TK_CP _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0xBA); }
| label? _TK_CP _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0xBB); }
| label? _TK_CP _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0xBC); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xBE); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xBE + P_IX) << 8); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xBE + P_IX)); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xBE + P_IY) << 8); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xBE + P_IY)); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xBC + P_IX)); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xBD + P_IX)); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xBC + P_IY)); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xBD + P_IY)); }
| label? _TK_CP _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0xBD); }
| label? _TK_CP _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xFE); }
| label? _TK_CP _TK_A _TK_NEWLINE @{ DO_stmt(0xBF); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBF); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB8); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB9); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBA); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBB); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBC); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBE); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xBE + P_IX) << 8); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xBE + P_IX)); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xBE + P_IY) << 8); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xBE + P_IY)); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBD); }
| label? _TK_CP _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xFE); }
| label? _TK_CP _TK_B _TK_NEWLINE @{ DO_stmt(0xB8); }
| label? _TK_CP _TK_C _TK_NEWLINE @{ DO_stmt(0xB9); }
| label? _TK_CP _TK_D _TK_NEWLINE @{ DO_stmt(0xBA); }
| label? _TK_CP _TK_E _TK_NEWLINE @{ DO_stmt(0xBB); }
| label? _TK_CP _TK_H _TK_NEWLINE @{ DO_stmt(0xBC); }
| label? _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xBE); }
| label? _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xBE + P_IX) << 8); }
| label? _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xBE + P_IX)); }
| label? _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xBE + P_IY) << 8); }
| label? _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xBE + P_IY)); }
| label? _TK_CP _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xBC + P_IX)); }
| label? _TK_CP _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xBD + P_IX)); }
| label? _TK_CP _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xBC + P_IY)); }
| label? _TK_CP _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xBD + P_IY)); }
| label? _TK_CP _TK_L _TK_NEWLINE @{ DO_stmt(0xBD); }
| label? _TK_CP expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xFE); }
| label? _TK_CPL _TK_A _TK_NEWLINE @{ DO_stmt(0x2F); }
| label? _TK_CPL _TK_A1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x2F); }
| label? _TK_CPL _TK_NEWLINE @{ DO_stmt(0x2F); }
| label? _TK_DAA _TK_NEWLINE @{ if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x27); }
| label? _TK_DEC _TK_A _TK_NEWLINE @{ DO_stmt(0x3D); }
| label? _TK_DEC _TK_A1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x3D); }
| label? _TK_DEC _TK_B _TK_NEWLINE @{ DO_stmt(0x05); }
| label? _TK_DEC _TK_B1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x05); }
| label? _TK_DEC _TK_C _TK_NEWLINE @{ DO_stmt(0x0D); }
| label? _TK_DEC _TK_C1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x0D); }
| label? _TK_DEC _TK_D _TK_NEWLINE @{ DO_stmt(0x15); }
| label? _TK_DEC _TK_D1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x15); }
| label? _TK_DEC _TK_E _TK_NEWLINE @{ DO_stmt(0x1D); }
| label? _TK_DEC _TK_E1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x1D); }
| label? _TK_DEC _TK_H _TK_NEWLINE @{ DO_stmt(0x25); }
| label? _TK_DEC _TK_H1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x25); }
| label? _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x35); }
| label? _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x35 + P_IX) << 8); }
| label? _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x35 + P_IX)); }
| label? _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x35 + P_IY) << 8); }
| label? _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x35 + P_IY)); }
| label? _TK_DEC _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x25 + P_IX)); }
| label? _TK_DEC _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x2D + P_IX)); }
| label? _TK_DEC _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x25 + P_IY)); }
| label? _TK_DEC _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x2D + P_IY)); }
| label? _TK_DEC _TK_L _TK_NEWLINE @{ DO_stmt(0x2D); }
| label? _TK_DEC _TK_L1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x2D); }
| label? _TK_INC _TK_A _TK_NEWLINE @{ DO_stmt(0x3C); }
| label? _TK_INC _TK_A1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x3C); }
| label? _TK_INC _TK_B _TK_NEWLINE @{ DO_stmt(0x04); }
| label? _TK_INC _TK_B1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x04); }
| label? _TK_INC _TK_C _TK_NEWLINE @{ DO_stmt(0x0C); }
| label? _TK_INC _TK_C1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x0C); }
| label? _TK_INC _TK_D _TK_NEWLINE @{ DO_stmt(0x14); }
| label? _TK_INC _TK_D1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x14); }
| label? _TK_INC _TK_E _TK_NEWLINE @{ DO_stmt(0x1C); }
| label? _TK_INC _TK_E1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x1C); }
| label? _TK_INC _TK_H _TK_NEWLINE @{ DO_stmt(0x24); }
| label? _TK_INC _TK_H1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x24); }
| label? _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x34); }
| label? _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x34 + P_IX) << 8); }
| label? _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x34 + P_IX)); }
| label? _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x34 + P_IY) << 8); }
| label? _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x34 + P_IY)); }
| label? _TK_INC _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x24 + P_IX)); }
| label? _TK_INC _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x2C + P_IX)); }
| label? _TK_INC _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x24 + P_IY)); }
| label? _TK_INC _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x2C + P_IY)); }
| label? _TK_INC _TK_L _TK_NEWLINE @{ DO_stmt(0x2C); }
| label? _TK_INC _TK_L1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x2C); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_NEWLINE @{ DO_stmt(0x0A); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_NEWLINE @{ DO_stmt(0x1A); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x7E); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x7E + P_IX) << 8); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x7E + P_IX)); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x7E + P_IY) << 8); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x7E + P_IY)); }
| label? _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) { DO_stmt_nn(0x3A); } else { DO_stmt_n(0x3E); } }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_BC _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x0A); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_DE _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x1A); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x7E); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x7E + P_IX) << 8); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x7E + P_IX)); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x7E + P_IY) << 8); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x7E + P_IY)); }
| label? _TK_LD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0x3A); } else { DO_stmt_n(0x3E); } }
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x46); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x46 + P_IX) << 8); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x46 + P_IX)); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x46 + P_IY) << 8); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x46 + P_IY)); }
| label? _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0x06); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x46); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x46 + P_IX) << 8); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x46 + P_IX)); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x46 + P_IY) << 8); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x46 + P_IY)); }
| label? _TK_LD _TK_B1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x06); }
| label? _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) { DO_stmt_nn(0xED4B); } else { DO_stmt_nn(0x01); } }
| label? _TK_LD _TK_BC1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0xED4B); } else { DO_stmt_nn(0x01); } }
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x4E); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x4E + P_IX) << 8); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x4E + P_IX)); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x4E + P_IY) << 8); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x4E + P_IY)); }
| label? _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0x0E); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x4E); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x4E + P_IX) << 8); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x4E + P_IX)); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x4E + P_IY) << 8); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x4E + P_IY)); }
| label? _TK_LD _TK_C1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x0E); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x56); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x56 + P_IX) << 8); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x56 + P_IX)); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x56 + P_IY) << 8); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x56 + P_IY)); }
| label? _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0x16); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x56); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x56 + P_IX) << 8); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x56 + P_IX)); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x56 + P_IY) << 8); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x56 + P_IY)); }
| label? _TK_LD _TK_D1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x16); }
| label? _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) { DO_stmt_nn(0xED5B); } else { DO_stmt_nn(0x11); } }
| label? _TK_LD _TK_DE1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0xED5B); } else { DO_stmt_nn(0x11); } }
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x5E); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x5E + P_IX) << 8); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x5E + P_IX)); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x5E + P_IY) << 8); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x5E + P_IY)); }
| label? _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0x1E); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x5E); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x5E + P_IX) << 8); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x5E + P_IX)); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x5E + P_IY) << 8); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x5E + P_IY)); }
| label? _TK_LD _TK_E1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x1E); }
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x66); }
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x66 + P_IX) << 8); }
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x66 + P_IX)); }
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x66 + P_IY) << 8); }
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x66 + P_IY)); }
| label? _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0x26); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x66); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x66 + P_IX) << 8); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x66 + P_IX)); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x66 + P_IY) << 8); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x66 + P_IY)); }
| label? _TK_LD _TK_H1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x26); }
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xE4 + P_IX) << 8); }
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx((0xE4 + P_IX)); }
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xE4 << 8); }
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx(0xE4); }
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xE4 + P_IY) << 8); }
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx((0xE4 + P_IY)); }
| label? _TK_LD _TK_HL _TK_COMMA _TK_IX _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x7C + P_IX)); }
| label? _TK_LD _TK_HL _TK_COMMA _TK_IY _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x7C + P_IY)); }
| label? _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) { DO_stmt_nn(0x2A); } else { DO_stmt_nn(0x21); } }
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE4 + P_IX) << 8); }
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xE4 + P_IX)); }
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xE4 << 8); }
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xE4); }
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE4 + P_IY) << 8); }
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xE4 + P_IY)); }
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IX _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x7C + P_IX)); }
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IY _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x7C + P_IY)); }
| label? _TK_LD _TK_HL1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0x2A); } else { DO_stmt_nn(0x21); } }
| label? _TK_LD _TK_IND_BC _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x02); }
| label? _TK_LD _TK_IND_DE _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x12); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x77); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x70); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x71); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x72); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x73); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x74); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xF4 + P_IX) << 8); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x75); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0x36); }
| label? _TK_LD _TK_IND_HL expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx((0xF4 + P_IX)); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt((0x77 + P_IX) << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt((0x70 + P_IX) << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt((0x71 + P_IX) << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt((0x72 + P_IX) << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt((0x73 + P_IX) << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt((0x74 + P_IX) << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xF4 << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt((0x75 + P_IX) << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n((0x36 + P_IX) << 8); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt_idx((0x77 + P_IX)); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt_idx((0x70 + P_IX)); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt_idx((0x71 + P_IX)); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt_idx((0x72 + P_IX)); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt_idx((0x73 + P_IX)); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt_idx((0x74 + P_IX)); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx(0xF4); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt_idx((0x75 + P_IX)); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_idx_n((0x36 + P_IX)); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt((0x77 + P_IY) << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt((0x70 + P_IY) << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt((0x71 + P_IY) << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt((0x72 + P_IY) << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt((0x73 + P_IY) << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt((0x74 + P_IY) << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xF4 + P_IY) << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt((0x75 + P_IY) << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n((0x36 + P_IY) << 8); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt_idx((0x77 + P_IY)); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt_idx((0x70 + P_IY)); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt_idx((0x71 + P_IY)); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt_idx((0x72 + P_IY)); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt_idx((0x73 + P_IY)); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt_idx((0x74 + P_IY)); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx((0xF4 + P_IY)); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt_idx((0x75 + P_IY)); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_idx_n((0x36 + P_IY)); }
| label? _TK_LD _TK_IX _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x7D + P_IX)); }
| label? _TK_LD _TK_IX _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) { DO_stmt_nn((0x2A + P_IX)); } else { DO_stmt_nn((0x21 + P_IX)); } }
| label? _TK_LD _TK_IXH _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n((0x26 + P_IX)); }
| label? _TK_LD _TK_IXL _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n((0x2E + P_IX)); }
| label? _TK_LD _TK_IY _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x7D + P_IY)); }
| label? _TK_LD _TK_IY _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) { DO_stmt_nn((0x2A + P_IY)); } else { DO_stmt_nn((0x21 + P_IY)); } }
| label? _TK_LD _TK_IYH _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n((0x26 + P_IY)); }
| label? _TK_LD _TK_IYL _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n((0x2E + P_IY)); }
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x6E); }
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x6E + P_IX) << 8); }
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x6E + P_IX)); }
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x6E + P_IY) << 8); }
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x6E + P_IY)); }
| label? _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0x2E); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x6E); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x6E + P_IX) << 8); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x6E + P_IX)); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x6E + P_IY) << 8); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x6E + P_IY)); }
| label? _TK_LD _TK_L1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x2E); }
| label? _TK_LD _TK_SP _TK_COMMA _TK_HL _TK_NEWLINE @{ DO_stmt(0xF9); }
| label? _TK_LD _TK_SP _TK_COMMA _TK_IX _TK_NEWLINE @{ DO_stmt((0xF9 + P_IX)); }
| label? _TK_LD _TK_SP _TK_COMMA _TK_IY _TK_NEWLINE @{ DO_stmt((0xF9 + P_IY)); }
| label? _TK_LD _TK_SP _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) { DO_stmt_nn(0xED7B); } else { DO_stmt_nn(0x31); } }
| label? _TK_LD expr _TK_COMMA _TK_A _TK_NEWLINE @{ if (!expr_in_parens) return FALSE; DO_stmt_nn(0x32); }
| label? _TK_LD expr _TK_COMMA _TK_BC _TK_NEWLINE @{ if (!expr_in_parens) return FALSE; DO_stmt_nn(0xED43); }
| label? _TK_LD expr _TK_COMMA _TK_DE _TK_NEWLINE @{ if (!expr_in_parens) return FALSE; DO_stmt_nn(0xED53); }
| label? _TK_LD expr _TK_COMMA _TK_HL _TK_NEWLINE @{ if (!expr_in_parens) return FALSE; DO_stmt_nn(0x22); }
| label? _TK_LD expr _TK_COMMA _TK_IX _TK_NEWLINE @{ if (!expr_in_parens) return FALSE; DO_stmt_nn((0x22 + P_IX)); }
| label? _TK_LD expr _TK_COMMA _TK_IY _TK_NEWLINE @{ if (!expr_in_parens) return FALSE; DO_stmt_nn((0x22 + P_IY)); }
| label? _TK_LD expr _TK_COMMA _TK_SP _TK_NEWLINE @{ if (!expr_in_parens) return FALSE; DO_stmt_nn(0xED73); }
| label? _TK_LDP _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED6C); }
| label? _TK_LDP _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x6C + P_IX)); }
| label? _TK_LDP _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x6C + P_IY)); }
| label? _TK_LDP _TK_HL _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (!expr_in_parens) return FALSE; DO_stmt_nn(0xED6D); }
| label? _TK_LDP _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED64); }
| label? _TK_LDP _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x64 + P_IX)); }
| label? _TK_LDP _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x64 + P_IY)); }
| label? _TK_LDP _TK_IX _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (!expr_in_parens) return FALSE; DO_stmt_nn((0x6D + P_IX)); }
| label? _TK_LDP _TK_IY _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (!expr_in_parens) return FALSE; DO_stmt_nn((0x6D + P_IY)); }
| label? _TK_LDP expr _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (!expr_in_parens) return FALSE; DO_stmt_nn(0xED65); }
| label? _TK_LDP expr _TK_COMMA _TK_IX _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (!expr_in_parens) return FALSE; DO_stmt_nn((0x65 + P_IX)); }
| label? _TK_LDP expr _TK_COMMA _TK_IY _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (!expr_in_parens) return FALSE; DO_stmt_nn((0x65 + P_IY)); }
| label? _TK_NEG _TK_A _TK_NEWLINE @{ DO_stmt(0xED44); }
| label? _TK_NEG _TK_A1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xED44); }
| label? _TK_NEG _TK_NEWLINE @{ DO_stmt(0xED44); }
| label? _TK_OR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0xB7); }
| label? _TK_OR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0xB0); }
| label? _TK_OR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0xB1); }
| label? _TK_OR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0xB2); }
| label? _TK_OR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0xB3); }
| label? _TK_OR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0xB4); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xB6); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xB6 + P_IX) << 8); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xB6 + P_IX)); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xB6 + P_IY) << 8); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xB6 + P_IY)); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xB4 + P_IX)); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xB5 + P_IX)); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xB4 + P_IY)); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xB5 + P_IY)); }
| label? _TK_OR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0xB5); }
| label? _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xF6); }
| label? _TK_OR _TK_A _TK_NEWLINE @{ DO_stmt(0xB7); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB7); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB0); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB1); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB2); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB3); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB4); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB6); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xB6 + P_IX) << 8); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xB6 + P_IX)); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xB6 + P_IY) << 8); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xB6 + P_IY)); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB5); }
| label? _TK_OR _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xF6); }
| label? _TK_OR _TK_B _TK_NEWLINE @{ DO_stmt(0xB0); }
| label? _TK_OR _TK_C _TK_NEWLINE @{ DO_stmt(0xB1); }
| label? _TK_OR _TK_D _TK_NEWLINE @{ DO_stmt(0xB2); }
| label? _TK_OR _TK_E _TK_NEWLINE @{ DO_stmt(0xB3); }
| label? _TK_OR _TK_H _TK_NEWLINE @{ DO_stmt(0xB4); }
| label? _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xB6); }
| label? _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xB6 + P_IX) << 8); }
| label? _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xB6 + P_IX)); }
| label? _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xB6 + P_IY) << 8); }
| label? _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xB6 + P_IY)); }
| label? _TK_OR _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xB4 + P_IX)); }
| label? _TK_OR _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xB5 + P_IX)); }
| label? _TK_OR _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xB4 + P_IY)); }
| label? _TK_OR _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xB5 + P_IY)); }
| label? _TK_OR _TK_L _TK_NEWLINE @{ DO_stmt(0xB5); }
| label? _TK_OR expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xF6); }
| label? _TK_POP _TK_AF _TK_NEWLINE @{ DO_stmt(0xF1); }
| label? _TK_POP _TK_AF1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xF1); }
| label? _TK_POP _TK_BC _TK_NEWLINE @{ DO_stmt(0xC1); }
| label? _TK_POP _TK_BC1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xC1); }
| label? _TK_POP _TK_DE _TK_NEWLINE @{ DO_stmt(0xD1); }
| label? _TK_POP _TK_DE1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xD1); }
| label? _TK_POP _TK_HL _TK_NEWLINE @{ DO_stmt(0xE1); }
| label? _TK_POP _TK_HL1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xE1); }
| label? _TK_POP _TK_IP _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED7E); }
| label? _TK_POP _TK_IX _TK_NEWLINE @{ DO_stmt((0xE1 + P_IX)); }
| label? _TK_POP _TK_IY _TK_NEWLINE @{ DO_stmt((0xE1 + P_IY)); }
| label? _TK_POP _TK_SU _TK_NEWLINE @{ if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED6E); }
| label? _TK_PUSH _TK_AF _TK_NEWLINE @{ DO_stmt(0xF5); }
| label? _TK_PUSH _TK_BC _TK_NEWLINE @{ DO_stmt(0xC5); }
| label? _TK_PUSH _TK_DE _TK_NEWLINE @{ DO_stmt(0xD5); }
| label? _TK_PUSH _TK_HL _TK_NEWLINE @{ DO_stmt(0xE5); }
| label? _TK_PUSH _TK_IP _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED76); }
| label? _TK_PUSH _TK_IX _TK_NEWLINE @{ DO_stmt((0xE5 + P_IX)); }
| label? _TK_PUSH _TK_IY _TK_NEWLINE @{ DO_stmt((0xE5 + P_IY)); }
| label? _TK_PUSH _TK_SU _TK_NEWLINE @{ if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED66); }
| label? _TK_RLD _TK_NEWLINE @{ DO_stmt_emul(0xED6F, rcmx_rld); }
| label? _TK_RRD _TK_NEWLINE @{ DO_stmt_emul(0xED67, rcmx_rrd); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x9F); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x98); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x99); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x9A); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x9B); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x9C); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x9E); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x9E + P_IX) << 8); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x9E + P_IX)); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x9E + P_IY) << 8); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x9E + P_IY)); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x9C + P_IX)); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x9D + P_IX)); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x9C + P_IY)); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x9D + P_IY)); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x9D); }
| label? _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xDE); }
| label? _TK_SBC _TK_A _TK_NEWLINE @{ DO_stmt(0x9F); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9F); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x98); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x99); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9A); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9B); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9C); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9E); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x9E + P_IX) << 8); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x9E + P_IX)); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x9E + P_IY) << 8); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x9E + P_IY)); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9D); }
| label? _TK_SBC _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xDE); }
| label? _TK_SBC _TK_B _TK_NEWLINE @{ DO_stmt(0x98); }
| label? _TK_SBC _TK_C _TK_NEWLINE @{ DO_stmt(0x99); }
| label? _TK_SBC _TK_D _TK_NEWLINE @{ DO_stmt(0x9A); }
| label? _TK_SBC _TK_E _TK_NEWLINE @{ DO_stmt(0x9B); }
| label? _TK_SBC _TK_H _TK_NEWLINE @{ DO_stmt(0x9C); }
| label? _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x9E); }
| label? _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x9E + P_IX) << 8); }
| label? _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x9E + P_IX)); }
| label? _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x9E + P_IY) << 8); }
| label? _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x9E + P_IY)); }
| label? _TK_SBC _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x9C + P_IX)); }
| label? _TK_SBC _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x9D + P_IX)); }
| label? _TK_SBC _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x9C + P_IY)); }
| label? _TK_SBC _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x9D + P_IY)); }
| label? _TK_SBC _TK_L _TK_NEWLINE @{ DO_stmt(0x9D); }
| label? _TK_SBC expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xDE); }
| label? _TK_SCF _TK_F _TK_NEWLINE @{ DO_stmt(0x37); }
| label? _TK_SCF _TK_F1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x37); }
| label? _TK_SCF _TK_NEWLINE @{ DO_stmt(0x37); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x97); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x90); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x91); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x92); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x93); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x94); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x96); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x96 + P_IX) << 8); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x96 + P_IX)); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x96 + P_IY) << 8); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x96 + P_IY)); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x94 + P_IX)); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x95 + P_IX)); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x94 + P_IY)); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x95 + P_IY)); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x95); }
| label? _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xD6); }
| label? _TK_SUB _TK_A _TK_NEWLINE @{ DO_stmt(0x97); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x97); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x90); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x91); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x92); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x93); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x94); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x96); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x96 + P_IX) << 8); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x96 + P_IX)); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x96 + P_IY) << 8); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0x96 + P_IY)); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x95); }
| label? _TK_SUB _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xD6); }
| label? _TK_SUB _TK_B _TK_NEWLINE @{ DO_stmt(0x90); }
| label? _TK_SUB _TK_C _TK_NEWLINE @{ DO_stmt(0x91); }
| label? _TK_SUB _TK_D _TK_NEWLINE @{ DO_stmt(0x92); }
| label? _TK_SUB _TK_E _TK_NEWLINE @{ DO_stmt(0x93); }
| label? _TK_SUB _TK_H _TK_NEWLINE @{ DO_stmt(0x94); }
| label? _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x96); }
| label? _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x96 + P_IX) << 8); }
| label? _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x96 + P_IX)); }
| label? _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0x96 + P_IY) << 8); }
| label? _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0x96 + P_IY)); }
| label? _TK_SUB _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x94 + P_IX)); }
| label? _TK_SUB _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x95 + P_IX)); }
| label? _TK_SUB _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x94 + P_IY)); }
| label? _TK_SUB _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x95 + P_IY)); }
| label? _TK_SUB _TK_L _TK_NEWLINE @{ DO_stmt(0x95); }
| label? _TK_SUB expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xD6); }
| label? _TK_TST _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED3C); }
| label? _TK_TST _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED04); }
| label? _TK_TST _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED0C); }
| label? _TK_TST _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED14); }
| label? _TK_TST _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED1C); }
| label? _TK_TST _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED24); }
| label? _TK_TST _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED34); }
| label? _TK_TST _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED2C); }
| label? _TK_TST _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xED64); }
| label? _TK_TST _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED3C); }
| label? _TK_TST _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED04); }
| label? _TK_TST _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED0C); }
| label? _TK_TST _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED14); }
| label? _TK_TST _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED1C); }
| label? _TK_TST _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED24); }
| label? _TK_TST _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED34); }
| label? _TK_TST _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xED2C); }
| label? _TK_TST expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xED64); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0xAF); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0xA8); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0xA9); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0xAA); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0xAB); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0xAC); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xAE); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xAE + P_IX) << 8); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xAE + P_IX)); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xAE + P_IY) << 8); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xAE + P_IY)); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xAC + P_IX)); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xAD + P_IX)); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xAC + P_IY)); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xAD + P_IY)); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0xAD); }
| label? _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xEE); }
| label? _TK_XOR _TK_A _TK_NEWLINE @{ DO_stmt(0xAF); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAF); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA8); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA9); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAA); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAB); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAC); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAE); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xAE + P_IX) << 8); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xAE + P_IX)); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xAE + P_IY) << 8); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xAE + P_IY)); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAD); }
| label? _TK_XOR _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xEE); }
| label? _TK_XOR _TK_B _TK_NEWLINE @{ DO_stmt(0xA8); }
| label? _TK_XOR _TK_C _TK_NEWLINE @{ DO_stmt(0xA9); }
| label? _TK_XOR _TK_D _TK_NEWLINE @{ DO_stmt(0xAA); }
| label? _TK_XOR _TK_E _TK_NEWLINE @{ DO_stmt(0xAB); }
| label? _TK_XOR _TK_H _TK_NEWLINE @{ DO_stmt(0xAC); }
| label? _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xAE); }
| label? _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xAE + P_IX) << 8); }
| label? _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xAE + P_IX)); }
| label? _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt((0xAE + P_IY) << 8); }
| label? _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx((0xAE + P_IY)); }
| label? _TK_XOR _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xAC + P_IX)); }
| label? _TK_XOR _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xAD + P_IX)); }
| label? _TK_XOR _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xAC + P_IY)); }
| label? _TK_XOR _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xAD + P_IY)); }
| label? _TK_XOR _TK_L _TK_NEWLINE @{ DO_stmt(0xAD); }
| label? _TK_XOR expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xEE); }

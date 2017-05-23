| label? _TK_ADC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x8F); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x88); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x89); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x8A); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x8B); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x8C); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x8E); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD8E << 8); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD8E); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD8E << 8); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD8E); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD8C); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD8D); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD8C); }
| label? _TK_ADC _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD8D); }
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
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD8E << 8); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD8E); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD8E << 8); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD8E); }
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8D); }
| label? _TK_ADC _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xCE); }
| label? _TK_ADC _TK_B _TK_NEWLINE @{ DO_stmt(0x88); }
| label? _TK_ADC _TK_C _TK_NEWLINE @{ DO_stmt(0x89); }
| label? _TK_ADC _TK_D _TK_NEWLINE @{ DO_stmt(0x8A); }
| label? _TK_ADC _TK_E _TK_NEWLINE @{ DO_stmt(0x8B); }
| label? _TK_ADC _TK_H _TK_NEWLINE @{ DO_stmt(0x8C); }
| label? _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x8E); }
| label? _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD8E << 8); }
| label? _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD8E); }
| label? _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD8E << 8); }
| label? _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD8E); }
| label? _TK_ADC _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD8C); }
| label? _TK_ADC _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD8D); }
| label? _TK_ADC _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD8C); }
| label? _TK_ADC _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD8D); }
| label? _TK_ADC _TK_L _TK_NEWLINE @{ DO_stmt(0x8D); }
| label? _TK_ADC expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xCE); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x87); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x80); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x81); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x82); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x83); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x84); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x86); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD86 << 8); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD86); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD86 << 8); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD86); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD84); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD85); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD84); }
| label? _TK_ADD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD85); }
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
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD86 << 8); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD86); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD86 << 8); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD86); }
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x85); }
| label? _TK_ADD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xC6); }
| label? _TK_ADD _TK_B _TK_NEWLINE @{ DO_stmt(0x80); }
| label? _TK_ADD _TK_C _TK_NEWLINE @{ DO_stmt(0x81); }
| label? _TK_ADD _TK_D _TK_NEWLINE @{ DO_stmt(0x82); }
| label? _TK_ADD _TK_E _TK_NEWLINE @{ DO_stmt(0x83); }
| label? _TK_ADD _TK_H _TK_NEWLINE @{ DO_stmt(0x84); }
| label? _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x86); }
| label? _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD86 << 8); }
| label? _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD86); }
| label? _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD86 << 8); }
| label? _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD86); }
| label? _TK_ADD _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD84); }
| label? _TK_ADD _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD85); }
| label? _TK_ADD _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD84); }
| label? _TK_ADD _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD85); }
| label? _TK_ADD _TK_L _TK_NEWLINE @{ DO_stmt(0x85); }
| label? _TK_ADD expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xC6); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8F); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x88); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x89); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8A); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8B); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8C); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8E); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD8E << 8); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD8E); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD8E << 8); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD8E); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x8D); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xCE); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x87); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x80); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x81); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x82); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x83); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x84); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x86); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD86 << 8); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD86); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD86 << 8); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD86); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x85); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xC6); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA7); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA0); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA1); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA2); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA3); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA4); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA6); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDDA6 << 8); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDDA6); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFDA6 << 8); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFDA6); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA5); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xE6); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBF); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB8); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB9); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBA); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBB); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBC); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBE); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDDBE << 8); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDDBE); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFDBE << 8); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFDBE); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBD); }
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xFE); }
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
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x7F); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x78); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x79); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x7A); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x7B); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x7C); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x0A); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x1A); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x7E); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD7E << 8); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD7E); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD7E << 8); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD7E); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x7D); }
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0x3A); } else { DO_stmt_n(0x3E); } }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x47); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x40); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x41); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x42); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x43); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x44); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x46); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD46 << 8); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD46); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD46 << 8); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD46); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x45); }
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x06); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x4F); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x48); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x49); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x4A); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x4B); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x4C); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x4E); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD4E << 8); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD4E); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD4E << 8); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD4E); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x4D); }
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x0E); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x57); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x50); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x51); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x52); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x53); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x54); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x56); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD56 << 8); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD56); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD56 << 8); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD56); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x55); }
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x16); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x5F); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x58); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x59); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x5A); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x5B); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x5C); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x5E); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD5E << 8); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD5E); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD5E << 8); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD5E); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x5D); }
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x1E); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x67); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x60); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x61); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x62); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x63); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x64); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x66); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD66 << 8); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD66); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD66 << 8); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD66); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x65); }
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x26); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x6F); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x68); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x69); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x6A); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x6B); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x6C); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x6E); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD6E << 8); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD6E); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD6E << 8); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD6E); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x6D); }
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x2E); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB7); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB0); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB1); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB2); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB3); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB4); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB6); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDDB6 << 8); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDDB6); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFDB6 << 8); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFDB6); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB5); }
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xF6); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9F); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x98); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x99); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9A); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9B); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9C); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9E); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD9E << 8); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD9E); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD9E << 8); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD9E); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9D); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xDE); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x97); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x90); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x91); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x92); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x93); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x94); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x96); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD96 << 8); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD96); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD96 << 8); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD96); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x95); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xD6); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAF); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA8); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA9); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAA); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAB); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAC); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAE); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDDAE << 8); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDDAE); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFDAE << 8); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFDAE); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAD); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xEE); }
| label? _TK_AND _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0xA7); }
| label? _TK_AND _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0xA0); }
| label? _TK_AND _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0xA1); }
| label? _TK_AND _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0xA2); }
| label? _TK_AND _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0xA3); }
| label? _TK_AND _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0xA4); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xA6); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDDA6 << 8); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDDA6); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFDA6 << 8); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFDA6); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDA4); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDA5); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDA4); }
| label? _TK_AND _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDA5); }
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
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDDA6 << 8); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDDA6); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFDA6 << 8); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFDA6); }
| label? _TK_AND _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xA5); }
| label? _TK_AND _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xE6); }
| label? _TK_AND _TK_B _TK_NEWLINE @{ DO_stmt(0xA0); }
| label? _TK_AND _TK_C _TK_NEWLINE @{ DO_stmt(0xA1); }
| label? _TK_AND _TK_D _TK_NEWLINE @{ DO_stmt(0xA2); }
| label? _TK_AND _TK_E _TK_NEWLINE @{ DO_stmt(0xA3); }
| label? _TK_AND _TK_H _TK_NEWLINE @{ DO_stmt(0xA4); }
| label? _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xA6); }
| label? _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDDA6 << 8); }
| label? _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDDA6); }
| label? _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFDA6 << 8); }
| label? _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFDA6); }
| label? _TK_AND _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDA4); }
| label? _TK_AND _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDA5); }
| label? _TK_AND _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDA4); }
| label? _TK_AND _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDA5); }
| label? _TK_AND _TK_L _TK_NEWLINE @{ DO_stmt(0xA5); }
| label? _TK_AND expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xE6); }
| label? _TK_CP _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0xBF); }
| label? _TK_CP _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0xB8); }
| label? _TK_CP _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0xB9); }
| label? _TK_CP _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0xBA); }
| label? _TK_CP _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0xBB); }
| label? _TK_CP _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0xBC); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xBE); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDDBE << 8); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDDBE); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFDBE << 8); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFDBE); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDBC); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDBD); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDBC); }
| label? _TK_CP _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDBD); }
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
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDDBE << 8); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDDBE); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFDBE << 8); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFDBE); }
| label? _TK_CP _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xBD); }
| label? _TK_CP _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xFE); }
| label? _TK_CP _TK_B _TK_NEWLINE @{ DO_stmt(0xB8); }
| label? _TK_CP _TK_C _TK_NEWLINE @{ DO_stmt(0xB9); }
| label? _TK_CP _TK_D _TK_NEWLINE @{ DO_stmt(0xBA); }
| label? _TK_CP _TK_E _TK_NEWLINE @{ DO_stmt(0xBB); }
| label? _TK_CP _TK_H _TK_NEWLINE @{ DO_stmt(0xBC); }
| label? _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xBE); }
| label? _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDDBE << 8); }
| label? _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDDBE); }
| label? _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFDBE << 8); }
| label? _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFDBE); }
| label? _TK_CP _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDBC); }
| label? _TK_CP _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDBD); }
| label? _TK_CP _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDBC); }
| label? _TK_CP _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDBD); }
| label? _TK_CP _TK_L _TK_NEWLINE @{ DO_stmt(0xBD); }
| label? _TK_CP expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xFE); }
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
| label? _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD35 << 8); }
| label? _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD35); }
| label? _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD35 << 8); }
| label? _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD35); }
| label? _TK_DEC _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD25); }
| label? _TK_DEC _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD2D); }
| label? _TK_DEC _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD25); }
| label? _TK_DEC _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD2D); }
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
| label? _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD34 << 8); }
| label? _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD34); }
| label? _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD34 << 8); }
| label? _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD34); }
| label? _TK_INC _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD24); }
| label? _TK_INC _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD2C); }
| label? _TK_INC _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD24); }
| label? _TK_INC _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD2C); }
| label? _TK_INC _TK_L _TK_NEWLINE @{ DO_stmt(0x2C); }
| label? _TK_INC _TK_L1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x2C); }
| label? _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x7F); }
| label? _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x78); }
| label? _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x79); }
| label? _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x7A); }
| label? _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x7B); }
| label? _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x7C); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_NEWLINE @{ DO_stmt(0x0A); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_NEWLINE @{ DO_stmt(0x1A); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x7E); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD7E << 8); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD7E); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD7E << 8); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD7E); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD7C); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD7D); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD7C); }
| label? _TK_LD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD7D); }
| label? _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x7D); }
| label? _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) { DO_stmt_nn(0x3A); } else { DO_stmt_n(0x3E); } }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x7F); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x78); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x79); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x7A); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x7B); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x7C); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_BC _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x0A); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_DE _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x1A); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x7E); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD7E << 8); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD7E); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD7E << 8); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD7E); }
| label? _TK_LD _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x7D); }
| label? _TK_LD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0x3A); } else { DO_stmt_n(0x3E); } }
| label? _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x47); }
| label? _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x40); }
| label? _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x41); }
| label? _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x42); }
| label? _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x43); }
| label? _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x44); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x46); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD46 << 8); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD46); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD46 << 8); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD46); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD44); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD45); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD44); }
| label? _TK_LD _TK_B _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD45); }
| label? _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x45); }
| label? _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0x06); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x47); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x40); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x41); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x42); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x43); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x44); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x46); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD46 << 8); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD46); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD46 << 8); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD46); }
| label? _TK_LD _TK_B1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x45); }
| label? _TK_LD _TK_B1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x06); }
| label? _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x4F); }
| label? _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x48); }
| label? _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x49); }
| label? _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x4A); }
| label? _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x4B); }
| label? _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x4C); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x4E); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD4E << 8); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD4E); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD4E << 8); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD4E); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD4C); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD4D); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD4C); }
| label? _TK_LD _TK_C _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD4D); }
| label? _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x4D); }
| label? _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0x0E); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x4F); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x48); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x49); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x4A); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x4B); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x4C); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x4E); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD4E << 8); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD4E); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD4E << 8); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD4E); }
| label? _TK_LD _TK_C1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x4D); }
| label? _TK_LD _TK_C1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x0E); }
| label? _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x57); }
| label? _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x50); }
| label? _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x51); }
| label? _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x52); }
| label? _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x53); }
| label? _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x54); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x56); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD56 << 8); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD56); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD56 << 8); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD56); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD54); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD55); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD54); }
| label? _TK_LD _TK_D _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD55); }
| label? _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x55); }
| label? _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0x16); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x57); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x50); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x51); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x52); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x53); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x54); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x56); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD56 << 8); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD56); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD56 << 8); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD56); }
| label? _TK_LD _TK_D1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x55); }
| label? _TK_LD _TK_D1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x16); }
| label? _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x5F); }
| label? _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x58); }
| label? _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x59); }
| label? _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x5A); }
| label? _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x5B); }
| label? _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x5C); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x5E); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD5E << 8); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD5E); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD5E << 8); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD5E); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD5C); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD5D); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD5C); }
| label? _TK_LD _TK_E _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD5D); }
| label? _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x5D); }
| label? _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0x1E); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x5F); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x58); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x59); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x5A); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x5B); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x5C); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x5E); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD5E << 8); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD5E); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD5E << 8); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD5E); }
| label? _TK_LD _TK_E1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x5D); }
| label? _TK_LD _TK_E1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x1E); }
| label? _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x67); }
| label? _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x60); }
| label? _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x61); }
| label? _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x62); }
| label? _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x63); }
| label? _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x64); }
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x66); }
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD66 << 8); }
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD66); }
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD66 << 8); }
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD66); }
| label? _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x65); }
| label? _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0x26); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x67); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x60); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x61); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x62); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x63); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x64); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x66); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD66 << 8); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD66); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD66 << 8); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD66); }
| label? _TK_LD _TK_H1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x65); }
| label? _TK_LD _TK_H1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x26); }
| label? _TK_LD _TK_IND_BC _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x02); }
| label? _TK_LD _TK_IND_DE _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x12); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x77); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x70); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x71); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x72); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x73); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x74); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x75); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0x36); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0xDD77 << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0xDD70 << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0xDD71 << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0xDD72 << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0xDD73 << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0xDD74 << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0xDD75 << 8); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xDD36 << 8); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt_idx(0xDD77); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt_idx(0xDD70); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt_idx(0xDD71); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt_idx(0xDD72); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt_idx(0xDD73); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt_idx(0xDD74); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt_idx(0xDD75); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_idx_n(0xDD36); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0xFD77 << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0xFD70 << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0xFD71 << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0xFD72 << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0xFD73 << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0xFD74 << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0xFD75 << 8); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xFD36 << 8); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt_idx(0xFD77); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt_idx(0xFD70); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt_idx(0xFD71); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt_idx(0xFD72); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt_idx(0xFD73); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt_idx(0xFD74); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt_idx(0xFD75); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_idx_n(0xFD36); }
| label? _TK_LD _TK_IXH _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD67); }
| label? _TK_LD _TK_IXH _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD60); }
| label? _TK_LD _TK_IXH _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD61); }
| label? _TK_LD _TK_IXH _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD62); }
| label? _TK_LD _TK_IXH _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD63); }
| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD64); }
| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD65); }
| label? _TK_LD _TK_IXH _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xDD26); }
| label? _TK_LD _TK_IXL _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD6F); }
| label? _TK_LD _TK_IXL _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD68); }
| label? _TK_LD _TK_IXL _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD69); }
| label? _TK_LD _TK_IXL _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD6A); }
| label? _TK_LD _TK_IXL _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD6B); }
| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD6C); }
| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD6D); }
| label? _TK_LD _TK_IXL _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xDD2E); }
| label? _TK_LD _TK_IYH _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD67); }
| label? _TK_LD _TK_IYH _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD60); }
| label? _TK_LD _TK_IYH _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD61); }
| label? _TK_LD _TK_IYH _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD62); }
| label? _TK_LD _TK_IYH _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD63); }
| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD64); }
| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD65); }
| label? _TK_LD _TK_IYH _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xFD26); }
| label? _TK_LD _TK_IYL _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD6F); }
| label? _TK_LD _TK_IYL _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD68); }
| label? _TK_LD _TK_IYL _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD69); }
| label? _TK_LD _TK_IYL _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD6A); }
| label? _TK_LD _TK_IYL _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD6B); }
| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD6C); }
| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD6D); }
| label? _TK_LD _TK_IYL _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xFD2E); }
| label? _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x6F); }
| label? _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x68); }
| label? _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x69); }
| label? _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x6A); }
| label? _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x6B); }
| label? _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x6C); }
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x6E); }
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD6E << 8); }
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD6E); }
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD6E << 8); }
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD6E); }
| label? _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{ DO_stmt(0x6D); }
| label? _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0x2E); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x6F); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_B _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x68); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_C _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x69); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_D _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x6A); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_E _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x6B); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_H _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x6C); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x6E); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD6E << 8); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD6E); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD6E << 8); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD6E); }
| label? _TK_LD _TK_L1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x6D); }
| label? _TK_LD _TK_L1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0x2E); }
| label? _TK_LD expr _TK_COMMA _TK_A _TK_NEWLINE @{ if (!expr_in_parens) return FALSE; DO_stmt_nn(0x32); }
| label? _TK_OR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0xB7); }
| label? _TK_OR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0xB0); }
| label? _TK_OR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0xB1); }
| label? _TK_OR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0xB2); }
| label? _TK_OR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0xB3); }
| label? _TK_OR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0xB4); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xB6); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDDB6 << 8); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDDB6); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFDB6 << 8); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFDB6); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDB4); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDB5); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDB4); }
| label? _TK_OR _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDB5); }
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
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDDB6 << 8); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDDB6); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFDB6 << 8); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFDB6); }
| label? _TK_OR _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xB5); }
| label? _TK_OR _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xF6); }
| label? _TK_OR _TK_B _TK_NEWLINE @{ DO_stmt(0xB0); }
| label? _TK_OR _TK_C _TK_NEWLINE @{ DO_stmt(0xB1); }
| label? _TK_OR _TK_D _TK_NEWLINE @{ DO_stmt(0xB2); }
| label? _TK_OR _TK_E _TK_NEWLINE @{ DO_stmt(0xB3); }
| label? _TK_OR _TK_H _TK_NEWLINE @{ DO_stmt(0xB4); }
| label? _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xB6); }
| label? _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDDB6 << 8); }
| label? _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDDB6); }
| label? _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFDB6 << 8); }
| label? _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFDB6); }
| label? _TK_OR _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDB4); }
| label? _TK_OR _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDB5); }
| label? _TK_OR _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDB4); }
| label? _TK_OR _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDB5); }
| label? _TK_OR _TK_L _TK_NEWLINE @{ DO_stmt(0xB5); }
| label? _TK_OR expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xF6); }
| label? _TK_RLD _TK_NEWLINE @{ DO_stmt_emul(0xED6F, rcmx_rld); }
| label? _TK_RRD _TK_NEWLINE @{ DO_stmt_emul(0xED67, rcmx_rrd); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x9F); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x98); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x99); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x9A); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x9B); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x9C); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x9E); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD9E << 8); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD9E); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD9E << 8); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD9E); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD9C); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD9D); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD9C); }
| label? _TK_SBC _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD9D); }
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
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD9E << 8); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD9E); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD9E << 8); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD9E); }
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x9D); }
| label? _TK_SBC _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xDE); }
| label? _TK_SBC _TK_B _TK_NEWLINE @{ DO_stmt(0x98); }
| label? _TK_SBC _TK_C _TK_NEWLINE @{ DO_stmt(0x99); }
| label? _TK_SBC _TK_D _TK_NEWLINE @{ DO_stmt(0x9A); }
| label? _TK_SBC _TK_E _TK_NEWLINE @{ DO_stmt(0x9B); }
| label? _TK_SBC _TK_H _TK_NEWLINE @{ DO_stmt(0x9C); }
| label? _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x9E); }
| label? _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD9E << 8); }
| label? _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD9E); }
| label? _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD9E << 8); }
| label? _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD9E); }
| label? _TK_SBC _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD9C); }
| label? _TK_SBC _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD9D); }
| label? _TK_SBC _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD9C); }
| label? _TK_SBC _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD9D); }
| label? _TK_SBC _TK_L _TK_NEWLINE @{ DO_stmt(0x9D); }
| label? _TK_SBC expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xDE); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ DO_stmt(0x97); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ DO_stmt(0x90); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ DO_stmt(0x91); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ DO_stmt(0x92); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ DO_stmt(0x93); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ DO_stmt(0x94); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x96); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD96 << 8); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD96); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD96 << 8); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD96); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD94); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD95); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD94); }
| label? _TK_SUB _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD95); }
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
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDD96 << 8); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDD96); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFD96 << 8); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFD96); }
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x95); }
| label? _TK_SUB _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xD6); }
| label? _TK_SUB _TK_B _TK_NEWLINE @{ DO_stmt(0x90); }
| label? _TK_SUB _TK_C _TK_NEWLINE @{ DO_stmt(0x91); }
| label? _TK_SUB _TK_D _TK_NEWLINE @{ DO_stmt(0x92); }
| label? _TK_SUB _TK_E _TK_NEWLINE @{ DO_stmt(0x93); }
| label? _TK_SUB _TK_H _TK_NEWLINE @{ DO_stmt(0x94); }
| label? _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0x96); }
| label? _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDD96 << 8); }
| label? _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDD96); }
| label? _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFD96 << 8); }
| label? _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFD96); }
| label? _TK_SUB _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD94); }
| label? _TK_SUB _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDD95); }
| label? _TK_SUB _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD94); }
| label? _TK_SUB _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFD95); }
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
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDDAE << 8); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDDAE); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFDAE << 8); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFDAE); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDAC); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDAD); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDAC); }
| label? _TK_XOR _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDAD); }
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
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xDDAE << 8); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xDDAE); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xFDAE << 8); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xFDAE); }
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xAD); }
| label? _TK_XOR _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xEE); }
| label? _TK_XOR _TK_B _TK_NEWLINE @{ DO_stmt(0xA8); }
| label? _TK_XOR _TK_C _TK_NEWLINE @{ DO_stmt(0xA9); }
| label? _TK_XOR _TK_D _TK_NEWLINE @{ DO_stmt(0xAA); }
| label? _TK_XOR _TK_E _TK_NEWLINE @{ DO_stmt(0xAB); }
| label? _TK_XOR _TK_H _TK_NEWLINE @{ DO_stmt(0xAC); }
| label? _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xAE); }
| label? _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xDDAE << 8); }
| label? _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xDDAE); }
| label? _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ DO_stmt(0xFDAE << 8); }
| label? _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ DO_stmt_idx(0xFDAE); }
| label? _TK_XOR _TK_IXH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDAC); }
| label? _TK_XOR _TK_IXL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xDDAD); }
| label? _TK_XOR _TK_IYH _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDAC); }
| label? _TK_XOR _TK_IYL _TK_NEWLINE @{ if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xFDAD); }
| label? _TK_XOR _TK_L _TK_NEWLINE @{ DO_stmt(0xAD); }
| label? _TK_XOR expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xEE); }

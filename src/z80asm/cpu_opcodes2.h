| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE4 + P_IX) << 8); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xE4 + P_IX)); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xE4 << 8); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xE4); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE4 + P_IY) << 8); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xE4 + P_IY)); }
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xE4 + P_IX) << 8); }
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx((0xE4 + P_IX)); }
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xE4 << 8); }
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx(0xE4); }
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xE4 + P_IY) << 8); }
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx((0xE4 + P_IY)); }
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE4 + P_IX) << 8); }
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xE4 + P_IX)); }
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xE4 << 8); }
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xE4); }
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE4 + P_IY) << 8); }
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xE4 + P_IY)); }
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xF4 + P_IX) << 8); }
| label? _TK_LD _TK_IND_HL expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx((0xF4 + P_IX)); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xF4 << 8); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx(0xF4); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xF4 + P_IY) << 8); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx((0xF4 + P_IY)); }
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

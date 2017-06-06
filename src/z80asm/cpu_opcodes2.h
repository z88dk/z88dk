| label? _TK_ALTD _TK_CCF _TK_F _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x3F); }
| label? _TK_ALTD _TK_CPL _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x2F); }
| label? _TK_ALTD _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0xED4B); } else { DO_stmt_nn(0x01); } }
| label? _TK_ALTD _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0xED5B); } else { DO_stmt_nn(0x11); } }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE4 + P_IX) << 8); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xE4 + P_IX)); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xE4 << 8); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx(0xE4); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE4 + P_IY) << 8); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt_idx((0xE4 + P_IY)); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IX _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x7C + P_IX)); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IY _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0x7C + P_IY)); }
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0x2A); } else { DO_stmt_nn(0x21); } }
| label? _TK_ALTD _TK_NEG _TK_A _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xED44); }
| label? _TK_ALTD _TK_POP _TK_AF _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xF1); }
| label? _TK_ALTD _TK_POP _TK_BC _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xC1); }
| label? _TK_ALTD _TK_POP _TK_DE _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xD1); }
| label? _TK_ALTD _TK_POP _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xE1); }
| label? _TK_ALTD _TK_POP _TK_IX _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE1 + P_IX)); }
| label? _TK_ALTD _TK_POP _TK_IY _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE1 + P_IY)); }
| label? _TK_ALTD _TK_SCF _TK_F _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x37); }
| label? _TK_CCF _TK_F _TK_NEWLINE @{ DO_stmt(0x3F); }
| label? _TK_CCF _TK_F1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x3F); }
| label? _TK_CCF _TK_NEWLINE @{ DO_stmt(0x3F); }
| label? _TK_CPL _TK_A _TK_NEWLINE @{ DO_stmt(0x2F); }
| label? _TK_CPL _TK_A1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x2F); }
| label? _TK_CPL _TK_NEWLINE @{ DO_stmt(0x2F); }
| label? _TK_DAA _TK_NEWLINE @{ if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x27); }
| label? _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) { DO_stmt_nn(0xED4B); } else { DO_stmt_nn(0x01); } }
| label? _TK_LD _TK_BC1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0xED4B); } else { DO_stmt_nn(0x01); } }
| label? _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) { DO_stmt_nn(0xED5B); } else { DO_stmt_nn(0x11); } }
| label? _TK_LD _TK_DE1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); if (expr_in_parens) { DO_stmt_nn(0xED5B); } else { DO_stmt_nn(0x11); } }
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
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xF4 + P_IX) << 8); }
| label? _TK_LD _TK_IND_HL expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx((0xF4 + P_IX)); }
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0xF4 << 8); }
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx(0xF4); }
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0xF4 + P_IY) << 8); }
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt_idx((0xF4 + P_IY)); }
| label? _TK_LD _TK_IX _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x7D + P_IX)); }
| label? _TK_LD _TK_IX _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) { DO_stmt_nn((0x2A + P_IX)); } else { DO_stmt_nn((0x21 + P_IX)); } }
| label? _TK_LD _TK_IY _TK_COMMA _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt((0x7D + P_IY)); }
| label? _TK_LD _TK_IY _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) { DO_stmt_nn((0x2A + P_IY)); } else { DO_stmt_nn((0x21 + P_IY)); } }
| label? _TK_LD _TK_SP _TK_COMMA _TK_HL _TK_NEWLINE @{ DO_stmt(0xF9); }
| label? _TK_LD _TK_SP _TK_COMMA _TK_IX _TK_NEWLINE @{ DO_stmt((0xF9 + P_IX)); }
| label? _TK_LD _TK_SP _TK_COMMA _TK_IY _TK_NEWLINE @{ DO_stmt((0xF9 + P_IY)); }
| label? _TK_LD _TK_SP _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) { DO_stmt_nn(0xED7B); } else { DO_stmt_nn(0x31); } }
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
| label? _TK_SCF _TK_F _TK_NEWLINE @{ DO_stmt(0x37); }
| label? _TK_SCF _TK_F1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x37); }
| label? _TK_SCF _TK_NEWLINE @{ DO_stmt(0x37); }

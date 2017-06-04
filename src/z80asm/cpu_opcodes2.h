| label? _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xCE); }
| label? _TK_ADC _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xCE); }
| label? _TK_ADC expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xCE); }
| label? _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xC6); }
| label? _TK_ADD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xC6); }
| label? _TK_ADD expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xC6); }
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xCE); }
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xC6); }
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xE6); }
| label? _TK_ALTD _TK_CCF _TK_F _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x3F); }
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
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xF6); }
| label? _TK_ALTD _TK_POP _TK_AF _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xF1); }
| label? _TK_ALTD _TK_POP _TK_BC _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xC1); }
| label? _TK_ALTD _TK_POP _TK_DE _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xD1); }
| label? _TK_ALTD _TK_POP _TK_HL _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0xE1); }
| label? _TK_ALTD _TK_POP _TK_IX _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE1 + P_IX)); }
| label? _TK_ALTD _TK_POP _TK_IY _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt((0xE1 + P_IY)); }
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xDE); }
| label? _TK_ALTD _TK_SCF _TK_F _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x37); }
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xD6); }
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xEE); }
| label? _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xE6); }
| label? _TK_AND _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xE6); }
| label? _TK_AND expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xE6); }
| label? _TK_CCF _TK_F _TK_NEWLINE @{ DO_stmt(0x3F); }
| label? _TK_CCF _TK_F1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x3F); }
| label? _TK_CCF _TK_NEWLINE @{ DO_stmt(0x3F); }
| label? _TK_CP _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xFE); }
| label? _TK_CP _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xFE); }
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
| label? _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xF6); }
| label? _TK_OR _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xF6); }
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
| label? _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xDE); }
| label? _TK_SBC _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xDE); }
| label? _TK_SBC expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xDE); }
| label? _TK_SCF _TK_F _TK_NEWLINE @{ DO_stmt(0x37); }
| label? _TK_SCF _TK_F1 _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } DO_stmt(0x76); DO_stmt(0x37); }
| label? _TK_SCF _TK_NEWLINE @{ DO_stmt(0x37); }
| label? _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xD6); }
| label? _TK_SUB _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xD6); }
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
| label? _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xEE); }
| label? _TK_XOR _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } if (expr_in_parens) warn_expr_in_parens(); DO_stmt(0x76); DO_stmt_n(0xEE); }
| label? _TK_XOR expr _TK_NEWLINE @{ if (expr_in_parens) warn_expr_in_parens(); DO_stmt_n(0xEE); }

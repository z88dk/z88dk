| label? _TK_EX _TK_AF _TK_COMMA _TK_AF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x08);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_AF _TK_COMMA _TK_AF1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x08);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_DE _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xE5);
DO_stmt(0xD5);
DO_stmt(0xE1);
DO_stmt(0xD1);
break;
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEB);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__ex_sp_hl");
break;
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE3);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDE3); } else { DO_stmt(0xFDE3); }
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE3); } else { DO_stmt(0xDDE3); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x78);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x79);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_I _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED57);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_MINUS _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_PLUS _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HLD _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HLI _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7E00); } else { DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD7E); } else { DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7E00); } else { DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD7E); } else { DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7C); } else { DO_stmt(0xFD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7D); } else { DO_stmt(0xFD7D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7C); } else { DO_stmt(0xDD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7D); } else { DO_stmt(0xDD7D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_R _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) { DO_stmt_nn(0x3A); } else { DO_stmt_n(0x3E); }
break;
case CPU_GBZ80: 
if (expr_in_parens) { DO_stmt_nn(0xFA); } else { DO_stmt_n(0x3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x47);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x40);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x41);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x42);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x43);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x44);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4600); } else { DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD46); } else { DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4600); } else { DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD46); } else { DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD44); } else { DO_stmt(0xFD44); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD45); } else { DO_stmt(0xFD45); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD44); } else { DO_stmt(0xDD44); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD45); } else { DO_stmt(0xDD45); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x45);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x06);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x01);
break;
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) { DO_stmt_nn(0xED4B); } else { DO_stmt_nn(0x01); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x48);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x49);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4E00); } else { DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD4E); } else { DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4E00); } else { DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD4E); } else { DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4C); } else { DO_stmt(0xFD4C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4D); } else { DO_stmt(0xFD4D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4C); } else { DO_stmt(0xDD4C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4D); } else { DO_stmt(0xDD4D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x57);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x50);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x51);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x52);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x53);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x54);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5600); } else { DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD56); } else { DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5600); } else { DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD56); } else { DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD54); } else { DO_stmt(0xFD54); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD55); } else { DO_stmt(0xFD55); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD54); } else { DO_stmt(0xDD54); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD55); } else { DO_stmt(0xDD55); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x55);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x16);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x11);
break;
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) { DO_stmt_nn(0xED5B); } else { DO_stmt_nn(0x11); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x58);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x59);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5E00); } else { DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD5E); } else { DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5E00); } else { DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD5E); } else { DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5C); } else { DO_stmt(0xFD5C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5D); } else { DO_stmt(0xFD5D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5C); } else { DO_stmt(0xDD5C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5D); } else { DO_stmt(0xDD5D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x67);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x60);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x61);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x62);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x63);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x64);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6600); } else { DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD66); } else { DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6600); } else { DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD66); } else { DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x65);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x26);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xED);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x21);
break;
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) { DO_stmt_nn(0x2A); } else { DO_stmt_nn(0x21); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_I _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED47);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_BC _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x02);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_DE _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x12);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_DE _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xD9);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_MINUS _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x32);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_PLUS _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x77);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x70);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x71);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x72);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x73);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x74);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x75);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x36);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HLD _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x32);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HLI _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7700); } else { DO_stmt(0xFD7700); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7000); } else { DO_stmt(0xFD7000); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7100); } else { DO_stmt(0xFD7100); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7200); } else { DO_stmt(0xFD7200); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7300); } else { DO_stmt(0xFD7300); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7400); } else { DO_stmt(0xFD7400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7500); } else { DO_stmt(0xFD7500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xDD3600); } else { DO_stmt_n(0xFD3600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD77); } else { DO_stmt_idx(0xFD77); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD70); } else { DO_stmt_idx(0xFD70); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD71); } else { DO_stmt_idx(0xFD71); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD72); } else { DO_stmt_idx(0xFD72); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD73); } else { DO_stmt_idx(0xFD73); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD74); } else { DO_stmt_idx(0xFD74); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD75); } else { DO_stmt_idx(0xFD75); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx_n(0xDD36); } else { DO_stmt_idx_n(0xFD36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7700); } else { DO_stmt(0xDD7700); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7000); } else { DO_stmt(0xDD7000); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7100); } else { DO_stmt(0xDD7100); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7200); } else { DO_stmt(0xDD7200); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7300); } else { DO_stmt(0xDD7300); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7400); } else { DO_stmt(0xDD7400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7500); } else { DO_stmt(0xDD7500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xFD3600); } else { DO_stmt_n(0xDD3600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD77); } else { DO_stmt_idx(0xDD77); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD70); } else { DO_stmt_idx(0xDD70); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD71); } else { DO_stmt_idx(0xDD71); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD72); } else { DO_stmt_idx(0xDD72); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD73); } else { DO_stmt_idx(0xDD73); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD74); } else { DO_stmt_idx(0xDD74); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD75); } else { DO_stmt_idx(0xDD75); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx_n(0xFD36); } else { DO_stmt_idx_n(0xDD36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IX _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) { if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD2A); } else { DO_stmt_nn(0xFD2A); } } else { if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD21); } else { DO_stmt_nn(0xFD21); } }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD67); } else { DO_stmt(0xFD67); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD60); } else { DO_stmt(0xFD60); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD61); } else { DO_stmt(0xFD61); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD62); } else { DO_stmt(0xFD62); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD63); } else { DO_stmt(0xFD63); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD64); } else { DO_stmt(0xFD64); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD65); } else { DO_stmt(0xFD65); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xDD26); } else { DO_stmt_n(0xFD26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6F); } else { DO_stmt(0xFD6F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD68); } else { DO_stmt(0xFD68); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD69); } else { DO_stmt(0xFD69); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6A); } else { DO_stmt(0xFD6A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6B); } else { DO_stmt(0xFD6B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6C); } else { DO_stmt(0xFD6C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6D); } else { DO_stmt(0xFD6D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xDD2E); } else { DO_stmt_n(0xFD2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IY _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) { if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD2A); } else { DO_stmt_nn(0xDD2A); } } else { if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD21); } else { DO_stmt_nn(0xDD21); } }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD67); } else { DO_stmt(0xDD67); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD60); } else { DO_stmt(0xDD60); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD61); } else { DO_stmt(0xDD61); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD62); } else { DO_stmt(0xDD62); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD63); } else { DO_stmt(0xDD63); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD64); } else { DO_stmt(0xDD64); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD65); } else { DO_stmt(0xDD65); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xFD26); } else { DO_stmt_n(0xDD26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6F); } else { DO_stmt(0xDD6F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD68); } else { DO_stmt(0xDD68); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD69); } else { DO_stmt(0xDD69); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6A); } else { DO_stmt(0xDD6A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6B); } else { DO_stmt(0xDD6B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6C); } else { DO_stmt(0xDD6C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6D); } else { DO_stmt(0xDD6D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xFD2E); } else { DO_stmt_n(0xDD2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x68);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x69);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6E00); } else { DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD6E); } else { DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6E00); } else { DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD6E); } else { DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_R _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED4F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_SP _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF9);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_SP _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDF9); } else { DO_stmt(0xFDF9); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_SP _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDF9); } else { DO_stmt(0xDDF9); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x31);
break;
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) { DO_stmt_nn(0xED7B); } else { DO_stmt_nn(0x31); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
DO_stmt_nn(0x32);
break;
case CPU_GBZ80: 
if (!expr_in_parens) return false;
DO_stmt_nn(0xEA);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
DO_stmt_nn(0xED43);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
DO_stmt_nn(0xED53);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
DO_stmt_nn(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD22); } else { DO_stmt_nn(0xFD22); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD22); } else { DO_stmt_nn(0xDD22); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
if (!expr_in_parens) return false;
DO_stmt_nn(0x08);
break;
case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
DO_stmt_nn(0xED73);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x3A);
break;
case CPU_GBZ80: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFA);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDAX _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDAX _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDAX _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDAX _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x32);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__ldd");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__lddr");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDB8);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDI _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDI _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__ldi");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__ldir");
break;
case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_LHLD expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LHLDE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xED);
break;
default: error_illegal_ident(); }
}

| label? _TK_LHLX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xED);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_B _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x01);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x01);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_D _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x11);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x11);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_H _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x21);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x21);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x31);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7F);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x78);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x79);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7A);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7B);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7D);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x47);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x40);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x41);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x42);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x43);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x44);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x45);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4F);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x48);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x49);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4A);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4D);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x57);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x50);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x51);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x52);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x53);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x54);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x55);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x58);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x59);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5A);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5D);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x67);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x60);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x61);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x62);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x63);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x64);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x65);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6F);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x68);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x69);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6A);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6B);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6D);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x77);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x70);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x71);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x72);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x73);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x74);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x75);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x3E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_B _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x06);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_C _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_D _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x16);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_E _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_H _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x26);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_L _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_M _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x36);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_AF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xC1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xC1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xD1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xD1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDE1); } else { DO_stmt(0xFDE1); }
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE1); } else { DO_stmt(0xDDE1); }
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_PSW _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF1);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_AF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xC5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xC5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xD5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xD5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDE5); } else { DO_stmt(0xFDE5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE5); } else { DO_stmt(0xDDE5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_PSW _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF5);
break;
default: error_illegal_ident(); }
}

| label? _TK_SHLD expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_SHLDE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xD9);
break;
default: error_illegal_ident(); }
}

| label? _TK_SHLX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xD9);
break;
default: error_illegal_ident(); }
}

| label? _TK_SPHL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF9);
break;
default: error_illegal_ident(); }
}

| label? _TK_STA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x32);
break;
case CPU_GBZ80: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEA);
break;
default: error_illegal_ident(); }
}

| label? _TK_STAX _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x02);
break;
default: error_illegal_ident(); }
}

| label? _TK_STAX _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x02);
break;
default: error_illegal_ident(); }
}

| label? _TK_STAX _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x12);
break;
default: error_illegal_ident(); }
}

| label? _TK_STAX _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_GBZ80: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x12);
break;
default: error_illegal_ident(); }
}

| label? _TK_XCHG _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_GBZ80: 
DO_stmt(0xE5);
DO_stmt(0xD5);
DO_stmt(0xE1);
DO_stmt(0xD1);
break;
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEB);
break;
default: error_illegal_ident(); }
}

| label? _TK_XTHL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE3);
break;
default: error_illegal_ident(); }
}


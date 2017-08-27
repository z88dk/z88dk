| label? _TK_ADC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x8F);
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x88);
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x89);
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x8A);
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x8B);
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x8C);
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x8E);
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8C); } else { DO_stmt(0xFD8C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8D); } else { DO_stmt(0xFD8D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8C); } else { DO_stmt(0xDD8C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8D); } else { DO_stmt(0xDD8D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x8D);
}

| label? _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xCE);
}

| label? _TK_ADC _TK_A _TK_NEWLINE @{
DO_stmt(0x8F);
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x88);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x89);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xCE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_B _TK_NEWLINE @{
DO_stmt(0x88);
}

| label? _TK_ADC _TK_C _TK_NEWLINE @{
DO_stmt(0x89);
}

| label? _TK_ADC _TK_D _TK_NEWLINE @{
DO_stmt(0x8A);
}

| label? _TK_ADC _TK_E _TK_NEWLINE @{
DO_stmt(0x8B);
}

| label? _TK_ADC _TK_H _TK_NEWLINE @{
DO_stmt(0x8C);
}

| label? _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x8E);
}

| label? _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
}

| label? _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
}

| label? _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
}

| label? _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
}

| label? _TK_ADC _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8C); } else { DO_stmt(0xFD8C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8D); } else { DO_stmt(0xFD8D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8C); } else { DO_stmt(0xDD8C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8D); } else { DO_stmt(0xDD8D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_L _TK_NEWLINE @{
DO_stmt(0x8D);
}

| label? _TK_ADC expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xCE);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x87);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x80);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x81);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x82);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x83);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x84);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x86);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD84); } else { DO_stmt(0xFD84); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD85); } else { DO_stmt(0xFD85); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD84); } else { DO_stmt(0xDD84); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD85); } else { DO_stmt(0xDD85); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x85);
}

| label? _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xC6);
}

| label? _TK_ADD _TK_A _TK_NEWLINE @{
DO_stmt(0x87);
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x87);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x80);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x81);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x82);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x83);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x84);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x85);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xC6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_B _TK_NEWLINE @{
DO_stmt(0x80);
}

| label? _TK_ADD _TK_C _TK_NEWLINE @{
DO_stmt(0x81);
}

| label? _TK_ADD _TK_D _TK_NEWLINE @{
DO_stmt(0x82);
}

| label? _TK_ADD _TK_E _TK_NEWLINE @{
DO_stmt(0x83);
}

| label? _TK_ADD _TK_H _TK_NEWLINE @{
DO_stmt(0x84);
}

| label? _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x86);
}

| label? _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
}

| label? _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
}

| label? _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
}

| label? _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
}

| label? _TK_ADD _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD84); } else { DO_stmt(0xFD84); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD85); } else { DO_stmt(0xFD85); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD84); } else { DO_stmt(0xDD84); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD85); } else { DO_stmt(0xDD85); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_L _TK_NEWLINE @{
DO_stmt(0x85);
}

| label? _TK_ADD expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xC6);
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x88);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x89);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xCE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x88);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x89);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xCE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x87);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x80);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x81);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x82);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x83);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x84);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x85);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xC6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x87);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x80);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x81);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x82);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x83);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x84);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x85);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xC6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA7);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA2);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA3);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA5);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xE6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA7);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA2);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA3);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA5);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xE6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CCF _TK_F _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CCF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBF);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB8);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB9);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBA);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBB);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBC);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBD);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xFE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBF);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB8);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB9);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBA);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBB);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBC);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBD);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xFE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CPL _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CPL _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x76);
DO_stmt(0x2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CPL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x05);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x15);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x25);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x04);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x14);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x24);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7E00); } else { DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD7E); } else { DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7E00); } else { DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD7E); } else { DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4600); } else { DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD46); } else { DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4600); } else { DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD46); } else { DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4E00); } else { DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD4E); } else { DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4E00); } else { DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD4E); } else { DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5600); } else { DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD56); } else { DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5600); } else { DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD56); } else { DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5E00); } else { DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD5E); } else { DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5E00); } else { DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD5E); } else { DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6600); } else { DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD66); } else { DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6600); } else { DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD66); } else { DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xE400); } else { DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xE4); } else { DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE400); } else { DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDE4); } else { DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6E00); } else { DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD6E); } else { DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6E00); } else { DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD6E); } else { DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7E00); } else { DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD7E); } else { DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7E00); } else { DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD7E); } else { DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4600); } else { DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD46); } else { DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4600); } else { DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD46); } else { DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4E00); } else { DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD4E); } else { DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4E00); } else { DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD4E); } else { DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5600); } else { DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD56); } else { DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5600); } else { DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD56); } else { DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5E00); } else { DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD5E); } else { DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5E00); } else { DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD5E); } else { DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6600); } else { DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD66); } else { DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6600); } else { DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD66); } else { DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xE400); } else { DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xE4); } else { DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE400); } else { DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDE4); } else { DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6E00); } else { DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD6E); } else { DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6E00); } else { DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD6E); } else { DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x78);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x79);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7E00); } else { DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD7E); } else { DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7E00); } else { DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD7E); } else { DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (expr_in_parens) { DO_stmt_nn(0x3A); } else { DO_stmt_n(0x3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x47);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x40);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x41);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x42);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x43);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x44);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4600); } else { DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD46); } else { DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4600); } else { DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD46); } else { DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x45);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x06);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_BC _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED49);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_BC _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED41);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (expr_in_parens) { DO_stmt_nn(0xED4B); } else { DO_stmt_nn(0x01); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x48);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x49);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4E00); } else { DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD4E); } else { DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4E00); } else { DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD4E); } else { DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x57);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x50);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x51);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x52);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x53);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x54);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5600); } else { DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD56); } else { DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5600); } else { DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD56); } else { DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x55);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x16);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_DE _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED59);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_DE _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED51);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (expr_in_parens) { DO_stmt_nn(0xED5B); } else { DO_stmt_nn(0x11); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x58);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x59);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5E00); } else { DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD5E); } else { DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5E00); } else { DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD5E); } else { DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x67);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x60);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x61);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x62);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x63);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x64);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6600); } else { DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD66); } else { DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6600); } else { DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD66); } else { DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x65);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x26);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED69);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED61);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xE400); } else { DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xE4); } else { DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE400); } else { DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDE4); } else { DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xC400);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt_n(0xC4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7C); } else { DO_stmt(0xFD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7C); } else { DO_stmt(0xDD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (expr_in_parens) { DO_stmt_nn(0x2A); } else { DO_stmt_nn(0x21); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x68);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x69);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6E00); } else { DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD6E); } else { DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6E00); } else { DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD6E); } else { DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_NEG _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED44);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_NEG _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED44);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB7);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB2);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB3);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB5);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xF6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB7);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB2);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB3);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB5);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xF6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_POP _TK_AF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xF1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_POP _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xC1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_POP _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_POP _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xE1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x98);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x99);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xDE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x98);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x99);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xDE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SCF _TK_F _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x37);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SCF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x37);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x97);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x90);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x91);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x92);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x93);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x94);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x95);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xD6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x97);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x90);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x91);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x92);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x93);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x94);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x95);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xD6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAF);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA9);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAA);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAB);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAC);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAD);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xEE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAF);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA9);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAA);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAB);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAC);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAD);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xEE);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0xA7);
}

| label? _TK_AND _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0xA0);
}

| label? _TK_AND _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0xA1);
}

| label? _TK_AND _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0xA2);
}

| label? _TK_AND _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0xA3);
}

| label? _TK_AND _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0xA4);
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xA6);
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA4); } else { DO_stmt(0xFDA4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA5); } else { DO_stmt(0xFDA5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA4); } else { DO_stmt(0xDDA4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA5); } else { DO_stmt(0xDDA5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0xA5);
}

| label? _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xE6);
}

| label? _TK_AND _TK_A _TK_NEWLINE @{
DO_stmt(0xA7);
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA7);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA1);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA2);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA3);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA4);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA5);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xE6);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_B _TK_NEWLINE @{
DO_stmt(0xA0);
}

| label? _TK_AND _TK_C _TK_NEWLINE @{
DO_stmt(0xA1);
}

| label? _TK_AND _TK_D _TK_NEWLINE @{
DO_stmt(0xA2);
}

| label? _TK_AND _TK_E _TK_NEWLINE @{
DO_stmt(0xA3);
}

| label? _TK_AND _TK_H _TK_NEWLINE @{
DO_stmt(0xA4);
}

| label? _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xA6);
}

| label? _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
}

| label? _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
}

| label? _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
}

| label? _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
}

| label? _TK_AND _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA4); } else { DO_stmt(0xFDA4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA5); } else { DO_stmt(0xFDA5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA4); } else { DO_stmt(0xDDA4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA5); } else { DO_stmt(0xDDA5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_L _TK_NEWLINE @{
DO_stmt(0xA5);
}

| label? _TK_AND expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xE6);
}

| label? _TK_CCF _TK_F _TK_NEWLINE @{
DO_stmt(0x3F);
}

| label? _TK_CCF _TK_F1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3F);
break;
default: error_illegal_ident(); }
}

| label? _TK_CCF _TK_NEWLINE @{
DO_stmt(0x3F);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0xBF);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0xB8);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0xB9);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0xBA);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0xBB);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0xBC);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xBE);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBC); } else { DO_stmt(0xFDBC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBD); } else { DO_stmt(0xFDBD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBC); } else { DO_stmt(0xDDBC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBD); } else { DO_stmt(0xDDBD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0xBD);
}

| label? _TK_CP _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xFE);
}

| label? _TK_CP _TK_A _TK_NEWLINE @{
DO_stmt(0xBF);
}

| label? _TK_CP _TK_B _TK_NEWLINE @{
DO_stmt(0xB8);
}

| label? _TK_CP _TK_C _TK_NEWLINE @{
DO_stmt(0xB9);
}

| label? _TK_CP _TK_D _TK_NEWLINE @{
DO_stmt(0xBA);
}

| label? _TK_CP _TK_E _TK_NEWLINE @{
DO_stmt(0xBB);
}

| label? _TK_CP _TK_H _TK_NEWLINE @{
DO_stmt(0xBC);
}

| label? _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xBE);
}

| label? _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
}

| label? _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
}

| label? _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
}

| label? _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
}

| label? _TK_CP _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBC); } else { DO_stmt(0xFDBC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBD); } else { DO_stmt(0xFDBD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBC); } else { DO_stmt(0xDDBC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBD); } else { DO_stmt(0xDDBD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_L _TK_NEWLINE @{
DO_stmt(0xBD);
}

| label? _TK_CP expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xFE);
}

| label? _TK_CPL _TK_A _TK_NEWLINE @{
DO_stmt(0x2F);
}

| label? _TK_CPL _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPL _TK_NEWLINE @{
DO_stmt(0x2F);
}

| label? _TK_DAA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80_ZXN: 
DO_stmt(0x27);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_A _TK_NEWLINE @{
DO_stmt(0x3D);
}

| label? _TK_DEC _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_B _TK_NEWLINE @{
DO_stmt(0x05);
}

| label? _TK_DEC _TK_B1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x05);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_C _TK_NEWLINE @{
DO_stmt(0x0D);
}

| label? _TK_DEC _TK_C1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_D _TK_NEWLINE @{
DO_stmt(0x15);
}

| label? _TK_DEC _TK_D1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x15);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_E _TK_NEWLINE @{
DO_stmt(0x1D);
}

| label? _TK_DEC _TK_E1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_H _TK_NEWLINE @{
DO_stmt(0x25);
}

| label? _TK_DEC _TK_H1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x25);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x35);
}

| label? _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD3500); } else { DO_stmt(0xFD3500); }
}

| label? _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD35); } else { DO_stmt_idx(0xFD35); }
}

| label? _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD3500); } else { DO_stmt(0xDD3500); }
}

| label? _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD35); } else { DO_stmt_idx(0xDD35); }
}

| label? _TK_DEC _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD25); } else { DO_stmt(0xFD25); }
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD2D); } else { DO_stmt(0xFD2D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD25); } else { DO_stmt(0xDD25); }
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD2D); } else { DO_stmt(0xDD2D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_L _TK_NEWLINE @{
DO_stmt(0x2D);
}

| label? _TK_DEC _TK_L1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2D);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_A _TK_NEWLINE @{
DO_stmt(0x3C);
}

| label? _TK_INC _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_B _TK_NEWLINE @{
DO_stmt(0x04);
}

| label? _TK_INC _TK_B1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x04);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_C _TK_NEWLINE @{
DO_stmt(0x0C);
}

| label? _TK_INC _TK_C1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_D _TK_NEWLINE @{
DO_stmt(0x14);
}

| label? _TK_INC _TK_D1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x14);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_E _TK_NEWLINE @{
DO_stmt(0x1C);
}

| label? _TK_INC _TK_E1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_H _TK_NEWLINE @{
DO_stmt(0x24);
}

| label? _TK_INC _TK_H1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x24);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x34);
}

| label? _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD3400); } else { DO_stmt(0xFD3400); }
}

| label? _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD34); } else { DO_stmt_idx(0xFD34); }
}

| label? _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD3400); } else { DO_stmt(0xDD3400); }
}

| label? _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD34); } else { DO_stmt_idx(0xDD34); }
}

| label? _TK_INC _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD24); } else { DO_stmt(0xFD24); }
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD2C); } else { DO_stmt(0xFD2C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD24); } else { DO_stmt(0xDD24); }
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD2C); } else { DO_stmt(0xDD2C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_L _TK_NEWLINE @{
DO_stmt(0x2C);
}

| label? _TK_INC _TK_L1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7E00); } else { DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD7E); } else { DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7E00); } else { DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD7E); } else { DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4600); } else { DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD46); } else { DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4600); } else { DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD46); } else { DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4E00); } else { DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD4E); } else { DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4E00); } else { DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD4E); } else { DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5600); } else { DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD56); } else { DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5600); } else { DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD56); } else { DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5E00); } else { DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD5E); } else { DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5E00); } else { DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD5E); } else { DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6600); } else { DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD66); } else { DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6600); } else { DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD66); } else { DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xE400); } else { DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xE4); } else { DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE400); } else { DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDE4); } else { DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6E00); } else { DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD6E); } else { DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6E00); } else { DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD6E); } else { DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x35);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD3500); } else { DO_stmt(0xFD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD35); } else { DO_stmt_idx(0xFD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD3500); } else { DO_stmt(0xDD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD35); } else { DO_stmt_idx(0xDD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x34);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD3400); } else { DO_stmt(0xFD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD34); } else { DO_stmt_idx(0xFD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD3400); } else { DO_stmt(0xDD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD34); } else { DO_stmt_idx(0xDD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7E00); } else { DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD7E); } else { DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7E00); } else { DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD7E); } else { DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7E00); } else { DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD7E); } else { DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7E00); } else { DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD7E); } else { DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4600); } else { DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD46); } else { DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4600); } else { DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD46); } else { DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4600); } else { DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD46); } else { DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4600); } else { DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD46); } else { DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_BC1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4E00); } else { DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD4E); } else { DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4E00); } else { DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD4E); } else { DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4E00); } else { DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD4E); } else { DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4E00); } else { DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD4E); } else { DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5600); } else { DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD56); } else { DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5600); } else { DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD56); } else { DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5600); } else { DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD56); } else { DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5600); } else { DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD56); } else { DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_DE1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5E00); } else { DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD5E); } else { DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5E00); } else { DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD5E); } else { DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5E00); } else { DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD5E); } else { DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5E00); } else { DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD5E); } else { DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6600); } else { DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD66); } else { DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6600); } else { DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD66); } else { DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6600); } else { DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD66); } else { DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6600); } else { DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD66); } else { DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xE400); } else { DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xE4); } else { DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE400); } else { DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDE4); } else { DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xE400); } else { DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xE4); } else { DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE400); } else { DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDE4); } else { DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_BC _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x02);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_DE _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x12);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x77);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x70);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x71);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x72);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x73);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x74);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xDDF400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x75);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
DO_stmt_n(0x36);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt_idx(0xDDF4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7700); } else { DO_stmt(0xFD7700); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7000); } else { DO_stmt(0xFD7000); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7100); } else { DO_stmt(0xFD7100); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7200); } else { DO_stmt(0xFD7200); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7300); } else { DO_stmt(0xFD7300); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7400); } else { DO_stmt(0xFD7400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xF400); } else { DO_stmt(0xFDF400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7500); } else { DO_stmt(0xFD7500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_n(0xDD3600); } else { DO_stmt_n(0xFD3600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD77); } else { DO_stmt_idx(0xFD77); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD70); } else { DO_stmt_idx(0xFD70); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD71); } else { DO_stmt_idx(0xFD71); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD72); } else { DO_stmt_idx(0xFD72); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD73); } else { DO_stmt_idx(0xFD73); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD74); } else { DO_stmt_idx(0xFD74); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xF4); } else { DO_stmt_idx(0xFDF4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD75); } else { DO_stmt_idx(0xFD75); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx_n(0xDD36); } else { DO_stmt_idx_n(0xFD36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7700); } else { DO_stmt(0xDD7700); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7000); } else { DO_stmt(0xDD7000); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7100); } else { DO_stmt(0xDD7100); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7200); } else { DO_stmt(0xDD7200); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7300); } else { DO_stmt(0xDD7300); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7400); } else { DO_stmt(0xDD7400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDF400); } else { DO_stmt(0xF400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7500); } else { DO_stmt(0xDD7500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_n(0xFD3600); } else { DO_stmt_n(0xDD3600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD77); } else { DO_stmt_idx(0xDD77); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD70); } else { DO_stmt_idx(0xDD70); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD71); } else { DO_stmt_idx(0xDD71); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD72); } else { DO_stmt_idx(0xDD72); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD73); } else { DO_stmt_idx(0xDD73); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD74); } else { DO_stmt_idx(0xDD74); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDF4); } else { DO_stmt_idx(0xF4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD75); } else { DO_stmt_idx(0xDD75); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx_n(0xFD36); } else { DO_stmt_idx_n(0xDD36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IX _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD2A); } else { DO_stmt_nn(0xFD2A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IY _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD2A); } else { DO_stmt_nn(0xDD2A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6E00); } else { DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD6E); } else { DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6E00); } else { DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD6E); } else { DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6E00); } else { DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD6E); } else { DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6E00); } else { DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD6E); } else { DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt_nn(0xED7B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt_nn(0x32);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD expr _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt_nn(0xED43);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD expr _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt_nn(0xED53);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD expr _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt_nn(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD expr _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD22); } else { DO_stmt_nn(0xFD22); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD expr _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD22); } else { DO_stmt_nn(0xDD22); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD expr _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xDB);
DO_stmt_nn(0xED73);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7E00); } else { DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD7E); } else { DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7E00); } else { DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD7E); } else { DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4600); } else { DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD46); } else { DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4600); } else { DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD46); } else { DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4E00); } else { DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD4E); } else { DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4E00); } else { DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD4E); } else { DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5600); } else { DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD56); } else { DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5600); } else { DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD56); } else { DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5E00); } else { DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD5E); } else { DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5E00); } else { DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD5E); } else { DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6600); } else { DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD66); } else { DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6600); } else { DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD66); } else { DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xE400); } else { DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xE4); } else { DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE400); } else { DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDE4); } else { DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6E00); } else { DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD6E); } else { DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6E00); } else { DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD6E); } else { DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x35);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD3500); } else { DO_stmt(0xFD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD35); } else { DO_stmt_idx(0xFD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD3500); } else { DO_stmt(0xDD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD35); } else { DO_stmt_idx(0xDD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x34);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD3400); } else { DO_stmt(0xFD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD34); } else { DO_stmt_idx(0xFD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD3400); } else { DO_stmt(0xDD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD34); } else { DO_stmt_idx(0xDD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7E00); } else { DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD7E); } else { DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7E00); } else { DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD7E); } else { DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7E00); } else { DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD7E); } else { DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7E00); } else { DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD7E); } else { DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4600); } else { DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD46); } else { DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4600); } else { DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD46); } else { DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4600); } else { DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD46); } else { DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4600); } else { DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD46); } else { DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_BC1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4E00); } else { DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD4E); } else { DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4E00); } else { DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD4E); } else { DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4E00); } else { DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD4E); } else { DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4E00); } else { DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD4E); } else { DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5600); } else { DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD56); } else { DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5600); } else { DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD56); } else { DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5600); } else { DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD56); } else { DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5600); } else { DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD56); } else { DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_DE1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5E00); } else { DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD5E); } else { DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5E00); } else { DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD5E); } else { DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5E00); } else { DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD5E); } else { DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5E00); } else { DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD5E); } else { DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6600); } else { DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD66); } else { DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6600); } else { DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD66); } else { DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6600); } else { DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD66); } else { DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6600); } else { DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD66); } else { DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xE400); } else { DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xE4); } else { DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE400); } else { DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDE4); } else { DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xE400); } else { DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xE4); } else { DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE400); } else { DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDE4); } else { DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_BC _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x02);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_DE _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x12);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x77);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x70);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x71);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x72);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x73);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x74);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xDDF400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x75);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
DO_stmt_n(0x36);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt_idx(0xDDF4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7700); } else { DO_stmt(0xFD7700); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7000); } else { DO_stmt(0xFD7000); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7100); } else { DO_stmt(0xFD7100); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7200); } else { DO_stmt(0xFD7200); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7300); } else { DO_stmt(0xFD7300); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7400); } else { DO_stmt(0xFD7400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xF400); } else { DO_stmt(0xFDF400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7500); } else { DO_stmt(0xFD7500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_n(0xDD3600); } else { DO_stmt_n(0xFD3600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD77); } else { DO_stmt_idx(0xFD77); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD70); } else { DO_stmt_idx(0xFD70); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD71); } else { DO_stmt_idx(0xFD71); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD72); } else { DO_stmt_idx(0xFD72); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD73); } else { DO_stmt_idx(0xFD73); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD74); } else { DO_stmt_idx(0xFD74); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xF4); } else { DO_stmt_idx(0xFDF4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD75); } else { DO_stmt_idx(0xFD75); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx_n(0xDD36); } else { DO_stmt_idx_n(0xFD36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7700); } else { DO_stmt(0xDD7700); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7000); } else { DO_stmt(0xDD7000); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7100); } else { DO_stmt(0xDD7100); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7200); } else { DO_stmt(0xDD7200); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7300); } else { DO_stmt(0xDD7300); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7400); } else { DO_stmt(0xDD7400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDF400); } else { DO_stmt(0xF400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7500); } else { DO_stmt(0xDD7500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_n(0xFD3600); } else { DO_stmt_n(0xDD3600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD77); } else { DO_stmt_idx(0xDD77); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD70); } else { DO_stmt_idx(0xDD70); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD71); } else { DO_stmt_idx(0xDD71); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD72); } else { DO_stmt_idx(0xDD72); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD73); } else { DO_stmt_idx(0xDD73); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD74); } else { DO_stmt_idx(0xDD74); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDF4); } else { DO_stmt_idx(0xF4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD75); } else { DO_stmt_idx(0xDD75); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx_n(0xFD36); } else { DO_stmt_idx_n(0xDD36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IX _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD2A); } else { DO_stmt_nn(0xFD2A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IY _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD2A); } else { DO_stmt_nn(0xDD2A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6E00); } else { DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD6E); } else { DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6E00); } else { DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD6E); } else { DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6E00); } else { DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD6E); } else { DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6E00); } else { DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD6E); } else { DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt_nn(0xED7B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt_nn(0x32);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD expr _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt_nn(0xED43);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD expr _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt_nn(0xED53);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD expr _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt_nn(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD expr _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD22); } else { DO_stmt_nn(0xFD22); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD expr _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD22); } else { DO_stmt_nn(0xDD22); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD expr _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt(0xD3);
DO_stmt_nn(0xED73);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x7F);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x78);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x79);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x7A);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x7B);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x7C);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x0A);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x1A);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x7E);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7E00); } else { DO_stmt(0xFD7E00); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD7E); } else { DO_stmt_idx(0xFD7E); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7E00); } else { DO_stmt(0xDD7E00); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD7E); } else { DO_stmt_idx(0xDD7E); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7C); } else { DO_stmt(0xFD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7D); } else { DO_stmt(0xFD7D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7C); } else { DO_stmt(0xDD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7D); } else { DO_stmt(0xDD7D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x7D);
}

| label? _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) { DO_stmt_nn(0x3A); } else { DO_stmt_n(0x3E); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x78);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x79);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7E00); } else { DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD7E); } else { DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7E00); } else { DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD7E); } else { DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (expr_in_parens) { DO_stmt_nn(0x3A); } else { DO_stmt_n(0x3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x47);
}

| label? _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x40);
}

| label? _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x41);
}

| label? _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x42);
}

| label? _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x43);
}

| label? _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x44);
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x46);
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD4600); } else { DO_stmt(0xFD4600); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD46); } else { DO_stmt_idx(0xFD46); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD4600); } else { DO_stmt(0xDD4600); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD46); } else { DO_stmt_idx(0xDD46); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD44); } else { DO_stmt(0xFD44); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD45); } else { DO_stmt(0xFD45); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD44); } else { DO_stmt(0xDD44); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD45); } else { DO_stmt(0xDD45); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x45);
}

| label? _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x06);
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x47);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x40);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x41);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x42);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x43);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x44);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4600); } else { DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD46); } else { DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4600); } else { DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD46); } else { DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x45);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x06);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) { DO_stmt_nn(0xED4B); } else { DO_stmt_nn(0x01); }
}

| label? _TK_LD _TK_BC1 _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED49);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_BC1 _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED41);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_BC1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (expr_in_parens) { DO_stmt_nn(0xED4B); } else { DO_stmt_nn(0x01); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x4F);
}

| label? _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x48);
}

| label? _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x49);
}

| label? _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x4A);
}

| label? _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x4B);
}

| label? _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x4C);
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x4E);
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD4E00); } else { DO_stmt(0xFD4E00); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD4E); } else { DO_stmt_idx(0xFD4E); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD4E00); } else { DO_stmt(0xDD4E00); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD4E); } else { DO_stmt_idx(0xDD4E); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4C); } else { DO_stmt(0xFD4C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4D); } else { DO_stmt(0xFD4D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4C); } else { DO_stmt(0xDD4C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4D); } else { DO_stmt(0xDD4D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x4D);
}

| label? _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x0E);
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x48);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x49);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4E00); } else { DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD4E); } else { DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4E00); } else { DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD4E); } else { DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x57);
}

| label? _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x50);
}

| label? _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x51);
}

| label? _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x52);
}

| label? _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x53);
}

| label? _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x54);
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x56);
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD5600); } else { DO_stmt(0xFD5600); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD56); } else { DO_stmt_idx(0xFD56); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD5600); } else { DO_stmt(0xDD5600); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD56); } else { DO_stmt_idx(0xDD56); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD54); } else { DO_stmt(0xFD54); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD55); } else { DO_stmt(0xFD55); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD54); } else { DO_stmt(0xDD54); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD55); } else { DO_stmt(0xDD55); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x55);
}

| label? _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x16);
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x57);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x50);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x51);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x52);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x53);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x54);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5600); } else { DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD56); } else { DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5600); } else { DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD56); } else { DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x55);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x16);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) { DO_stmt_nn(0xED5B); } else { DO_stmt_nn(0x11); }
}

| label? _TK_LD _TK_DE1 _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED59);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE1 _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED51);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (expr_in_parens) { DO_stmt_nn(0xED5B); } else { DO_stmt_nn(0x11); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x5F);
}

| label? _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x58);
}

| label? _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x59);
}

| label? _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x5A);
}

| label? _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x5B);
}

| label? _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x5C);
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x5E);
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD5E00); } else { DO_stmt(0xFD5E00); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD5E); } else { DO_stmt_idx(0xFD5E); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD5E00); } else { DO_stmt(0xDD5E00); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD5E); } else { DO_stmt_idx(0xDD5E); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5C); } else { DO_stmt(0xFD5C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5D); } else { DO_stmt(0xFD5D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5C); } else { DO_stmt(0xDD5C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5D); } else { DO_stmt(0xDD5D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x5D);
}

| label? _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x1E);
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x58);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x59);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5E00); } else { DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD5E); } else { DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5E00); } else { DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD5E); } else { DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x67);
}

| label? _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x60);
}

| label? _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x61);
}

| label? _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x62);
}

| label? _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x63);
}

| label? _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x64);
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x66);
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD6600); } else { DO_stmt(0xFD6600); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD66); } else { DO_stmt_idx(0xFD66); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD6600); } else { DO_stmt(0xDD6600); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD66); } else { DO_stmt_idx(0xDD66); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x65);
}

| label? _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x26);
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x67);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x60);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x61);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x62);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x63);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x64);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6600); } else { DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD66); } else { DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6600); } else { DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD66); } else { DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x65);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x26);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xE400); } else { DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xE4); } else { DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE400); } else { DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDE4); } else { DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xC400);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt_n(0xC4);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7C); } else { DO_stmt(0xFD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7C); } else { DO_stmt(0xDD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) { DO_stmt_nn(0x2A); } else { DO_stmt_nn(0x21); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED69);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED61);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xE400); } else { DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xE4); } else { DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE400); } else { DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDE4); } else { DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xC400);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt_n(0xC4);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7C); } else { DO_stmt(0xFD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7C); } else { DO_stmt(0xDD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (expr_in_parens) { DO_stmt_nn(0x2A); } else { DO_stmt_nn(0x21); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_BC _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x02);
}

| label? _TK_LD _TK_IND_DE _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x12);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x77);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x70);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x71);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x72);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x73);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x74);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDDF400);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x75);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x36);
}

| label? _TK_LD _TK_IND_HL expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt_idx(0xDDF4);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7700); } else { DO_stmt(0xFD7700); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7000); } else { DO_stmt(0xFD7000); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7100); } else { DO_stmt(0xFD7100); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7200); } else { DO_stmt(0xFD7200); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7300); } else { DO_stmt(0xFD7300); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7400); } else { DO_stmt(0xFD7400); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xF400); } else { DO_stmt(0xFDF400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7500); } else { DO_stmt(0xFD7500); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xDD3600); } else { DO_stmt_n(0xFD3600); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD77); } else { DO_stmt_idx(0xFD77); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD70); } else { DO_stmt_idx(0xFD70); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD71); } else { DO_stmt_idx(0xFD71); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD72); } else { DO_stmt_idx(0xFD72); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD73); } else { DO_stmt_idx(0xFD73); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD74); } else { DO_stmt_idx(0xFD74); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xF4); } else { DO_stmt_idx(0xFDF4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD75); } else { DO_stmt_idx(0xFD75); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx_n(0xDD36); } else { DO_stmt_idx_n(0xFD36); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7700); } else { DO_stmt(0xDD7700); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7000); } else { DO_stmt(0xDD7000); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7100); } else { DO_stmt(0xDD7100); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7200); } else { DO_stmt(0xDD7200); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7300); } else { DO_stmt(0xDD7300); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7400); } else { DO_stmt(0xDD7400); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDF400); } else { DO_stmt(0xF400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7500); } else { DO_stmt(0xDD7500); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xFD3600); } else { DO_stmt_n(0xDD3600); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD77); } else { DO_stmt_idx(0xDD77); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD70); } else { DO_stmt_idx(0xDD70); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD71); } else { DO_stmt_idx(0xDD71); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD72); } else { DO_stmt_idx(0xDD72); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD73); } else { DO_stmt_idx(0xDD73); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD74); } else { DO_stmt_idx(0xDD74); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDF4); } else { DO_stmt_idx(0xF4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD75); } else { DO_stmt_idx(0xDD75); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx_n(0xFD36); } else { DO_stmt_idx_n(0xDD36); }
}

| label? _TK_LD _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD400);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDD400); } else { DO_stmt(0xFDD400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDD400); } else { DO_stmt(0xDDD400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_SP expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt_n(0xD4);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_SP expr _TK_RPAREN _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_n(0xDDD4); } else { DO_stmt_n(0xFDD4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_SP expr _TK_RPAREN _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_n(0xFDD4); } else { DO_stmt_n(0xDDD4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IX _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7D); } else { DO_stmt(0xFD7D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IX _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDC400); } else { DO_stmt(0xFDC400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IX _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_n(0xDDC4); } else { DO_stmt_n(0xFDC4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IX _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) { if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD2A); } else { DO_stmt_nn(0xFD2A); } } else { if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD21); } else { DO_stmt_nn(0xFD21); } }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD67); } else { DO_stmt(0xFD67); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD60); } else { DO_stmt(0xFD60); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD61); } else { DO_stmt(0xFD61); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD62); } else { DO_stmt(0xFD62); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD63); } else { DO_stmt(0xFD63); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD64); } else { DO_stmt(0xFD64); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD65); } else { DO_stmt(0xFD65); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xDD26); } else { DO_stmt_n(0xFD26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6F); } else { DO_stmt(0xFD6F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD68); } else { DO_stmt(0xFD68); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD69); } else { DO_stmt(0xFD69); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6A); } else { DO_stmt(0xFD6A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6B); } else { DO_stmt(0xFD6B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6C); } else { DO_stmt(0xFD6C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6D); } else { DO_stmt(0xFD6D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xDD2E); } else { DO_stmt_n(0xFD2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IY _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7D); } else { DO_stmt(0xDD7D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IY _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDC400); } else { DO_stmt(0xDDC400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IY _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_n(0xFDC4); } else { DO_stmt_n(0xDDC4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IY _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) { if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD2A); } else { DO_stmt_nn(0xDD2A); } } else { if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD21); } else { DO_stmt_nn(0xDD21); } }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD67); } else { DO_stmt(0xDD67); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD60); } else { DO_stmt(0xDD60); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD61); } else { DO_stmt(0xDD61); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD62); } else { DO_stmt(0xDD62); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD63); } else { DO_stmt(0xDD63); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD64); } else { DO_stmt(0xDD64); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD65); } else { DO_stmt(0xDD65); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xFD26); } else { DO_stmt_n(0xDD26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6F); } else { DO_stmt(0xDD6F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD68); } else { DO_stmt(0xDD68); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD69); } else { DO_stmt(0xDD69); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6A); } else { DO_stmt(0xDD6A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6B); } else { DO_stmt(0xDD6B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6C); } else { DO_stmt(0xDD6C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6D); } else { DO_stmt(0xDD6D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xFD2E); } else { DO_stmt_n(0xDD2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x6F);
}

| label? _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x68);
}

| label? _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x69);
}

| label? _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x6A);
}

| label? _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x6B);
}

| label? _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x6C);
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x6E);
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD6E00); } else { DO_stmt(0xFD6E00); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD6E); } else { DO_stmt_idx(0xFD6E); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD6E00); } else { DO_stmt(0xDD6E00); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD6E); } else { DO_stmt_idx(0xDD6E); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x6D);
}

| label? _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x2E);
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x68);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x69);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6E00); } else { DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD6E); } else { DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6E00); } else { DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD6E); } else { DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_SP _TK_COMMA _TK_HL _TK_NEWLINE @{
DO_stmt(0xF9);
}

| label? _TK_LD _TK_SP _TK_COMMA _TK_IX _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDF9); } else { DO_stmt(0xFDF9); }
}

| label? _TK_LD _TK_SP _TK_COMMA _TK_IY _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDF9); } else { DO_stmt(0xDDF9); }
}

| label? _TK_LD _TK_SP _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) { DO_stmt_nn(0xED7B); } else { DO_stmt_nn(0x31); }
}

| label? _TK_LD expr _TK_COMMA _TK_A _TK_NEWLINE @{
if (!expr_in_parens) return FALSE;
DO_stmt_nn(0x32);
}

| label? _TK_LD expr _TK_COMMA _TK_BC _TK_NEWLINE @{
if (!expr_in_parens) return FALSE;
DO_stmt_nn(0xED43);
}

| label? _TK_LD expr _TK_COMMA _TK_DE _TK_NEWLINE @{
if (!expr_in_parens) return FALSE;
DO_stmt_nn(0xED53);
}

| label? _TK_LD expr _TK_COMMA _TK_HL _TK_NEWLINE @{
if (!expr_in_parens) return FALSE;
DO_stmt_nn(0x22);
}

| label? _TK_LD expr _TK_COMMA _TK_IX _TK_NEWLINE @{
if (!expr_in_parens) return FALSE;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD22); } else { DO_stmt_nn(0xFD22); }
}

| label? _TK_LD expr _TK_COMMA _TK_IY _TK_NEWLINE @{
if (!expr_in_parens) return FALSE;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD22); } else { DO_stmt_nn(0xDD22); }
}

| label? _TK_LD expr _TK_COMMA _TK_SP _TK_NEWLINE @{
if (!expr_in_parens) return FALSE;
DO_stmt_nn(0xED73);
}

| label? _TK_LDP _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED6C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6C); } else { DO_stmt(0xFD6C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6C); } else { DO_stmt(0xDD6C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt_nn(0xED6D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED64);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD64); } else { DO_stmt(0xFD64); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD64); } else { DO_stmt(0xDD64); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_IX _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD6D); } else { DO_stmt_nn(0xFD6D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_IY _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD6D); } else { DO_stmt_nn(0xDD6D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP expr _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
DO_stmt_nn(0xED65);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP expr _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD65); } else { DO_stmt_nn(0xFD65); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP expr _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return FALSE;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD65); } else { DO_stmt_nn(0xDD65); }
break;
default: error_illegal_ident(); }
}

| label? _TK_NEG _TK_A _TK_NEWLINE @{
DO_stmt(0xED44);
}

| label? _TK_NEG _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED44);
break;
default: error_illegal_ident(); }
}

| label? _TK_NEG _TK_NEWLINE @{
DO_stmt(0xED44);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0xB7);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0xB0);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0xB1);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0xB2);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0xB3);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0xB4);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xB6);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB4); } else { DO_stmt(0xFDB4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB5); } else { DO_stmt(0xFDB5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB4); } else { DO_stmt(0xDDB4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB5); } else { DO_stmt(0xDDB5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0xB5);
}

| label? _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xF6);
}

| label? _TK_OR _TK_A _TK_NEWLINE @{
DO_stmt(0xB7);
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB7);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB1);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB2);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB4);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB5);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xF6);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_B _TK_NEWLINE @{
DO_stmt(0xB0);
}

| label? _TK_OR _TK_C _TK_NEWLINE @{
DO_stmt(0xB1);
}

| label? _TK_OR _TK_D _TK_NEWLINE @{
DO_stmt(0xB2);
}

| label? _TK_OR _TK_E _TK_NEWLINE @{
DO_stmt(0xB3);
}

| label? _TK_OR _TK_H _TK_NEWLINE @{
DO_stmt(0xB4);
}

| label? _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xB6);
}

| label? _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
}

| label? _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
}

| label? _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
}

| label? _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
}

| label? _TK_OR _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB4); } else { DO_stmt(0xFDB4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB5); } else { DO_stmt(0xFDB5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB4); } else { DO_stmt(0xDDB4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB5); } else { DO_stmt(0xDDB5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_L _TK_NEWLINE @{
DO_stmt(0xB5);
}

| label? _TK_OR expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xF6);
}

| label? _TK_POP _TK_AF _TK_NEWLINE @{
DO_stmt(0xF1);
}

| label? _TK_POP _TK_AF1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xF1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_BC _TK_NEWLINE @{
DO_stmt(0xC1);
}

| label? _TK_POP _TK_BC1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xC1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_DE _TK_NEWLINE @{
DO_stmt(0xD1);
}

| label? _TK_POP _TK_DE1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_HL _TK_NEWLINE @{
DO_stmt(0xE1);
}

| label? _TK_POP _TK_HL1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xE1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_IP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_IX _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDE1); } else { DO_stmt(0xFDE1); }
}

| label? _TK_POP _TK_IY _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDE1); } else { DO_stmt(0xDDE1); }
}

| label? _TK_POP _TK_SU _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xED6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_AF _TK_NEWLINE @{
DO_stmt(0xF5);
}

| label? _TK_PUSH _TK_BC _TK_NEWLINE @{
DO_stmt(0xC5);
}

| label? _TK_PUSH _TK_DE _TK_NEWLINE @{
DO_stmt(0xD5);
}

| label? _TK_PUSH _TK_HL _TK_NEWLINE @{
DO_stmt(0xE5);
}

| label? _TK_PUSH _TK_IP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED76);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_IX _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDE5); } else { DO_stmt(0xFDE5); }
}

| label? _TK_PUSH _TK_IY _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDE5); } else { DO_stmt(0xDDE5); }
}

| label? _TK_PUSH _TK_SU _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xED66);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_STMT_LABEL();
declare_extern_symbol("__z80asm__rld");
Expr *emul_func = parse_expr("__z80asm__rld");
add_opcode_nn(0xCD, emul_func);
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80_ZXN: 
DO_stmt(0xED6F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_STMT_LABEL();
declare_extern_symbol("__z80asm__rrd");
Expr *emul_func = parse_expr("__z80asm__rrd");
add_opcode_nn(0xCD, emul_func);
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80_ZXN: 
DO_stmt(0xED67);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x9F);
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x98);
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x99);
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x9A);
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x9B);
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x9C);
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x9E);
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9C); } else { DO_stmt(0xFD9C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9D); } else { DO_stmt(0xFD9D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9C); } else { DO_stmt(0xDD9C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9D); } else { DO_stmt(0xDD9D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x9D);
}

| label? _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xDE);
}

| label? _TK_SBC _TK_A _TK_NEWLINE @{
DO_stmt(0x9F);
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9F);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x98);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x99);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9A);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9B);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9C);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9D);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xDE);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_B _TK_NEWLINE @{
DO_stmt(0x98);
}

| label? _TK_SBC _TK_C _TK_NEWLINE @{
DO_stmt(0x99);
}

| label? _TK_SBC _TK_D _TK_NEWLINE @{
DO_stmt(0x9A);
}

| label? _TK_SBC _TK_E _TK_NEWLINE @{
DO_stmt(0x9B);
}

| label? _TK_SBC _TK_H _TK_NEWLINE @{
DO_stmt(0x9C);
}

| label? _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x9E);
}

| label? _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
}

| label? _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
}

| label? _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
}

| label? _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
}

| label? _TK_SBC _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9C); } else { DO_stmt(0xFD9C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9D); } else { DO_stmt(0xFD9D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9C); } else { DO_stmt(0xDD9C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9D); } else { DO_stmt(0xDD9D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_L _TK_NEWLINE @{
DO_stmt(0x9D);
}

| label? _TK_SBC expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xDE);
}

| label? _TK_SCF _TK_F _TK_NEWLINE @{
DO_stmt(0x37);
}

| label? _TK_SCF _TK_F1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x37);
break;
default: error_illegal_ident(); }
}

| label? _TK_SCF _TK_NEWLINE @{
DO_stmt(0x37);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x97);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x90);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x91);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x92);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x93);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x94);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x96);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD94); } else { DO_stmt(0xFD94); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD95); } else { DO_stmt(0xFD95); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD94); } else { DO_stmt(0xDD94); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD95); } else { DO_stmt(0xDD95); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x95);
}

| label? _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xD6);
}

| label? _TK_SUB _TK_A _TK_NEWLINE @{
DO_stmt(0x97);
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x97);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x90);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x91);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x92);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x93);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x94);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x95);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xD6);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_B _TK_NEWLINE @{
DO_stmt(0x90);
}

| label? _TK_SUB _TK_C _TK_NEWLINE @{
DO_stmt(0x91);
}

| label? _TK_SUB _TK_D _TK_NEWLINE @{
DO_stmt(0x92);
}

| label? _TK_SUB _TK_E _TK_NEWLINE @{
DO_stmt(0x93);
}

| label? _TK_SUB _TK_H _TK_NEWLINE @{
DO_stmt(0x94);
}

| label? _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x96);
}

| label? _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
}

| label? _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
}

| label? _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
}

| label? _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
}

| label? _TK_SUB _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD94); } else { DO_stmt(0xFD94); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD95); } else { DO_stmt(0xFD95); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD94); } else { DO_stmt(0xDD94); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD95); } else { DO_stmt(0xDD95); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_L _TK_NEWLINE @{
DO_stmt(0x95);
}

| label? _TK_SUB expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xD6);
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED04);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED14);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED24);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED34);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDED0034); } else { DO_stmt(0xFDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDED34); } else { DO_stmt_idx(0xFDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDED0034); } else { DO_stmt(0xDDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDED34); } else { DO_stmt_idx(0xDDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80_ZXN: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED27);
break;
case CPU_Z180: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED64);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED04);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED14);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED24);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED34);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDED0034); } else { DO_stmt(0xFDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDED34); } else { DO_stmt_idx(0xFDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDED0034); } else { DO_stmt(0xDDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDED34); } else { DO_stmt_idx(0xDDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80_ZXN: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED27);
break;
case CPU_Z180: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED64);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED04);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED14);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED24);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED34);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDED0034); } else { DO_stmt(0xFDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDED34); } else { DO_stmt_idx(0xFDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDED0034); } else { DO_stmt(0xDDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDED34); } else { DO_stmt_idx(0xDDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80_ZXN: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED27);
break;
case CPU_Z180: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED64);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED04);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED14);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED24);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED34);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDED0034); } else { DO_stmt(0xFDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDED34); } else { DO_stmt_idx(0xFDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDED0034); } else { DO_stmt(0xDDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDED34); } else { DO_stmt_idx(0xDDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80_ZXN: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED27);
break;
case CPU_Z180: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED64);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0xAF);
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0xA8);
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0xA9);
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0xAA);
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0xAB);
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0xAC);
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xAE);
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAC); } else { DO_stmt(0xFDAC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAD); } else { DO_stmt(0xFDAD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAC); } else { DO_stmt(0xDDAC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAD); } else { DO_stmt(0xDDAD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0xAD);
}

| label? _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xEE);
}

| label? _TK_XOR _TK_A _TK_NEWLINE @{
DO_stmt(0xAF);
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAF);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA9);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAA);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAB);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAC);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76); 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAD);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xEE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_B _TK_NEWLINE @{
DO_stmt(0xA8);
}

| label? _TK_XOR _TK_C _TK_NEWLINE @{
DO_stmt(0xA9);
}

| label? _TK_XOR _TK_D _TK_NEWLINE @{
DO_stmt(0xAA);
}

| label? _TK_XOR _TK_E _TK_NEWLINE @{
DO_stmt(0xAB);
}

| label? _TK_XOR _TK_H _TK_NEWLINE @{
DO_stmt(0xAC);
}

| label? _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xAE);
}

| label? _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
}

| label? _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
}

| label? _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
}

| label? _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
}

| label? _TK_XOR _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAC); } else { DO_stmt(0xFDAC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAD); } else { DO_stmt(0xFDAD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAC); } else { DO_stmt(0xDDAC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80_ZXN: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAD); } else { DO_stmt(0xDDAD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_L _TK_NEWLINE @{
DO_stmt(0xAD);
}

| label? _TK_XOR expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xEE);
}


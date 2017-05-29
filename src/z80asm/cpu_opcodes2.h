| label? 
 _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{ 
  DO_stmt(0x40); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x40); 
 }

| label? 
 _TK_LD _TK_B1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x40); 
 }

| label? 
 _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{ 
  DO_stmt(0x41); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x41); 
 }

| label? 
 _TK_LD _TK_B1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x41); 
 }

| label? 
 _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{ 
  DO_stmt(0x42); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x42); 
 }

| label? 
 _TK_LD _TK_B1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x42); 
 }

| label? 
 _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{ 
  DO_stmt(0x43); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x43); 
 }

| label? 
 _TK_LD _TK_B1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x43); 
 }

| label? 
 _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{ 
  DO_stmt(0x44); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x44); 
 }

| label? 
 _TK_LD _TK_B1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x44); 
 }

| label? 
 _TK_LD _TK_B _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x44); 
 }

| label? 
 _TK_LD _TK_B _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x44); 
 }

| label? 
 _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{ 
  DO_stmt(0x45); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x45); 
 }

| label? 
 _TK_LD _TK_B1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x45); 
 }

| label? 
 _TK_LD _TK_B _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x45); 
 }

| label? 
 _TK_LD _TK_B _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x45); 
 }

| label? 
 _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{ 
  DO_stmt(0x47); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x47); 
 }

| label? 
 _TK_LD _TK_B1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x47); 
 }

| label? 
 _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{ 
  DO_stmt(0x48); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x48); 
 }

| label? 
 _TK_LD _TK_C1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x48); 
 }

| label? 
 _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{ 
  DO_stmt(0x49); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x49); 
 }

| label? 
 _TK_LD _TK_C1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x49); 
 }

| label? 
 _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{ 
  DO_stmt(0x4A); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x4A); 
 }

| label? 
 _TK_LD _TK_C1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x4A); 
 }

| label? 
 _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{ 
  DO_stmt(0x4B); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x4B); 
 }

| label? 
 _TK_LD _TK_C1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x4B); 
 }

| label? 
 _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{ 
  DO_stmt(0x4C); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x4C); 
 }

| label? 
 _TK_LD _TK_C1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x4C); 
 }

| label? 
 _TK_LD _TK_C _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x4C); 
 }

| label? 
 _TK_LD _TK_C _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x4C); 
 }

| label? 
 _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{ 
  DO_stmt(0x4D); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x4D); 
 }

| label? 
 _TK_LD _TK_C1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x4D); 
 }

| label? 
 _TK_LD _TK_C _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x4D); 
 }

| label? 
 _TK_LD _TK_C _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x4D); 
 }

| label? 
 _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{ 
  DO_stmt(0x4F); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x4F); 
 }

| label? 
 _TK_LD _TK_C1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x4F); 
 }

| label? 
 _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{ 
  DO_stmt(0x50); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x50); 
 }

| label? 
 _TK_LD _TK_D1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x50); 
 }

| label? 
 _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{ 
  DO_stmt(0x51); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x51); 
 }

| label? 
 _TK_LD _TK_D1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x51); 
 }

| label? 
 _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{ 
  DO_stmt(0x52); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x52); 
 }

| label? 
 _TK_LD _TK_D1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x52); 
 }

| label? 
 _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{ 
  DO_stmt(0x53); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x53); 
 }

| label? 
 _TK_LD _TK_D1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x53); 
 }

| label? 
 _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{ 
  DO_stmt(0x54); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x54); 
 }

| label? 
 _TK_LD _TK_D1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x54); 
 }

| label? 
 _TK_LD _TK_D _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x54); 
 }

| label? 
 _TK_LD _TK_D _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x54); 
 }

| label? 
 _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{ 
  DO_stmt(0x55); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x55); 
 }

| label? 
 _TK_LD _TK_D1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x55); 
 }

| label? 
 _TK_LD _TK_D _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x55); 
 }

| label? 
 _TK_LD _TK_D _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x55); 
 }

| label? 
 _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{ 
  DO_stmt(0x57); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x57); 
 }

| label? 
 _TK_LD _TK_D1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x57); 
 }

| label? 
 _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{ 
  DO_stmt(0x58); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x58); 
 }

| label? 
 _TK_LD _TK_E1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x58); 
 }

| label? 
 _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{ 
  DO_stmt(0x59); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x59); 
 }

| label? 
 _TK_LD _TK_E1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x59); 
 }

| label? 
 _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{ 
  DO_stmt(0x5A); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x5A); 
 }

| label? 
 _TK_LD _TK_E1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x5A); 
 }

| label? 
 _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{ 
  DO_stmt(0x5B); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x5B); 
 }

| label? 
 _TK_LD _TK_E1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x5B); 
 }

| label? 
 _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{ 
  DO_stmt(0x5C); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x5C); 
 }

| label? 
 _TK_LD _TK_E1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x5C); 
 }

| label? 
 _TK_LD _TK_E _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x5C); 
 }

| label? 
 _TK_LD _TK_E _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x5C); 
 }

| label? 
 _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{ 
  DO_stmt(0x5D); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x5D); 
 }

| label? 
 _TK_LD _TK_E1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x5D); 
 }

| label? 
 _TK_LD _TK_E _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x5D); 
 }

| label? 
 _TK_LD _TK_E _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x5D); 
 }

| label? 
 _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{ 
  DO_stmt(0x5F); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x5F); 
 }

| label? 
 _TK_LD _TK_E1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x5F); 
 }

| label? 
 _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{ 
  DO_stmt(0x60); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x60); 
 }

| label? 
 _TK_LD _TK_H1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x60); 
 }

| label? 
 _TK_LD _TK_IXH _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x60); 
 }

| label? 
 _TK_LD _TK_IYH _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x60); 
 }

| label? 
 _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{ 
  DO_stmt(0x61); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x61); 
 }

| label? 
 _TK_LD _TK_H1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x61); 
 }

| label? 
 _TK_LD _TK_IXH _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x61); 
 }

| label? 
 _TK_LD _TK_IYH _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x61); 
 }

| label? 
 _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{ 
  DO_stmt(0x62); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x62); 
 }

| label? 
 _TK_LD _TK_H1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x62); 
 }

| label? 
 _TK_LD _TK_IXH _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x62); 
 }

| label? 
 _TK_LD _TK_IYH _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x62); 
 }

| label? 
 _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{ 
  DO_stmt(0x63); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x63); 
 }

| label? 
 _TK_LD _TK_H1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x63); 
 }

| label? 
 _TK_LD _TK_IXH _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x63); 
 }

| label? 
 _TK_LD _TK_IYH _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x63); 
 }

| label? 
 _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{ 
  DO_stmt(0x64); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x64); 
 }

| label? 
 _TK_LD _TK_H1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x64); 
 }

| label? 
 _TK_LD _TK_IXH _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x64); 
 }

| label? 
 _TK_LD _TK_IYH _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x64); 
 }

| label? 
 _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{ 
  DO_stmt(0x65); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x65); 
 }

| label? 
 _TK_LD _TK_H1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x65); 
 }

| label? 
 _TK_LD _TK_IXH _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x65); 
 }

| label? 
 _TK_LD _TK_IYH _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x65); 
 }

| label? 
 _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{ 
  DO_stmt(0x67); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x67); 
 }

| label? 
 _TK_LD _TK_H1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x67); 
 }

| label? 
 _TK_LD _TK_IXH _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x67); 
 }

| label? 
 _TK_LD _TK_IYH _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x67); 
 }

| label? 
 _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{ 
  DO_stmt(0x68); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x68); 
 }

| label? 
 _TK_LD _TK_L1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x68); 
 }

| label? 
 _TK_LD _TK_IXL _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x68); 
 }

| label? 
 _TK_LD _TK_IYL _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x68); 
 }

| label? 
 _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{ 
  DO_stmt(0x69); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x69); 
 }

| label? 
 _TK_LD _TK_L1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x69); 
 }

| label? 
 _TK_LD _TK_IXL _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x69); 
 }

| label? 
 _TK_LD _TK_IYL _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x69); 
 }

| label? 
 _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{ 
  DO_stmt(0x6A); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x6A); 
 }

| label? 
 _TK_LD _TK_L1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x6A); 
 }

| label? 
 _TK_LD _TK_IXL _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x6A); 
 }

| label? 
 _TK_LD _TK_IYL _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x6A); 
 }

| label? 
 _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{ 
  DO_stmt(0x6B); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x6B); 
 }

| label? 
 _TK_LD _TK_L1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x6B); 
 }

| label? 
 _TK_LD _TK_IXL _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x6B); 
 }

| label? 
 _TK_LD _TK_IYL _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x6B); 
 }

| label? 
 _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{ 
  DO_stmt(0x6C); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x6C); 
 }

| label? 
 _TK_LD _TK_L1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x6C); 
 }

| label? 
 _TK_LD _TK_IXL _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x6C); 
 }

| label? 
 _TK_LD _TK_IYL _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x6C); 
 }

| label? 
 _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{ 
  DO_stmt(0x6D); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x6D); 
 }

| label? 
 _TK_LD _TK_L1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x6D); 
 }

| label? 
 _TK_LD _TK_IXL _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x6D); 
 }

| label? 
 _TK_LD _TK_IYL _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x6D); 
 }

| label? 
 _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{ 
  DO_stmt(0x6F); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x6F); 
 }

| label? 
 _TK_LD _TK_L1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x6F); 
 }

| label? 
 _TK_LD _TK_IXL _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x6F); 
 }

| label? 
 _TK_LD _TK_IYL _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x6F); 
 }

| label? 
 _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ 
  DO_stmt(0x78); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x78); 
 }

| label? 
 _TK_LD _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x78); 
 }

| label? 
 _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ 
  DO_stmt(0x79); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x79); 
 }

| label? 
 _TK_LD _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x79); 
 }

| label? 
 _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ 
  DO_stmt(0x7A); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x7A); 
 }

| label? 
 _TK_LD _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x7A); 
 }

| label? 
 _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ 
  DO_stmt(0x7B); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x7B); 
 }

| label? 
 _TK_LD _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x7B); 
 }

| label? 
 _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ 
  DO_stmt(0x7C); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x7C); 
 }

| label? 
 _TK_LD _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x7C); 
 }

| label? 
 _TK_LD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x7C); 
 }

| label? 
 _TK_LD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x7C); 
 }

| label? 
 _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ 
  DO_stmt(0x7D); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x7D); 
 }

| label? 
 _TK_LD _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x7D); 
 }

| label? 
 _TK_LD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IX + 0x7D); 
 }

| label? 
 _TK_LD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(P_IY + 0x7D); 
 }

| label? 
 _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ 
  DO_stmt(0x7F); 
 }

| label? 
 _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x7F); 
 }

| label? 
 _TK_LD _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
 if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
 DO_stmt(0x76); DO_stmt(0x7F); 
 }


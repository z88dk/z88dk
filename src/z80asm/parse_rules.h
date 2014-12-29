




















static const int parser_start = 1;
static const int parser_first_final = 530;
static const int parser_error = 0;

static const int parser_en_main = 1;




static Bool _parse_statement( Bool compile_active )
{
    p = pe = eof = NULL;



    {
        cs = parser_start;
    }



    while ( eof == NULL || eof != pe )
    {
        read_token();



        {
            if ( p == pe )
                goto _test_eof;

            switch ( cs )
            {
            case 1:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 0:
                    goto st530;

                case 4:
                    goto tr2;

                case 12:
                    goto st530;

                case 87:
                    goto st3;

                case 88:
                    goto st48;

                case 89:
                    goto st103;

                case 90:
                    goto st140;

                case 91:
                    goto st175;

                case 92:
                    goto st176;

                case 93:
                    goto st213;

                case 94:
                    goto st214;

                case 95:
                    goto st215;

                case 96:
                    goto st216;

                case 97:
                    goto st217;

                case 98:
                    goto st218;

                case 99:
                    goto st219;

                case 100:
                    goto st220;

                case 101:
                    goto st223;

                case 102:
                    goto st224;

                case 103:
                    goto st237;

                case 104:
                    goto st238;

                case 105:
                    goto st239;

                case 106:
                    goto st242;

                case 107:
                    goto st268;

                case 108:
                    goto st269;

                case 109:
                    goto st270;

                case 110:
                    goto st271;

                case 111:
                    goto st272;

                case 112:
                    goto st312;

                case 113:
                    goto st331;

                case 114:
                    goto st332;

                case 115:
                    goto st333;

                case 116:
                    goto st334;

                case 117:
                    goto st335;

                case 118:
                    goto st336;

                case 119:
                    goto st337;

                case 120:
                    goto st374;

                case 121:
                    goto st375;

                case 122:
                    goto st376;

                case 123:
                    goto st377;

                case 124:
                    goto st378;

                case 125:
                    goto st385;

                case 126:
                    goto st392;

                case 127:
                    goto st401;

                case 128:
                    goto st402;

                case 129:
                    goto st403;

                case 130:
                    goto st404;

                case 131:
                    goto st405;

                case 132:
                    goto st406;

                case 133:
                    goto st407;

                case 134:
                    goto st408;

                case 135:
                    goto st409;

                case 136:
                    goto st412;

                case 137:
                    goto st455;

                case 138:
                    goto st456;

                case 139:
                    goto st493;
                }

                goto st0;
st0:
                cs = 0;
                goto _out;
tr56:

                {
                    if ( stmt_label )
                    {
                        if ( compile_active )
                        {
                            define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                        };

                        stmt_label = NULL;
                    };
                }
                goto st530;
tr74:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_n( ( Z80_ADC_n ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr77:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC( REG_C ) );
                    };
                }
                goto st530;
tr78:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC( REG_B ) );
                    };
                }
                goto st530;
tr79:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC( REG_D ) );
                    };
                }
                goto st530;
tr80:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC( REG_E ) );
                    };
                }
                goto st530;
tr81:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC( REG_H ) );
                    };
                }
                goto st530;
tr82:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC( REG_H ) + P_IX );
                    };
                }
                goto st530;
tr83:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC( REG_H ) + P_IY );
                    };
                }
                goto st530;
tr84:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC( REG_L ) );
                    };
                }
                goto st530;
tr85:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC( REG_L ) + P_IX );
                    };
                }
                goto st530;
tr86:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC( REG_L ) + P_IY );
                    };
                }
                goto st530;
tr87:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC( REG_A ) );
                    };
                }
                goto st530;
tr90:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC( REG_idx ) );
                    };
                }
                goto st530;
tr94:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_ADC( REG_idx ) + P_IX ) << 8 );
                    };
                }
                goto st530;
tr101:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_ADC( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr107:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_ADC( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr112:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_ADC( REG_idx ) + P_IY ) << 8 );
                    };
                }
                goto st530;
tr117:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_ADC( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr123:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_ADC( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr130:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC16( REG_BC ) + 0 );
                    };
                }
                goto st530;
tr131:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC16( REG_DE ) + 0 );
                    };
                }
                goto st530;
tr132:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC16( REG_HL ) + 0 );
                    };
                }
                goto st530;
tr133:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADC16( REG_SP ) + 0 );
                    };
                }
                goto st530;
tr153:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_n( ( Z80_ADD_n ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr156:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD( REG_C ) );
                    };
                }
                goto st530;
tr157:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD( REG_B ) );
                    };
                }
                goto st530;
tr158:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD( REG_D ) );
                    };
                }
                goto st530;
tr159:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD( REG_E ) );
                    };
                }
                goto st530;
tr160:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD( REG_H ) );
                    };
                }
                goto st530;
tr161:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD( REG_H ) + P_IX );
                    };
                }
                goto st530;
tr162:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD( REG_H ) + P_IY );
                    };
                }
                goto st530;
tr163:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD( REG_L ) );
                    };
                }
                goto st530;
tr164:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD( REG_L ) + P_IX );
                    };
                }
                goto st530;
tr165:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD( REG_L ) + P_IY );
                    };
                }
                goto st530;
tr166:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD( REG_A ) );
                    };
                }
                goto st530;
tr169:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD( REG_idx ) );
                    };
                }
                goto st530;
tr173:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_ADD( REG_idx ) + P_IX ) << 8 );
                    };
                }
                goto st530;
tr178:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_ADD( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr184:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_ADD( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr189:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_ADD( REG_idx ) + P_IY ) << 8 );
                    };
                }
                goto st530;
tr194:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_ADD( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr200:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_ADD( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr207:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD16( REG_BC ) + 0 );
                    };
                }
                goto st530;
tr208:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD16( REG_DE ) + 0 );
                    };
                }
                goto st530;
tr209:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD16( REG_HL ) + 0 );
                    };
                }
                goto st530;
tr210:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD16( REG_SP ) + 0 );
                    };
                }
                goto st530;
tr216:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD16( REG_BC ) + P_IX );
                    };
                }
                goto st530;
tr217:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD16( REG_DE ) + P_IX );
                    };
                }
                goto st530;
tr218:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD16( REG_IX ) + P_IX );
                    };
                }
                goto st530;
tr219:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD16( REG_SP ) + P_IX );
                    };
                }
                goto st530;
tr225:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD16( REG_BC ) + P_IY );
                    };
                }
                goto st530;
tr226:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD16( REG_DE ) + P_IY );
                    };
                }
                goto st530;
tr227:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD16( REG_IY ) + P_IY );
                    };
                }
                goto st530;
tr228:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_ADD16( REG_SP ) + P_IY );
                    };
                }
                goto st530;
tr245:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_n( ( Z80_AND_n ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr248:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_AND( REG_C ) );
                    };
                }
                goto st530;
tr249:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_AND( REG_B ) );
                    };
                }
                goto st530;
tr250:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_AND( REG_D ) );
                    };
                }
                goto st530;
tr251:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_AND( REG_E ) );
                    };
                }
                goto st530;
tr252:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_AND( REG_H ) );
                    };
                }
                goto st530;
tr253:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_AND( REG_H ) + P_IX );
                    };
                }
                goto st530;
tr254:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_AND( REG_H ) + P_IY );
                    };
                }
                goto st530;
tr255:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_AND( REG_L ) );
                    };
                }
                goto st530;
tr256:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_AND( REG_L ) + P_IX );
                    };
                }
                goto st530;
tr257:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_AND( REG_L ) + P_IY );
                    };
                }
                goto st530;
tr258:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_AND( REG_A ) );
                    };
                }
                goto st530;
tr261:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_AND( REG_idx ) );
                    };
                }
                goto st530;
tr265:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_AND( REG_idx ) + P_IX ) << 8 );
                    };
                }
                goto st530;
tr270:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_AND( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr276:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_AND( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr281:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_AND( REG_idx ) + P_IY ) << 8 );
                    };
                }
                goto st530;
tr286:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_AND( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr292:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_AND( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr304:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_nn( ( Z80_CALL ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr310:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    Expr *expr = pop_expr();

                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_call_flag( FLAG_NZ, expr );
                    }
                    else OBJ_DELETE( expr );
                }
                goto st530;
tr316:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    Expr *expr = pop_expr();

                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_call_flag( FLAG_Z, expr );
                    }
                    else OBJ_DELETE( expr );
                }
                goto st530;
tr322:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    Expr *expr = pop_expr();

                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_call_flag( FLAG_NC, expr );
                    }
                    else OBJ_DELETE( expr );
                }
                goto st530;
tr328:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    Expr *expr = pop_expr();

                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_call_flag( FLAG_C, expr );
                    }
                    else OBJ_DELETE( expr );
                }
                goto st530;
tr334:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    Expr *expr = pop_expr();

                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_call_flag( FLAG_PO, expr );
                    }
                    else OBJ_DELETE( expr );
                }
                goto st530;
tr340:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    Expr *expr = pop_expr();

                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_call_flag( FLAG_PE, expr );
                    }
                    else OBJ_DELETE( expr );
                }
                goto st530;
tr346:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    Expr *expr = pop_expr();

                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_call_flag( FLAG_P, expr );
                    }
                    else OBJ_DELETE( expr );
                }
                goto st530;
tr352:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    Expr *expr = pop_expr();

                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_call_flag( FLAG_M, expr );
                    }
                    else OBJ_DELETE( expr );
                }
                goto st530;
tr355:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_CCF );
                    };
                }
                goto st530;
tr372:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_n( ( Z80_CP_n ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr375:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_CP( REG_C ) );
                    };
                }
                goto st530;
tr376:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_CP( REG_B ) );
                    };
                }
                goto st530;
tr377:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_CP( REG_D ) );
                    };
                }
                goto st530;
tr378:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_CP( REG_E ) );
                    };
                }
                goto st530;
tr379:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_CP( REG_H ) );
                    };
                }
                goto st530;
tr380:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_CP( REG_H ) + P_IX );
                    };
                }
                goto st530;
tr381:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_CP( REG_H ) + P_IY );
                    };
                }
                goto st530;
tr382:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_CP( REG_L ) );
                    };
                }
                goto st530;
tr383:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_CP( REG_L ) + P_IX );
                    };
                }
                goto st530;
tr384:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_CP( REG_L ) + P_IY );
                    };
                }
                goto st530;
tr385:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_CP( REG_A ) );
                    };
                }
                goto st530;
tr388:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_CP( REG_idx ) );
                    };
                }
                goto st530;
tr392:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_CP( REG_idx ) + P_IX ) << 8 );
                    };
                }
                goto st530;
tr397:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_CP( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr403:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_CP( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr408:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_CP( REG_idx ) + P_IY ) << 8 );
                    };
                }
                goto st530;
tr413:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_CP( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr419:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_CP( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr421:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode_emul( Z80_CPD, "rcmx_cpd" );
                    }
                }
                goto st530;
tr422:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode_emul( Z80_CPDR, "rcmx_cpdr" );
                    }
                }
                goto st530;
tr423:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode_emul( Z80_CPI, "rcmx_cpi" );
                    }
                }
                goto st530;
tr424:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode_emul( Z80_CPIR, "rcmx_cpir" );
                    }
                }
                goto st530;
tr425:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_CPL );
                    };
                }
                goto st530;
tr426:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_DAA );
                    };
                }
                goto st530;
tr427:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_DI );
                    };
                }
                goto st530;
tr430:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_jr( ( Z80_DJNZ ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr433:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_EI );
                    };
                }
                goto st530;
tr439:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_EX_DE_HL ) );
                    };
                }
                goto st530;
tr443:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_EX_AF_AF ) );
                    };
                }
                goto st530;
tr444:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_EX_AF_AF ) );
                    };
                }
                goto st530;
tr449:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_EX_IND_SP_HL ) );
                    };
                }
                goto st530;
tr450:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_EX_IND_SP_idx + P_IX ) );
                    };
                }
                goto st530;
tr451:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_EX_IND_SP_idx + P_IY ) );
                    };
                }
                goto st530;
tr452:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_EXX );
                    };
                }
                goto st530;
tr453:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_HALT );
                    };
                }
                goto st530;
tr456:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    pop_eval_expr( &expr_value, &expr_error );
                }

                {
                    if ( !expr_error )
                    {
                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_IM( expr_value ) );
                        };
                    }
                }
                goto st530;
tr468:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_IN_REG_C( REG_C ) );
                    };
                }
                goto st530;
tr471:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_IN_REG_C( REG_B ) );
                    };
                }
                goto st530;
tr474:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_IN_REG_C( REG_D ) );
                    };
                }
                goto st530;
tr477:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_IN_REG_C( REG_E ) );
                    };
                }
                goto st530;
tr480:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_IN_REG_C( REG_H ) );
                    };
                }
                goto st530;
tr483:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_IN_REG_C( REG_L ) );
                    };
                }
                goto st530;
tr491:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_n( ( Z80_IN_A_n ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr493:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_IN_REG_C( REG_A ) );
                    };
                }
                goto st530;
tr494:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_IND );
                    };
                }
                goto st530;
tr495:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_INDR );
                    };
                }
                goto st530;
tr496:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_INI );
                    };
                }
                goto st530;
tr497:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_INIR );
                    };
                }
                goto st530;
tr511:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_nn( ( Z80_JP ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr517:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_nn( ( Z80_JP_FLAG( FLAG_NZ ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr523:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_nn( ( Z80_JP_FLAG( FLAG_Z ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr529:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_nn( ( Z80_JP_FLAG( FLAG_NC ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr535:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_nn( ( Z80_JP_FLAG( FLAG_C ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr541:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_nn( ( Z80_JP_FLAG( FLAG_PO ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr547:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_nn( ( Z80_JP_FLAG( FLAG_PE ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr553:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_nn( ( Z80_JP_FLAG( FLAG_P ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr559:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_nn( ( Z80_JP_FLAG( FLAG_M ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr562:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_JP_idx ) );
                    };
                }
                goto st530;
tr564:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_JP_idx + P_IX ) );
                    };
                }
                goto st530;
tr566:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_JP_idx + P_IY ) );
                    };
                }
                goto st530;
tr573:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_jr( ( Z80_JR ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr579:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_jr( ( Z80_JR_FLAG( FLAG_NZ ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr585:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_jr( ( Z80_JR_FLAG( FLAG_Z ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr591:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_jr( ( Z80_JR_FLAG( FLAG_NC ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr597:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_jr( ( Z80_JR_FLAG( FLAG_C ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr600:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_LDD );
                    };
                }
                goto st530;
tr601:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_LDDR );
                    };
                }
                goto st530;
tr602:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_LDI );
                    };
                }
                goto st530;
tr603:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_LDIR );
                    };
                }
                goto st530;
tr604:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_NEG );
                    };
                }
                goto st530;
tr605:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_NOP );
                    };
                }
                goto st530;
tr622:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_n( ( Z80_OR_n ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr625:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OR( REG_C ) );
                    };
                }
                goto st530;
tr626:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OR( REG_B ) );
                    };
                }
                goto st530;
tr627:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OR( REG_D ) );
                    };
                }
                goto st530;
tr628:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OR( REG_E ) );
                    };
                }
                goto st530;
tr629:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OR( REG_H ) );
                    };
                }
                goto st530;
tr630:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OR( REG_H ) + P_IX );
                    };
                }
                goto st530;
tr631:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OR( REG_H ) + P_IY );
                    };
                }
                goto st530;
tr632:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OR( REG_L ) );
                    };
                }
                goto st530;
tr633:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OR( REG_L ) + P_IX );
                    };
                }
                goto st530;
tr634:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OR( REG_L ) + P_IY );
                    };
                }
                goto st530;
tr635:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OR( REG_A ) );
                    };
                }
                goto st530;
tr638:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OR( REG_idx ) );
                    };
                }
                goto st530;
tr642:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_OR( REG_idx ) + P_IX ) << 8 );
                    };
                }
                goto st530;
tr647:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_OR( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr653:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_OR( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr658:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_OR( REG_idx ) + P_IY ) << 8 );
                    };
                }
                goto st530;
tr663:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_OR( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr669:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_OR( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr671:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OTDR );
                    };
                }
                goto st530;
tr672:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OTIR );
                    };
                }
                goto st530;
tr673:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OUTD );
                    };
                }
                goto st530;
tr674:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OUTI );
                    };
                }
                goto st530;
tr681:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_POP( REG_BC ) );
                    };
                }
                goto st530;
tr682:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_POP( REG_DE ) );
                    };
                }
                goto st530;
tr683:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_POP( REG_HL ) );
                    };
                }
                goto st530;
tr684:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_POP( REG_HL ) + P_IX );
                    };
                }
                goto st530;
tr685:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_POP( REG_HL ) + P_IY );
                    };
                }
                goto st530;
tr686:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_POP( REG_AF ) );
                    };
                }
                goto st530;
tr693:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_PUSH( REG_BC ) );
                    };
                }
                goto st530;
tr694:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_PUSH( REG_DE ) );
                    };
                }
                goto st530;
tr695:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_PUSH( REG_HL ) );
                    };
                }
                goto st530;
tr696:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_PUSH( REG_HL ) + P_IX );
                    };
                }
                goto st530;
tr697:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_PUSH( REG_HL ) + P_IY );
                    };
                }
                goto st530;
tr698:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_PUSH( REG_AF ) );
                    };
                }
                goto st530;
tr699:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RET );
                    };
                }
                goto st530;
tr708:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RET_FLAG( FLAG_NZ ) );
                    };
                }
                goto st530;
tr709:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RET_FLAG( FLAG_Z ) );
                    };
                }
                goto st530;
tr710:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RET_FLAG( FLAG_NC ) );
                    };
                }
                goto st530;
tr711:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RET_FLAG( FLAG_C ) );
                    };
                }
                goto st530;
tr712:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RET_FLAG( FLAG_PO ) );
                    };
                }
                goto st530;
tr713:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RET_FLAG( FLAG_PE ) );
                    };
                }
                goto st530;
tr714:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RET_FLAG( FLAG_P ) );
                    };
                }
                goto st530;
tr715:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RET_FLAG( FLAG_M ) );
                    };
                }
                goto st530;
tr716:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RETI );
                    };
                }
                goto st530;
tr717:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RETN );
                    };
                }
                goto st530;
tr718:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RLA );
                    };
                }
                goto st530;
tr719:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RLCA );
                    };
                }
                goto st530;
tr720:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode_emul( Z80_RLD, "rcmx_rld" );
                    }
                }
                goto st530;
tr721:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RRA );
                    };
                }
                goto st530;
tr722:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RRCA );
                    };
                }
                goto st530;
tr723:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode_emul( Z80_RRD, "rcmx_rrd" );
                    }
                }
                goto st530;
tr726:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    pop_eval_expr( &expr_value, &expr_error );
                }

                {
                    if ( !expr_error )
                    {
                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_RST( expr_value ) );
                        };
                    }
                }
                goto st530;
tr746:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_n( ( Z80_SBC_n ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr749:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC( REG_C ) );
                    };
                }
                goto st530;
tr750:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC( REG_B ) );
                    };
                }
                goto st530;
tr751:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC( REG_D ) );
                    };
                }
                goto st530;
tr752:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC( REG_E ) );
                    };
                }
                goto st530;
tr753:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC( REG_H ) );
                    };
                }
                goto st530;
tr754:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC( REG_H ) + P_IX );
                    };
                }
                goto st530;
tr755:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC( REG_H ) + P_IY );
                    };
                }
                goto st530;
tr756:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC( REG_L ) );
                    };
                }
                goto st530;
tr757:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC( REG_L ) + P_IX );
                    };
                }
                goto st530;
tr758:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC( REG_L ) + P_IY );
                    };
                }
                goto st530;
tr759:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC( REG_A ) );
                    };
                }
                goto st530;
tr762:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC( REG_idx ) );
                    };
                }
                goto st530;
tr766:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_SBC( REG_idx ) + P_IX ) << 8 );
                    };
                }
                goto st530;
tr771:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_SBC( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr777:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_SBC( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr782:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_SBC( REG_idx ) + P_IY ) << 8 );
                    };
                }
                goto st530;
tr787:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_SBC( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr793:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_SBC( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr800:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC16( REG_BC ) + 0 );
                    };
                }
                goto st530;
tr801:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC16( REG_DE ) + 0 );
                    };
                }
                goto st530;
tr802:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC16( REG_HL ) + 0 );
                    };
                }
                goto st530;
tr803:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SBC16( REG_SP ) + 0 );
                    };
                }
                goto st530;
tr804:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SCF );
                    };
                }
                goto st530;
tr821:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_n( ( Z80_SUB_n ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr824:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SUB( REG_C ) );
                    };
                }
                goto st530;
tr825:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SUB( REG_B ) );
                    };
                }
                goto st530;
tr826:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SUB( REG_D ) );
                    };
                }
                goto st530;
tr827:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SUB( REG_E ) );
                    };
                }
                goto st530;
tr828:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SUB( REG_H ) );
                    };
                }
                goto st530;
tr829:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SUB( REG_H ) + P_IX );
                    };
                }
                goto st530;
tr830:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SUB( REG_H ) + P_IY );
                    };
                }
                goto st530;
tr831:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SUB( REG_L ) );
                    };
                }
                goto st530;
tr832:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SUB( REG_L ) + P_IX );
                    };
                }
                goto st530;
tr833:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SUB( REG_L ) + P_IY );
                    };
                }
                goto st530;
tr834:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SUB( REG_A ) );
                    };
                }
                goto st530;
tr837:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SUB( REG_idx ) );
                    };
                }
                goto st530;
tr841:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_SUB( REG_idx ) + P_IX ) << 8 );
                    };
                }
                goto st530;
tr846:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_SUB( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr852:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_SUB( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr857:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_SUB( REG_idx ) + P_IY ) << 8 );
                    };
                }
                goto st530;
tr862:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_SUB( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr868:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_SUB( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr886:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_n( ( Z80_XOR_n ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr889:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_XOR( REG_C ) );
                    };
                }
                goto st530;
tr890:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_XOR( REG_B ) );
                    };
                }
                goto st530;
tr891:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_XOR( REG_D ) );
                    };
                }
                goto st530;
tr892:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_XOR( REG_E ) );
                    };
                }
                goto st530;
tr893:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_XOR( REG_H ) );
                    };
                }
                goto st530;
tr894:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_XOR( REG_H ) + P_IX );
                    };
                }
                goto st530;
tr895:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_XOR( REG_H ) + P_IY );
                    };
                }
                goto st530;
tr896:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_XOR( REG_L ) );
                    };
                }
                goto st530;
tr897:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_XOR( REG_L ) + P_IX );
                    };
                }
                goto st530;
tr898:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_XOR( REG_L ) + P_IY );
                    };
                }
                goto st530;
tr899:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_XOR( REG_A ) );
                    };
                }
                goto st530;
tr902:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_XOR( REG_idx ) );
                    };
                }
                goto st530;
tr906:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_XOR( REG_idx ) + P_IX ) << 8 );
                    };
                }
                goto st530;
tr911:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_XOR( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr917:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_XOR( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr922:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( Z80_XOR( REG_idx ) + P_IY ) << 8 );
                    };
                }
                goto st530;
tr927:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_XOR( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
tr933:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode_idx( ( Z80_XOR( REG_idx ) + P_IY ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st530;
st530:

                if ( ++p == pe )
                    goto _test_eof530;

            case 530:

                goto st0;
tr2:

                {
                    stmt_label = p->string;
                }
                goto st2;
st2:

                if ( ++p == pe )
                    goto _test_eof2;

            case 2:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr56;

                case 87:
                    goto st3;

                case 88:
                    goto st48;

                case 89:
                    goto st103;

                case 90:
                    goto st140;

                case 91:
                    goto st175;

                case 92:
                    goto st176;

                case 93:
                    goto st213;

                case 94:
                    goto st214;

                case 95:
                    goto st215;

                case 96:
                    goto st216;

                case 97:
                    goto st217;

                case 98:
                    goto st218;

                case 99:
                    goto st219;

                case 100:
                    goto st220;

                case 101:
                    goto st223;

                case 102:
                    goto st224;

                case 103:
                    goto st237;

                case 104:
                    goto st238;

                case 105:
                    goto st239;

                case 106:
                    goto st242;

                case 107:
                    goto st268;

                case 108:
                    goto st269;

                case 109:
                    goto st270;

                case 110:
                    goto st271;

                case 111:
                    goto st272;

                case 112:
                    goto st312;

                case 113:
                    goto st331;

                case 114:
                    goto st332;

                case 115:
                    goto st333;

                case 116:
                    goto st334;

                case 117:
                    goto st335;

                case 118:
                    goto st336;

                case 119:
                    goto st337;

                case 120:
                    goto st374;

                case 121:
                    goto st375;

                case 122:
                    goto st376;

                case 123:
                    goto st377;

                case 124:
                    goto st378;

                case 125:
                    goto st385;

                case 126:
                    goto st392;

                case 127:
                    goto st401;

                case 128:
                    goto st402;

                case 129:
                    goto st403;

                case 130:
                    goto st404;

                case 131:
                    goto st405;

                case 132:
                    goto st406;

                case 133:
                    goto st407;

                case 134:
                    goto st408;

                case 135:
                    goto st409;

                case 136:
                    goto st412;

                case 137:
                    goto st455;

                case 138:
                    goto st456;

                case 139:
                    goto st493;
                }

                goto st0;
st3:

                if ( ++p == pe )
                    goto _test_eof3;

            case 3:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr57;

                case 5:
                    goto tr57;

                case 8:
                    goto tr57;

                case 18:
                    goto tr58;

                case 21:
                    goto tr58;

                case 23:
                    goto tr58;

                case 36:
                    goto tr58;

                case 44:
                    goto tr58;

                case 48:
                    goto st6;

                case 53:
                    goto st7;

                case 54:
                    goto st8;

                case 55:
                    goto st9;

                case 56:
                    goto st10;

                case 57:
                    goto st11;

                case 58:
                    goto st12;

                case 59:
                    goto st13;

                case 60:
                    goto st14;

                case 61:
                    goto st15;

                case 62:
                    goto st16;

                case 71:
                    goto st42;

                case 79:
                    goto st19;

                case 80:
                    goto st20;

                case 81:
                    goto st32;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr58;

                goto st0;
tr57:

                {
                    expr_start = p;
                }
                goto st4;
st4:

                if ( ++p == pe )
                    goto _test_eof4;

            case 4:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr74;

                case 19:
                    goto st4;

                case 23:
                    goto st5;

                case 37:
                    goto st4;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st5;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st5;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st5;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st5;
                }
                else
                    goto st5;

                goto st0;
tr58:

                {
                    expr_start = p;
                }
                goto st5;
st5:

                if ( ++p == pe )
                    goto _test_eof5;

            case 5:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st4;

                case 5:
                    goto st4;

                case 8:
                    goto st4;

                case 13:
                    goto st5;

                case 18:
                    goto st5;

                case 21:
                    goto st5;

                case 23:
                    goto st5;

                case 36:
                    goto st5;

                case 44:
                    goto st5;
                }

                goto st0;
st6:

                if ( ++p == pe )
                    goto _test_eof6;

            case 6:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr77;

                goto st0;
st7:

                if ( ++p == pe )
                    goto _test_eof7;

            case 7:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr78;

                goto st0;
st8:

                if ( ++p == pe )
                    goto _test_eof8;

            case 8:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr79;

                goto st0;
st9:

                if ( ++p == pe )
                    goto _test_eof9;

            case 9:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr80;

                goto st0;
st10:

                if ( ++p == pe )
                    goto _test_eof10;

            case 10:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr81;

                goto st0;
st11:

                if ( ++p == pe )
                    goto _test_eof11;

            case 11:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr82;

                goto st0;
st12:

                if ( ++p == pe )
                    goto _test_eof12;

            case 12:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr83;

                goto st0;
st13:

                if ( ++p == pe )
                    goto _test_eof13;

            case 13:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr84;

                goto st0;
st14:

                if ( ++p == pe )
                    goto _test_eof14;

            case 14:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr85;

                goto st0;
st15:

                if ( ++p == pe )
                    goto _test_eof15;

            case 15:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr86;

                goto st0;
st16:

                if ( ++p == pe )
                    goto _test_eof16;

            case 16:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr87;

                case 22:
                    goto st17;
                }

                goto st0;
st17:

                if ( ++p == pe )
                    goto _test_eof17;

            case 17:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr57;

                case 5:
                    goto tr57;

                case 8:
                    goto tr57;

                case 18:
                    goto tr58;

                case 21:
                    goto tr58;

                case 23:
                    goto tr58;

                case 36:
                    goto tr58;

                case 44:
                    goto tr58;

                case 48:
                    goto st6;

                case 53:
                    goto st7;

                case 54:
                    goto st8;

                case 55:
                    goto st9;

                case 56:
                    goto st10;

                case 57:
                    goto st11;

                case 58:
                    goto st12;

                case 59:
                    goto st13;

                case 60:
                    goto st14;

                case 61:
                    goto st15;

                case 62:
                    goto st18;

                case 79:
                    goto st19;

                case 80:
                    goto st20;

                case 81:
                    goto st32;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr58;

                goto st0;
st18:

                if ( ++p == pe )
                    goto _test_eof18;

            case 18:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr87;

                goto st0;
st19:

                if ( ++p == pe )
                    goto _test_eof19;

            case 19:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr90;

                goto st0;
st20:

                if ( ++p == pe )
                    goto _test_eof20;

            case 20:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st21;

                case 21:
                    goto st22;

                case 23:
                    goto st28;
                }

                goto st0;
st21:

                if ( ++p == pe )
                    goto _test_eof21;

            case 21:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr94;

                goto st0;
st22:

                if ( ++p == pe )
                    goto _test_eof22;

            case 22:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr95;

                case 5:
                    goto tr95;

                case 8:
                    goto tr95;

                case 18:
                    goto tr96;

                case 21:
                    goto tr96;

                case 23:
                    goto tr96;

                case 36:
                    goto tr96;

                case 44:
                    goto tr96;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr96;

                goto st0;
tr95:

                {
                    expr_start = p;
                }
                goto st23;
st23:

                if ( ++p == pe )
                    goto _test_eof23;

            case 23:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr98;

                case 23:
                    goto st24;

                case 37:
                    goto st23;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
st24:

                if ( ++p == pe )
                    goto _test_eof24;

            case 24:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st25;

                case 5:
                    goto st25;

                case 8:
                    goto st25;

                case 13:
                    goto st24;

                case 18:
                    goto st24;

                case 21:
                    goto st24;

                case 23:
                    goto st24;

                case 36:
                    goto st24;

                case 44:
                    goto st24;
                }

                goto st0;
st25:

                if ( ++p == pe )
                    goto _test_eof25;

            case 25:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st25;

                case 23:
                    goto st24;

                case 37:
                    goto st25;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr98:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st26;
st26:

                if ( ++p == pe )
                    goto _test_eof26;

            case 26:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr101;

                case 19:
                    goto tr98;

                case 23:
                    goto st24;

                case 37:
                    goto st23;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr96:

                {
                    expr_start = p;
                }
                goto st27;
st27:

                if ( ++p == pe )
                    goto _test_eof27;

            case 27:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st23;

                case 5:
                    goto st23;

                case 8:
                    goto st23;

                case 13:
                    goto st27;

                case 18:
                    goto st27;

                case 21:
                    goto st27;

                case 23:
                    goto st27;

                case 36:
                    goto st27;

                case 44:
                    goto st27;
                }

                goto st0;
st28:

                if ( ++p == pe )
                    goto _test_eof28;

            case 28:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr103;

                case 5:
                    goto tr103;

                case 8:
                    goto tr103;

                case 18:
                    goto tr104;

                case 21:
                    goto tr104;

                case 23:
                    goto tr104;

                case 36:
                    goto tr104;

                case 44:
                    goto tr104;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr104;

                goto st0;
tr103:

                {
                    expr_start = p;
                }
                goto st29;
st29:

                if ( ++p == pe )
                    goto _test_eof29;

            case 29:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr105;

                case 23:
                    goto st24;

                case 37:
                    goto st29;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr105:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st30;
st30:

                if ( ++p == pe )
                    goto _test_eof30;

            case 30:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr107;

                case 19:
                    goto tr105;

                case 23:
                    goto st24;

                case 37:
                    goto st29;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr104:

                {
                    expr_start = p;
                }
                goto st31;
st31:

                if ( ++p == pe )
                    goto _test_eof31;

            case 31:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st29;

                case 5:
                    goto st29;

                case 8:
                    goto st29;

                case 13:
                    goto st31;

                case 18:
                    goto st31;

                case 21:
                    goto st31;

                case 23:
                    goto st31;

                case 36:
                    goto st31;

                case 44:
                    goto st31;
                }

                goto st0;
st32:

                if ( ++p == pe )
                    goto _test_eof32;

            case 32:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st33;

                case 21:
                    goto st34;

                case 23:
                    goto st38;
                }

                goto st0;
st33:

                if ( ++p == pe )
                    goto _test_eof33;

            case 33:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr112;

                goto st0;
st34:

                if ( ++p == pe )
                    goto _test_eof34;

            case 34:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr113;

                case 5:
                    goto tr113;

                case 8:
                    goto tr113;

                case 18:
                    goto tr114;

                case 21:
                    goto tr114;

                case 23:
                    goto tr114;

                case 36:
                    goto tr114;

                case 44:
                    goto tr114;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr114;

                goto st0;
tr113:

                {
                    expr_start = p;
                }
                goto st35;
st35:

                if ( ++p == pe )
                    goto _test_eof35;

            case 35:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr115;

                case 23:
                    goto st24;

                case 37:
                    goto st35;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr115:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st36;
st36:

                if ( ++p == pe )
                    goto _test_eof36;

            case 36:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr117;

                case 19:
                    goto tr115;

                case 23:
                    goto st24;

                case 37:
                    goto st35;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr114:

                {
                    expr_start = p;
                }
                goto st37;
st37:

                if ( ++p == pe )
                    goto _test_eof37;

            case 37:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st35;

                case 5:
                    goto st35;

                case 8:
                    goto st35;

                case 13:
                    goto st37;

                case 18:
                    goto st37;

                case 21:
                    goto st37;

                case 23:
                    goto st37;

                case 36:
                    goto st37;

                case 44:
                    goto st37;
                }

                goto st0;
st38:

                if ( ++p == pe )
                    goto _test_eof38;

            case 38:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr119;

                case 5:
                    goto tr119;

                case 8:
                    goto tr119;

                case 18:
                    goto tr120;

                case 21:
                    goto tr120;

                case 23:
                    goto tr120;

                case 36:
                    goto tr120;

                case 44:
                    goto tr120;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr120;

                goto st0;
tr119:

                {
                    expr_start = p;
                }
                goto st39;
st39:

                if ( ++p == pe )
                    goto _test_eof39;

            case 39:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr121;

                case 23:
                    goto st24;

                case 37:
                    goto st39;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr121:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st40;
st40:

                if ( ++p == pe )
                    goto _test_eof40;

            case 40:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr123;

                case 19:
                    goto tr121;

                case 23:
                    goto st24;

                case 37:
                    goto st39;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr120:

                {
                    expr_start = p;
                }
                goto st41;
st41:

                if ( ++p == pe )
                    goto _test_eof41;

            case 41:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st39;

                case 5:
                    goto st39;

                case 8:
                    goto st39;

                case 13:
                    goto st41;

                case 18:
                    goto st41;

                case 21:
                    goto st41;

                case 23:
                    goto st41;

                case 36:
                    goto st41;

                case 44:
                    goto st41;
                }

                goto st0;
st42:

                if ( ++p == pe )
                    goto _test_eof42;

            case 42:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st43;

                goto st0;
st43:

                if ( ++p == pe )
                    goto _test_eof43;

            case 43:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st44;

                case 70:
                    goto st45;

                case 71:
                    goto st46;

                case 75:
                    goto st47;
                }

                goto st0;
st44:

                if ( ++p == pe )
                    goto _test_eof44;

            case 44:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr130;

                goto st0;
st45:

                if ( ++p == pe )
                    goto _test_eof45;

            case 45:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr131;

                goto st0;
st46:

                if ( ++p == pe )
                    goto _test_eof46;

            case 46:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr132;

                goto st0;
st47:

                if ( ++p == pe )
                    goto _test_eof47;

            case 47:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr133;

                goto st0;
st48:

                if ( ++p == pe )
                    goto _test_eof48;

            case 48:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr134;

                case 5:
                    goto tr134;

                case 8:
                    goto tr134;

                case 18:
                    goto tr135;

                case 21:
                    goto tr135;

                case 23:
                    goto tr135;

                case 36:
                    goto tr135;

                case 44:
                    goto tr135;

                case 48:
                    goto st51;

                case 53:
                    goto st52;

                case 54:
                    goto st53;

                case 55:
                    goto st54;

                case 56:
                    goto st55;

                case 57:
                    goto st56;

                case 58:
                    goto st57;

                case 59:
                    goto st58;

                case 60:
                    goto st59;

                case 61:
                    goto st60;

                case 62:
                    goto st61;

                case 71:
                    goto st85;

                case 72:
                    goto st91;

                case 73:
                    goto st97;

                case 79:
                    goto st64;

                case 80:
                    goto st65;

                case 81:
                    goto st75;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr135;

                goto st0;
tr134:

                {
                    expr_start = p;
                }
                goto st49;
st49:

                if ( ++p == pe )
                    goto _test_eof49;

            case 49:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr153;

                case 19:
                    goto st49;

                case 23:
                    goto st50;

                case 37:
                    goto st49;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st50;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st50;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st50;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st50;
                }
                else
                    goto st50;

                goto st0;
tr135:

                {
                    expr_start = p;
                }
                goto st50;
st50:

                if ( ++p == pe )
                    goto _test_eof50;

            case 50:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st49;

                case 5:
                    goto st49;

                case 8:
                    goto st49;

                case 13:
                    goto st50;

                case 18:
                    goto st50;

                case 21:
                    goto st50;

                case 23:
                    goto st50;

                case 36:
                    goto st50;

                case 44:
                    goto st50;
                }

                goto st0;
st51:

                if ( ++p == pe )
                    goto _test_eof51;

            case 51:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr156;

                goto st0;
st52:

                if ( ++p == pe )
                    goto _test_eof52;

            case 52:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr157;

                goto st0;
st53:

                if ( ++p == pe )
                    goto _test_eof53;

            case 53:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr158;

                goto st0;
st54:

                if ( ++p == pe )
                    goto _test_eof54;

            case 54:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr159;

                goto st0;
st55:

                if ( ++p == pe )
                    goto _test_eof55;

            case 55:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr160;

                goto st0;
st56:

                if ( ++p == pe )
                    goto _test_eof56;

            case 56:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr161;

                goto st0;
st57:

                if ( ++p == pe )
                    goto _test_eof57;

            case 57:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr162;

                goto st0;
st58:

                if ( ++p == pe )
                    goto _test_eof58;

            case 58:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr163;

                goto st0;
st59:

                if ( ++p == pe )
                    goto _test_eof59;

            case 59:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr164;

                goto st0;
st60:

                if ( ++p == pe )
                    goto _test_eof60;

            case 60:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr165;

                goto st0;
st61:

                if ( ++p == pe )
                    goto _test_eof61;

            case 61:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr166;

                case 22:
                    goto st62;
                }

                goto st0;
st62:

                if ( ++p == pe )
                    goto _test_eof62;

            case 62:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr134;

                case 5:
                    goto tr134;

                case 8:
                    goto tr134;

                case 18:
                    goto tr135;

                case 21:
                    goto tr135;

                case 23:
                    goto tr135;

                case 36:
                    goto tr135;

                case 44:
                    goto tr135;

                case 48:
                    goto st51;

                case 53:
                    goto st52;

                case 54:
                    goto st53;

                case 55:
                    goto st54;

                case 56:
                    goto st55;

                case 57:
                    goto st56;

                case 58:
                    goto st57;

                case 59:
                    goto st58;

                case 60:
                    goto st59;

                case 61:
                    goto st60;

                case 62:
                    goto st63;

                case 79:
                    goto st64;

                case 80:
                    goto st65;

                case 81:
                    goto st75;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr135;

                goto st0;
st63:

                if ( ++p == pe )
                    goto _test_eof63;

            case 63:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr166;

                goto st0;
st64:

                if ( ++p == pe )
                    goto _test_eof64;

            case 64:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr169;

                goto st0;
st65:

                if ( ++p == pe )
                    goto _test_eof65;

            case 65:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st66;

                case 21:
                    goto st67;

                case 23:
                    goto st71;
                }

                goto st0;
st66:

                if ( ++p == pe )
                    goto _test_eof66;

            case 66:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr173;

                goto st0;
st67:

                if ( ++p == pe )
                    goto _test_eof67;

            case 67:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr174;

                case 5:
                    goto tr174;

                case 8:
                    goto tr174;

                case 18:
                    goto tr175;

                case 21:
                    goto tr175;

                case 23:
                    goto tr175;

                case 36:
                    goto tr175;

                case 44:
                    goto tr175;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr175;

                goto st0;
tr174:

                {
                    expr_start = p;
                }
                goto st68;
st68:

                if ( ++p == pe )
                    goto _test_eof68;

            case 68:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr176;

                case 23:
                    goto st24;

                case 37:
                    goto st68;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr176:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st69;
st69:

                if ( ++p == pe )
                    goto _test_eof69;

            case 69:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr178;

                case 19:
                    goto tr176;

                case 23:
                    goto st24;

                case 37:
                    goto st68;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr175:

                {
                    expr_start = p;
                }
                goto st70;
st70:

                if ( ++p == pe )
                    goto _test_eof70;

            case 70:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st68;

                case 5:
                    goto st68;

                case 8:
                    goto st68;

                case 13:
                    goto st70;

                case 18:
                    goto st70;

                case 21:
                    goto st70;

                case 23:
                    goto st70;

                case 36:
                    goto st70;

                case 44:
                    goto st70;
                }

                goto st0;
st71:

                if ( ++p == pe )
                    goto _test_eof71;

            case 71:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr180;

                case 5:
                    goto tr180;

                case 8:
                    goto tr180;

                case 18:
                    goto tr181;

                case 21:
                    goto tr181;

                case 23:
                    goto tr181;

                case 36:
                    goto tr181;

                case 44:
                    goto tr181;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr181;

                goto st0;
tr180:

                {
                    expr_start = p;
                }
                goto st72;
st72:

                if ( ++p == pe )
                    goto _test_eof72;

            case 72:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr182;

                case 23:
                    goto st24;

                case 37:
                    goto st72;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr182:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st73;
st73:

                if ( ++p == pe )
                    goto _test_eof73;

            case 73:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr184;

                case 19:
                    goto tr182;

                case 23:
                    goto st24;

                case 37:
                    goto st72;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr181:

                {
                    expr_start = p;
                }
                goto st74;
st74:

                if ( ++p == pe )
                    goto _test_eof74;

            case 74:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st72;

                case 5:
                    goto st72;

                case 8:
                    goto st72;

                case 13:
                    goto st74;

                case 18:
                    goto st74;

                case 21:
                    goto st74;

                case 23:
                    goto st74;

                case 36:
                    goto st74;

                case 44:
                    goto st74;
                }

                goto st0;
st75:

                if ( ++p == pe )
                    goto _test_eof75;

            case 75:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st76;

                case 21:
                    goto st77;

                case 23:
                    goto st81;
                }

                goto st0;
st76:

                if ( ++p == pe )
                    goto _test_eof76;

            case 76:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr189;

                goto st0;
st77:

                if ( ++p == pe )
                    goto _test_eof77;

            case 77:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr190;

                case 5:
                    goto tr190;

                case 8:
                    goto tr190;

                case 18:
                    goto tr191;

                case 21:
                    goto tr191;

                case 23:
                    goto tr191;

                case 36:
                    goto tr191;

                case 44:
                    goto tr191;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr191;

                goto st0;
tr190:

                {
                    expr_start = p;
                }
                goto st78;
st78:

                if ( ++p == pe )
                    goto _test_eof78;

            case 78:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr192;

                case 23:
                    goto st24;

                case 37:
                    goto st78;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr192:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st79;
st79:

                if ( ++p == pe )
                    goto _test_eof79;

            case 79:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr194;

                case 19:
                    goto tr192;

                case 23:
                    goto st24;

                case 37:
                    goto st78;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr191:

                {
                    expr_start = p;
                }
                goto st80;
st80:

                if ( ++p == pe )
                    goto _test_eof80;

            case 80:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st78;

                case 5:
                    goto st78;

                case 8:
                    goto st78;

                case 13:
                    goto st80;

                case 18:
                    goto st80;

                case 21:
                    goto st80;

                case 23:
                    goto st80;

                case 36:
                    goto st80;

                case 44:
                    goto st80;
                }

                goto st0;
st81:

                if ( ++p == pe )
                    goto _test_eof81;

            case 81:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr196;

                case 5:
                    goto tr196;

                case 8:
                    goto tr196;

                case 18:
                    goto tr197;

                case 21:
                    goto tr197;

                case 23:
                    goto tr197;

                case 36:
                    goto tr197;

                case 44:
                    goto tr197;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr197;

                goto st0;
tr196:

                {
                    expr_start = p;
                }
                goto st82;
st82:

                if ( ++p == pe )
                    goto _test_eof82;

            case 82:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr198;

                case 23:
                    goto st24;

                case 37:
                    goto st82;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr198:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st83;
st83:

                if ( ++p == pe )
                    goto _test_eof83;

            case 83:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr200;

                case 19:
                    goto tr198;

                case 23:
                    goto st24;

                case 37:
                    goto st82;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr197:

                {
                    expr_start = p;
                }
                goto st84;
st84:

                if ( ++p == pe )
                    goto _test_eof84;

            case 84:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st82;

                case 5:
                    goto st82;

                case 8:
                    goto st82;

                case 13:
                    goto st84;

                case 18:
                    goto st84;

                case 21:
                    goto st84;

                case 23:
                    goto st84;

                case 36:
                    goto st84;

                case 44:
                    goto st84;
                }

                goto st0;
st85:

                if ( ++p == pe )
                    goto _test_eof85;

            case 85:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st86;

                goto st0;
st86:

                if ( ++p == pe )
                    goto _test_eof86;

            case 86:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st87;

                case 70:
                    goto st88;

                case 71:
                    goto st89;

                case 75:
                    goto st90;
                }

                goto st0;
st87:

                if ( ++p == pe )
                    goto _test_eof87;

            case 87:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr207;

                goto st0;
st88:

                if ( ++p == pe )
                    goto _test_eof88;

            case 88:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr208;

                goto st0;
st89:

                if ( ++p == pe )
                    goto _test_eof89;

            case 89:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr209;

                goto st0;
st90:

                if ( ++p == pe )
                    goto _test_eof90;

            case 90:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr210;

                goto st0;
st91:

                if ( ++p == pe )
                    goto _test_eof91;

            case 91:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st92;

                goto st0;
st92:

                if ( ++p == pe )
                    goto _test_eof92;

            case 92:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st93;

                case 70:
                    goto st94;

                case 72:
                    goto st95;

                case 75:
                    goto st96;
                }

                goto st0;
st93:

                if ( ++p == pe )
                    goto _test_eof93;

            case 93:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr216;

                goto st0;
st94:

                if ( ++p == pe )
                    goto _test_eof94;

            case 94:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr217;

                goto st0;
st95:

                if ( ++p == pe )
                    goto _test_eof95;

            case 95:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr218;

                goto st0;
st96:

                if ( ++p == pe )
                    goto _test_eof96;

            case 96:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr219;

                goto st0;
st97:

                if ( ++p == pe )
                    goto _test_eof97;

            case 97:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st98;

                goto st0;
st98:

                if ( ++p == pe )
                    goto _test_eof98;

            case 98:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st99;

                case 70:
                    goto st100;

                case 73:
                    goto st101;

                case 75:
                    goto st102;
                }

                goto st0;
st99:

                if ( ++p == pe )
                    goto _test_eof99;

            case 99:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr225;

                goto st0;
st100:

                if ( ++p == pe )
                    goto _test_eof100;

            case 100:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr226;

                goto st0;
st101:

                if ( ++p == pe )
                    goto _test_eof101;

            case 101:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr227;

                goto st0;
st102:

                if ( ++p == pe )
                    goto _test_eof102;

            case 102:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr228;

                goto st0;
st103:

                if ( ++p == pe )
                    goto _test_eof103;

            case 103:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr229;

                case 5:
                    goto tr229;

                case 8:
                    goto tr229;

                case 18:
                    goto tr230;

                case 21:
                    goto tr230;

                case 23:
                    goto tr230;

                case 36:
                    goto tr230;

                case 44:
                    goto tr230;

                case 48:
                    goto st106;

                case 53:
                    goto st107;

                case 54:
                    goto st108;

                case 55:
                    goto st109;

                case 56:
                    goto st110;

                case 57:
                    goto st111;

                case 58:
                    goto st112;

                case 59:
                    goto st113;

                case 60:
                    goto st114;

                case 61:
                    goto st115;

                case 62:
                    goto st116;

                case 79:
                    goto st119;

                case 80:
                    goto st120;

                case 81:
                    goto st130;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr230;

                goto st0;
tr229:

                {
                    expr_start = p;
                }
                goto st104;
st104:

                if ( ++p == pe )
                    goto _test_eof104;

            case 104:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr245;

                case 19:
                    goto st104;

                case 23:
                    goto st105;

                case 37:
                    goto st104;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st105;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st105;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st105;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st105;
                }
                else
                    goto st105;

                goto st0;
tr230:

                {
                    expr_start = p;
                }
                goto st105;
st105:

                if ( ++p == pe )
                    goto _test_eof105;

            case 105:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st104;

                case 5:
                    goto st104;

                case 8:
                    goto st104;

                case 13:
                    goto st105;

                case 18:
                    goto st105;

                case 21:
                    goto st105;

                case 23:
                    goto st105;

                case 36:
                    goto st105;

                case 44:
                    goto st105;
                }

                goto st0;
st106:

                if ( ++p == pe )
                    goto _test_eof106;

            case 106:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr248;

                goto st0;
st107:

                if ( ++p == pe )
                    goto _test_eof107;

            case 107:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr249;

                goto st0;
st108:

                if ( ++p == pe )
                    goto _test_eof108;

            case 108:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr250;

                goto st0;
st109:

                if ( ++p == pe )
                    goto _test_eof109;

            case 109:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr251;

                goto st0;
st110:

                if ( ++p == pe )
                    goto _test_eof110;

            case 110:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr252;

                goto st0;
st111:

                if ( ++p == pe )
                    goto _test_eof111;

            case 111:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr253;

                goto st0;
st112:

                if ( ++p == pe )
                    goto _test_eof112;

            case 112:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr254;

                goto st0;
st113:

                if ( ++p == pe )
                    goto _test_eof113;

            case 113:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr255;

                goto st0;
st114:

                if ( ++p == pe )
                    goto _test_eof114;

            case 114:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr256;

                goto st0;
st115:

                if ( ++p == pe )
                    goto _test_eof115;

            case 115:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr257;

                goto st0;
st116:

                if ( ++p == pe )
                    goto _test_eof116;

            case 116:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr258;

                case 22:
                    goto st117;
                }

                goto st0;
st117:

                if ( ++p == pe )
                    goto _test_eof117;

            case 117:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr229;

                case 5:
                    goto tr229;

                case 8:
                    goto tr229;

                case 18:
                    goto tr230;

                case 21:
                    goto tr230;

                case 23:
                    goto tr230;

                case 36:
                    goto tr230;

                case 44:
                    goto tr230;

                case 48:
                    goto st106;

                case 53:
                    goto st107;

                case 54:
                    goto st108;

                case 55:
                    goto st109;

                case 56:
                    goto st110;

                case 57:
                    goto st111;

                case 58:
                    goto st112;

                case 59:
                    goto st113;

                case 60:
                    goto st114;

                case 61:
                    goto st115;

                case 62:
                    goto st118;

                case 79:
                    goto st119;

                case 80:
                    goto st120;

                case 81:
                    goto st130;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr230;

                goto st0;
st118:

                if ( ++p == pe )
                    goto _test_eof118;

            case 118:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr258;

                goto st0;
st119:

                if ( ++p == pe )
                    goto _test_eof119;

            case 119:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr261;

                goto st0;
st120:

                if ( ++p == pe )
                    goto _test_eof120;

            case 120:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st121;

                case 21:
                    goto st122;

                case 23:
                    goto st126;
                }

                goto st0;
st121:

                if ( ++p == pe )
                    goto _test_eof121;

            case 121:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr265;

                goto st0;
st122:

                if ( ++p == pe )
                    goto _test_eof122;

            case 122:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr266;

                case 5:
                    goto tr266;

                case 8:
                    goto tr266;

                case 18:
                    goto tr267;

                case 21:
                    goto tr267;

                case 23:
                    goto tr267;

                case 36:
                    goto tr267;

                case 44:
                    goto tr267;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr267;

                goto st0;
tr266:

                {
                    expr_start = p;
                }
                goto st123;
st123:

                if ( ++p == pe )
                    goto _test_eof123;

            case 123:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr268;

                case 23:
                    goto st24;

                case 37:
                    goto st123;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr268:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st124;
st124:

                if ( ++p == pe )
                    goto _test_eof124;

            case 124:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr270;

                case 19:
                    goto tr268;

                case 23:
                    goto st24;

                case 37:
                    goto st123;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr267:

                {
                    expr_start = p;
                }
                goto st125;
st125:

                if ( ++p == pe )
                    goto _test_eof125;

            case 125:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st123;

                case 5:
                    goto st123;

                case 8:
                    goto st123;

                case 13:
                    goto st125;

                case 18:
                    goto st125;

                case 21:
                    goto st125;

                case 23:
                    goto st125;

                case 36:
                    goto st125;

                case 44:
                    goto st125;
                }

                goto st0;
st126:

                if ( ++p == pe )
                    goto _test_eof126;

            case 126:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr272;

                case 5:
                    goto tr272;

                case 8:
                    goto tr272;

                case 18:
                    goto tr273;

                case 21:
                    goto tr273;

                case 23:
                    goto tr273;

                case 36:
                    goto tr273;

                case 44:
                    goto tr273;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr273;

                goto st0;
tr272:

                {
                    expr_start = p;
                }
                goto st127;
st127:

                if ( ++p == pe )
                    goto _test_eof127;

            case 127:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr274;

                case 23:
                    goto st24;

                case 37:
                    goto st127;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr274:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st128;
st128:

                if ( ++p == pe )
                    goto _test_eof128;

            case 128:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr276;

                case 19:
                    goto tr274;

                case 23:
                    goto st24;

                case 37:
                    goto st127;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr273:

                {
                    expr_start = p;
                }
                goto st129;
st129:

                if ( ++p == pe )
                    goto _test_eof129;

            case 129:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st127;

                case 5:
                    goto st127;

                case 8:
                    goto st127;

                case 13:
                    goto st129;

                case 18:
                    goto st129;

                case 21:
                    goto st129;

                case 23:
                    goto st129;

                case 36:
                    goto st129;

                case 44:
                    goto st129;
                }

                goto st0;
st130:

                if ( ++p == pe )
                    goto _test_eof130;

            case 130:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st131;

                case 21:
                    goto st132;

                case 23:
                    goto st136;
                }

                goto st0;
st131:

                if ( ++p == pe )
                    goto _test_eof131;

            case 131:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr281;

                goto st0;
st132:

                if ( ++p == pe )
                    goto _test_eof132;

            case 132:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr282;

                case 5:
                    goto tr282;

                case 8:
                    goto tr282;

                case 18:
                    goto tr283;

                case 21:
                    goto tr283;

                case 23:
                    goto tr283;

                case 36:
                    goto tr283;

                case 44:
                    goto tr283;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr283;

                goto st0;
tr282:

                {
                    expr_start = p;
                }
                goto st133;
st133:

                if ( ++p == pe )
                    goto _test_eof133;

            case 133:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr284;

                case 23:
                    goto st24;

                case 37:
                    goto st133;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr284:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st134;
st134:

                if ( ++p == pe )
                    goto _test_eof134;

            case 134:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr286;

                case 19:
                    goto tr284;

                case 23:
                    goto st24;

                case 37:
                    goto st133;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr283:

                {
                    expr_start = p;
                }
                goto st135;
st135:

                if ( ++p == pe )
                    goto _test_eof135;

            case 135:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st133;

                case 5:
                    goto st133;

                case 8:
                    goto st133;

                case 13:
                    goto st135;

                case 18:
                    goto st135;

                case 21:
                    goto st135;

                case 23:
                    goto st135;

                case 36:
                    goto st135;

                case 44:
                    goto st135;
                }

                goto st0;
st136:

                if ( ++p == pe )
                    goto _test_eof136;

            case 136:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr288;

                case 5:
                    goto tr288;

                case 8:
                    goto tr288;

                case 18:
                    goto tr289;

                case 21:
                    goto tr289;

                case 23:
                    goto tr289;

                case 36:
                    goto tr289;

                case 44:
                    goto tr289;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr289;

                goto st0;
tr288:

                {
                    expr_start = p;
                }
                goto st137;
st137:

                if ( ++p == pe )
                    goto _test_eof137;

            case 137:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr290;

                case 23:
                    goto st24;

                case 37:
                    goto st137;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr290:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st138;
st138:

                if ( ++p == pe )
                    goto _test_eof138;

            case 138:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr292;

                case 19:
                    goto tr290;

                case 23:
                    goto st24;

                case 37:
                    goto st137;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr289:

                {
                    expr_start = p;
                }
                goto st139;
st139:

                if ( ++p == pe )
                    goto _test_eof139;

            case 139:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st137;

                case 5:
                    goto st137;

                case 8:
                    goto st137;

                case 13:
                    goto st139;

                case 18:
                    goto st139;

                case 21:
                    goto st139;

                case 23:
                    goto st139;

                case 36:
                    goto st139;

                case 44:
                    goto st139;
                }

                goto st0;
st140:

                if ( ++p == pe )
                    goto _test_eof140;

            case 140:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr294;

                case 5:
                    goto tr294;

                case 8:
                    goto tr294;

                case 18:
                    goto tr295;

                case 21:
                    goto tr295;

                case 23:
                    goto tr295;

                case 36:
                    goto tr295;

                case 44:
                    goto tr295;

                case 45:
                    goto st143;

                case 46:
                    goto st147;

                case 47:
                    goto st151;

                case 48:
                    goto st155;

                case 49:
                    goto st159;

                case 50:
                    goto st163;

                case 51:
                    goto st167;

                case 52:
                    goto st171;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr295;

                goto st0;
tr294:

                {
                    expr_start = p;
                }
                goto st141;
st141:

                if ( ++p == pe )
                    goto _test_eof141;

            case 141:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr304;

                case 19:
                    goto st141;

                case 23:
                    goto st142;

                case 37:
                    goto st141;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st142;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st142;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st142;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st142;
                }
                else
                    goto st142;

                goto st0;
tr295:

                {
                    expr_start = p;
                }
                goto st142;
st142:

                if ( ++p == pe )
                    goto _test_eof142;

            case 142:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st141;

                case 5:
                    goto st141;

                case 8:
                    goto st141;

                case 13:
                    goto st142;

                case 18:
                    goto st142;

                case 21:
                    goto st142;

                case 23:
                    goto st142;

                case 36:
                    goto st142;

                case 44:
                    goto st142;
                }

                goto st0;
st143:

                if ( ++p == pe )
                    goto _test_eof143;

            case 143:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st144;

                goto st0;
st144:

                if ( ++p == pe )
                    goto _test_eof144;

            case 144:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr308;

                case 5:
                    goto tr308;

                case 8:
                    goto tr308;

                case 18:
                    goto tr309;

                case 21:
                    goto tr309;

                case 23:
                    goto tr309;

                case 36:
                    goto tr309;

                case 44:
                    goto tr309;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr309;

                goto st0;
tr308:

                {
                    expr_start = p;
                }
                goto st145;
st145:

                if ( ++p == pe )
                    goto _test_eof145;

            case 145:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr310;

                case 19:
                    goto st145;

                case 23:
                    goto st146;

                case 37:
                    goto st145;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st146;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st146;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st146;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st146;
                }
                else
                    goto st146;

                goto st0;
tr309:

                {
                    expr_start = p;
                }
                goto st146;
st146:

                if ( ++p == pe )
                    goto _test_eof146;

            case 146:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st145;

                case 5:
                    goto st145;

                case 8:
                    goto st145;

                case 13:
                    goto st146;

                case 18:
                    goto st146;

                case 21:
                    goto st146;

                case 23:
                    goto st146;

                case 36:
                    goto st146;

                case 44:
                    goto st146;
                }

                goto st0;
st147:

                if ( ++p == pe )
                    goto _test_eof147;

            case 147:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st148;

                goto st0;
st148:

                if ( ++p == pe )
                    goto _test_eof148;

            case 148:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr314;

                case 5:
                    goto tr314;

                case 8:
                    goto tr314;

                case 18:
                    goto tr315;

                case 21:
                    goto tr315;

                case 23:
                    goto tr315;

                case 36:
                    goto tr315;

                case 44:
                    goto tr315;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr315;

                goto st0;
tr314:

                {
                    expr_start = p;
                }
                goto st149;
st149:

                if ( ++p == pe )
                    goto _test_eof149;

            case 149:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr316;

                case 19:
                    goto st149;

                case 23:
                    goto st150;

                case 37:
                    goto st149;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st150;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st150;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st150;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st150;
                }
                else
                    goto st150;

                goto st0;
tr315:

                {
                    expr_start = p;
                }
                goto st150;
st150:

                if ( ++p == pe )
                    goto _test_eof150;

            case 150:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st149;

                case 5:
                    goto st149;

                case 8:
                    goto st149;

                case 13:
                    goto st150;

                case 18:
                    goto st150;

                case 21:
                    goto st150;

                case 23:
                    goto st150;

                case 36:
                    goto st150;

                case 44:
                    goto st150;
                }

                goto st0;
st151:

                if ( ++p == pe )
                    goto _test_eof151;

            case 151:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st152;

                goto st0;
st152:

                if ( ++p == pe )
                    goto _test_eof152;

            case 152:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr320;

                case 5:
                    goto tr320;

                case 8:
                    goto tr320;

                case 18:
                    goto tr321;

                case 21:
                    goto tr321;

                case 23:
                    goto tr321;

                case 36:
                    goto tr321;

                case 44:
                    goto tr321;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr321;

                goto st0;
tr320:

                {
                    expr_start = p;
                }
                goto st153;
st153:

                if ( ++p == pe )
                    goto _test_eof153;

            case 153:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr322;

                case 19:
                    goto st153;

                case 23:
                    goto st154;

                case 37:
                    goto st153;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st154;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st154;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st154;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st154;
                }
                else
                    goto st154;

                goto st0;
tr321:

                {
                    expr_start = p;
                }
                goto st154;
st154:

                if ( ++p == pe )
                    goto _test_eof154;

            case 154:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st153;

                case 5:
                    goto st153;

                case 8:
                    goto st153;

                case 13:
                    goto st154;

                case 18:
                    goto st154;

                case 21:
                    goto st154;

                case 23:
                    goto st154;

                case 36:
                    goto st154;

                case 44:
                    goto st154;
                }

                goto st0;
st155:

                if ( ++p == pe )
                    goto _test_eof155;

            case 155:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st156;

                goto st0;
st156:

                if ( ++p == pe )
                    goto _test_eof156;

            case 156:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr326;

                case 5:
                    goto tr326;

                case 8:
                    goto tr326;

                case 18:
                    goto tr327;

                case 21:
                    goto tr327;

                case 23:
                    goto tr327;

                case 36:
                    goto tr327;

                case 44:
                    goto tr327;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr327;

                goto st0;
tr326:

                {
                    expr_start = p;
                }
                goto st157;
st157:

                if ( ++p == pe )
                    goto _test_eof157;

            case 157:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr328;

                case 19:
                    goto st157;

                case 23:
                    goto st158;

                case 37:
                    goto st157;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st158;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st158;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st158;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st158;
                }
                else
                    goto st158;

                goto st0;
tr327:

                {
                    expr_start = p;
                }
                goto st158;
st158:

                if ( ++p == pe )
                    goto _test_eof158;

            case 158:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st157;

                case 5:
                    goto st157;

                case 8:
                    goto st157;

                case 13:
                    goto st158;

                case 18:
                    goto st158;

                case 21:
                    goto st158;

                case 23:
                    goto st158;

                case 36:
                    goto st158;

                case 44:
                    goto st158;
                }

                goto st0;
st159:

                if ( ++p == pe )
                    goto _test_eof159;

            case 159:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st160;

                goto st0;
st160:

                if ( ++p == pe )
                    goto _test_eof160;

            case 160:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr332;

                case 5:
                    goto tr332;

                case 8:
                    goto tr332;

                case 18:
                    goto tr333;

                case 21:
                    goto tr333;

                case 23:
                    goto tr333;

                case 36:
                    goto tr333;

                case 44:
                    goto tr333;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr333;

                goto st0;
tr332:

                {
                    expr_start = p;
                }
                goto st161;
st161:

                if ( ++p == pe )
                    goto _test_eof161;

            case 161:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr334;

                case 19:
                    goto st161;

                case 23:
                    goto st162;

                case 37:
                    goto st161;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st162;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st162;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st162;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st162;
                }
                else
                    goto st162;

                goto st0;
tr333:

                {
                    expr_start = p;
                }
                goto st162;
st162:

                if ( ++p == pe )
                    goto _test_eof162;

            case 162:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st161;

                case 5:
                    goto st161;

                case 8:
                    goto st161;

                case 13:
                    goto st162;

                case 18:
                    goto st162;

                case 21:
                    goto st162;

                case 23:
                    goto st162;

                case 36:
                    goto st162;

                case 44:
                    goto st162;
                }

                goto st0;
st163:

                if ( ++p == pe )
                    goto _test_eof163;

            case 163:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st164;

                goto st0;
st164:

                if ( ++p == pe )
                    goto _test_eof164;

            case 164:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr338;

                case 5:
                    goto tr338;

                case 8:
                    goto tr338;

                case 18:
                    goto tr339;

                case 21:
                    goto tr339;

                case 23:
                    goto tr339;

                case 36:
                    goto tr339;

                case 44:
                    goto tr339;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr339;

                goto st0;
tr338:

                {
                    expr_start = p;
                }
                goto st165;
st165:

                if ( ++p == pe )
                    goto _test_eof165;

            case 165:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr340;

                case 19:
                    goto st165;

                case 23:
                    goto st166;

                case 37:
                    goto st165;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st166;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st166;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st166;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st166;
                }
                else
                    goto st166;

                goto st0;
tr339:

                {
                    expr_start = p;
                }
                goto st166;
st166:

                if ( ++p == pe )
                    goto _test_eof166;

            case 166:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st165;

                case 5:
                    goto st165;

                case 8:
                    goto st165;

                case 13:
                    goto st166;

                case 18:
                    goto st166;

                case 21:
                    goto st166;

                case 23:
                    goto st166;

                case 36:
                    goto st166;

                case 44:
                    goto st166;
                }

                goto st0;
st167:

                if ( ++p == pe )
                    goto _test_eof167;

            case 167:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st168;

                goto st0;
st168:

                if ( ++p == pe )
                    goto _test_eof168;

            case 168:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr344;

                case 5:
                    goto tr344;

                case 8:
                    goto tr344;

                case 18:
                    goto tr345;

                case 21:
                    goto tr345;

                case 23:
                    goto tr345;

                case 36:
                    goto tr345;

                case 44:
                    goto tr345;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr345;

                goto st0;
tr344:

                {
                    expr_start = p;
                }
                goto st169;
st169:

                if ( ++p == pe )
                    goto _test_eof169;

            case 169:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr346;

                case 19:
                    goto st169;

                case 23:
                    goto st170;

                case 37:
                    goto st169;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st170;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st170;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st170;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st170;
                }
                else
                    goto st170;

                goto st0;
tr345:

                {
                    expr_start = p;
                }
                goto st170;
st170:

                if ( ++p == pe )
                    goto _test_eof170;

            case 170:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st169;

                case 5:
                    goto st169;

                case 8:
                    goto st169;

                case 13:
                    goto st170;

                case 18:
                    goto st170;

                case 21:
                    goto st170;

                case 23:
                    goto st170;

                case 36:
                    goto st170;

                case 44:
                    goto st170;
                }

                goto st0;
st171:

                if ( ++p == pe )
                    goto _test_eof171;

            case 171:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st172;

                goto st0;
st172:

                if ( ++p == pe )
                    goto _test_eof172;

            case 172:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr350;

                case 5:
                    goto tr350;

                case 8:
                    goto tr350;

                case 18:
                    goto tr351;

                case 21:
                    goto tr351;

                case 23:
                    goto tr351;

                case 36:
                    goto tr351;

                case 44:
                    goto tr351;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr351;

                goto st0;
tr350:

                {
                    expr_start = p;
                }
                goto st173;
st173:

                if ( ++p == pe )
                    goto _test_eof173;

            case 173:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr352;

                case 19:
                    goto st173;

                case 23:
                    goto st174;

                case 37:
                    goto st173;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st174;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st174;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st174;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st174;
                }
                else
                    goto st174;

                goto st0;
tr351:

                {
                    expr_start = p;
                }
                goto st174;
st174:

                if ( ++p == pe )
                    goto _test_eof174;

            case 174:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st173;

                case 5:
                    goto st173;

                case 8:
                    goto st173;

                case 13:
                    goto st174;

                case 18:
                    goto st174;

                case 21:
                    goto st174;

                case 23:
                    goto st174;

                case 36:
                    goto st174;

                case 44:
                    goto st174;
                }

                goto st0;
st175:

                if ( ++p == pe )
                    goto _test_eof175;

            case 175:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr355;

                goto st0;
st176:

                if ( ++p == pe )
                    goto _test_eof176;

            case 176:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr356;

                case 5:
                    goto tr356;

                case 8:
                    goto tr356;

                case 18:
                    goto tr357;

                case 21:
                    goto tr357;

                case 23:
                    goto tr357;

                case 36:
                    goto tr357;

                case 44:
                    goto tr357;

                case 48:
                    goto st179;

                case 53:
                    goto st180;

                case 54:
                    goto st181;

                case 55:
                    goto st182;

                case 56:
                    goto st183;

                case 57:
                    goto st184;

                case 58:
                    goto st185;

                case 59:
                    goto st186;

                case 60:
                    goto st187;

                case 61:
                    goto st188;

                case 62:
                    goto st189;

                case 79:
                    goto st192;

                case 80:
                    goto st193;

                case 81:
                    goto st203;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr357;

                goto st0;
tr356:

                {
                    expr_start = p;
                }
                goto st177;
st177:

                if ( ++p == pe )
                    goto _test_eof177;

            case 177:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr372;

                case 19:
                    goto st177;

                case 23:
                    goto st178;

                case 37:
                    goto st177;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st178;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st178;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st178;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st178;
                }
                else
                    goto st178;

                goto st0;
tr357:

                {
                    expr_start = p;
                }
                goto st178;
st178:

                if ( ++p == pe )
                    goto _test_eof178;

            case 178:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st177;

                case 5:
                    goto st177;

                case 8:
                    goto st177;

                case 13:
                    goto st178;

                case 18:
                    goto st178;

                case 21:
                    goto st178;

                case 23:
                    goto st178;

                case 36:
                    goto st178;

                case 44:
                    goto st178;
                }

                goto st0;
st179:

                if ( ++p == pe )
                    goto _test_eof179;

            case 179:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr375;

                goto st0;
st180:

                if ( ++p == pe )
                    goto _test_eof180;

            case 180:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr376;

                goto st0;
st181:

                if ( ++p == pe )
                    goto _test_eof181;

            case 181:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr377;

                goto st0;
st182:

                if ( ++p == pe )
                    goto _test_eof182;

            case 182:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr378;

                goto st0;
st183:

                if ( ++p == pe )
                    goto _test_eof183;

            case 183:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr379;

                goto st0;
st184:

                if ( ++p == pe )
                    goto _test_eof184;

            case 184:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr380;

                goto st0;
st185:

                if ( ++p == pe )
                    goto _test_eof185;

            case 185:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr381;

                goto st0;
st186:

                if ( ++p == pe )
                    goto _test_eof186;

            case 186:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr382;

                goto st0;
st187:

                if ( ++p == pe )
                    goto _test_eof187;

            case 187:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr383;

                goto st0;
st188:

                if ( ++p == pe )
                    goto _test_eof188;

            case 188:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr384;

                goto st0;
st189:

                if ( ++p == pe )
                    goto _test_eof189;

            case 189:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr385;

                case 22:
                    goto st190;
                }

                goto st0;
st190:

                if ( ++p == pe )
                    goto _test_eof190;

            case 190:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr356;

                case 5:
                    goto tr356;

                case 8:
                    goto tr356;

                case 18:
                    goto tr357;

                case 21:
                    goto tr357;

                case 23:
                    goto tr357;

                case 36:
                    goto tr357;

                case 44:
                    goto tr357;

                case 48:
                    goto st179;

                case 53:
                    goto st180;

                case 54:
                    goto st181;

                case 55:
                    goto st182;

                case 56:
                    goto st183;

                case 57:
                    goto st184;

                case 58:
                    goto st185;

                case 59:
                    goto st186;

                case 60:
                    goto st187;

                case 61:
                    goto st188;

                case 62:
                    goto st191;

                case 79:
                    goto st192;

                case 80:
                    goto st193;

                case 81:
                    goto st203;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr357;

                goto st0;
st191:

                if ( ++p == pe )
                    goto _test_eof191;

            case 191:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr385;

                goto st0;
st192:

                if ( ++p == pe )
                    goto _test_eof192;

            case 192:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr388;

                goto st0;
st193:

                if ( ++p == pe )
                    goto _test_eof193;

            case 193:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st194;

                case 21:
                    goto st195;

                case 23:
                    goto st199;
                }

                goto st0;
st194:

                if ( ++p == pe )
                    goto _test_eof194;

            case 194:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr392;

                goto st0;
st195:

                if ( ++p == pe )
                    goto _test_eof195;

            case 195:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr393;

                case 5:
                    goto tr393;

                case 8:
                    goto tr393;

                case 18:
                    goto tr394;

                case 21:
                    goto tr394;

                case 23:
                    goto tr394;

                case 36:
                    goto tr394;

                case 44:
                    goto tr394;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr394;

                goto st0;
tr393:

                {
                    expr_start = p;
                }
                goto st196;
st196:

                if ( ++p == pe )
                    goto _test_eof196;

            case 196:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr395;

                case 23:
                    goto st24;

                case 37:
                    goto st196;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr395:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st197;
st197:

                if ( ++p == pe )
                    goto _test_eof197;

            case 197:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr397;

                case 19:
                    goto tr395;

                case 23:
                    goto st24;

                case 37:
                    goto st196;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr394:

                {
                    expr_start = p;
                }
                goto st198;
st198:

                if ( ++p == pe )
                    goto _test_eof198;

            case 198:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st196;

                case 5:
                    goto st196;

                case 8:
                    goto st196;

                case 13:
                    goto st198;

                case 18:
                    goto st198;

                case 21:
                    goto st198;

                case 23:
                    goto st198;

                case 36:
                    goto st198;

                case 44:
                    goto st198;
                }

                goto st0;
st199:

                if ( ++p == pe )
                    goto _test_eof199;

            case 199:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr399;

                case 5:
                    goto tr399;

                case 8:
                    goto tr399;

                case 18:
                    goto tr400;

                case 21:
                    goto tr400;

                case 23:
                    goto tr400;

                case 36:
                    goto tr400;

                case 44:
                    goto tr400;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr400;

                goto st0;
tr399:

                {
                    expr_start = p;
                }
                goto st200;
st200:

                if ( ++p == pe )
                    goto _test_eof200;

            case 200:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr401;

                case 23:
                    goto st24;

                case 37:
                    goto st200;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr401:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st201;
st201:

                if ( ++p == pe )
                    goto _test_eof201;

            case 201:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr403;

                case 19:
                    goto tr401;

                case 23:
                    goto st24;

                case 37:
                    goto st200;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr400:

                {
                    expr_start = p;
                }
                goto st202;
st202:

                if ( ++p == pe )
                    goto _test_eof202;

            case 202:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st200;

                case 5:
                    goto st200;

                case 8:
                    goto st200;

                case 13:
                    goto st202;

                case 18:
                    goto st202;

                case 21:
                    goto st202;

                case 23:
                    goto st202;

                case 36:
                    goto st202;

                case 44:
                    goto st202;
                }

                goto st0;
st203:

                if ( ++p == pe )
                    goto _test_eof203;

            case 203:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st204;

                case 21:
                    goto st205;

                case 23:
                    goto st209;
                }

                goto st0;
st204:

                if ( ++p == pe )
                    goto _test_eof204;

            case 204:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr408;

                goto st0;
st205:

                if ( ++p == pe )
                    goto _test_eof205;

            case 205:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr409;

                case 5:
                    goto tr409;

                case 8:
                    goto tr409;

                case 18:
                    goto tr410;

                case 21:
                    goto tr410;

                case 23:
                    goto tr410;

                case 36:
                    goto tr410;

                case 44:
                    goto tr410;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr410;

                goto st0;
tr409:

                {
                    expr_start = p;
                }
                goto st206;
st206:

                if ( ++p == pe )
                    goto _test_eof206;

            case 206:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr411;

                case 23:
                    goto st24;

                case 37:
                    goto st206;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr411:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st207;
st207:

                if ( ++p == pe )
                    goto _test_eof207;

            case 207:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr413;

                case 19:
                    goto tr411;

                case 23:
                    goto st24;

                case 37:
                    goto st206;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr410:

                {
                    expr_start = p;
                }
                goto st208;
st208:

                if ( ++p == pe )
                    goto _test_eof208;

            case 208:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st206;

                case 5:
                    goto st206;

                case 8:
                    goto st206;

                case 13:
                    goto st208;

                case 18:
                    goto st208;

                case 21:
                    goto st208;

                case 23:
                    goto st208;

                case 36:
                    goto st208;

                case 44:
                    goto st208;
                }

                goto st0;
st209:

                if ( ++p == pe )
                    goto _test_eof209;

            case 209:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr415;

                case 5:
                    goto tr415;

                case 8:
                    goto tr415;

                case 18:
                    goto tr416;

                case 21:
                    goto tr416;

                case 23:
                    goto tr416;

                case 36:
                    goto tr416;

                case 44:
                    goto tr416;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr416;

                goto st0;
tr415:

                {
                    expr_start = p;
                }
                goto st210;
st210:

                if ( ++p == pe )
                    goto _test_eof210;

            case 210:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr417;

                case 23:
                    goto st24;

                case 37:
                    goto st210;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr417:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st211;
st211:

                if ( ++p == pe )
                    goto _test_eof211;

            case 211:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr419;

                case 19:
                    goto tr417;

                case 23:
                    goto st24;

                case 37:
                    goto st210;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr416:

                {
                    expr_start = p;
                }
                goto st212;
st212:

                if ( ++p == pe )
                    goto _test_eof212;

            case 212:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st210;

                case 5:
                    goto st210;

                case 8:
                    goto st210;

                case 13:
                    goto st212;

                case 18:
                    goto st212;

                case 21:
                    goto st212;

                case 23:
                    goto st212;

                case 36:
                    goto st212;

                case 44:
                    goto st212;
                }

                goto st0;
st213:

                if ( ++p == pe )
                    goto _test_eof213;

            case 213:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr421;

                goto st0;
st214:

                if ( ++p == pe )
                    goto _test_eof214;

            case 214:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr422;

                goto st0;
st215:

                if ( ++p == pe )
                    goto _test_eof215;

            case 215:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr423;

                goto st0;
st216:

                if ( ++p == pe )
                    goto _test_eof216;

            case 216:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr424;

                goto st0;
st217:

                if ( ++p == pe )
                    goto _test_eof217;

            case 217:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr425;

                goto st0;
st218:

                if ( ++p == pe )
                    goto _test_eof218;

            case 218:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr426;

                goto st0;
st219:

                if ( ++p == pe )
                    goto _test_eof219;

            case 219:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr427;

                goto st0;
st220:

                if ( ++p == pe )
                    goto _test_eof220;

            case 220:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr428;

                case 5:
                    goto tr428;

                case 8:
                    goto tr428;

                case 18:
                    goto tr429;

                case 21:
                    goto tr429;

                case 23:
                    goto tr429;

                case 36:
                    goto tr429;

                case 44:
                    goto tr429;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr429;

                goto st0;
tr428:

                {
                    expr_start = p;
                }
                goto st221;
st221:

                if ( ++p == pe )
                    goto _test_eof221;

            case 221:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr430;

                case 19:
                    goto st221;

                case 23:
                    goto st222;

                case 37:
                    goto st221;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st222;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st222;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st222;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st222;
                }
                else
                    goto st222;

                goto st0;
tr429:

                {
                    expr_start = p;
                }
                goto st222;
st222:

                if ( ++p == pe )
                    goto _test_eof222;

            case 222:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st221;

                case 5:
                    goto st221;

                case 8:
                    goto st221;

                case 13:
                    goto st222;

                case 18:
                    goto st222;

                case 21:
                    goto st222;

                case 23:
                    goto st222;

                case 36:
                    goto st222;

                case 44:
                    goto st222;
                }

                goto st0;
st223:

                if ( ++p == pe )
                    goto _test_eof223;

            case 223:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr433;

                goto st0;
st224:

                if ( ++p == pe )
                    goto _test_eof224;

            case 224:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 70:
                    goto st225;

                case 74:
                    goto st228;

                case 82:
                    goto st232;
                }

                goto st0;
st225:

                if ( ++p == pe )
                    goto _test_eof225;

            case 225:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st226;

                goto st0;
st226:

                if ( ++p == pe )
                    goto _test_eof226;

            case 226:
                if ( ( ( ( int ) p->tok ) ) == 71 )
                    goto st227;

                goto st0;
st227:

                if ( ++p == pe )
                    goto _test_eof227;

            case 227:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr439;

                goto st0;
st228:

                if ( ++p == pe )
                    goto _test_eof228;

            case 228:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st229;

                goto st0;
st229:

                if ( ++p == pe )
                    goto _test_eof229;

            case 229:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 74:
                    goto st230;

                case 76:
                    goto st231;
                }

                goto st0;
st230:

                if ( ++p == pe )
                    goto _test_eof230;

            case 230:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr443;

                goto st0;
st231:

                if ( ++p == pe )
                    goto _test_eof231;

            case 231:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr444;

                goto st0;
st232:

                if ( ++p == pe )
                    goto _test_eof232;

            case 232:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st233;

                goto st0;
st233:

                if ( ++p == pe )
                    goto _test_eof233;

            case 233:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 71:
                    goto st234;

                case 72:
                    goto st235;

                case 73:
                    goto st236;
                }

                goto st0;
st234:

                if ( ++p == pe )
                    goto _test_eof234;

            case 234:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr449;

                goto st0;
st235:

                if ( ++p == pe )
                    goto _test_eof235;

            case 235:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr450;

                goto st0;
st236:

                if ( ++p == pe )
                    goto _test_eof236;

            case 236:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr451;

                goto st0;
st237:

                if ( ++p == pe )
                    goto _test_eof237;

            case 237:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr452;

                goto st0;
st238:

                if ( ++p == pe )
                    goto _test_eof238;

            case 238:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr453;

                goto st0;
st239:

                if ( ++p == pe )
                    goto _test_eof239;

            case 239:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr454;

                case 5:
                    goto tr454;

                case 8:
                    goto tr454;

                case 18:
                    goto tr455;

                case 21:
                    goto tr455;

                case 23:
                    goto tr455;

                case 36:
                    goto tr455;

                case 44:
                    goto tr455;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr455;

                goto st0;
tr454:

                {
                    expr_start = p;
                }
                goto st240;
st240:

                if ( ++p == pe )
                    goto _test_eof240;

            case 240:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr456;

                case 19:
                    goto st240;

                case 23:
                    goto st241;

                case 37:
                    goto st240;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st241;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st241;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st241;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st241;
                }
                else
                    goto st241;

                goto st0;
tr455:

                {
                    expr_start = p;
                }
                goto st241;
st241:

                if ( ++p == pe )
                    goto _test_eof241;

            case 241:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st240;

                case 5:
                    goto st240;

                case 8:
                    goto st240;

                case 13:
                    goto st241;

                case 18:
                    goto st241;

                case 21:
                    goto st241;

                case 23:
                    goto st241;

                case 36:
                    goto st241;

                case 44:
                    goto st241;
                }

                goto st0;
st242:

                if ( ++p == pe )
                    goto _test_eof242;

            case 242:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st243;

                case 53:
                    goto st246;

                case 54:
                    goto st249;

                case 55:
                    goto st252;

                case 56:
                    goto st255;

                case 59:
                    goto st258;

                case 62:
                    goto st261;
                }

                goto st0;
st243:

                if ( ++p == pe )
                    goto _test_eof243;

            case 243:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st244;

                goto st0;
st244:

                if ( ++p == pe )
                    goto _test_eof244;

            case 244:
                if ( ( ( ( int ) p->tok ) ) == 68 )
                    goto st245;

                goto st0;
st245:

                if ( ++p == pe )
                    goto _test_eof245;

            case 245:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr468;

                goto st0;
st246:

                if ( ++p == pe )
                    goto _test_eof246;

            case 246:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st247;

                goto st0;
st247:

                if ( ++p == pe )
                    goto _test_eof247;

            case 247:
                if ( ( ( ( int ) p->tok ) ) == 68 )
                    goto st248;

                goto st0;
st248:

                if ( ++p == pe )
                    goto _test_eof248;

            case 248:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr471;

                goto st0;
st249:

                if ( ++p == pe )
                    goto _test_eof249;

            case 249:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st250;

                goto st0;
st250:

                if ( ++p == pe )
                    goto _test_eof250;

            case 250:
                if ( ( ( ( int ) p->tok ) ) == 68 )
                    goto st251;

                goto st0;
st251:

                if ( ++p == pe )
                    goto _test_eof251;

            case 251:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr474;

                goto st0;
st252:

                if ( ++p == pe )
                    goto _test_eof252;

            case 252:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st253;

                goto st0;
st253:

                if ( ++p == pe )
                    goto _test_eof253;

            case 253:
                if ( ( ( ( int ) p->tok ) ) == 68 )
                    goto st254;

                goto st0;
st254:

                if ( ++p == pe )
                    goto _test_eof254;

            case 254:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr477;

                goto st0;
st255:

                if ( ++p == pe )
                    goto _test_eof255;

            case 255:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st256;

                goto st0;
st256:

                if ( ++p == pe )
                    goto _test_eof256;

            case 256:
                if ( ( ( ( int ) p->tok ) ) == 68 )
                    goto st257;

                goto st0;
st257:

                if ( ++p == pe )
                    goto _test_eof257;

            case 257:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr480;

                goto st0;
st258:

                if ( ++p == pe )
                    goto _test_eof258;

            case 258:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st259;

                goto st0;
st259:

                if ( ++p == pe )
                    goto _test_eof259;

            case 259:
                if ( ( ( ( int ) p->tok ) ) == 68 )
                    goto st260;

                goto st0;
st260:

                if ( ++p == pe )
                    goto _test_eof260;

            case 260:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr483;

                goto st0;
st261:

                if ( ++p == pe )
                    goto _test_eof261;

            case 261:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st262;

                goto st0;
st262:

                if ( ++p == pe )
                    goto _test_eof262;

            case 262:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 18:
                    goto st263;

                case 68:
                    goto st267;
                }

                goto st0;
st263:

                if ( ++p == pe )
                    goto _test_eof263;

            case 263:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr487;

                case 5:
                    goto tr487;

                case 8:
                    goto tr487;

                case 18:
                    goto tr488;

                case 21:
                    goto tr488;

                case 23:
                    goto tr488;

                case 36:
                    goto tr488;

                case 44:
                    goto tr488;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr488;

                goto st0;
tr487:

                {
                    expr_start = p;
                }
                goto st264;
st264:

                if ( ++p == pe )
                    goto _test_eof264;

            case 264:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr489;

                case 23:
                    goto st24;

                case 37:
                    goto st264;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr489:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st265;
st265:

                if ( ++p == pe )
                    goto _test_eof265;

            case 265:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr491;

                case 19:
                    goto tr489;

                case 23:
                    goto st24;

                case 37:
                    goto st264;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr488:

                {
                    expr_start = p;
                }
                goto st266;
st266:

                if ( ++p == pe )
                    goto _test_eof266;

            case 266:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st264;

                case 5:
                    goto st264;

                case 8:
                    goto st264;

                case 13:
                    goto st266;

                case 18:
                    goto st266;

                case 21:
                    goto st266;

                case 23:
                    goto st266;

                case 36:
                    goto st266;

                case 44:
                    goto st266;
                }

                goto st0;
st267:

                if ( ++p == pe )
                    goto _test_eof267;

            case 267:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr493;

                goto st0;
st268:

                if ( ++p == pe )
                    goto _test_eof268;

            case 268:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr494;

                goto st0;
st269:

                if ( ++p == pe )
                    goto _test_eof269;

            case 269:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr495;

                goto st0;
st270:

                if ( ++p == pe )
                    goto _test_eof270;

            case 270:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr496;

                goto st0;
st271:

                if ( ++p == pe )
                    goto _test_eof271;

            case 271:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr497;

                goto st0;
st272:

                if ( ++p == pe )
                    goto _test_eof272;

            case 272:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr498;

                case 5:
                    goto tr498;

                case 8:
                    goto tr498;

                case 18:
                    goto tr499;

                case 21:
                    goto tr499;

                case 23:
                    goto tr499;

                case 36:
                    goto tr499;

                case 44:
                    goto tr499;

                case 45:
                    goto st275;

                case 46:
                    goto st279;

                case 47:
                    goto st283;

                case 48:
                    goto st287;

                case 49:
                    goto st291;

                case 50:
                    goto st295;

                case 51:
                    goto st299;

                case 52:
                    goto st303;

                case 79:
                    goto st307;

                case 80:
                    goto st308;

                case 81:
                    goto st310;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr499;

                goto st0;
tr498:

                {
                    expr_start = p;
                }
                goto st273;
st273:

                if ( ++p == pe )
                    goto _test_eof273;

            case 273:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr511;

                case 19:
                    goto st273;

                case 23:
                    goto st274;

                case 37:
                    goto st273;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st274;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st274;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st274;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st274;
                }
                else
                    goto st274;

                goto st0;
tr499:

                {
                    expr_start = p;
                }
                goto st274;
st274:

                if ( ++p == pe )
                    goto _test_eof274;

            case 274:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st273;

                case 5:
                    goto st273;

                case 8:
                    goto st273;

                case 13:
                    goto st274;

                case 18:
                    goto st274;

                case 21:
                    goto st274;

                case 23:
                    goto st274;

                case 36:
                    goto st274;

                case 44:
                    goto st274;
                }

                goto st0;
st275:

                if ( ++p == pe )
                    goto _test_eof275;

            case 275:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st276;

                goto st0;
st276:

                if ( ++p == pe )
                    goto _test_eof276;

            case 276:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr515;

                case 5:
                    goto tr515;

                case 8:
                    goto tr515;

                case 18:
                    goto tr516;

                case 21:
                    goto tr516;

                case 23:
                    goto tr516;

                case 36:
                    goto tr516;

                case 44:
                    goto tr516;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr516;

                goto st0;
tr515:

                {
                    expr_start = p;
                }
                goto st277;
st277:

                if ( ++p == pe )
                    goto _test_eof277;

            case 277:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr517;

                case 19:
                    goto st277;

                case 23:
                    goto st278;

                case 37:
                    goto st277;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st278;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st278;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st278;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st278;
                }
                else
                    goto st278;

                goto st0;
tr516:

                {
                    expr_start = p;
                }
                goto st278;
st278:

                if ( ++p == pe )
                    goto _test_eof278;

            case 278:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st277;

                case 5:
                    goto st277;

                case 8:
                    goto st277;

                case 13:
                    goto st278;

                case 18:
                    goto st278;

                case 21:
                    goto st278;

                case 23:
                    goto st278;

                case 36:
                    goto st278;

                case 44:
                    goto st278;
                }

                goto st0;
st279:

                if ( ++p == pe )
                    goto _test_eof279;

            case 279:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st280;

                goto st0;
st280:

                if ( ++p == pe )
                    goto _test_eof280;

            case 280:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr521;

                case 5:
                    goto tr521;

                case 8:
                    goto tr521;

                case 18:
                    goto tr522;

                case 21:
                    goto tr522;

                case 23:
                    goto tr522;

                case 36:
                    goto tr522;

                case 44:
                    goto tr522;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr522;

                goto st0;
tr521:

                {
                    expr_start = p;
                }
                goto st281;
st281:

                if ( ++p == pe )
                    goto _test_eof281;

            case 281:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr523;

                case 19:
                    goto st281;

                case 23:
                    goto st282;

                case 37:
                    goto st281;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st282;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st282;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st282;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st282;
                }
                else
                    goto st282;

                goto st0;
tr522:

                {
                    expr_start = p;
                }
                goto st282;
st282:

                if ( ++p == pe )
                    goto _test_eof282;

            case 282:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st281;

                case 5:
                    goto st281;

                case 8:
                    goto st281;

                case 13:
                    goto st282;

                case 18:
                    goto st282;

                case 21:
                    goto st282;

                case 23:
                    goto st282;

                case 36:
                    goto st282;

                case 44:
                    goto st282;
                }

                goto st0;
st283:

                if ( ++p == pe )
                    goto _test_eof283;

            case 283:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st284;

                goto st0;
st284:

                if ( ++p == pe )
                    goto _test_eof284;

            case 284:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr527;

                case 5:
                    goto tr527;

                case 8:
                    goto tr527;

                case 18:
                    goto tr528;

                case 21:
                    goto tr528;

                case 23:
                    goto tr528;

                case 36:
                    goto tr528;

                case 44:
                    goto tr528;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr528;

                goto st0;
tr527:

                {
                    expr_start = p;
                }
                goto st285;
st285:

                if ( ++p == pe )
                    goto _test_eof285;

            case 285:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr529;

                case 19:
                    goto st285;

                case 23:
                    goto st286;

                case 37:
                    goto st285;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st286;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st286;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st286;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st286;
                }
                else
                    goto st286;

                goto st0;
tr528:

                {
                    expr_start = p;
                }
                goto st286;
st286:

                if ( ++p == pe )
                    goto _test_eof286;

            case 286:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st285;

                case 5:
                    goto st285;

                case 8:
                    goto st285;

                case 13:
                    goto st286;

                case 18:
                    goto st286;

                case 21:
                    goto st286;

                case 23:
                    goto st286;

                case 36:
                    goto st286;

                case 44:
                    goto st286;
                }

                goto st0;
st287:

                if ( ++p == pe )
                    goto _test_eof287;

            case 287:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st288;

                goto st0;
st288:

                if ( ++p == pe )
                    goto _test_eof288;

            case 288:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr533;

                case 5:
                    goto tr533;

                case 8:
                    goto tr533;

                case 18:
                    goto tr534;

                case 21:
                    goto tr534;

                case 23:
                    goto tr534;

                case 36:
                    goto tr534;

                case 44:
                    goto tr534;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr534;

                goto st0;
tr533:

                {
                    expr_start = p;
                }
                goto st289;
st289:

                if ( ++p == pe )
                    goto _test_eof289;

            case 289:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr535;

                case 19:
                    goto st289;

                case 23:
                    goto st290;

                case 37:
                    goto st289;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st290;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st290;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st290;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st290;
                }
                else
                    goto st290;

                goto st0;
tr534:

                {
                    expr_start = p;
                }
                goto st290;
st290:

                if ( ++p == pe )
                    goto _test_eof290;

            case 290:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st289;

                case 5:
                    goto st289;

                case 8:
                    goto st289;

                case 13:
                    goto st290;

                case 18:
                    goto st290;

                case 21:
                    goto st290;

                case 23:
                    goto st290;

                case 36:
                    goto st290;

                case 44:
                    goto st290;
                }

                goto st0;
st291:

                if ( ++p == pe )
                    goto _test_eof291;

            case 291:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st292;

                goto st0;
st292:

                if ( ++p == pe )
                    goto _test_eof292;

            case 292:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr539;

                case 5:
                    goto tr539;

                case 8:
                    goto tr539;

                case 18:
                    goto tr540;

                case 21:
                    goto tr540;

                case 23:
                    goto tr540;

                case 36:
                    goto tr540;

                case 44:
                    goto tr540;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr540;

                goto st0;
tr539:

                {
                    expr_start = p;
                }
                goto st293;
st293:

                if ( ++p == pe )
                    goto _test_eof293;

            case 293:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr541;

                case 19:
                    goto st293;

                case 23:
                    goto st294;

                case 37:
                    goto st293;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st294;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st294;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st294;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st294;
                }
                else
                    goto st294;

                goto st0;
tr540:

                {
                    expr_start = p;
                }
                goto st294;
st294:

                if ( ++p == pe )
                    goto _test_eof294;

            case 294:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st293;

                case 5:
                    goto st293;

                case 8:
                    goto st293;

                case 13:
                    goto st294;

                case 18:
                    goto st294;

                case 21:
                    goto st294;

                case 23:
                    goto st294;

                case 36:
                    goto st294;

                case 44:
                    goto st294;
                }

                goto st0;
st295:

                if ( ++p == pe )
                    goto _test_eof295;

            case 295:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st296;

                goto st0;
st296:

                if ( ++p == pe )
                    goto _test_eof296;

            case 296:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr545;

                case 5:
                    goto tr545;

                case 8:
                    goto tr545;

                case 18:
                    goto tr546;

                case 21:
                    goto tr546;

                case 23:
                    goto tr546;

                case 36:
                    goto tr546;

                case 44:
                    goto tr546;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr546;

                goto st0;
tr545:

                {
                    expr_start = p;
                }
                goto st297;
st297:

                if ( ++p == pe )
                    goto _test_eof297;

            case 297:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr547;

                case 19:
                    goto st297;

                case 23:
                    goto st298;

                case 37:
                    goto st297;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st298;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st298;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st298;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st298;
                }
                else
                    goto st298;

                goto st0;
tr546:

                {
                    expr_start = p;
                }
                goto st298;
st298:

                if ( ++p == pe )
                    goto _test_eof298;

            case 298:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st297;

                case 5:
                    goto st297;

                case 8:
                    goto st297;

                case 13:
                    goto st298;

                case 18:
                    goto st298;

                case 21:
                    goto st298;

                case 23:
                    goto st298;

                case 36:
                    goto st298;

                case 44:
                    goto st298;
                }

                goto st0;
st299:

                if ( ++p == pe )
                    goto _test_eof299;

            case 299:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st300;

                goto st0;
st300:

                if ( ++p == pe )
                    goto _test_eof300;

            case 300:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr551;

                case 5:
                    goto tr551;

                case 8:
                    goto tr551;

                case 18:
                    goto tr552;

                case 21:
                    goto tr552;

                case 23:
                    goto tr552;

                case 36:
                    goto tr552;

                case 44:
                    goto tr552;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr552;

                goto st0;
tr551:

                {
                    expr_start = p;
                }
                goto st301;
st301:

                if ( ++p == pe )
                    goto _test_eof301;

            case 301:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr553;

                case 19:
                    goto st301;

                case 23:
                    goto st302;

                case 37:
                    goto st301;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st302;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st302;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st302;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st302;
                }
                else
                    goto st302;

                goto st0;
tr552:

                {
                    expr_start = p;
                }
                goto st302;
st302:

                if ( ++p == pe )
                    goto _test_eof302;

            case 302:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st301;

                case 5:
                    goto st301;

                case 8:
                    goto st301;

                case 13:
                    goto st302;

                case 18:
                    goto st302;

                case 21:
                    goto st302;

                case 23:
                    goto st302;

                case 36:
                    goto st302;

                case 44:
                    goto st302;
                }

                goto st0;
st303:

                if ( ++p == pe )
                    goto _test_eof303;

            case 303:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st304;

                goto st0;
st304:

                if ( ++p == pe )
                    goto _test_eof304;

            case 304:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr557;

                case 5:
                    goto tr557;

                case 8:
                    goto tr557;

                case 18:
                    goto tr558;

                case 21:
                    goto tr558;

                case 23:
                    goto tr558;

                case 36:
                    goto tr558;

                case 44:
                    goto tr558;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr558;

                goto st0;
tr557:

                {
                    expr_start = p;
                }
                goto st305;
st305:

                if ( ++p == pe )
                    goto _test_eof305;

            case 305:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr559;

                case 19:
                    goto st305;

                case 23:
                    goto st306;

                case 37:
                    goto st305;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st306;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st306;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st306;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st306;
                }
                else
                    goto st306;

                goto st0;
tr558:

                {
                    expr_start = p;
                }
                goto st306;
st306:

                if ( ++p == pe )
                    goto _test_eof306;

            case 306:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st305;

                case 5:
                    goto st305;

                case 8:
                    goto st305;

                case 13:
                    goto st306;

                case 18:
                    goto st306;

                case 21:
                    goto st306;

                case 23:
                    goto st306;

                case 36:
                    goto st306;

                case 44:
                    goto st306;
                }

                goto st0;
st307:

                if ( ++p == pe )
                    goto _test_eof307;

            case 307:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr562;

                goto st0;
st308:

                if ( ++p == pe )
                    goto _test_eof308;

            case 308:
                if ( ( ( ( int ) p->tok ) ) == 19 )
                    goto st309;

                goto st0;
st309:

                if ( ++p == pe )
                    goto _test_eof309;

            case 309:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr564;

                goto st0;
st310:

                if ( ++p == pe )
                    goto _test_eof310;

            case 310:
                if ( ( ( ( int ) p->tok ) ) == 19 )
                    goto st311;

                goto st0;
st311:

                if ( ++p == pe )
                    goto _test_eof311;

            case 311:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr566;

                goto st0;
st312:

                if ( ++p == pe )
                    goto _test_eof312;

            case 312:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr567;

                case 5:
                    goto tr567;

                case 8:
                    goto tr567;

                case 18:
                    goto tr568;

                case 21:
                    goto tr568;

                case 23:
                    goto tr568;

                case 36:
                    goto tr568;

                case 44:
                    goto tr568;

                case 45:
                    goto st315;

                case 46:
                    goto st319;

                case 47:
                    goto st323;

                case 48:
                    goto st327;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr568;

                goto st0;
tr567:

                {
                    expr_start = p;
                }
                goto st313;
st313:

                if ( ++p == pe )
                    goto _test_eof313;

            case 313:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr573;

                case 19:
                    goto st313;

                case 23:
                    goto st314;

                case 37:
                    goto st313;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st314;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st314;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st314;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st314;
                }
                else
                    goto st314;

                goto st0;
tr568:

                {
                    expr_start = p;
                }
                goto st314;
st314:

                if ( ++p == pe )
                    goto _test_eof314;

            case 314:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st313;

                case 5:
                    goto st313;

                case 8:
                    goto st313;

                case 13:
                    goto st314;

                case 18:
                    goto st314;

                case 21:
                    goto st314;

                case 23:
                    goto st314;

                case 36:
                    goto st314;

                case 44:
                    goto st314;
                }

                goto st0;
st315:

                if ( ++p == pe )
                    goto _test_eof315;

            case 315:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st316;

                goto st0;
st316:

                if ( ++p == pe )
                    goto _test_eof316;

            case 316:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr577;

                case 5:
                    goto tr577;

                case 8:
                    goto tr577;

                case 18:
                    goto tr578;

                case 21:
                    goto tr578;

                case 23:
                    goto tr578;

                case 36:
                    goto tr578;

                case 44:
                    goto tr578;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr578;

                goto st0;
tr577:

                {
                    expr_start = p;
                }
                goto st317;
st317:

                if ( ++p == pe )
                    goto _test_eof317;

            case 317:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr579;

                case 19:
                    goto st317;

                case 23:
                    goto st318;

                case 37:
                    goto st317;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st318;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st318;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st318;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st318;
                }
                else
                    goto st318;

                goto st0;
tr578:

                {
                    expr_start = p;
                }
                goto st318;
st318:

                if ( ++p == pe )
                    goto _test_eof318;

            case 318:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st317;

                case 5:
                    goto st317;

                case 8:
                    goto st317;

                case 13:
                    goto st318;

                case 18:
                    goto st318;

                case 21:
                    goto st318;

                case 23:
                    goto st318;

                case 36:
                    goto st318;

                case 44:
                    goto st318;
                }

                goto st0;
st319:

                if ( ++p == pe )
                    goto _test_eof319;

            case 319:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st320;

                goto st0;
st320:

                if ( ++p == pe )
                    goto _test_eof320;

            case 320:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr583;

                case 5:
                    goto tr583;

                case 8:
                    goto tr583;

                case 18:
                    goto tr584;

                case 21:
                    goto tr584;

                case 23:
                    goto tr584;

                case 36:
                    goto tr584;

                case 44:
                    goto tr584;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr584;

                goto st0;
tr583:

                {
                    expr_start = p;
                }
                goto st321;
st321:

                if ( ++p == pe )
                    goto _test_eof321;

            case 321:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr585;

                case 19:
                    goto st321;

                case 23:
                    goto st322;

                case 37:
                    goto st321;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st322;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st322;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st322;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st322;
                }
                else
                    goto st322;

                goto st0;
tr584:

                {
                    expr_start = p;
                }
                goto st322;
st322:

                if ( ++p == pe )
                    goto _test_eof322;

            case 322:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st321;

                case 5:
                    goto st321;

                case 8:
                    goto st321;

                case 13:
                    goto st322;

                case 18:
                    goto st322;

                case 21:
                    goto st322;

                case 23:
                    goto st322;

                case 36:
                    goto st322;

                case 44:
                    goto st322;
                }

                goto st0;
st323:

                if ( ++p == pe )
                    goto _test_eof323;

            case 323:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st324;

                goto st0;
st324:

                if ( ++p == pe )
                    goto _test_eof324;

            case 324:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr589;

                case 5:
                    goto tr589;

                case 8:
                    goto tr589;

                case 18:
                    goto tr590;

                case 21:
                    goto tr590;

                case 23:
                    goto tr590;

                case 36:
                    goto tr590;

                case 44:
                    goto tr590;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr590;

                goto st0;
tr589:

                {
                    expr_start = p;
                }
                goto st325;
st325:

                if ( ++p == pe )
                    goto _test_eof325;

            case 325:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr591;

                case 19:
                    goto st325;

                case 23:
                    goto st326;

                case 37:
                    goto st325;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st326;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st326;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st326;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st326;
                }
                else
                    goto st326;

                goto st0;
tr590:

                {
                    expr_start = p;
                }
                goto st326;
st326:

                if ( ++p == pe )
                    goto _test_eof326;

            case 326:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st325;

                case 5:
                    goto st325;

                case 8:
                    goto st325;

                case 13:
                    goto st326;

                case 18:
                    goto st326;

                case 21:
                    goto st326;

                case 23:
                    goto st326;

                case 36:
                    goto st326;

                case 44:
                    goto st326;
                }

                goto st0;
st327:

                if ( ++p == pe )
                    goto _test_eof327;

            case 327:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st328;

                goto st0;
st328:

                if ( ++p == pe )
                    goto _test_eof328;

            case 328:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr595;

                case 5:
                    goto tr595;

                case 8:
                    goto tr595;

                case 18:
                    goto tr596;

                case 21:
                    goto tr596;

                case 23:
                    goto tr596;

                case 36:
                    goto tr596;

                case 44:
                    goto tr596;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr596;

                goto st0;
tr595:

                {
                    expr_start = p;
                }
                goto st329;
st329:

                if ( ++p == pe )
                    goto _test_eof329;

            case 329:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr597;

                case 19:
                    goto st329;

                case 23:
                    goto st330;

                case 37:
                    goto st329;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st330;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st330;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st330;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st330;
                }
                else
                    goto st330;

                goto st0;
tr596:

                {
                    expr_start = p;
                }
                goto st330;
st330:

                if ( ++p == pe )
                    goto _test_eof330;

            case 330:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st329;

                case 5:
                    goto st329;

                case 8:
                    goto st329;

                case 13:
                    goto st330;

                case 18:
                    goto st330;

                case 21:
                    goto st330;

                case 23:
                    goto st330;

                case 36:
                    goto st330;

                case 44:
                    goto st330;
                }

                goto st0;
st331:

                if ( ++p == pe )
                    goto _test_eof331;

            case 331:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr600;

                goto st0;
st332:

                if ( ++p == pe )
                    goto _test_eof332;

            case 332:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr601;

                goto st0;
st333:

                if ( ++p == pe )
                    goto _test_eof333;

            case 333:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr602;

                goto st0;
st334:

                if ( ++p == pe )
                    goto _test_eof334;

            case 334:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr603;

                goto st0;
st335:

                if ( ++p == pe )
                    goto _test_eof335;

            case 335:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr604;

                goto st0;
st336:

                if ( ++p == pe )
                    goto _test_eof336;

            case 336:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr605;

                goto st0;
st337:

                if ( ++p == pe )
                    goto _test_eof337;

            case 337:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr606;

                case 5:
                    goto tr606;

                case 8:
                    goto tr606;

                case 18:
                    goto tr607;

                case 21:
                    goto tr607;

                case 23:
                    goto tr607;

                case 36:
                    goto tr607;

                case 44:
                    goto tr607;

                case 48:
                    goto st340;

                case 53:
                    goto st341;

                case 54:
                    goto st342;

                case 55:
                    goto st343;

                case 56:
                    goto st344;

                case 57:
                    goto st345;

                case 58:
                    goto st346;

                case 59:
                    goto st347;

                case 60:
                    goto st348;

                case 61:
                    goto st349;

                case 62:
                    goto st350;

                case 79:
                    goto st353;

                case 80:
                    goto st354;

                case 81:
                    goto st364;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr607;

                goto st0;
tr606:

                {
                    expr_start = p;
                }
                goto st338;
st338:

                if ( ++p == pe )
                    goto _test_eof338;

            case 338:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr622;

                case 19:
                    goto st338;

                case 23:
                    goto st339;

                case 37:
                    goto st338;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st339;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st339;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st339;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st339;
                }
                else
                    goto st339;

                goto st0;
tr607:

                {
                    expr_start = p;
                }
                goto st339;
st339:

                if ( ++p == pe )
                    goto _test_eof339;

            case 339:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st338;

                case 5:
                    goto st338;

                case 8:
                    goto st338;

                case 13:
                    goto st339;

                case 18:
                    goto st339;

                case 21:
                    goto st339;

                case 23:
                    goto st339;

                case 36:
                    goto st339;

                case 44:
                    goto st339;
                }

                goto st0;
st340:

                if ( ++p == pe )
                    goto _test_eof340;

            case 340:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr625;

                goto st0;
st341:

                if ( ++p == pe )
                    goto _test_eof341;

            case 341:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr626;

                goto st0;
st342:

                if ( ++p == pe )
                    goto _test_eof342;

            case 342:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr627;

                goto st0;
st343:

                if ( ++p == pe )
                    goto _test_eof343;

            case 343:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr628;

                goto st0;
st344:

                if ( ++p == pe )
                    goto _test_eof344;

            case 344:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr629;

                goto st0;
st345:

                if ( ++p == pe )
                    goto _test_eof345;

            case 345:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr630;

                goto st0;
st346:

                if ( ++p == pe )
                    goto _test_eof346;

            case 346:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr631;

                goto st0;
st347:

                if ( ++p == pe )
                    goto _test_eof347;

            case 347:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr632;

                goto st0;
st348:

                if ( ++p == pe )
                    goto _test_eof348;

            case 348:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr633;

                goto st0;
st349:

                if ( ++p == pe )
                    goto _test_eof349;

            case 349:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr634;

                goto st0;
st350:

                if ( ++p == pe )
                    goto _test_eof350;

            case 350:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr635;

                case 22:
                    goto st351;
                }

                goto st0;
st351:

                if ( ++p == pe )
                    goto _test_eof351;

            case 351:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr606;

                case 5:
                    goto tr606;

                case 8:
                    goto tr606;

                case 18:
                    goto tr607;

                case 21:
                    goto tr607;

                case 23:
                    goto tr607;

                case 36:
                    goto tr607;

                case 44:
                    goto tr607;

                case 48:
                    goto st340;

                case 53:
                    goto st341;

                case 54:
                    goto st342;

                case 55:
                    goto st343;

                case 56:
                    goto st344;

                case 57:
                    goto st345;

                case 58:
                    goto st346;

                case 59:
                    goto st347;

                case 60:
                    goto st348;

                case 61:
                    goto st349;

                case 62:
                    goto st352;

                case 79:
                    goto st353;

                case 80:
                    goto st354;

                case 81:
                    goto st364;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr607;

                goto st0;
st352:

                if ( ++p == pe )
                    goto _test_eof352;

            case 352:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr635;

                goto st0;
st353:

                if ( ++p == pe )
                    goto _test_eof353;

            case 353:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr638;

                goto st0;
st354:

                if ( ++p == pe )
                    goto _test_eof354;

            case 354:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st355;

                case 21:
                    goto st356;

                case 23:
                    goto st360;
                }

                goto st0;
st355:

                if ( ++p == pe )
                    goto _test_eof355;

            case 355:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr642;

                goto st0;
st356:

                if ( ++p == pe )
                    goto _test_eof356;

            case 356:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr643;

                case 5:
                    goto tr643;

                case 8:
                    goto tr643;

                case 18:
                    goto tr644;

                case 21:
                    goto tr644;

                case 23:
                    goto tr644;

                case 36:
                    goto tr644;

                case 44:
                    goto tr644;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr644;

                goto st0;
tr643:

                {
                    expr_start = p;
                }
                goto st357;
st357:

                if ( ++p == pe )
                    goto _test_eof357;

            case 357:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr645;

                case 23:
                    goto st24;

                case 37:
                    goto st357;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr645:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st358;
st358:

                if ( ++p == pe )
                    goto _test_eof358;

            case 358:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr647;

                case 19:
                    goto tr645;

                case 23:
                    goto st24;

                case 37:
                    goto st357;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr644:

                {
                    expr_start = p;
                }
                goto st359;
st359:

                if ( ++p == pe )
                    goto _test_eof359;

            case 359:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st357;

                case 5:
                    goto st357;

                case 8:
                    goto st357;

                case 13:
                    goto st359;

                case 18:
                    goto st359;

                case 21:
                    goto st359;

                case 23:
                    goto st359;

                case 36:
                    goto st359;

                case 44:
                    goto st359;
                }

                goto st0;
st360:

                if ( ++p == pe )
                    goto _test_eof360;

            case 360:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr649;

                case 5:
                    goto tr649;

                case 8:
                    goto tr649;

                case 18:
                    goto tr650;

                case 21:
                    goto tr650;

                case 23:
                    goto tr650;

                case 36:
                    goto tr650;

                case 44:
                    goto tr650;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr650;

                goto st0;
tr649:

                {
                    expr_start = p;
                }
                goto st361;
st361:

                if ( ++p == pe )
                    goto _test_eof361;

            case 361:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr651;

                case 23:
                    goto st24;

                case 37:
                    goto st361;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr651:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st362;
st362:

                if ( ++p == pe )
                    goto _test_eof362;

            case 362:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr653;

                case 19:
                    goto tr651;

                case 23:
                    goto st24;

                case 37:
                    goto st361;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr650:

                {
                    expr_start = p;
                }
                goto st363;
st363:

                if ( ++p == pe )
                    goto _test_eof363;

            case 363:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st361;

                case 5:
                    goto st361;

                case 8:
                    goto st361;

                case 13:
                    goto st363;

                case 18:
                    goto st363;

                case 21:
                    goto st363;

                case 23:
                    goto st363;

                case 36:
                    goto st363;

                case 44:
                    goto st363;
                }

                goto st0;
st364:

                if ( ++p == pe )
                    goto _test_eof364;

            case 364:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st365;

                case 21:
                    goto st366;

                case 23:
                    goto st370;
                }

                goto st0;
st365:

                if ( ++p == pe )
                    goto _test_eof365;

            case 365:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr658;

                goto st0;
st366:

                if ( ++p == pe )
                    goto _test_eof366;

            case 366:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr659;

                case 5:
                    goto tr659;

                case 8:
                    goto tr659;

                case 18:
                    goto tr660;

                case 21:
                    goto tr660;

                case 23:
                    goto tr660;

                case 36:
                    goto tr660;

                case 44:
                    goto tr660;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr660;

                goto st0;
tr659:

                {
                    expr_start = p;
                }
                goto st367;
st367:

                if ( ++p == pe )
                    goto _test_eof367;

            case 367:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr661;

                case 23:
                    goto st24;

                case 37:
                    goto st367;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr661:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st368;
st368:

                if ( ++p == pe )
                    goto _test_eof368;

            case 368:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr663;

                case 19:
                    goto tr661;

                case 23:
                    goto st24;

                case 37:
                    goto st367;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr660:

                {
                    expr_start = p;
                }
                goto st369;
st369:

                if ( ++p == pe )
                    goto _test_eof369;

            case 369:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st367;

                case 5:
                    goto st367;

                case 8:
                    goto st367;

                case 13:
                    goto st369;

                case 18:
                    goto st369;

                case 21:
                    goto st369;

                case 23:
                    goto st369;

                case 36:
                    goto st369;

                case 44:
                    goto st369;
                }

                goto st0;
st370:

                if ( ++p == pe )
                    goto _test_eof370;

            case 370:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr665;

                case 5:
                    goto tr665;

                case 8:
                    goto tr665;

                case 18:
                    goto tr666;

                case 21:
                    goto tr666;

                case 23:
                    goto tr666;

                case 36:
                    goto tr666;

                case 44:
                    goto tr666;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr666;

                goto st0;
tr665:

                {
                    expr_start = p;
                }
                goto st371;
st371:

                if ( ++p == pe )
                    goto _test_eof371;

            case 371:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr667;

                case 23:
                    goto st24;

                case 37:
                    goto st371;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr667:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st372;
st372:

                if ( ++p == pe )
                    goto _test_eof372;

            case 372:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr669;

                case 19:
                    goto tr667;

                case 23:
                    goto st24;

                case 37:
                    goto st371;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr666:

                {
                    expr_start = p;
                }
                goto st373;
st373:

                if ( ++p == pe )
                    goto _test_eof373;

            case 373:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st371;

                case 5:
                    goto st371;

                case 8:
                    goto st371;

                case 13:
                    goto st373;

                case 18:
                    goto st373;

                case 21:
                    goto st373;

                case 23:
                    goto st373;

                case 36:
                    goto st373;

                case 44:
                    goto st373;
                }

                goto st0;
st374:

                if ( ++p == pe )
                    goto _test_eof374;

            case 374:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr671;

                goto st0;
st375:

                if ( ++p == pe )
                    goto _test_eof375;

            case 375:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr672;

                goto st0;
st376:

                if ( ++p == pe )
                    goto _test_eof376;

            case 376:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr673;

                goto st0;
st377:

                if ( ++p == pe )
                    goto _test_eof377;

            case 377:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr674;

                goto st0;
st378:

                if ( ++p == pe )
                    goto _test_eof378;

            case 378:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st379;

                case 70:
                    goto st380;

                case 71:
                    goto st381;

                case 72:
                    goto st382;

                case 73:
                    goto st383;

                case 74:
                    goto st384;
                }

                goto st0;
st379:

                if ( ++p == pe )
                    goto _test_eof379;

            case 379:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr681;

                goto st0;
st380:

                if ( ++p == pe )
                    goto _test_eof380;

            case 380:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr682;

                goto st0;
st381:

                if ( ++p == pe )
                    goto _test_eof381;

            case 381:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr683;

                goto st0;
st382:

                if ( ++p == pe )
                    goto _test_eof382;

            case 382:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr684;

                goto st0;
st383:

                if ( ++p == pe )
                    goto _test_eof383;

            case 383:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr685;

                goto st0;
st384:

                if ( ++p == pe )
                    goto _test_eof384;

            case 384:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr686;

                goto st0;
st385:

                if ( ++p == pe )
                    goto _test_eof385;

            case 385:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st386;

                case 70:
                    goto st387;

                case 71:
                    goto st388;

                case 72:
                    goto st389;

                case 73:
                    goto st390;

                case 74:
                    goto st391;
                }

                goto st0;
st386:

                if ( ++p == pe )
                    goto _test_eof386;

            case 386:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr693;

                goto st0;
st387:

                if ( ++p == pe )
                    goto _test_eof387;

            case 387:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr694;

                goto st0;
st388:

                if ( ++p == pe )
                    goto _test_eof388;

            case 388:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr695;

                goto st0;
st389:

                if ( ++p == pe )
                    goto _test_eof389;

            case 389:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr696;

                goto st0;
st390:

                if ( ++p == pe )
                    goto _test_eof390;

            case 390:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr697;

                goto st0;
st391:

                if ( ++p == pe )
                    goto _test_eof391;

            case 391:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr698;

                goto st0;
st392:

                if ( ++p == pe )
                    goto _test_eof392;

            case 392:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr699;

                case 45:
                    goto st393;

                case 46:
                    goto st394;

                case 47:
                    goto st395;

                case 48:
                    goto st396;

                case 49:
                    goto st397;

                case 50:
                    goto st398;

                case 51:
                    goto st399;

                case 52:
                    goto st400;
                }

                goto st0;
st393:

                if ( ++p == pe )
                    goto _test_eof393;

            case 393:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr708;

                goto st0;
st394:

                if ( ++p == pe )
                    goto _test_eof394;

            case 394:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr709;

                goto st0;
st395:

                if ( ++p == pe )
                    goto _test_eof395;

            case 395:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr710;

                goto st0;
st396:

                if ( ++p == pe )
                    goto _test_eof396;

            case 396:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr711;

                goto st0;
st397:

                if ( ++p == pe )
                    goto _test_eof397;

            case 397:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr712;

                goto st0;
st398:

                if ( ++p == pe )
                    goto _test_eof398;

            case 398:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr713;

                goto st0;
st399:

                if ( ++p == pe )
                    goto _test_eof399;

            case 399:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr714;

                goto st0;
st400:

                if ( ++p == pe )
                    goto _test_eof400;

            case 400:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr715;

                goto st0;
st401:

                if ( ++p == pe )
                    goto _test_eof401;

            case 401:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr716;

                goto st0;
st402:

                if ( ++p == pe )
                    goto _test_eof402;

            case 402:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr717;

                goto st0;
st403:

                if ( ++p == pe )
                    goto _test_eof403;

            case 403:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr718;

                goto st0;
st404:

                if ( ++p == pe )
                    goto _test_eof404;

            case 404:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr719;

                goto st0;
st405:

                if ( ++p == pe )
                    goto _test_eof405;

            case 405:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr720;

                goto st0;
st406:

                if ( ++p == pe )
                    goto _test_eof406;

            case 406:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr721;

                goto st0;
st407:

                if ( ++p == pe )
                    goto _test_eof407;

            case 407:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr722;

                goto st0;
st408:

                if ( ++p == pe )
                    goto _test_eof408;

            case 408:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr723;

                goto st0;
st409:

                if ( ++p == pe )
                    goto _test_eof409;

            case 409:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr724;

                case 5:
                    goto tr724;

                case 8:
                    goto tr724;

                case 18:
                    goto tr725;

                case 21:
                    goto tr725;

                case 23:
                    goto tr725;

                case 36:
                    goto tr725;

                case 44:
                    goto tr725;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr725;

                goto st0;
tr724:

                {
                    expr_start = p;
                }
                goto st410;
st410:

                if ( ++p == pe )
                    goto _test_eof410;

            case 410:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr726;

                case 19:
                    goto st410;

                case 23:
                    goto st411;

                case 37:
                    goto st410;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st411;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st411;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st411;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st411;
                }
                else
                    goto st411;

                goto st0;
tr725:

                {
                    expr_start = p;
                }
                goto st411;
st411:

                if ( ++p == pe )
                    goto _test_eof411;

            case 411:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st410;

                case 5:
                    goto st410;

                case 8:
                    goto st410;

                case 13:
                    goto st411;

                case 18:
                    goto st411;

                case 21:
                    goto st411;

                case 23:
                    goto st411;

                case 36:
                    goto st411;

                case 44:
                    goto st411;
                }

                goto st0;
st412:

                if ( ++p == pe )
                    goto _test_eof412;

            case 412:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr729;

                case 5:
                    goto tr729;

                case 8:
                    goto tr729;

                case 18:
                    goto tr730;

                case 21:
                    goto tr730;

                case 23:
                    goto tr730;

                case 36:
                    goto tr730;

                case 44:
                    goto tr730;

                case 48:
                    goto st415;

                case 53:
                    goto st416;

                case 54:
                    goto st417;

                case 55:
                    goto st418;

                case 56:
                    goto st419;

                case 57:
                    goto st420;

                case 58:
                    goto st421;

                case 59:
                    goto st422;

                case 60:
                    goto st423;

                case 61:
                    goto st424;

                case 62:
                    goto st425;

                case 71:
                    goto st449;

                case 79:
                    goto st428;

                case 80:
                    goto st429;

                case 81:
                    goto st439;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr730;

                goto st0;
tr729:

                {
                    expr_start = p;
                }
                goto st413;
st413:

                if ( ++p == pe )
                    goto _test_eof413;

            case 413:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr746;

                case 19:
                    goto st413;

                case 23:
                    goto st414;

                case 37:
                    goto st413;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st414;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st414;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st414;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st414;
                }
                else
                    goto st414;

                goto st0;
tr730:

                {
                    expr_start = p;
                }
                goto st414;
st414:

                if ( ++p == pe )
                    goto _test_eof414;

            case 414:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st413;

                case 5:
                    goto st413;

                case 8:
                    goto st413;

                case 13:
                    goto st414;

                case 18:
                    goto st414;

                case 21:
                    goto st414;

                case 23:
                    goto st414;

                case 36:
                    goto st414;

                case 44:
                    goto st414;
                }

                goto st0;
st415:

                if ( ++p == pe )
                    goto _test_eof415;

            case 415:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr749;

                goto st0;
st416:

                if ( ++p == pe )
                    goto _test_eof416;

            case 416:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr750;

                goto st0;
st417:

                if ( ++p == pe )
                    goto _test_eof417;

            case 417:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr751;

                goto st0;
st418:

                if ( ++p == pe )
                    goto _test_eof418;

            case 418:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr752;

                goto st0;
st419:

                if ( ++p == pe )
                    goto _test_eof419;

            case 419:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr753;

                goto st0;
st420:

                if ( ++p == pe )
                    goto _test_eof420;

            case 420:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr754;

                goto st0;
st421:

                if ( ++p == pe )
                    goto _test_eof421;

            case 421:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr755;

                goto st0;
st422:

                if ( ++p == pe )
                    goto _test_eof422;

            case 422:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr756;

                goto st0;
st423:

                if ( ++p == pe )
                    goto _test_eof423;

            case 423:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr757;

                goto st0;
st424:

                if ( ++p == pe )
                    goto _test_eof424;

            case 424:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr758;

                goto st0;
st425:

                if ( ++p == pe )
                    goto _test_eof425;

            case 425:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr759;

                case 22:
                    goto st426;
                }

                goto st0;
st426:

                if ( ++p == pe )
                    goto _test_eof426;

            case 426:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr729;

                case 5:
                    goto tr729;

                case 8:
                    goto tr729;

                case 18:
                    goto tr730;

                case 21:
                    goto tr730;

                case 23:
                    goto tr730;

                case 36:
                    goto tr730;

                case 44:
                    goto tr730;

                case 48:
                    goto st415;

                case 53:
                    goto st416;

                case 54:
                    goto st417;

                case 55:
                    goto st418;

                case 56:
                    goto st419;

                case 57:
                    goto st420;

                case 58:
                    goto st421;

                case 59:
                    goto st422;

                case 60:
                    goto st423;

                case 61:
                    goto st424;

                case 62:
                    goto st427;

                case 79:
                    goto st428;

                case 80:
                    goto st429;

                case 81:
                    goto st439;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr730;

                goto st0;
st427:

                if ( ++p == pe )
                    goto _test_eof427;

            case 427:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr759;

                goto st0;
st428:

                if ( ++p == pe )
                    goto _test_eof428;

            case 428:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr762;

                goto st0;
st429:

                if ( ++p == pe )
                    goto _test_eof429;

            case 429:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st430;

                case 21:
                    goto st431;

                case 23:
                    goto st435;
                }

                goto st0;
st430:

                if ( ++p == pe )
                    goto _test_eof430;

            case 430:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr766;

                goto st0;
st431:

                if ( ++p == pe )
                    goto _test_eof431;

            case 431:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr767;

                case 5:
                    goto tr767;

                case 8:
                    goto tr767;

                case 18:
                    goto tr768;

                case 21:
                    goto tr768;

                case 23:
                    goto tr768;

                case 36:
                    goto tr768;

                case 44:
                    goto tr768;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr768;

                goto st0;
tr767:

                {
                    expr_start = p;
                }
                goto st432;
st432:

                if ( ++p == pe )
                    goto _test_eof432;

            case 432:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr769;

                case 23:
                    goto st24;

                case 37:
                    goto st432;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr769:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st433;
st433:

                if ( ++p == pe )
                    goto _test_eof433;

            case 433:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr771;

                case 19:
                    goto tr769;

                case 23:
                    goto st24;

                case 37:
                    goto st432;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr768:

                {
                    expr_start = p;
                }
                goto st434;
st434:

                if ( ++p == pe )
                    goto _test_eof434;

            case 434:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st432;

                case 5:
                    goto st432;

                case 8:
                    goto st432;

                case 13:
                    goto st434;

                case 18:
                    goto st434;

                case 21:
                    goto st434;

                case 23:
                    goto st434;

                case 36:
                    goto st434;

                case 44:
                    goto st434;
                }

                goto st0;
st435:

                if ( ++p == pe )
                    goto _test_eof435;

            case 435:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr773;

                case 5:
                    goto tr773;

                case 8:
                    goto tr773;

                case 18:
                    goto tr774;

                case 21:
                    goto tr774;

                case 23:
                    goto tr774;

                case 36:
                    goto tr774;

                case 44:
                    goto tr774;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr774;

                goto st0;
tr773:

                {
                    expr_start = p;
                }
                goto st436;
st436:

                if ( ++p == pe )
                    goto _test_eof436;

            case 436:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr775;

                case 23:
                    goto st24;

                case 37:
                    goto st436;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr775:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st437;
st437:

                if ( ++p == pe )
                    goto _test_eof437;

            case 437:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr777;

                case 19:
                    goto tr775;

                case 23:
                    goto st24;

                case 37:
                    goto st436;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr774:

                {
                    expr_start = p;
                }
                goto st438;
st438:

                if ( ++p == pe )
                    goto _test_eof438;

            case 438:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st436;

                case 5:
                    goto st436;

                case 8:
                    goto st436;

                case 13:
                    goto st438;

                case 18:
                    goto st438;

                case 21:
                    goto st438;

                case 23:
                    goto st438;

                case 36:
                    goto st438;

                case 44:
                    goto st438;
                }

                goto st0;
st439:

                if ( ++p == pe )
                    goto _test_eof439;

            case 439:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st440;

                case 21:
                    goto st441;

                case 23:
                    goto st445;
                }

                goto st0;
st440:

                if ( ++p == pe )
                    goto _test_eof440;

            case 440:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr782;

                goto st0;
st441:

                if ( ++p == pe )
                    goto _test_eof441;

            case 441:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr783;

                case 5:
                    goto tr783;

                case 8:
                    goto tr783;

                case 18:
                    goto tr784;

                case 21:
                    goto tr784;

                case 23:
                    goto tr784;

                case 36:
                    goto tr784;

                case 44:
                    goto tr784;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr784;

                goto st0;
tr783:

                {
                    expr_start = p;
                }
                goto st442;
st442:

                if ( ++p == pe )
                    goto _test_eof442;

            case 442:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr785;

                case 23:
                    goto st24;

                case 37:
                    goto st442;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr785:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st443;
st443:

                if ( ++p == pe )
                    goto _test_eof443;

            case 443:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr787;

                case 19:
                    goto tr785;

                case 23:
                    goto st24;

                case 37:
                    goto st442;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr784:

                {
                    expr_start = p;
                }
                goto st444;
st444:

                if ( ++p == pe )
                    goto _test_eof444;

            case 444:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st442;

                case 5:
                    goto st442;

                case 8:
                    goto st442;

                case 13:
                    goto st444;

                case 18:
                    goto st444;

                case 21:
                    goto st444;

                case 23:
                    goto st444;

                case 36:
                    goto st444;

                case 44:
                    goto st444;
                }

                goto st0;
st445:

                if ( ++p == pe )
                    goto _test_eof445;

            case 445:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr789;

                case 5:
                    goto tr789;

                case 8:
                    goto tr789;

                case 18:
                    goto tr790;

                case 21:
                    goto tr790;

                case 23:
                    goto tr790;

                case 36:
                    goto tr790;

                case 44:
                    goto tr790;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr790;

                goto st0;
tr789:

                {
                    expr_start = p;
                }
                goto st446;
st446:

                if ( ++p == pe )
                    goto _test_eof446;

            case 446:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr791;

                case 23:
                    goto st24;

                case 37:
                    goto st446;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr791:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st447;
st447:

                if ( ++p == pe )
                    goto _test_eof447;

            case 447:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr793;

                case 19:
                    goto tr791;

                case 23:
                    goto st24;

                case 37:
                    goto st446;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr790:

                {
                    expr_start = p;
                }
                goto st448;
st448:

                if ( ++p == pe )
                    goto _test_eof448;

            case 448:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st446;

                case 5:
                    goto st446;

                case 8:
                    goto st446;

                case 13:
                    goto st448;

                case 18:
                    goto st448;

                case 21:
                    goto st448;

                case 23:
                    goto st448;

                case 36:
                    goto st448;

                case 44:
                    goto st448;
                }

                goto st0;
st449:

                if ( ++p == pe )
                    goto _test_eof449;

            case 449:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st450;

                goto st0;
st450:

                if ( ++p == pe )
                    goto _test_eof450;

            case 450:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st451;

                case 70:
                    goto st452;

                case 71:
                    goto st453;

                case 75:
                    goto st454;
                }

                goto st0;
st451:

                if ( ++p == pe )
                    goto _test_eof451;

            case 451:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr800;

                goto st0;
st452:

                if ( ++p == pe )
                    goto _test_eof452;

            case 452:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr801;

                goto st0;
st453:

                if ( ++p == pe )
                    goto _test_eof453;

            case 453:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr802;

                goto st0;
st454:

                if ( ++p == pe )
                    goto _test_eof454;

            case 454:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr803;

                goto st0;
st455:

                if ( ++p == pe )
                    goto _test_eof455;

            case 455:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr804;

                goto st0;
st456:

                if ( ++p == pe )
                    goto _test_eof456;

            case 456:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr805;

                case 5:
                    goto tr805;

                case 8:
                    goto tr805;

                case 18:
                    goto tr806;

                case 21:
                    goto tr806;

                case 23:
                    goto tr806;

                case 36:
                    goto tr806;

                case 44:
                    goto tr806;

                case 48:
                    goto st459;

                case 53:
                    goto st460;

                case 54:
                    goto st461;

                case 55:
                    goto st462;

                case 56:
                    goto st463;

                case 57:
                    goto st464;

                case 58:
                    goto st465;

                case 59:
                    goto st466;

                case 60:
                    goto st467;

                case 61:
                    goto st468;

                case 62:
                    goto st469;

                case 79:
                    goto st472;

                case 80:
                    goto st473;

                case 81:
                    goto st483;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr806;

                goto st0;
tr805:

                {
                    expr_start = p;
                }
                goto st457;
st457:

                if ( ++p == pe )
                    goto _test_eof457;

            case 457:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr821;

                case 19:
                    goto st457;

                case 23:
                    goto st458;

                case 37:
                    goto st457;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st458;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st458;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st458;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st458;
                }
                else
                    goto st458;

                goto st0;
tr806:

                {
                    expr_start = p;
                }
                goto st458;
st458:

                if ( ++p == pe )
                    goto _test_eof458;

            case 458:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st457;

                case 5:
                    goto st457;

                case 8:
                    goto st457;

                case 13:
                    goto st458;

                case 18:
                    goto st458;

                case 21:
                    goto st458;

                case 23:
                    goto st458;

                case 36:
                    goto st458;

                case 44:
                    goto st458;
                }

                goto st0;
st459:

                if ( ++p == pe )
                    goto _test_eof459;

            case 459:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr824;

                goto st0;
st460:

                if ( ++p == pe )
                    goto _test_eof460;

            case 460:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr825;

                goto st0;
st461:

                if ( ++p == pe )
                    goto _test_eof461;

            case 461:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr826;

                goto st0;
st462:

                if ( ++p == pe )
                    goto _test_eof462;

            case 462:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr827;

                goto st0;
st463:

                if ( ++p == pe )
                    goto _test_eof463;

            case 463:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr828;

                goto st0;
st464:

                if ( ++p == pe )
                    goto _test_eof464;

            case 464:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr829;

                goto st0;
st465:

                if ( ++p == pe )
                    goto _test_eof465;

            case 465:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr830;

                goto st0;
st466:

                if ( ++p == pe )
                    goto _test_eof466;

            case 466:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr831;

                goto st0;
st467:

                if ( ++p == pe )
                    goto _test_eof467;

            case 467:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr832;

                goto st0;
st468:

                if ( ++p == pe )
                    goto _test_eof468;

            case 468:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr833;

                goto st0;
st469:

                if ( ++p == pe )
                    goto _test_eof469;

            case 469:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr834;

                case 22:
                    goto st470;
                }

                goto st0;
st470:

                if ( ++p == pe )
                    goto _test_eof470;

            case 470:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr805;

                case 5:
                    goto tr805;

                case 8:
                    goto tr805;

                case 18:
                    goto tr806;

                case 21:
                    goto tr806;

                case 23:
                    goto tr806;

                case 36:
                    goto tr806;

                case 44:
                    goto tr806;

                case 48:
                    goto st459;

                case 53:
                    goto st460;

                case 54:
                    goto st461;

                case 55:
                    goto st462;

                case 56:
                    goto st463;

                case 57:
                    goto st464;

                case 58:
                    goto st465;

                case 59:
                    goto st466;

                case 60:
                    goto st467;

                case 61:
                    goto st468;

                case 62:
                    goto st471;

                case 79:
                    goto st472;

                case 80:
                    goto st473;

                case 81:
                    goto st483;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr806;

                goto st0;
st471:

                if ( ++p == pe )
                    goto _test_eof471;

            case 471:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr834;

                goto st0;
st472:

                if ( ++p == pe )
                    goto _test_eof472;

            case 472:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr837;

                goto st0;
st473:

                if ( ++p == pe )
                    goto _test_eof473;

            case 473:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st474;

                case 21:
                    goto st475;

                case 23:
                    goto st479;
                }

                goto st0;
st474:

                if ( ++p == pe )
                    goto _test_eof474;

            case 474:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr841;

                goto st0;
st475:

                if ( ++p == pe )
                    goto _test_eof475;

            case 475:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr842;

                case 5:
                    goto tr842;

                case 8:
                    goto tr842;

                case 18:
                    goto tr843;

                case 21:
                    goto tr843;

                case 23:
                    goto tr843;

                case 36:
                    goto tr843;

                case 44:
                    goto tr843;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr843;

                goto st0;
tr842:

                {
                    expr_start = p;
                }
                goto st476;
st476:

                if ( ++p == pe )
                    goto _test_eof476;

            case 476:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr844;

                case 23:
                    goto st24;

                case 37:
                    goto st476;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr844:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st477;
st477:

                if ( ++p == pe )
                    goto _test_eof477;

            case 477:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr846;

                case 19:
                    goto tr844;

                case 23:
                    goto st24;

                case 37:
                    goto st476;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr843:

                {
                    expr_start = p;
                }
                goto st478;
st478:

                if ( ++p == pe )
                    goto _test_eof478;

            case 478:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st476;

                case 5:
                    goto st476;

                case 8:
                    goto st476;

                case 13:
                    goto st478;

                case 18:
                    goto st478;

                case 21:
                    goto st478;

                case 23:
                    goto st478;

                case 36:
                    goto st478;

                case 44:
                    goto st478;
                }

                goto st0;
st479:

                if ( ++p == pe )
                    goto _test_eof479;

            case 479:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr848;

                case 5:
                    goto tr848;

                case 8:
                    goto tr848;

                case 18:
                    goto tr849;

                case 21:
                    goto tr849;

                case 23:
                    goto tr849;

                case 36:
                    goto tr849;

                case 44:
                    goto tr849;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr849;

                goto st0;
tr848:

                {
                    expr_start = p;
                }
                goto st480;
st480:

                if ( ++p == pe )
                    goto _test_eof480;

            case 480:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr850;

                case 23:
                    goto st24;

                case 37:
                    goto st480;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr850:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st481;
st481:

                if ( ++p == pe )
                    goto _test_eof481;

            case 481:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr852;

                case 19:
                    goto tr850;

                case 23:
                    goto st24;

                case 37:
                    goto st480;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr849:

                {
                    expr_start = p;
                }
                goto st482;
st482:

                if ( ++p == pe )
                    goto _test_eof482;

            case 482:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st480;

                case 5:
                    goto st480;

                case 8:
                    goto st480;

                case 13:
                    goto st482;

                case 18:
                    goto st482;

                case 21:
                    goto st482;

                case 23:
                    goto st482;

                case 36:
                    goto st482;

                case 44:
                    goto st482;
                }

                goto st0;
st483:

                if ( ++p == pe )
                    goto _test_eof483;

            case 483:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st484;

                case 21:
                    goto st485;

                case 23:
                    goto st489;
                }

                goto st0;
st484:

                if ( ++p == pe )
                    goto _test_eof484;

            case 484:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr857;

                goto st0;
st485:

                if ( ++p == pe )
                    goto _test_eof485;

            case 485:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr858;

                case 5:
                    goto tr858;

                case 8:
                    goto tr858;

                case 18:
                    goto tr859;

                case 21:
                    goto tr859;

                case 23:
                    goto tr859;

                case 36:
                    goto tr859;

                case 44:
                    goto tr859;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr859;

                goto st0;
tr858:

                {
                    expr_start = p;
                }
                goto st486;
st486:

                if ( ++p == pe )
                    goto _test_eof486;

            case 486:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr860;

                case 23:
                    goto st24;

                case 37:
                    goto st486;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr860:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st487;
st487:

                if ( ++p == pe )
                    goto _test_eof487;

            case 487:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr862;

                case 19:
                    goto tr860;

                case 23:
                    goto st24;

                case 37:
                    goto st486;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr859:

                {
                    expr_start = p;
                }
                goto st488;
st488:

                if ( ++p == pe )
                    goto _test_eof488;

            case 488:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st486;

                case 5:
                    goto st486;

                case 8:
                    goto st486;

                case 13:
                    goto st488;

                case 18:
                    goto st488;

                case 21:
                    goto st488;

                case 23:
                    goto st488;

                case 36:
                    goto st488;

                case 44:
                    goto st488;
                }

                goto st0;
st489:

                if ( ++p == pe )
                    goto _test_eof489;

            case 489:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr864;

                case 5:
                    goto tr864;

                case 8:
                    goto tr864;

                case 18:
                    goto tr865;

                case 21:
                    goto tr865;

                case 23:
                    goto tr865;

                case 36:
                    goto tr865;

                case 44:
                    goto tr865;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr865;

                goto st0;
tr864:

                {
                    expr_start = p;
                }
                goto st490;
st490:

                if ( ++p == pe )
                    goto _test_eof490;

            case 490:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr866;

                case 23:
                    goto st24;

                case 37:
                    goto st490;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr866:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st491;
st491:

                if ( ++p == pe )
                    goto _test_eof491;

            case 491:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr868;

                case 19:
                    goto tr866;

                case 23:
                    goto st24;

                case 37:
                    goto st490;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr865:

                {
                    expr_start = p;
                }
                goto st492;
st492:

                if ( ++p == pe )
                    goto _test_eof492;

            case 492:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st490;

                case 5:
                    goto st490;

                case 8:
                    goto st490;

                case 13:
                    goto st492;

                case 18:
                    goto st492;

                case 21:
                    goto st492;

                case 23:
                    goto st492;

                case 36:
                    goto st492;

                case 44:
                    goto st492;
                }

                goto st0;
st493:

                if ( ++p == pe )
                    goto _test_eof493;

            case 493:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr870;

                case 5:
                    goto tr870;

                case 8:
                    goto tr870;

                case 18:
                    goto tr871;

                case 21:
                    goto tr871;

                case 23:
                    goto tr871;

                case 36:
                    goto tr871;

                case 44:
                    goto tr871;

                case 48:
                    goto st496;

                case 53:
                    goto st497;

                case 54:
                    goto st498;

                case 55:
                    goto st499;

                case 56:
                    goto st500;

                case 57:
                    goto st501;

                case 58:
                    goto st502;

                case 59:
                    goto st503;

                case 60:
                    goto st504;

                case 61:
                    goto st505;

                case 62:
                    goto st506;

                case 79:
                    goto st509;

                case 80:
                    goto st510;

                case 81:
                    goto st520;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr871;

                goto st0;
tr870:

                {
                    expr_start = p;
                }
                goto st494;
st494:

                if ( ++p == pe )
                    goto _test_eof494;

            case 494:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr886;

                case 19:
                    goto st494;

                case 23:
                    goto st495;

                case 37:
                    goto st494;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st495;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st495;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st495;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st495;
                }
                else
                    goto st495;

                goto st0;
tr871:

                {
                    expr_start = p;
                }
                goto st495;
st495:

                if ( ++p == pe )
                    goto _test_eof495;

            case 495:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st494;

                case 5:
                    goto st494;

                case 8:
                    goto st494;

                case 13:
                    goto st495;

                case 18:
                    goto st495;

                case 21:
                    goto st495;

                case 23:
                    goto st495;

                case 36:
                    goto st495;

                case 44:
                    goto st495;
                }

                goto st0;
st496:

                if ( ++p == pe )
                    goto _test_eof496;

            case 496:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr889;

                goto st0;
st497:

                if ( ++p == pe )
                    goto _test_eof497;

            case 497:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr890;

                goto st0;
st498:

                if ( ++p == pe )
                    goto _test_eof498;

            case 498:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr891;

                goto st0;
st499:

                if ( ++p == pe )
                    goto _test_eof499;

            case 499:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr892;

                goto st0;
st500:

                if ( ++p == pe )
                    goto _test_eof500;

            case 500:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr893;

                goto st0;
st501:

                if ( ++p == pe )
                    goto _test_eof501;

            case 501:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr894;

                goto st0;
st502:

                if ( ++p == pe )
                    goto _test_eof502;

            case 502:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr895;

                goto st0;
st503:

                if ( ++p == pe )
                    goto _test_eof503;

            case 503:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr896;

                goto st0;
st504:

                if ( ++p == pe )
                    goto _test_eof504;

            case 504:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr897;

                goto st0;
st505:

                if ( ++p == pe )
                    goto _test_eof505;

            case 505:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr898;

                goto st0;
st506:

                if ( ++p == pe )
                    goto _test_eof506;

            case 506:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr899;

                case 22:
                    goto st507;
                }

                goto st0;
st507:

                if ( ++p == pe )
                    goto _test_eof507;

            case 507:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr870;

                case 5:
                    goto tr870;

                case 8:
                    goto tr870;

                case 18:
                    goto tr871;

                case 21:
                    goto tr871;

                case 23:
                    goto tr871;

                case 36:
                    goto tr871;

                case 44:
                    goto tr871;

                case 48:
                    goto st496;

                case 53:
                    goto st497;

                case 54:
                    goto st498;

                case 55:
                    goto st499;

                case 56:
                    goto st500;

                case 57:
                    goto st501;

                case 58:
                    goto st502;

                case 59:
                    goto st503;

                case 60:
                    goto st504;

                case 61:
                    goto st505;

                case 62:
                    goto st508;

                case 79:
                    goto st509;

                case 80:
                    goto st510;

                case 81:
                    goto st520;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr871;

                goto st0;
st508:

                if ( ++p == pe )
                    goto _test_eof508;

            case 508:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr899;

                goto st0;
st509:

                if ( ++p == pe )
                    goto _test_eof509;

            case 509:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr902;

                goto st0;
st510:

                if ( ++p == pe )
                    goto _test_eof510;

            case 510:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st511;

                case 21:
                    goto st512;

                case 23:
                    goto st516;
                }

                goto st0;
st511:

                if ( ++p == pe )
                    goto _test_eof511;

            case 511:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr906;

                goto st0;
st512:

                if ( ++p == pe )
                    goto _test_eof512;

            case 512:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr907;

                case 5:
                    goto tr907;

                case 8:
                    goto tr907;

                case 18:
                    goto tr908;

                case 21:
                    goto tr908;

                case 23:
                    goto tr908;

                case 36:
                    goto tr908;

                case 44:
                    goto tr908;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr908;

                goto st0;
tr907:

                {
                    expr_start = p;
                }
                goto st513;
st513:

                if ( ++p == pe )
                    goto _test_eof513;

            case 513:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr909;

                case 23:
                    goto st24;

                case 37:
                    goto st513;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr909:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st514;
st514:

                if ( ++p == pe )
                    goto _test_eof514;

            case 514:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr911;

                case 19:
                    goto tr909;

                case 23:
                    goto st24;

                case 37:
                    goto st513;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr908:

                {
                    expr_start = p;
                }
                goto st515;
st515:

                if ( ++p == pe )
                    goto _test_eof515;

            case 515:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st513;

                case 5:
                    goto st513;

                case 8:
                    goto st513;

                case 13:
                    goto st515;

                case 18:
                    goto st515;

                case 21:
                    goto st515;

                case 23:
                    goto st515;

                case 36:
                    goto st515;

                case 44:
                    goto st515;
                }

                goto st0;
st516:

                if ( ++p == pe )
                    goto _test_eof516;

            case 516:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr913;

                case 5:
                    goto tr913;

                case 8:
                    goto tr913;

                case 18:
                    goto tr914;

                case 21:
                    goto tr914;

                case 23:
                    goto tr914;

                case 36:
                    goto tr914;

                case 44:
                    goto tr914;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr914;

                goto st0;
tr913:

                {
                    expr_start = p;
                }
                goto st517;
st517:

                if ( ++p == pe )
                    goto _test_eof517;

            case 517:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr915;

                case 23:
                    goto st24;

                case 37:
                    goto st517;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr915:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st518;
st518:

                if ( ++p == pe )
                    goto _test_eof518;

            case 518:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr917;

                case 19:
                    goto tr915;

                case 23:
                    goto st24;

                case 37:
                    goto st517;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr914:

                {
                    expr_start = p;
                }
                goto st519;
st519:

                if ( ++p == pe )
                    goto _test_eof519;

            case 519:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st517;

                case 5:
                    goto st517;

                case 8:
                    goto st517;

                case 13:
                    goto st519;

                case 18:
                    goto st519;

                case 21:
                    goto st519;

                case 23:
                    goto st519;

                case 36:
                    goto st519;

                case 44:
                    goto st519;
                }

                goto st0;
st520:

                if ( ++p == pe )
                    goto _test_eof520;

            case 520:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st521;

                case 21:
                    goto st522;

                case 23:
                    goto st526;
                }

                goto st0;
st521:

                if ( ++p == pe )
                    goto _test_eof521;

            case 521:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr922;

                goto st0;
st522:

                if ( ++p == pe )
                    goto _test_eof522;

            case 522:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr923;

                case 5:
                    goto tr923;

                case 8:
                    goto tr923;

                case 18:
                    goto tr924;

                case 21:
                    goto tr924;

                case 23:
                    goto tr924;

                case 36:
                    goto tr924;

                case 44:
                    goto tr924;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr924;

                goto st0;
tr923:

                {
                    expr_start = p;
                }
                goto st523;
st523:

                if ( ++p == pe )
                    goto _test_eof523;

            case 523:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr925;

                case 23:
                    goto st24;

                case 37:
                    goto st523;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr925:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st524;
st524:

                if ( ++p == pe )
                    goto _test_eof524;

            case 524:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr927;

                case 19:
                    goto tr925;

                case 23:
                    goto st24;

                case 37:
                    goto st523;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr924:

                {
                    expr_start = p;
                }
                goto st525;
st525:

                if ( ++p == pe )
                    goto _test_eof525;

            case 525:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st523;

                case 5:
                    goto st523;

                case 8:
                    goto st523;

                case 13:
                    goto st525;

                case 18:
                    goto st525;

                case 21:
                    goto st525;

                case 23:
                    goto st525;

                case 36:
                    goto st525;

                case 44:
                    goto st525;
                }

                goto st0;
st526:

                if ( ++p == pe )
                    goto _test_eof526;

            case 526:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr929;

                case 5:
                    goto tr929;

                case 8:
                    goto tr929;

                case 18:
                    goto tr930;

                case 21:
                    goto tr930;

                case 23:
                    goto tr930;

                case 36:
                    goto tr930;

                case 44:
                    goto tr930;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr930;

                goto st0;
tr929:

                {
                    expr_start = p;
                }
                goto st527;
st527:

                if ( ++p == pe )
                    goto _test_eof527;

            case 527:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr931;

                case 23:
                    goto st24;

                case 37:
                    goto st527;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr931:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st528;
st528:

                if ( ++p == pe )
                    goto _test_eof528;

            case 528:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr933;

                case 19:
                    goto tr931;

                case 23:
                    goto st24;

                case 37:
                    goto st527;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr930:

                {
                    expr_start = p;
                }
                goto st529;
st529:

                if ( ++p == pe )
                    goto _test_eof529;

            case 529:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st527;

                case 5:
                    goto st527;

                case 8:
                    goto st527;

                case 13:
                    goto st529;

                case 18:
                    goto st529;

                case 21:
                    goto st529;

                case 23:
                    goto st529;

                case 36:
                    goto st529;

                case 44:
                    goto st529;
                }

                goto st0;
            }

_test_eof530:
            cs = 530;
            goto _test_eof;
_test_eof2:
            cs = 2;
            goto _test_eof;
_test_eof3:
            cs = 3;
            goto _test_eof;
_test_eof4:
            cs = 4;
            goto _test_eof;
_test_eof5:
            cs = 5;
            goto _test_eof;
_test_eof6:
            cs = 6;
            goto _test_eof;
_test_eof7:
            cs = 7;
            goto _test_eof;
_test_eof8:
            cs = 8;
            goto _test_eof;
_test_eof9:
            cs = 9;
            goto _test_eof;
_test_eof10:
            cs = 10;
            goto _test_eof;
_test_eof11:
            cs = 11;
            goto _test_eof;
_test_eof12:
            cs = 12;
            goto _test_eof;
_test_eof13:
            cs = 13;
            goto _test_eof;
_test_eof14:
            cs = 14;
            goto _test_eof;
_test_eof15:
            cs = 15;
            goto _test_eof;
_test_eof16:
            cs = 16;
            goto _test_eof;
_test_eof17:
            cs = 17;
            goto _test_eof;
_test_eof18:
            cs = 18;
            goto _test_eof;
_test_eof19:
            cs = 19;
            goto _test_eof;
_test_eof20:
            cs = 20;
            goto _test_eof;
_test_eof21:
            cs = 21;
            goto _test_eof;
_test_eof22:
            cs = 22;
            goto _test_eof;
_test_eof23:
            cs = 23;
            goto _test_eof;
_test_eof24:
            cs = 24;
            goto _test_eof;
_test_eof25:
            cs = 25;
            goto _test_eof;
_test_eof26:
            cs = 26;
            goto _test_eof;
_test_eof27:
            cs = 27;
            goto _test_eof;
_test_eof28:
            cs = 28;
            goto _test_eof;
_test_eof29:
            cs = 29;
            goto _test_eof;
_test_eof30:
            cs = 30;
            goto _test_eof;
_test_eof31:
            cs = 31;
            goto _test_eof;
_test_eof32:
            cs = 32;
            goto _test_eof;
_test_eof33:
            cs = 33;
            goto _test_eof;
_test_eof34:
            cs = 34;
            goto _test_eof;
_test_eof35:
            cs = 35;
            goto _test_eof;
_test_eof36:
            cs = 36;
            goto _test_eof;
_test_eof37:
            cs = 37;
            goto _test_eof;
_test_eof38:
            cs = 38;
            goto _test_eof;
_test_eof39:
            cs = 39;
            goto _test_eof;
_test_eof40:
            cs = 40;
            goto _test_eof;
_test_eof41:
            cs = 41;
            goto _test_eof;
_test_eof42:
            cs = 42;
            goto _test_eof;
_test_eof43:
            cs = 43;
            goto _test_eof;
_test_eof44:
            cs = 44;
            goto _test_eof;
_test_eof45:
            cs = 45;
            goto _test_eof;
_test_eof46:
            cs = 46;
            goto _test_eof;
_test_eof47:
            cs = 47;
            goto _test_eof;
_test_eof48:
            cs = 48;
            goto _test_eof;
_test_eof49:
            cs = 49;
            goto _test_eof;
_test_eof50:
            cs = 50;
            goto _test_eof;
_test_eof51:
            cs = 51;
            goto _test_eof;
_test_eof52:
            cs = 52;
            goto _test_eof;
_test_eof53:
            cs = 53;
            goto _test_eof;
_test_eof54:
            cs = 54;
            goto _test_eof;
_test_eof55:
            cs = 55;
            goto _test_eof;
_test_eof56:
            cs = 56;
            goto _test_eof;
_test_eof57:
            cs = 57;
            goto _test_eof;
_test_eof58:
            cs = 58;
            goto _test_eof;
_test_eof59:
            cs = 59;
            goto _test_eof;
_test_eof60:
            cs = 60;
            goto _test_eof;
_test_eof61:
            cs = 61;
            goto _test_eof;
_test_eof62:
            cs = 62;
            goto _test_eof;
_test_eof63:
            cs = 63;
            goto _test_eof;
_test_eof64:
            cs = 64;
            goto _test_eof;
_test_eof65:
            cs = 65;
            goto _test_eof;
_test_eof66:
            cs = 66;
            goto _test_eof;
_test_eof67:
            cs = 67;
            goto _test_eof;
_test_eof68:
            cs = 68;
            goto _test_eof;
_test_eof69:
            cs = 69;
            goto _test_eof;
_test_eof70:
            cs = 70;
            goto _test_eof;
_test_eof71:
            cs = 71;
            goto _test_eof;
_test_eof72:
            cs = 72;
            goto _test_eof;
_test_eof73:
            cs = 73;
            goto _test_eof;
_test_eof74:
            cs = 74;
            goto _test_eof;
_test_eof75:
            cs = 75;
            goto _test_eof;
_test_eof76:
            cs = 76;
            goto _test_eof;
_test_eof77:
            cs = 77;
            goto _test_eof;
_test_eof78:
            cs = 78;
            goto _test_eof;
_test_eof79:
            cs = 79;
            goto _test_eof;
_test_eof80:
            cs = 80;
            goto _test_eof;
_test_eof81:
            cs = 81;
            goto _test_eof;
_test_eof82:
            cs = 82;
            goto _test_eof;
_test_eof83:
            cs = 83;
            goto _test_eof;
_test_eof84:
            cs = 84;
            goto _test_eof;
_test_eof85:
            cs = 85;
            goto _test_eof;
_test_eof86:
            cs = 86;
            goto _test_eof;
_test_eof87:
            cs = 87;
            goto _test_eof;
_test_eof88:
            cs = 88;
            goto _test_eof;
_test_eof89:
            cs = 89;
            goto _test_eof;
_test_eof90:
            cs = 90;
            goto _test_eof;
_test_eof91:
            cs = 91;
            goto _test_eof;
_test_eof92:
            cs = 92;
            goto _test_eof;
_test_eof93:
            cs = 93;
            goto _test_eof;
_test_eof94:
            cs = 94;
            goto _test_eof;
_test_eof95:
            cs = 95;
            goto _test_eof;
_test_eof96:
            cs = 96;
            goto _test_eof;
_test_eof97:
            cs = 97;
            goto _test_eof;
_test_eof98:
            cs = 98;
            goto _test_eof;
_test_eof99:
            cs = 99;
            goto _test_eof;
_test_eof100:
            cs = 100;
            goto _test_eof;
_test_eof101:
            cs = 101;
            goto _test_eof;
_test_eof102:
            cs = 102;
            goto _test_eof;
_test_eof103:
            cs = 103;
            goto _test_eof;
_test_eof104:
            cs = 104;
            goto _test_eof;
_test_eof105:
            cs = 105;
            goto _test_eof;
_test_eof106:
            cs = 106;
            goto _test_eof;
_test_eof107:
            cs = 107;
            goto _test_eof;
_test_eof108:
            cs = 108;
            goto _test_eof;
_test_eof109:
            cs = 109;
            goto _test_eof;
_test_eof110:
            cs = 110;
            goto _test_eof;
_test_eof111:
            cs = 111;
            goto _test_eof;
_test_eof112:
            cs = 112;
            goto _test_eof;
_test_eof113:
            cs = 113;
            goto _test_eof;
_test_eof114:
            cs = 114;
            goto _test_eof;
_test_eof115:
            cs = 115;
            goto _test_eof;
_test_eof116:
            cs = 116;
            goto _test_eof;
_test_eof117:
            cs = 117;
            goto _test_eof;
_test_eof118:
            cs = 118;
            goto _test_eof;
_test_eof119:
            cs = 119;
            goto _test_eof;
_test_eof120:
            cs = 120;
            goto _test_eof;
_test_eof121:
            cs = 121;
            goto _test_eof;
_test_eof122:
            cs = 122;
            goto _test_eof;
_test_eof123:
            cs = 123;
            goto _test_eof;
_test_eof124:
            cs = 124;
            goto _test_eof;
_test_eof125:
            cs = 125;
            goto _test_eof;
_test_eof126:
            cs = 126;
            goto _test_eof;
_test_eof127:
            cs = 127;
            goto _test_eof;
_test_eof128:
            cs = 128;
            goto _test_eof;
_test_eof129:
            cs = 129;
            goto _test_eof;
_test_eof130:
            cs = 130;
            goto _test_eof;
_test_eof131:
            cs = 131;
            goto _test_eof;
_test_eof132:
            cs = 132;
            goto _test_eof;
_test_eof133:
            cs = 133;
            goto _test_eof;
_test_eof134:
            cs = 134;
            goto _test_eof;
_test_eof135:
            cs = 135;
            goto _test_eof;
_test_eof136:
            cs = 136;
            goto _test_eof;
_test_eof137:
            cs = 137;
            goto _test_eof;
_test_eof138:
            cs = 138;
            goto _test_eof;
_test_eof139:
            cs = 139;
            goto _test_eof;
_test_eof140:
            cs = 140;
            goto _test_eof;
_test_eof141:
            cs = 141;
            goto _test_eof;
_test_eof142:
            cs = 142;
            goto _test_eof;
_test_eof143:
            cs = 143;
            goto _test_eof;
_test_eof144:
            cs = 144;
            goto _test_eof;
_test_eof145:
            cs = 145;
            goto _test_eof;
_test_eof146:
            cs = 146;
            goto _test_eof;
_test_eof147:
            cs = 147;
            goto _test_eof;
_test_eof148:
            cs = 148;
            goto _test_eof;
_test_eof149:
            cs = 149;
            goto _test_eof;
_test_eof150:
            cs = 150;
            goto _test_eof;
_test_eof151:
            cs = 151;
            goto _test_eof;
_test_eof152:
            cs = 152;
            goto _test_eof;
_test_eof153:
            cs = 153;
            goto _test_eof;
_test_eof154:
            cs = 154;
            goto _test_eof;
_test_eof155:
            cs = 155;
            goto _test_eof;
_test_eof156:
            cs = 156;
            goto _test_eof;
_test_eof157:
            cs = 157;
            goto _test_eof;
_test_eof158:
            cs = 158;
            goto _test_eof;
_test_eof159:
            cs = 159;
            goto _test_eof;
_test_eof160:
            cs = 160;
            goto _test_eof;
_test_eof161:
            cs = 161;
            goto _test_eof;
_test_eof162:
            cs = 162;
            goto _test_eof;
_test_eof163:
            cs = 163;
            goto _test_eof;
_test_eof164:
            cs = 164;
            goto _test_eof;
_test_eof165:
            cs = 165;
            goto _test_eof;
_test_eof166:
            cs = 166;
            goto _test_eof;
_test_eof167:
            cs = 167;
            goto _test_eof;
_test_eof168:
            cs = 168;
            goto _test_eof;
_test_eof169:
            cs = 169;
            goto _test_eof;
_test_eof170:
            cs = 170;
            goto _test_eof;
_test_eof171:
            cs = 171;
            goto _test_eof;
_test_eof172:
            cs = 172;
            goto _test_eof;
_test_eof173:
            cs = 173;
            goto _test_eof;
_test_eof174:
            cs = 174;
            goto _test_eof;
_test_eof175:
            cs = 175;
            goto _test_eof;
_test_eof176:
            cs = 176;
            goto _test_eof;
_test_eof177:
            cs = 177;
            goto _test_eof;
_test_eof178:
            cs = 178;
            goto _test_eof;
_test_eof179:
            cs = 179;
            goto _test_eof;
_test_eof180:
            cs = 180;
            goto _test_eof;
_test_eof181:
            cs = 181;
            goto _test_eof;
_test_eof182:
            cs = 182;
            goto _test_eof;
_test_eof183:
            cs = 183;
            goto _test_eof;
_test_eof184:
            cs = 184;
            goto _test_eof;
_test_eof185:
            cs = 185;
            goto _test_eof;
_test_eof186:
            cs = 186;
            goto _test_eof;
_test_eof187:
            cs = 187;
            goto _test_eof;
_test_eof188:
            cs = 188;
            goto _test_eof;
_test_eof189:
            cs = 189;
            goto _test_eof;
_test_eof190:
            cs = 190;
            goto _test_eof;
_test_eof191:
            cs = 191;
            goto _test_eof;
_test_eof192:
            cs = 192;
            goto _test_eof;
_test_eof193:
            cs = 193;
            goto _test_eof;
_test_eof194:
            cs = 194;
            goto _test_eof;
_test_eof195:
            cs = 195;
            goto _test_eof;
_test_eof196:
            cs = 196;
            goto _test_eof;
_test_eof197:
            cs = 197;
            goto _test_eof;
_test_eof198:
            cs = 198;
            goto _test_eof;
_test_eof199:
            cs = 199;
            goto _test_eof;
_test_eof200:
            cs = 200;
            goto _test_eof;
_test_eof201:
            cs = 201;
            goto _test_eof;
_test_eof202:
            cs = 202;
            goto _test_eof;
_test_eof203:
            cs = 203;
            goto _test_eof;
_test_eof204:
            cs = 204;
            goto _test_eof;
_test_eof205:
            cs = 205;
            goto _test_eof;
_test_eof206:
            cs = 206;
            goto _test_eof;
_test_eof207:
            cs = 207;
            goto _test_eof;
_test_eof208:
            cs = 208;
            goto _test_eof;
_test_eof209:
            cs = 209;
            goto _test_eof;
_test_eof210:
            cs = 210;
            goto _test_eof;
_test_eof211:
            cs = 211;
            goto _test_eof;
_test_eof212:
            cs = 212;
            goto _test_eof;
_test_eof213:
            cs = 213;
            goto _test_eof;
_test_eof214:
            cs = 214;
            goto _test_eof;
_test_eof215:
            cs = 215;
            goto _test_eof;
_test_eof216:
            cs = 216;
            goto _test_eof;
_test_eof217:
            cs = 217;
            goto _test_eof;
_test_eof218:
            cs = 218;
            goto _test_eof;
_test_eof219:
            cs = 219;
            goto _test_eof;
_test_eof220:
            cs = 220;
            goto _test_eof;
_test_eof221:
            cs = 221;
            goto _test_eof;
_test_eof222:
            cs = 222;
            goto _test_eof;
_test_eof223:
            cs = 223;
            goto _test_eof;
_test_eof224:
            cs = 224;
            goto _test_eof;
_test_eof225:
            cs = 225;
            goto _test_eof;
_test_eof226:
            cs = 226;
            goto _test_eof;
_test_eof227:
            cs = 227;
            goto _test_eof;
_test_eof228:
            cs = 228;
            goto _test_eof;
_test_eof229:
            cs = 229;
            goto _test_eof;
_test_eof230:
            cs = 230;
            goto _test_eof;
_test_eof231:
            cs = 231;
            goto _test_eof;
_test_eof232:
            cs = 232;
            goto _test_eof;
_test_eof233:
            cs = 233;
            goto _test_eof;
_test_eof234:
            cs = 234;
            goto _test_eof;
_test_eof235:
            cs = 235;
            goto _test_eof;
_test_eof236:
            cs = 236;
            goto _test_eof;
_test_eof237:
            cs = 237;
            goto _test_eof;
_test_eof238:
            cs = 238;
            goto _test_eof;
_test_eof239:
            cs = 239;
            goto _test_eof;
_test_eof240:
            cs = 240;
            goto _test_eof;
_test_eof241:
            cs = 241;
            goto _test_eof;
_test_eof242:
            cs = 242;
            goto _test_eof;
_test_eof243:
            cs = 243;
            goto _test_eof;
_test_eof244:
            cs = 244;
            goto _test_eof;
_test_eof245:
            cs = 245;
            goto _test_eof;
_test_eof246:
            cs = 246;
            goto _test_eof;
_test_eof247:
            cs = 247;
            goto _test_eof;
_test_eof248:
            cs = 248;
            goto _test_eof;
_test_eof249:
            cs = 249;
            goto _test_eof;
_test_eof250:
            cs = 250;
            goto _test_eof;
_test_eof251:
            cs = 251;
            goto _test_eof;
_test_eof252:
            cs = 252;
            goto _test_eof;
_test_eof253:
            cs = 253;
            goto _test_eof;
_test_eof254:
            cs = 254;
            goto _test_eof;
_test_eof255:
            cs = 255;
            goto _test_eof;
_test_eof256:
            cs = 256;
            goto _test_eof;
_test_eof257:
            cs = 257;
            goto _test_eof;
_test_eof258:
            cs = 258;
            goto _test_eof;
_test_eof259:
            cs = 259;
            goto _test_eof;
_test_eof260:
            cs = 260;
            goto _test_eof;
_test_eof261:
            cs = 261;
            goto _test_eof;
_test_eof262:
            cs = 262;
            goto _test_eof;
_test_eof263:
            cs = 263;
            goto _test_eof;
_test_eof264:
            cs = 264;
            goto _test_eof;
_test_eof265:
            cs = 265;
            goto _test_eof;
_test_eof266:
            cs = 266;
            goto _test_eof;
_test_eof267:
            cs = 267;
            goto _test_eof;
_test_eof268:
            cs = 268;
            goto _test_eof;
_test_eof269:
            cs = 269;
            goto _test_eof;
_test_eof270:
            cs = 270;
            goto _test_eof;
_test_eof271:
            cs = 271;
            goto _test_eof;
_test_eof272:
            cs = 272;
            goto _test_eof;
_test_eof273:
            cs = 273;
            goto _test_eof;
_test_eof274:
            cs = 274;
            goto _test_eof;
_test_eof275:
            cs = 275;
            goto _test_eof;
_test_eof276:
            cs = 276;
            goto _test_eof;
_test_eof277:
            cs = 277;
            goto _test_eof;
_test_eof278:
            cs = 278;
            goto _test_eof;
_test_eof279:
            cs = 279;
            goto _test_eof;
_test_eof280:
            cs = 280;
            goto _test_eof;
_test_eof281:
            cs = 281;
            goto _test_eof;
_test_eof282:
            cs = 282;
            goto _test_eof;
_test_eof283:
            cs = 283;
            goto _test_eof;
_test_eof284:
            cs = 284;
            goto _test_eof;
_test_eof285:
            cs = 285;
            goto _test_eof;
_test_eof286:
            cs = 286;
            goto _test_eof;
_test_eof287:
            cs = 287;
            goto _test_eof;
_test_eof288:
            cs = 288;
            goto _test_eof;
_test_eof289:
            cs = 289;
            goto _test_eof;
_test_eof290:
            cs = 290;
            goto _test_eof;
_test_eof291:
            cs = 291;
            goto _test_eof;
_test_eof292:
            cs = 292;
            goto _test_eof;
_test_eof293:
            cs = 293;
            goto _test_eof;
_test_eof294:
            cs = 294;
            goto _test_eof;
_test_eof295:
            cs = 295;
            goto _test_eof;
_test_eof296:
            cs = 296;
            goto _test_eof;
_test_eof297:
            cs = 297;
            goto _test_eof;
_test_eof298:
            cs = 298;
            goto _test_eof;
_test_eof299:
            cs = 299;
            goto _test_eof;
_test_eof300:
            cs = 300;
            goto _test_eof;
_test_eof301:
            cs = 301;
            goto _test_eof;
_test_eof302:
            cs = 302;
            goto _test_eof;
_test_eof303:
            cs = 303;
            goto _test_eof;
_test_eof304:
            cs = 304;
            goto _test_eof;
_test_eof305:
            cs = 305;
            goto _test_eof;
_test_eof306:
            cs = 306;
            goto _test_eof;
_test_eof307:
            cs = 307;
            goto _test_eof;
_test_eof308:
            cs = 308;
            goto _test_eof;
_test_eof309:
            cs = 309;
            goto _test_eof;
_test_eof310:
            cs = 310;
            goto _test_eof;
_test_eof311:
            cs = 311;
            goto _test_eof;
_test_eof312:
            cs = 312;
            goto _test_eof;
_test_eof313:
            cs = 313;
            goto _test_eof;
_test_eof314:
            cs = 314;
            goto _test_eof;
_test_eof315:
            cs = 315;
            goto _test_eof;
_test_eof316:
            cs = 316;
            goto _test_eof;
_test_eof317:
            cs = 317;
            goto _test_eof;
_test_eof318:
            cs = 318;
            goto _test_eof;
_test_eof319:
            cs = 319;
            goto _test_eof;
_test_eof320:
            cs = 320;
            goto _test_eof;
_test_eof321:
            cs = 321;
            goto _test_eof;
_test_eof322:
            cs = 322;
            goto _test_eof;
_test_eof323:
            cs = 323;
            goto _test_eof;
_test_eof324:
            cs = 324;
            goto _test_eof;
_test_eof325:
            cs = 325;
            goto _test_eof;
_test_eof326:
            cs = 326;
            goto _test_eof;
_test_eof327:
            cs = 327;
            goto _test_eof;
_test_eof328:
            cs = 328;
            goto _test_eof;
_test_eof329:
            cs = 329;
            goto _test_eof;
_test_eof330:
            cs = 330;
            goto _test_eof;
_test_eof331:
            cs = 331;
            goto _test_eof;
_test_eof332:
            cs = 332;
            goto _test_eof;
_test_eof333:
            cs = 333;
            goto _test_eof;
_test_eof334:
            cs = 334;
            goto _test_eof;
_test_eof335:
            cs = 335;
            goto _test_eof;
_test_eof336:
            cs = 336;
            goto _test_eof;
_test_eof337:
            cs = 337;
            goto _test_eof;
_test_eof338:
            cs = 338;
            goto _test_eof;
_test_eof339:
            cs = 339;
            goto _test_eof;
_test_eof340:
            cs = 340;
            goto _test_eof;
_test_eof341:
            cs = 341;
            goto _test_eof;
_test_eof342:
            cs = 342;
            goto _test_eof;
_test_eof343:
            cs = 343;
            goto _test_eof;
_test_eof344:
            cs = 344;
            goto _test_eof;
_test_eof345:
            cs = 345;
            goto _test_eof;
_test_eof346:
            cs = 346;
            goto _test_eof;
_test_eof347:
            cs = 347;
            goto _test_eof;
_test_eof348:
            cs = 348;
            goto _test_eof;
_test_eof349:
            cs = 349;
            goto _test_eof;
_test_eof350:
            cs = 350;
            goto _test_eof;
_test_eof351:
            cs = 351;
            goto _test_eof;
_test_eof352:
            cs = 352;
            goto _test_eof;
_test_eof353:
            cs = 353;
            goto _test_eof;
_test_eof354:
            cs = 354;
            goto _test_eof;
_test_eof355:
            cs = 355;
            goto _test_eof;
_test_eof356:
            cs = 356;
            goto _test_eof;
_test_eof357:
            cs = 357;
            goto _test_eof;
_test_eof358:
            cs = 358;
            goto _test_eof;
_test_eof359:
            cs = 359;
            goto _test_eof;
_test_eof360:
            cs = 360;
            goto _test_eof;
_test_eof361:
            cs = 361;
            goto _test_eof;
_test_eof362:
            cs = 362;
            goto _test_eof;
_test_eof363:
            cs = 363;
            goto _test_eof;
_test_eof364:
            cs = 364;
            goto _test_eof;
_test_eof365:
            cs = 365;
            goto _test_eof;
_test_eof366:
            cs = 366;
            goto _test_eof;
_test_eof367:
            cs = 367;
            goto _test_eof;
_test_eof368:
            cs = 368;
            goto _test_eof;
_test_eof369:
            cs = 369;
            goto _test_eof;
_test_eof370:
            cs = 370;
            goto _test_eof;
_test_eof371:
            cs = 371;
            goto _test_eof;
_test_eof372:
            cs = 372;
            goto _test_eof;
_test_eof373:
            cs = 373;
            goto _test_eof;
_test_eof374:
            cs = 374;
            goto _test_eof;
_test_eof375:
            cs = 375;
            goto _test_eof;
_test_eof376:
            cs = 376;
            goto _test_eof;
_test_eof377:
            cs = 377;
            goto _test_eof;
_test_eof378:
            cs = 378;
            goto _test_eof;
_test_eof379:
            cs = 379;
            goto _test_eof;
_test_eof380:
            cs = 380;
            goto _test_eof;
_test_eof381:
            cs = 381;
            goto _test_eof;
_test_eof382:
            cs = 382;
            goto _test_eof;
_test_eof383:
            cs = 383;
            goto _test_eof;
_test_eof384:
            cs = 384;
            goto _test_eof;
_test_eof385:
            cs = 385;
            goto _test_eof;
_test_eof386:
            cs = 386;
            goto _test_eof;
_test_eof387:
            cs = 387;
            goto _test_eof;
_test_eof388:
            cs = 388;
            goto _test_eof;
_test_eof389:
            cs = 389;
            goto _test_eof;
_test_eof390:
            cs = 390;
            goto _test_eof;
_test_eof391:
            cs = 391;
            goto _test_eof;
_test_eof392:
            cs = 392;
            goto _test_eof;
_test_eof393:
            cs = 393;
            goto _test_eof;
_test_eof394:
            cs = 394;
            goto _test_eof;
_test_eof395:
            cs = 395;
            goto _test_eof;
_test_eof396:
            cs = 396;
            goto _test_eof;
_test_eof397:
            cs = 397;
            goto _test_eof;
_test_eof398:
            cs = 398;
            goto _test_eof;
_test_eof399:
            cs = 399;
            goto _test_eof;
_test_eof400:
            cs = 400;
            goto _test_eof;
_test_eof401:
            cs = 401;
            goto _test_eof;
_test_eof402:
            cs = 402;
            goto _test_eof;
_test_eof403:
            cs = 403;
            goto _test_eof;
_test_eof404:
            cs = 404;
            goto _test_eof;
_test_eof405:
            cs = 405;
            goto _test_eof;
_test_eof406:
            cs = 406;
            goto _test_eof;
_test_eof407:
            cs = 407;
            goto _test_eof;
_test_eof408:
            cs = 408;
            goto _test_eof;
_test_eof409:
            cs = 409;
            goto _test_eof;
_test_eof410:
            cs = 410;
            goto _test_eof;
_test_eof411:
            cs = 411;
            goto _test_eof;
_test_eof412:
            cs = 412;
            goto _test_eof;
_test_eof413:
            cs = 413;
            goto _test_eof;
_test_eof414:
            cs = 414;
            goto _test_eof;
_test_eof415:
            cs = 415;
            goto _test_eof;
_test_eof416:
            cs = 416;
            goto _test_eof;
_test_eof417:
            cs = 417;
            goto _test_eof;
_test_eof418:
            cs = 418;
            goto _test_eof;
_test_eof419:
            cs = 419;
            goto _test_eof;
_test_eof420:
            cs = 420;
            goto _test_eof;
_test_eof421:
            cs = 421;
            goto _test_eof;
_test_eof422:
            cs = 422;
            goto _test_eof;
_test_eof423:
            cs = 423;
            goto _test_eof;
_test_eof424:
            cs = 424;
            goto _test_eof;
_test_eof425:
            cs = 425;
            goto _test_eof;
_test_eof426:
            cs = 426;
            goto _test_eof;
_test_eof427:
            cs = 427;
            goto _test_eof;
_test_eof428:
            cs = 428;
            goto _test_eof;
_test_eof429:
            cs = 429;
            goto _test_eof;
_test_eof430:
            cs = 430;
            goto _test_eof;
_test_eof431:
            cs = 431;
            goto _test_eof;
_test_eof432:
            cs = 432;
            goto _test_eof;
_test_eof433:
            cs = 433;
            goto _test_eof;
_test_eof434:
            cs = 434;
            goto _test_eof;
_test_eof435:
            cs = 435;
            goto _test_eof;
_test_eof436:
            cs = 436;
            goto _test_eof;
_test_eof437:
            cs = 437;
            goto _test_eof;
_test_eof438:
            cs = 438;
            goto _test_eof;
_test_eof439:
            cs = 439;
            goto _test_eof;
_test_eof440:
            cs = 440;
            goto _test_eof;
_test_eof441:
            cs = 441;
            goto _test_eof;
_test_eof442:
            cs = 442;
            goto _test_eof;
_test_eof443:
            cs = 443;
            goto _test_eof;
_test_eof444:
            cs = 444;
            goto _test_eof;
_test_eof445:
            cs = 445;
            goto _test_eof;
_test_eof446:
            cs = 446;
            goto _test_eof;
_test_eof447:
            cs = 447;
            goto _test_eof;
_test_eof448:
            cs = 448;
            goto _test_eof;
_test_eof449:
            cs = 449;
            goto _test_eof;
_test_eof450:
            cs = 450;
            goto _test_eof;
_test_eof451:
            cs = 451;
            goto _test_eof;
_test_eof452:
            cs = 452;
            goto _test_eof;
_test_eof453:
            cs = 453;
            goto _test_eof;
_test_eof454:
            cs = 454;
            goto _test_eof;
_test_eof455:
            cs = 455;
            goto _test_eof;
_test_eof456:
            cs = 456;
            goto _test_eof;
_test_eof457:
            cs = 457;
            goto _test_eof;
_test_eof458:
            cs = 458;
            goto _test_eof;
_test_eof459:
            cs = 459;
            goto _test_eof;
_test_eof460:
            cs = 460;
            goto _test_eof;
_test_eof461:
            cs = 461;
            goto _test_eof;
_test_eof462:
            cs = 462;
            goto _test_eof;
_test_eof463:
            cs = 463;
            goto _test_eof;
_test_eof464:
            cs = 464;
            goto _test_eof;
_test_eof465:
            cs = 465;
            goto _test_eof;
_test_eof466:
            cs = 466;
            goto _test_eof;
_test_eof467:
            cs = 467;
            goto _test_eof;
_test_eof468:
            cs = 468;
            goto _test_eof;
_test_eof469:
            cs = 469;
            goto _test_eof;
_test_eof470:
            cs = 470;
            goto _test_eof;
_test_eof471:
            cs = 471;
            goto _test_eof;
_test_eof472:
            cs = 472;
            goto _test_eof;
_test_eof473:
            cs = 473;
            goto _test_eof;
_test_eof474:
            cs = 474;
            goto _test_eof;
_test_eof475:
            cs = 475;
            goto _test_eof;
_test_eof476:
            cs = 476;
            goto _test_eof;
_test_eof477:
            cs = 477;
            goto _test_eof;
_test_eof478:
            cs = 478;
            goto _test_eof;
_test_eof479:
            cs = 479;
            goto _test_eof;
_test_eof480:
            cs = 480;
            goto _test_eof;
_test_eof481:
            cs = 481;
            goto _test_eof;
_test_eof482:
            cs = 482;
            goto _test_eof;
_test_eof483:
            cs = 483;
            goto _test_eof;
_test_eof484:
            cs = 484;
            goto _test_eof;
_test_eof485:
            cs = 485;
            goto _test_eof;
_test_eof486:
            cs = 486;
            goto _test_eof;
_test_eof487:
            cs = 487;
            goto _test_eof;
_test_eof488:
            cs = 488;
            goto _test_eof;
_test_eof489:
            cs = 489;
            goto _test_eof;
_test_eof490:
            cs = 490;
            goto _test_eof;
_test_eof491:
            cs = 491;
            goto _test_eof;
_test_eof492:
            cs = 492;
            goto _test_eof;
_test_eof493:
            cs = 493;
            goto _test_eof;
_test_eof494:
            cs = 494;
            goto _test_eof;
_test_eof495:
            cs = 495;
            goto _test_eof;
_test_eof496:
            cs = 496;
            goto _test_eof;
_test_eof497:
            cs = 497;
            goto _test_eof;
_test_eof498:
            cs = 498;
            goto _test_eof;
_test_eof499:
            cs = 499;
            goto _test_eof;
_test_eof500:
            cs = 500;
            goto _test_eof;
_test_eof501:
            cs = 501;
            goto _test_eof;
_test_eof502:
            cs = 502;
            goto _test_eof;
_test_eof503:
            cs = 503;
            goto _test_eof;
_test_eof504:
            cs = 504;
            goto _test_eof;
_test_eof505:
            cs = 505;
            goto _test_eof;
_test_eof506:
            cs = 506;
            goto _test_eof;
_test_eof507:
            cs = 507;
            goto _test_eof;
_test_eof508:
            cs = 508;
            goto _test_eof;
_test_eof509:
            cs = 509;
            goto _test_eof;
_test_eof510:
            cs = 510;
            goto _test_eof;
_test_eof511:
            cs = 511;
            goto _test_eof;
_test_eof512:
            cs = 512;
            goto _test_eof;
_test_eof513:
            cs = 513;
            goto _test_eof;
_test_eof514:
            cs = 514;
            goto _test_eof;
_test_eof515:
            cs = 515;
            goto _test_eof;
_test_eof516:
            cs = 516;
            goto _test_eof;
_test_eof517:
            cs = 517;
            goto _test_eof;
_test_eof518:
            cs = 518;
            goto _test_eof;
_test_eof519:
            cs = 519;
            goto _test_eof;
_test_eof520:
            cs = 520;
            goto _test_eof;
_test_eof521:
            cs = 521;
            goto _test_eof;
_test_eof522:
            cs = 522;
            goto _test_eof;
_test_eof523:
            cs = 523;
            goto _test_eof;
_test_eof524:
            cs = 524;
            goto _test_eof;
_test_eof525:
            cs = 525;
            goto _test_eof;
_test_eof526:
            cs = 526;
            goto _test_eof;
_test_eof527:
            cs = 527;
            goto _test_eof;
_test_eof528:
            cs = 528;
            goto _test_eof;
_test_eof529:
            cs = 529;
            goto _test_eof;

_test_eof:
            {}
_out:
            {}
        }




        if ( cs ==

                0

           )
            return FALSE;

        if ( cs >=

                530

           )
            return TRUE;
    }

    return FALSE;
}

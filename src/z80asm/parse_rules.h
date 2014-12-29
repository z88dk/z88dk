




















static const int parser_start = 1;
static const int parser_first_final = 504;
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
                    goto st504;

                case 4:
                    goto tr2;

                case 12:
                    goto st504;

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
                    goto st243;

                case 108:
                    goto st244;

                case 109:
                    goto st245;

                case 110:
                    goto st246;

                case 111:
                    goto st286;

                case 112:
                    goto st305;

                case 113:
                    goto st306;

                case 114:
                    goto st307;

                case 115:
                    goto st308;

                case 116:
                    goto st309;

                case 117:
                    goto st310;

                case 118:
                    goto st311;

                case 119:
                    goto st348;

                case 120:
                    goto st349;

                case 121:
                    goto st350;

                case 122:
                    goto st351;

                case 123:
                    goto st352;

                case 124:
                    goto st359;

                case 125:
                    goto st366;

                case 126:
                    goto st375;

                case 127:
                    goto st376;

                case 128:
                    goto st377;

                case 129:
                    goto st378;

                case 130:
                    goto st379;

                case 131:
                    goto st380;

                case 132:
                    goto st381;

                case 133:
                    goto st382;

                case 134:
                    goto st383;

                case 135:
                    goto st386;

                case 136:
                    goto st429;

                case 137:
                    goto st430;

                case 138:
                    goto st467;
                }

                goto st0;
st0:
                cs = 0;
                goto _out;
tr55:

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
                goto st504;
tr73:

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
                goto st504;
tr76:

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
                goto st504;
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

                        add_opcode( Z80_ADC( REG_B ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADC( REG_D ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADC( REG_E ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADC( REG_H ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADC( REG_H ) + P_IX );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADC( REG_H ) + P_IY );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADC( REG_L ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADC( REG_L ) + P_IX );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADC( REG_L ) + P_IY );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADC( REG_A ) );
                    };
                }
                goto st504;
tr89:

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
                goto st504;
tr93:

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
                goto st504;
tr100:

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
                goto st504;
tr106:

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
                goto st504;
tr111:

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
                goto st504;
tr116:

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
                goto st504;
tr122:

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
                goto st504;
tr129:

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
                goto st504;
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

                        add_opcode( Z80_ADC16( REG_DE ) + 0 );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADC16( REG_HL ) + 0 );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADC16( REG_SP ) + 0 );
                    };
                }
                goto st504;
tr152:

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
                goto st504;
tr155:

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
                goto st504;
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

                        add_opcode( Z80_ADD( REG_B ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD( REG_D ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD( REG_E ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD( REG_H ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD( REG_H ) + P_IX );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD( REG_H ) + P_IY );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD( REG_L ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD( REG_L ) + P_IX );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD( REG_L ) + P_IY );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD( REG_A ) );
                    };
                }
                goto st504;
tr168:

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
                goto st504;
tr172:

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
                goto st504;
tr177:

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
                goto st504;
tr183:

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
                goto st504;
tr188:

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
                goto st504;
tr193:

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
                goto st504;
tr199:

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
                goto st504;
tr206:

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
                goto st504;
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

                        add_opcode( Z80_ADD16( REG_DE ) + 0 );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD16( REG_HL ) + 0 );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD16( REG_SP ) + 0 );
                    };
                }
                goto st504;
tr215:

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
                goto st504;
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

                        add_opcode( Z80_ADD16( REG_DE ) + P_IX );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD16( REG_IX ) + P_IX );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD16( REG_SP ) + P_IX );
                    };
                }
                goto st504;
tr224:

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
                goto st504;
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

                        add_opcode( Z80_ADD16( REG_DE ) + P_IY );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD16( REG_IY ) + P_IY );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_ADD16( REG_SP ) + P_IY );
                    };
                }
                goto st504;
tr244:

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
                goto st504;
tr247:

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
                goto st504;
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

                        add_opcode( Z80_AND( REG_B ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_AND( REG_D ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_AND( REG_E ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_AND( REG_H ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_AND( REG_H ) + P_IX );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_AND( REG_H ) + P_IY );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_AND( REG_L ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_AND( REG_L ) + P_IX );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_AND( REG_L ) + P_IY );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_AND( REG_A ) );
                    };
                }
                goto st504;
tr260:

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
                goto st504;
tr264:

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
                goto st504;
tr269:

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
                goto st504;
tr275:

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
                goto st504;
tr280:

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
                goto st504;
tr285:

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
                goto st504;
tr291:

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
                goto st504;
tr303:

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
                goto st504;
tr309:

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
                goto st504;
tr315:

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
                goto st504;
tr321:

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
                goto st504;
tr327:

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
                goto st504;
tr333:

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
                goto st504;
tr339:

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
                goto st504;
tr345:

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
                goto st504;
tr351:

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
                goto st504;
tr354:

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
                goto st504;
tr371:

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
                goto st504;
tr374:

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
                goto st504;
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

                        add_opcode( Z80_CP( REG_B ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_CP( REG_D ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_CP( REG_E ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_CP( REG_H ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_CP( REG_H ) + P_IX );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_CP( REG_H ) + P_IY );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_CP( REG_L ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_CP( REG_L ) + P_IX );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_CP( REG_L ) + P_IY );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_CP( REG_A ) );
                    };
                }
                goto st504;
tr387:

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
                goto st504;
tr391:

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
                goto st504;
tr396:

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
                goto st504;
tr402:

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
                goto st504;
tr407:

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
                goto st504;
tr412:

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
                goto st504;
tr418:

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
                goto st504;
tr420:

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
                goto st504;
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

                        add_opcode_emul( Z80_CPDR, "rcmx_cpdr" );
                    }
                }
                goto st504;
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

                        add_opcode_emul( Z80_CPI, "rcmx_cpi" );
                    }
                }
                goto st504;
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

                        add_opcode_emul( Z80_CPIR, "rcmx_cpir" );
                    }
                }
                goto st504;
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

                        add_opcode( Z80_CPL );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_DAA );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_DI );
                    };
                }
                goto st504;
tr429:

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
                goto st504;
tr432:

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
                goto st504;
tr438:

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
                goto st504;
tr442:

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
                goto st504;
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
                goto st504;
tr448:

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
                goto st504;
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

                        add_opcode( ( Z80_EX_IND_SP_idx + P_IX ) );
                    };
                }
                goto st504;
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

                        add_opcode( ( Z80_EX_IND_SP_idx + P_IY ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_EXX );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_HALT );
                    };
                }
                goto st504;
tr455:

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
                goto st504;
tr458:

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
                goto st504;
tr459:

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
                goto st504;
tr460:

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
                goto st504;
tr461:

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
                goto st504;
tr475:

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
                goto st504;
tr481:

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
                goto st504;
tr487:

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
                goto st504;
tr493:

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
                goto st504;
tr499:

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
                goto st504;
tr505:

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
                goto st504;
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

                            add_opcode_nn( ( Z80_JP_FLAG( FLAG_PE ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st504;
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

                            add_opcode_nn( ( Z80_JP_FLAG( FLAG_P ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st504;
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

                            add_opcode_nn( ( Z80_JP_FLAG( FLAG_M ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st504;
tr526:

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
                goto st504;
tr528:

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
                goto st504;
tr530:

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
                goto st504;
tr537:

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
                goto st504;
tr543:

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
                goto st504;
tr549:

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
                goto st504;
tr555:

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
                goto st504;
tr561:

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
                goto st504;
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

                        add_opcode( Z80_LDD );
                    };
                }
                goto st504;
tr565:

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
                goto st504;
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

                        add_opcode( Z80_LDI );
                    };
                }
                goto st504;
tr567:

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
                goto st504;
tr568:

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
                goto st504;
tr569:

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
                goto st504;
tr586:

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
                goto st504;
tr589:

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
                goto st504;
tr590:

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
                goto st504;
tr591:

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
                goto st504;
tr592:

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
                goto st504;
tr593:

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
                goto st504;
tr594:

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
                goto st504;
tr595:

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
                goto st504;
tr596:

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
                goto st504;
tr597:

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
                goto st504;
tr598:

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
                goto st504;
tr599:

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
                goto st504;
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

                        add_opcode( Z80_OR( REG_idx ) );
                    };
                }
                goto st504;
tr606:

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
                goto st504;
tr611:

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
                goto st504;
tr617:

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
                goto st504;
tr622:

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
                goto st504;
tr627:

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
                goto st504;
tr633:

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
                goto st504;
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

                        add_opcode( Z80_OTDR );
                    };
                }
                goto st504;
tr636:

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
                goto st504;
tr637:

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
                goto st504;
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

                        add_opcode( Z80_OUTI );
                    };
                }
                goto st504;
tr645:

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
                goto st504;
tr646:

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
                goto st504;
tr647:

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
                goto st504;
tr648:

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
                goto st504;
tr649:

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
                goto st504;
tr650:

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
                goto st504;
tr657:

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
                goto st504;
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

                        add_opcode( Z80_PUSH( REG_DE ) );
                    };
                }
                goto st504;
tr659:

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
                goto st504;
tr660:

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
                goto st504;
tr661:

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
                goto st504;
tr662:

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
                goto st504;
tr663:

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
                goto st504;
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

                        add_opcode( Z80_RET_FLAG( FLAG_NZ ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_RET_FLAG( FLAG_Z ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_RET_FLAG( FLAG_NC ) );
                    };
                }
                goto st504;
tr675:

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
                goto st504;
tr676:

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
                goto st504;
tr677:

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
                goto st504;
tr678:

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
                goto st504;
tr679:

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
                goto st504;
tr680:

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
                goto st504;
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

                        add_opcode( Z80_RETN );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_RLA );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_RLCA );
                    };
                }
                goto st504;
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

                        add_opcode_emul( Z80_RLD, "rcmx_rld" );
                    }
                }
                goto st504;
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

                        add_opcode( Z80_RRA );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_RRCA );
                    };
                }
                goto st504;
tr687:

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
                goto st504;
tr690:

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
                goto st504;
tr710:

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
                goto st504;
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

                        add_opcode( Z80_SBC( REG_C ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_SBC( REG_B ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_SBC( REG_D ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_SBC( REG_E ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_SBC( REG_H ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_SBC( REG_H ) + P_IX );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_SBC( REG_H ) + P_IY );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_SBC( REG_L ) );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_SBC( REG_L ) + P_IX );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_SBC( REG_L ) + P_IY );
                    };
                }
                goto st504;
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

                        add_opcode( Z80_SBC( REG_A ) );
                    };
                }
                goto st504;
tr726:

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
                goto st504;
tr730:

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
                goto st504;
tr735:

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
                goto st504;
tr741:

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
                goto st504;
tr746:

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
                goto st504;
tr751:

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
                goto st504;
tr757:

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
                goto st504;
tr764:

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
                goto st504;
tr765:

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
                goto st504;
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

                        add_opcode( Z80_SBC16( REG_HL ) + 0 );
                    };
                }
                goto st504;
tr767:

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
                goto st504;
tr768:

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
                goto st504;
tr785:

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
                goto st504;
tr788:

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
                goto st504;
tr789:

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
                goto st504;
tr790:

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
                goto st504;
tr791:

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
                goto st504;
tr792:

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
                goto st504;
tr793:

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
                goto st504;
tr794:

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
                goto st504;
tr795:

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
                goto st504;
tr796:

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
                goto st504;
tr797:

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
                goto st504;
tr798:

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
                goto st504;
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

                        add_opcode( Z80_SUB( REG_idx ) );
                    };
                }
                goto st504;
tr805:

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
                goto st504;
tr810:

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
                goto st504;
tr816:

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
                goto st504;
tr821:

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
                goto st504;
tr826:

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
                goto st504;
tr832:

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
                goto st504;
tr850:

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
                goto st504;
tr853:

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
                goto st504;
tr854:

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
                goto st504;
tr855:

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
                goto st504;
tr856:

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
                goto st504;
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

                        add_opcode( Z80_XOR( REG_H ) );
                    };
                }
                goto st504;
tr858:

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
                goto st504;
tr859:

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
                goto st504;
tr860:

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
                goto st504;
tr861:

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
                goto st504;
tr862:

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
                goto st504;
tr863:

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
                goto st504;
tr866:

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
                goto st504;
tr870:

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
                goto st504;
tr875:

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
                goto st504;
tr881:

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
                goto st504;
tr886:

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
                goto st504;
tr891:

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
                goto st504;
tr897:

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
                goto st504;
st504:

                if ( ++p == pe )
                    goto _test_eof504;

            case 504:

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
                    goto tr55;

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
                    goto st243;

                case 108:
                    goto st244;

                case 109:
                    goto st245;

                case 110:
                    goto st246;

                case 111:
                    goto st286;

                case 112:
                    goto st305;

                case 113:
                    goto st306;

                case 114:
                    goto st307;

                case 115:
                    goto st308;

                case 116:
                    goto st309;

                case 117:
                    goto st310;

                case 118:
                    goto st311;

                case 119:
                    goto st348;

                case 120:
                    goto st349;

                case 121:
                    goto st350;

                case 122:
                    goto st351;

                case 123:
                    goto st352;

                case 124:
                    goto st359;

                case 125:
                    goto st366;

                case 126:
                    goto st375;

                case 127:
                    goto st376;

                case 128:
                    goto st377;

                case 129:
                    goto st378;

                case 130:
                    goto st379;

                case 131:
                    goto st380;

                case 132:
                    goto st381;

                case 133:
                    goto st382;

                case 134:
                    goto st383;

                case 135:
                    goto st386;

                case 136:
                    goto st429;

                case 137:
                    goto st430;

                case 138:
                    goto st467;
                }

                goto st0;
st3:

                if ( ++p == pe )
                    goto _test_eof3;

            case 3:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr56;

                case 5:
                    goto tr56;

                case 8:
                    goto tr56;

                case 18:
                    goto tr57;

                case 21:
                    goto tr57;

                case 23:
                    goto tr57;

                case 36:
                    goto tr57;

                case 44:
                    goto tr57;

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
                    goto tr57;

                goto st0;
tr56:

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
                    goto tr73;

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
tr57:

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
                    goto tr76;

                goto st0;
st7:

                if ( ++p == pe )
                    goto _test_eof7;

            case 7:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr77;

                goto st0;
st8:

                if ( ++p == pe )
                    goto _test_eof8;

            case 8:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr78;

                goto st0;
st9:

                if ( ++p == pe )
                    goto _test_eof9;

            case 9:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr79;

                goto st0;
st10:

                if ( ++p == pe )
                    goto _test_eof10;

            case 10:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr80;

                goto st0;
st11:

                if ( ++p == pe )
                    goto _test_eof11;

            case 11:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr81;

                goto st0;
st12:

                if ( ++p == pe )
                    goto _test_eof12;

            case 12:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr82;

                goto st0;
st13:

                if ( ++p == pe )
                    goto _test_eof13;

            case 13:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr83;

                goto st0;
st14:

                if ( ++p == pe )
                    goto _test_eof14;

            case 14:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr84;

                goto st0;
st15:

                if ( ++p == pe )
                    goto _test_eof15;

            case 15:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr85;

                goto st0;
st16:

                if ( ++p == pe )
                    goto _test_eof16;

            case 16:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr86;

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
                    goto tr56;

                case 5:
                    goto tr56;

                case 8:
                    goto tr56;

                case 18:
                    goto tr57;

                case 21:
                    goto tr57;

                case 23:
                    goto tr57;

                case 36:
                    goto tr57;

                case 44:
                    goto tr57;

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
                    goto tr57;

                goto st0;
st18:

                if ( ++p == pe )
                    goto _test_eof18;

            case 18:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr86;

                goto st0;
st19:

                if ( ++p == pe )
                    goto _test_eof19;

            case 19:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr89;

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
                    goto tr93;

                goto st0;
st22:

                if ( ++p == pe )
                    goto _test_eof22;

            case 22:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr94;

                case 5:
                    goto tr94;

                case 8:
                    goto tr94;

                case 18:
                    goto tr95;

                case 21:
                    goto tr95;

                case 23:
                    goto tr95;

                case 36:
                    goto tr95;

                case 44:
                    goto tr95;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr95;

                goto st0;
tr94:

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
                    goto tr97;

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
tr97:

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
                    goto tr100;

                case 19:
                    goto tr97;

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
tr95:

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
                    goto tr102;

                case 5:
                    goto tr102;

                case 8:
                    goto tr102;

                case 18:
                    goto tr103;

                case 21:
                    goto tr103;

                case 23:
                    goto tr103;

                case 36:
                    goto tr103;

                case 44:
                    goto tr103;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr103;

                goto st0;
tr102:

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
                    goto tr104;

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
                    goto tr106;

                case 19:
                    goto tr104;

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
tr103:

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
                    goto tr111;

                goto st0;
st34:

                if ( ++p == pe )
                    goto _test_eof34;

            case 34:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr112;

                case 5:
                    goto tr112;

                case 8:
                    goto tr112;

                case 18:
                    goto tr113;

                case 21:
                    goto tr113;

                case 23:
                    goto tr113;

                case 36:
                    goto tr113;

                case 44:
                    goto tr113;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr113;

                goto st0;
tr112:

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
                    goto tr114;

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
                    goto tr116;

                case 19:
                    goto tr114;

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
tr113:

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
                    goto tr118;

                case 5:
                    goto tr118;

                case 8:
                    goto tr118;

                case 18:
                    goto tr119;

                case 21:
                    goto tr119;

                case 23:
                    goto tr119;

                case 36:
                    goto tr119;

                case 44:
                    goto tr119;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr119;

                goto st0;
tr118:

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
                    goto tr120;

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
                    goto tr122;

                case 19:
                    goto tr120;

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
tr119:

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
                    goto tr129;

                goto st0;
st45:

                if ( ++p == pe )
                    goto _test_eof45;

            case 45:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr130;

                goto st0;
st46:

                if ( ++p == pe )
                    goto _test_eof46;

            case 46:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr131;

                goto st0;
st47:

                if ( ++p == pe )
                    goto _test_eof47;

            case 47:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr132;

                goto st0;
st48:

                if ( ++p == pe )
                    goto _test_eof48;

            case 48:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr133;

                case 5:
                    goto tr133;

                case 8:
                    goto tr133;

                case 18:
                    goto tr134;

                case 21:
                    goto tr134;

                case 23:
                    goto tr134;

                case 36:
                    goto tr134;

                case 44:
                    goto tr134;

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
                    goto tr134;

                goto st0;
tr133:

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
                    goto tr152;

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
tr134:

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
                    goto tr155;

                goto st0;
st52:

                if ( ++p == pe )
                    goto _test_eof52;

            case 52:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr156;

                goto st0;
st53:

                if ( ++p == pe )
                    goto _test_eof53;

            case 53:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr157;

                goto st0;
st54:

                if ( ++p == pe )
                    goto _test_eof54;

            case 54:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr158;

                goto st0;
st55:

                if ( ++p == pe )
                    goto _test_eof55;

            case 55:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr159;

                goto st0;
st56:

                if ( ++p == pe )
                    goto _test_eof56;

            case 56:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr160;

                goto st0;
st57:

                if ( ++p == pe )
                    goto _test_eof57;

            case 57:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr161;

                goto st0;
st58:

                if ( ++p == pe )
                    goto _test_eof58;

            case 58:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr162;

                goto st0;
st59:

                if ( ++p == pe )
                    goto _test_eof59;

            case 59:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr163;

                goto st0;
st60:

                if ( ++p == pe )
                    goto _test_eof60;

            case 60:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr164;

                goto st0;
st61:

                if ( ++p == pe )
                    goto _test_eof61;

            case 61:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr165;

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
                    goto tr133;

                case 5:
                    goto tr133;

                case 8:
                    goto tr133;

                case 18:
                    goto tr134;

                case 21:
                    goto tr134;

                case 23:
                    goto tr134;

                case 36:
                    goto tr134;

                case 44:
                    goto tr134;

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
                    goto tr134;

                goto st0;
st63:

                if ( ++p == pe )
                    goto _test_eof63;

            case 63:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr165;

                goto st0;
st64:

                if ( ++p == pe )
                    goto _test_eof64;

            case 64:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr168;

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
                    goto tr172;

                goto st0;
st67:

                if ( ++p == pe )
                    goto _test_eof67;

            case 67:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr173;

                case 5:
                    goto tr173;

                case 8:
                    goto tr173;

                case 18:
                    goto tr174;

                case 21:
                    goto tr174;

                case 23:
                    goto tr174;

                case 36:
                    goto tr174;

                case 44:
                    goto tr174;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr174;

                goto st0;
tr173:

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
                    goto tr175;

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
                    goto tr177;

                case 19:
                    goto tr175;

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
tr174:

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
                    goto tr179;

                case 5:
                    goto tr179;

                case 8:
                    goto tr179;

                case 18:
                    goto tr180;

                case 21:
                    goto tr180;

                case 23:
                    goto tr180;

                case 36:
                    goto tr180;

                case 44:
                    goto tr180;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr180;

                goto st0;
tr179:

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
                    goto tr181;

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
                    goto tr183;

                case 19:
                    goto tr181;

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
tr180:

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
                    goto tr188;

                goto st0;
st77:

                if ( ++p == pe )
                    goto _test_eof77;

            case 77:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr189;

                case 5:
                    goto tr189;

                case 8:
                    goto tr189;

                case 18:
                    goto tr190;

                case 21:
                    goto tr190;

                case 23:
                    goto tr190;

                case 36:
                    goto tr190;

                case 44:
                    goto tr190;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr190;

                goto st0;
tr189:

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
                    goto tr191;

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
                    goto tr193;

                case 19:
                    goto tr191;

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
tr190:

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
                    goto tr195;

                case 5:
                    goto tr195;

                case 8:
                    goto tr195;

                case 18:
                    goto tr196;

                case 21:
                    goto tr196;

                case 23:
                    goto tr196;

                case 36:
                    goto tr196;

                case 44:
                    goto tr196;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr196;

                goto st0;
tr195:

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
                    goto tr197;

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
                    goto tr199;

                case 19:
                    goto tr197;

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
tr196:

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
                    goto tr206;

                goto st0;
st88:

                if ( ++p == pe )
                    goto _test_eof88;

            case 88:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr207;

                goto st0;
st89:

                if ( ++p == pe )
                    goto _test_eof89;

            case 89:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr208;

                goto st0;
st90:

                if ( ++p == pe )
                    goto _test_eof90;

            case 90:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr209;

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
                    goto tr215;

                goto st0;
st94:

                if ( ++p == pe )
                    goto _test_eof94;

            case 94:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr216;

                goto st0;
st95:

                if ( ++p == pe )
                    goto _test_eof95;

            case 95:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr217;

                goto st0;
st96:

                if ( ++p == pe )
                    goto _test_eof96;

            case 96:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr218;

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
                    goto tr224;

                goto st0;
st100:

                if ( ++p == pe )
                    goto _test_eof100;

            case 100:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr225;

                goto st0;
st101:

                if ( ++p == pe )
                    goto _test_eof101;

            case 101:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr226;

                goto st0;
st102:

                if ( ++p == pe )
                    goto _test_eof102;

            case 102:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr227;

                goto st0;
st103:

                if ( ++p == pe )
                    goto _test_eof103;

            case 103:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr228;

                case 5:
                    goto tr228;

                case 8:
                    goto tr228;

                case 18:
                    goto tr229;

                case 21:
                    goto tr229;

                case 23:
                    goto tr229;

                case 36:
                    goto tr229;

                case 44:
                    goto tr229;

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
                    goto tr229;

                goto st0;
tr228:

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
                    goto tr244;

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
tr229:

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
                    goto tr247;

                goto st0;
st107:

                if ( ++p == pe )
                    goto _test_eof107;

            case 107:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr248;

                goto st0;
st108:

                if ( ++p == pe )
                    goto _test_eof108;

            case 108:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr249;

                goto st0;
st109:

                if ( ++p == pe )
                    goto _test_eof109;

            case 109:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr250;

                goto st0;
st110:

                if ( ++p == pe )
                    goto _test_eof110;

            case 110:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr251;

                goto st0;
st111:

                if ( ++p == pe )
                    goto _test_eof111;

            case 111:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr252;

                goto st0;
st112:

                if ( ++p == pe )
                    goto _test_eof112;

            case 112:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr253;

                goto st0;
st113:

                if ( ++p == pe )
                    goto _test_eof113;

            case 113:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr254;

                goto st0;
st114:

                if ( ++p == pe )
                    goto _test_eof114;

            case 114:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr255;

                goto st0;
st115:

                if ( ++p == pe )
                    goto _test_eof115;

            case 115:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr256;

                goto st0;
st116:

                if ( ++p == pe )
                    goto _test_eof116;

            case 116:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr257;

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
                    goto tr228;

                case 5:
                    goto tr228;

                case 8:
                    goto tr228;

                case 18:
                    goto tr229;

                case 21:
                    goto tr229;

                case 23:
                    goto tr229;

                case 36:
                    goto tr229;

                case 44:
                    goto tr229;

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
                    goto tr229;

                goto st0;
st118:

                if ( ++p == pe )
                    goto _test_eof118;

            case 118:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr257;

                goto st0;
st119:

                if ( ++p == pe )
                    goto _test_eof119;

            case 119:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr260;

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
                    goto tr264;

                goto st0;
st122:

                if ( ++p == pe )
                    goto _test_eof122;

            case 122:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr265;

                case 5:
                    goto tr265;

                case 8:
                    goto tr265;

                case 18:
                    goto tr266;

                case 21:
                    goto tr266;

                case 23:
                    goto tr266;

                case 36:
                    goto tr266;

                case 44:
                    goto tr266;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr266;

                goto st0;
tr265:

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
                    goto tr267;

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
                    goto tr269;

                case 19:
                    goto tr267;

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
tr266:

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
                    goto tr271;

                case 5:
                    goto tr271;

                case 8:
                    goto tr271;

                case 18:
                    goto tr272;

                case 21:
                    goto tr272;

                case 23:
                    goto tr272;

                case 36:
                    goto tr272;

                case 44:
                    goto tr272;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr272;

                goto st0;
tr271:

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
                    goto tr273;

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
                    goto tr275;

                case 19:
                    goto tr273;

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
tr272:

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
                    goto tr280;

                goto st0;
st132:

                if ( ++p == pe )
                    goto _test_eof132;

            case 132:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr281;

                case 5:
                    goto tr281;

                case 8:
                    goto tr281;

                case 18:
                    goto tr282;

                case 21:
                    goto tr282;

                case 23:
                    goto tr282;

                case 36:
                    goto tr282;

                case 44:
                    goto tr282;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr282;

                goto st0;
tr281:

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
                    goto tr283;

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
                    goto tr285;

                case 19:
                    goto tr283;

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
tr282:

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
                    goto tr287;

                case 5:
                    goto tr287;

                case 8:
                    goto tr287;

                case 18:
                    goto tr288;

                case 21:
                    goto tr288;

                case 23:
                    goto tr288;

                case 36:
                    goto tr288;

                case 44:
                    goto tr288;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr288;

                goto st0;
tr287:

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
                    goto tr289;

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
                    goto tr291;

                case 19:
                    goto tr289;

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
tr288:

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
                    goto tr293;

                case 5:
                    goto tr293;

                case 8:
                    goto tr293;

                case 18:
                    goto tr294;

                case 21:
                    goto tr294;

                case 23:
                    goto tr294;

                case 36:
                    goto tr294;

                case 44:
                    goto tr294;

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
                    goto tr294;

                goto st0;
tr293:

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
                    goto tr303;

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
tr294:

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
                    goto tr307;

                case 5:
                    goto tr307;

                case 8:
                    goto tr307;

                case 18:
                    goto tr308;

                case 21:
                    goto tr308;

                case 23:
                    goto tr308;

                case 36:
                    goto tr308;

                case 44:
                    goto tr308;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr308;

                goto st0;
tr307:

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
                    goto tr309;

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
tr308:

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
                    goto tr313;

                case 5:
                    goto tr313;

                case 8:
                    goto tr313;

                case 18:
                    goto tr314;

                case 21:
                    goto tr314;

                case 23:
                    goto tr314;

                case 36:
                    goto tr314;

                case 44:
                    goto tr314;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr314;

                goto st0;
tr313:

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
                    goto tr315;

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
tr314:

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
                    goto tr319;

                case 5:
                    goto tr319;

                case 8:
                    goto tr319;

                case 18:
                    goto tr320;

                case 21:
                    goto tr320;

                case 23:
                    goto tr320;

                case 36:
                    goto tr320;

                case 44:
                    goto tr320;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr320;

                goto st0;
tr319:

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
                    goto tr321;

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
tr320:

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
                    goto tr325;

                case 5:
                    goto tr325;

                case 8:
                    goto tr325;

                case 18:
                    goto tr326;

                case 21:
                    goto tr326;

                case 23:
                    goto tr326;

                case 36:
                    goto tr326;

                case 44:
                    goto tr326;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr326;

                goto st0;
tr325:

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
                    goto tr327;

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
tr326:

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
                    goto tr331;

                case 5:
                    goto tr331;

                case 8:
                    goto tr331;

                case 18:
                    goto tr332;

                case 21:
                    goto tr332;

                case 23:
                    goto tr332;

                case 36:
                    goto tr332;

                case 44:
                    goto tr332;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr332;

                goto st0;
tr331:

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
                    goto tr333;

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
tr332:

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
                    goto tr337;

                case 5:
                    goto tr337;

                case 8:
                    goto tr337;

                case 18:
                    goto tr338;

                case 21:
                    goto tr338;

                case 23:
                    goto tr338;

                case 36:
                    goto tr338;

                case 44:
                    goto tr338;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr338;

                goto st0;
tr337:

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
                    goto tr339;

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
tr338:

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
                    goto tr343;

                case 5:
                    goto tr343;

                case 8:
                    goto tr343;

                case 18:
                    goto tr344;

                case 21:
                    goto tr344;

                case 23:
                    goto tr344;

                case 36:
                    goto tr344;

                case 44:
                    goto tr344;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr344;

                goto st0;
tr343:

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
                    goto tr345;

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
tr344:

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
                    goto tr349;

                case 5:
                    goto tr349;

                case 8:
                    goto tr349;

                case 18:
                    goto tr350;

                case 21:
                    goto tr350;

                case 23:
                    goto tr350;

                case 36:
                    goto tr350;

                case 44:
                    goto tr350;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr350;

                goto st0;
tr349:

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
                    goto tr351;

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
tr350:

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
                    goto tr354;

                goto st0;
st176:

                if ( ++p == pe )
                    goto _test_eof176;

            case 176:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr355;

                case 5:
                    goto tr355;

                case 8:
                    goto tr355;

                case 18:
                    goto tr356;

                case 21:
                    goto tr356;

                case 23:
                    goto tr356;

                case 36:
                    goto tr356;

                case 44:
                    goto tr356;

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
                    goto tr356;

                goto st0;
tr355:

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
                    goto tr371;

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
tr356:

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
                    goto tr374;

                goto st0;
st180:

                if ( ++p == pe )
                    goto _test_eof180;

            case 180:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr375;

                goto st0;
st181:

                if ( ++p == pe )
                    goto _test_eof181;

            case 181:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr376;

                goto st0;
st182:

                if ( ++p == pe )
                    goto _test_eof182;

            case 182:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr377;

                goto st0;
st183:

                if ( ++p == pe )
                    goto _test_eof183;

            case 183:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr378;

                goto st0;
st184:

                if ( ++p == pe )
                    goto _test_eof184;

            case 184:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr379;

                goto st0;
st185:

                if ( ++p == pe )
                    goto _test_eof185;

            case 185:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr380;

                goto st0;
st186:

                if ( ++p == pe )
                    goto _test_eof186;

            case 186:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr381;

                goto st0;
st187:

                if ( ++p == pe )
                    goto _test_eof187;

            case 187:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr382;

                goto st0;
st188:

                if ( ++p == pe )
                    goto _test_eof188;

            case 188:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr383;

                goto st0;
st189:

                if ( ++p == pe )
                    goto _test_eof189;

            case 189:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr384;

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
                    goto tr355;

                case 5:
                    goto tr355;

                case 8:
                    goto tr355;

                case 18:
                    goto tr356;

                case 21:
                    goto tr356;

                case 23:
                    goto tr356;

                case 36:
                    goto tr356;

                case 44:
                    goto tr356;

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
                    goto tr356;

                goto st0;
st191:

                if ( ++p == pe )
                    goto _test_eof191;

            case 191:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr384;

                goto st0;
st192:

                if ( ++p == pe )
                    goto _test_eof192;

            case 192:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr387;

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
                    goto tr391;

                goto st0;
st195:

                if ( ++p == pe )
                    goto _test_eof195;

            case 195:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr392;

                case 5:
                    goto tr392;

                case 8:
                    goto tr392;

                case 18:
                    goto tr393;

                case 21:
                    goto tr393;

                case 23:
                    goto tr393;

                case 36:
                    goto tr393;

                case 44:
                    goto tr393;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr393;

                goto st0;
tr392:

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
                    goto tr394;

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
                    goto tr396;

                case 19:
                    goto tr394;

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
tr393:

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
                    goto tr398;

                case 5:
                    goto tr398;

                case 8:
                    goto tr398;

                case 18:
                    goto tr399;

                case 21:
                    goto tr399;

                case 23:
                    goto tr399;

                case 36:
                    goto tr399;

                case 44:
                    goto tr399;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr399;

                goto st0;
tr398:

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
                    goto tr400;

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
                    goto tr402;

                case 19:
                    goto tr400;

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
tr399:

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
                    goto tr407;

                goto st0;
st205:

                if ( ++p == pe )
                    goto _test_eof205;

            case 205:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr408;

                case 5:
                    goto tr408;

                case 8:
                    goto tr408;

                case 18:
                    goto tr409;

                case 21:
                    goto tr409;

                case 23:
                    goto tr409;

                case 36:
                    goto tr409;

                case 44:
                    goto tr409;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr409;

                goto st0;
tr408:

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
                    goto tr410;

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
                    goto tr412;

                case 19:
                    goto tr410;

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
tr409:

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
                    goto tr414;

                case 5:
                    goto tr414;

                case 8:
                    goto tr414;

                case 18:
                    goto tr415;

                case 21:
                    goto tr415;

                case 23:
                    goto tr415;

                case 36:
                    goto tr415;

                case 44:
                    goto tr415;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr415;

                goto st0;
tr414:

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
                    goto tr416;

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
                    goto tr418;

                case 19:
                    goto tr416;

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
tr415:

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
                    goto tr420;

                goto st0;
st214:

                if ( ++p == pe )
                    goto _test_eof214;

            case 214:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr421;

                goto st0;
st215:

                if ( ++p == pe )
                    goto _test_eof215;

            case 215:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr422;

                goto st0;
st216:

                if ( ++p == pe )
                    goto _test_eof216;

            case 216:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr423;

                goto st0;
st217:

                if ( ++p == pe )
                    goto _test_eof217;

            case 217:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr424;

                goto st0;
st218:

                if ( ++p == pe )
                    goto _test_eof218;

            case 218:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr425;

                goto st0;
st219:

                if ( ++p == pe )
                    goto _test_eof219;

            case 219:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr426;

                goto st0;
st220:

                if ( ++p == pe )
                    goto _test_eof220;

            case 220:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr427;

                case 5:
                    goto tr427;

                case 8:
                    goto tr427;

                case 18:
                    goto tr428;

                case 21:
                    goto tr428;

                case 23:
                    goto tr428;

                case 36:
                    goto tr428;

                case 44:
                    goto tr428;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr428;

                goto st0;
tr427:

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
                    goto tr429;

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
tr428:

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
                    goto tr432;

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
                    goto tr438;

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
                    goto tr442;

                goto st0;
st231:

                if ( ++p == pe )
                    goto _test_eof231;

            case 231:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr443;

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
                    goto tr448;

                goto st0;
st235:

                if ( ++p == pe )
                    goto _test_eof235;

            case 235:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr449;

                goto st0;
st236:

                if ( ++p == pe )
                    goto _test_eof236;

            case 236:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr450;

                goto st0;
st237:

                if ( ++p == pe )
                    goto _test_eof237;

            case 237:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr451;

                goto st0;
st238:

                if ( ++p == pe )
                    goto _test_eof238;

            case 238:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr452;

                goto st0;
st239:

                if ( ++p == pe )
                    goto _test_eof239;

            case 239:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr453;

                case 5:
                    goto tr453;

                case 8:
                    goto tr453;

                case 18:
                    goto tr454;

                case 21:
                    goto tr454;

                case 23:
                    goto tr454;

                case 36:
                    goto tr454;

                case 44:
                    goto tr454;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr454;

                goto st0;
tr453:

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
                    goto tr455;

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
tr454:

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
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr458;

                goto st0;
st243:

                if ( ++p == pe )
                    goto _test_eof243;

            case 243:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr459;

                goto st0;
st244:

                if ( ++p == pe )
                    goto _test_eof244;

            case 244:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr460;

                goto st0;
st245:

                if ( ++p == pe )
                    goto _test_eof245;

            case 245:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr461;

                goto st0;
st246:

                if ( ++p == pe )
                    goto _test_eof246;

            case 246:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr462;

                case 5:
                    goto tr462;

                case 8:
                    goto tr462;

                case 18:
                    goto tr463;

                case 21:
                    goto tr463;

                case 23:
                    goto tr463;

                case 36:
                    goto tr463;

                case 44:
                    goto tr463;

                case 45:
                    goto st249;

                case 46:
                    goto st253;

                case 47:
                    goto st257;

                case 48:
                    goto st261;

                case 49:
                    goto st265;

                case 50:
                    goto st269;

                case 51:
                    goto st273;

                case 52:
                    goto st277;

                case 79:
                    goto st281;

                case 80:
                    goto st282;

                case 81:
                    goto st284;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr463;

                goto st0;
tr462:

                {
                    expr_start = p;
                }
                goto st247;
st247:

                if ( ++p == pe )
                    goto _test_eof247;

            case 247:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr475;

                case 19:
                    goto st247;

                case 23:
                    goto st248;

                case 37:
                    goto st247;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st248;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st248;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st248;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st248;
                }
                else
                    goto st248;

                goto st0;
tr463:

                {
                    expr_start = p;
                }
                goto st248;
st248:

                if ( ++p == pe )
                    goto _test_eof248;

            case 248:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st247;

                case 5:
                    goto st247;

                case 8:
                    goto st247;

                case 13:
                    goto st248;

                case 18:
                    goto st248;

                case 21:
                    goto st248;

                case 23:
                    goto st248;

                case 36:
                    goto st248;

                case 44:
                    goto st248;
                }

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
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr479;

                case 5:
                    goto tr479;

                case 8:
                    goto tr479;

                case 18:
                    goto tr480;

                case 21:
                    goto tr480;

                case 23:
                    goto tr480;

                case 36:
                    goto tr480;

                case 44:
                    goto tr480;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr480;

                goto st0;
tr479:

                {
                    expr_start = p;
                }
                goto st251;
st251:

                if ( ++p == pe )
                    goto _test_eof251;

            case 251:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr481;

                case 19:
                    goto st251;

                case 23:
                    goto st252;

                case 37:
                    goto st251;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st252;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st252;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st252;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st252;
                }
                else
                    goto st252;

                goto st0;
tr480:

                {
                    expr_start = p;
                }
                goto st252;
st252:

                if ( ++p == pe )
                    goto _test_eof252;

            case 252:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st251;

                case 5:
                    goto st251;

                case 8:
                    goto st251;

                case 13:
                    goto st252;

                case 18:
                    goto st252;

                case 21:
                    goto st252;

                case 23:
                    goto st252;

                case 36:
                    goto st252;

                case 44:
                    goto st252;
                }

                goto st0;
st253:

                if ( ++p == pe )
                    goto _test_eof253;

            case 253:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st254;

                goto st0;
st254:

                if ( ++p == pe )
                    goto _test_eof254;

            case 254:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr485;

                case 5:
                    goto tr485;

                case 8:
                    goto tr485;

                case 18:
                    goto tr486;

                case 21:
                    goto tr486;

                case 23:
                    goto tr486;

                case 36:
                    goto tr486;

                case 44:
                    goto tr486;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr486;

                goto st0;
tr485:

                {
                    expr_start = p;
                }
                goto st255;
st255:

                if ( ++p == pe )
                    goto _test_eof255;

            case 255:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr487;

                case 19:
                    goto st255;

                case 23:
                    goto st256;

                case 37:
                    goto st255;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st256;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st256;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st256;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st256;
                }
                else
                    goto st256;

                goto st0;
tr486:

                {
                    expr_start = p;
                }
                goto st256;
st256:

                if ( ++p == pe )
                    goto _test_eof256;

            case 256:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st255;

                case 5:
                    goto st255;

                case 8:
                    goto st255;

                case 13:
                    goto st256;

                case 18:
                    goto st256;

                case 21:
                    goto st256;

                case 23:
                    goto st256;

                case 36:
                    goto st256;

                case 44:
                    goto st256;
                }

                goto st0;
st257:

                if ( ++p == pe )
                    goto _test_eof257;

            case 257:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st258;

                goto st0;
st258:

                if ( ++p == pe )
                    goto _test_eof258;

            case 258:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr491;

                case 5:
                    goto tr491;

                case 8:
                    goto tr491;

                case 18:
                    goto tr492;

                case 21:
                    goto tr492;

                case 23:
                    goto tr492;

                case 36:
                    goto tr492;

                case 44:
                    goto tr492;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr492;

                goto st0;
tr491:

                {
                    expr_start = p;
                }
                goto st259;
st259:

                if ( ++p == pe )
                    goto _test_eof259;

            case 259:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr493;

                case 19:
                    goto st259;

                case 23:
                    goto st260;

                case 37:
                    goto st259;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st260;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st260;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st260;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st260;
                }
                else
                    goto st260;

                goto st0;
tr492:

                {
                    expr_start = p;
                }
                goto st260;
st260:

                if ( ++p == pe )
                    goto _test_eof260;

            case 260:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st259;

                case 5:
                    goto st259;

                case 8:
                    goto st259;

                case 13:
                    goto st260;

                case 18:
                    goto st260;

                case 21:
                    goto st260;

                case 23:
                    goto st260;

                case 36:
                    goto st260;

                case 44:
                    goto st260;
                }

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
                case 3:
                    goto tr497;

                case 5:
                    goto tr497;

                case 8:
                    goto tr497;

                case 18:
                    goto tr498;

                case 21:
                    goto tr498;

                case 23:
                    goto tr498;

                case 36:
                    goto tr498;

                case 44:
                    goto tr498;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr498;

                goto st0;
tr497:

                {
                    expr_start = p;
                }
                goto st263;
st263:

                if ( ++p == pe )
                    goto _test_eof263;

            case 263:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr499;

                case 19:
                    goto st263;

                case 23:
                    goto st264;

                case 37:
                    goto st263;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st264;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st264;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st264;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st264;
                }
                else
                    goto st264;

                goto st0;
tr498:

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
                case 3:
                    goto st263;

                case 5:
                    goto st263;

                case 8:
                    goto st263;

                case 13:
                    goto st264;

                case 18:
                    goto st264;

                case 21:
                    goto st264;

                case 23:
                    goto st264;

                case 36:
                    goto st264;

                case 44:
                    goto st264;
                }

                goto st0;
st265:

                if ( ++p == pe )
                    goto _test_eof265;

            case 265:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st266;

                goto st0;
st266:

                if ( ++p == pe )
                    goto _test_eof266;

            case 266:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr503;

                case 5:
                    goto tr503;

                case 8:
                    goto tr503;

                case 18:
                    goto tr504;

                case 21:
                    goto tr504;

                case 23:
                    goto tr504;

                case 36:
                    goto tr504;

                case 44:
                    goto tr504;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr504;

                goto st0;
tr503:

                {
                    expr_start = p;
                }
                goto st267;
st267:

                if ( ++p == pe )
                    goto _test_eof267;

            case 267:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr505;

                case 19:
                    goto st267;

                case 23:
                    goto st268;

                case 37:
                    goto st267;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st268;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st268;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st268;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st268;
                }
                else
                    goto st268;

                goto st0;
tr504:

                {
                    expr_start = p;
                }
                goto st268;
st268:

                if ( ++p == pe )
                    goto _test_eof268;

            case 268:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st267;

                case 5:
                    goto st267;

                case 8:
                    goto st267;

                case 13:
                    goto st268;

                case 18:
                    goto st268;

                case 21:
                    goto st268;

                case 23:
                    goto st268;

                case 36:
                    goto st268;

                case 44:
                    goto st268;
                }

                goto st0;
st269:

                if ( ++p == pe )
                    goto _test_eof269;

            case 269:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st270;

                goto st0;
st270:

                if ( ++p == pe )
                    goto _test_eof270;

            case 270:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr509;

                case 5:
                    goto tr509;

                case 8:
                    goto tr509;

                case 18:
                    goto tr510;

                case 21:
                    goto tr510;

                case 23:
                    goto tr510;

                case 36:
                    goto tr510;

                case 44:
                    goto tr510;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr510;

                goto st0;
tr509:

                {
                    expr_start = p;
                }
                goto st271;
st271:

                if ( ++p == pe )
                    goto _test_eof271;

            case 271:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr511;

                case 19:
                    goto st271;

                case 23:
                    goto st272;

                case 37:
                    goto st271;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st272;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st272;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st272;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st272;
                }
                else
                    goto st272;

                goto st0;
tr510:

                {
                    expr_start = p;
                }
                goto st272;
st272:

                if ( ++p == pe )
                    goto _test_eof272;

            case 272:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st271;

                case 5:
                    goto st271;

                case 8:
                    goto st271;

                case 13:
                    goto st272;

                case 18:
                    goto st272;

                case 21:
                    goto st272;

                case 23:
                    goto st272;

                case 36:
                    goto st272;

                case 44:
                    goto st272;
                }

                goto st0;
st273:

                if ( ++p == pe )
                    goto _test_eof273;

            case 273:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st274;

                goto st0;
st274:

                if ( ++p == pe )
                    goto _test_eof274;

            case 274:
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
                goto st275;
st275:

                if ( ++p == pe )
                    goto _test_eof275;

            case 275:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr517;

                case 19:
                    goto st275;

                case 23:
                    goto st276;

                case 37:
                    goto st275;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st276;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st276;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st276;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st276;
                }
                else
                    goto st276;

                goto st0;
tr516:

                {
                    expr_start = p;
                }
                goto st276;
st276:

                if ( ++p == pe )
                    goto _test_eof276;

            case 276:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st275;

                case 5:
                    goto st275;

                case 8:
                    goto st275;

                case 13:
                    goto st276;

                case 18:
                    goto st276;

                case 21:
                    goto st276;

                case 23:
                    goto st276;

                case 36:
                    goto st276;

                case 44:
                    goto st276;
                }

                goto st0;
st277:

                if ( ++p == pe )
                    goto _test_eof277;

            case 277:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st278;

                goto st0;
st278:

                if ( ++p == pe )
                    goto _test_eof278;

            case 278:
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
                goto st279;
st279:

                if ( ++p == pe )
                    goto _test_eof279;

            case 279:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr523;

                case 19:
                    goto st279;

                case 23:
                    goto st280;

                case 37:
                    goto st279;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st280;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st280;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st280;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st280;
                }
                else
                    goto st280;

                goto st0;
tr522:

                {
                    expr_start = p;
                }
                goto st280;
st280:

                if ( ++p == pe )
                    goto _test_eof280;

            case 280:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st279;

                case 5:
                    goto st279;

                case 8:
                    goto st279;

                case 13:
                    goto st280;

                case 18:
                    goto st280;

                case 21:
                    goto st280;

                case 23:
                    goto st280;

                case 36:
                    goto st280;

                case 44:
                    goto st280;
                }

                goto st0;
st281:

                if ( ++p == pe )
                    goto _test_eof281;

            case 281:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr526;

                goto st0;
st282:

                if ( ++p == pe )
                    goto _test_eof282;

            case 282:
                if ( ( ( ( int ) p->tok ) ) == 19 )
                    goto st283;

                goto st0;
st283:

                if ( ++p == pe )
                    goto _test_eof283;

            case 283:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr528;

                goto st0;
st284:

                if ( ++p == pe )
                    goto _test_eof284;

            case 284:
                if ( ( ( ( int ) p->tok ) ) == 19 )
                    goto st285;

                goto st0;
st285:

                if ( ++p == pe )
                    goto _test_eof285;

            case 285:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr530;

                goto st0;
st286:

                if ( ++p == pe )
                    goto _test_eof286;

            case 286:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr531;

                case 5:
                    goto tr531;

                case 8:
                    goto tr531;

                case 18:
                    goto tr532;

                case 21:
                    goto tr532;

                case 23:
                    goto tr532;

                case 36:
                    goto tr532;

                case 44:
                    goto tr532;

                case 45:
                    goto st289;

                case 46:
                    goto st293;

                case 47:
                    goto st297;

                case 48:
                    goto st301;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr532;

                goto st0;
tr531:

                {
                    expr_start = p;
                }
                goto st287;
st287:

                if ( ++p == pe )
                    goto _test_eof287;

            case 287:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr537;

                case 19:
                    goto st287;

                case 23:
                    goto st288;

                case 37:
                    goto st287;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st288;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st288;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st288;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st288;
                }
                else
                    goto st288;

                goto st0;
tr532:

                {
                    expr_start = p;
                }
                goto st288;
st288:

                if ( ++p == pe )
                    goto _test_eof288;

            case 288:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st287;

                case 5:
                    goto st287;

                case 8:
                    goto st287;

                case 13:
                    goto st288;

                case 18:
                    goto st288;

                case 21:
                    goto st288;

                case 23:
                    goto st288;

                case 36:
                    goto st288;

                case 44:
                    goto st288;
                }

                goto st0;
st289:

                if ( ++p == pe )
                    goto _test_eof289;

            case 289:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st290;

                goto st0;
st290:

                if ( ++p == pe )
                    goto _test_eof290;

            case 290:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr541;

                case 5:
                    goto tr541;

                case 8:
                    goto tr541;

                case 18:
                    goto tr542;

                case 21:
                    goto tr542;

                case 23:
                    goto tr542;

                case 36:
                    goto tr542;

                case 44:
                    goto tr542;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr542;

                goto st0;
tr541:

                {
                    expr_start = p;
                }
                goto st291;
st291:

                if ( ++p == pe )
                    goto _test_eof291;

            case 291:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr543;

                case 19:
                    goto st291;

                case 23:
                    goto st292;

                case 37:
                    goto st291;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st292;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st292;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st292;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st292;
                }
                else
                    goto st292;

                goto st0;
tr542:

                {
                    expr_start = p;
                }
                goto st292;
st292:

                if ( ++p == pe )
                    goto _test_eof292;

            case 292:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st291;

                case 5:
                    goto st291;

                case 8:
                    goto st291;

                case 13:
                    goto st292;

                case 18:
                    goto st292;

                case 21:
                    goto st292;

                case 23:
                    goto st292;

                case 36:
                    goto st292;

                case 44:
                    goto st292;
                }

                goto st0;
st293:

                if ( ++p == pe )
                    goto _test_eof293;

            case 293:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st294;

                goto st0;
st294:

                if ( ++p == pe )
                    goto _test_eof294;

            case 294:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr547;

                case 5:
                    goto tr547;

                case 8:
                    goto tr547;

                case 18:
                    goto tr548;

                case 21:
                    goto tr548;

                case 23:
                    goto tr548;

                case 36:
                    goto tr548;

                case 44:
                    goto tr548;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr548;

                goto st0;
tr547:

                {
                    expr_start = p;
                }
                goto st295;
st295:

                if ( ++p == pe )
                    goto _test_eof295;

            case 295:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr549;

                case 19:
                    goto st295;

                case 23:
                    goto st296;

                case 37:
                    goto st295;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st296;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st296;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st296;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st296;
                }
                else
                    goto st296;

                goto st0;
tr548:

                {
                    expr_start = p;
                }
                goto st296;
st296:

                if ( ++p == pe )
                    goto _test_eof296;

            case 296:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st295;

                case 5:
                    goto st295;

                case 8:
                    goto st295;

                case 13:
                    goto st296;

                case 18:
                    goto st296;

                case 21:
                    goto st296;

                case 23:
                    goto st296;

                case 36:
                    goto st296;

                case 44:
                    goto st296;
                }

                goto st0;
st297:

                if ( ++p == pe )
                    goto _test_eof297;

            case 297:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st298;

                goto st0;
st298:

                if ( ++p == pe )
                    goto _test_eof298;

            case 298:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr553;

                case 5:
                    goto tr553;

                case 8:
                    goto tr553;

                case 18:
                    goto tr554;

                case 21:
                    goto tr554;

                case 23:
                    goto tr554;

                case 36:
                    goto tr554;

                case 44:
                    goto tr554;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr554;

                goto st0;
tr553:

                {
                    expr_start = p;
                }
                goto st299;
st299:

                if ( ++p == pe )
                    goto _test_eof299;

            case 299:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr555;

                case 19:
                    goto st299;

                case 23:
                    goto st300;

                case 37:
                    goto st299;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st300;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st300;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st300;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st300;
                }
                else
                    goto st300;

                goto st0;
tr554:

                {
                    expr_start = p;
                }
                goto st300;
st300:

                if ( ++p == pe )
                    goto _test_eof300;

            case 300:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st299;

                case 5:
                    goto st299;

                case 8:
                    goto st299;

                case 13:
                    goto st300;

                case 18:
                    goto st300;

                case 21:
                    goto st300;

                case 23:
                    goto st300;

                case 36:
                    goto st300;

                case 44:
                    goto st300;
                }

                goto st0;
st301:

                if ( ++p == pe )
                    goto _test_eof301;

            case 301:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st302;

                goto st0;
st302:

                if ( ++p == pe )
                    goto _test_eof302;

            case 302:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr559;

                case 5:
                    goto tr559;

                case 8:
                    goto tr559;

                case 18:
                    goto tr560;

                case 21:
                    goto tr560;

                case 23:
                    goto tr560;

                case 36:
                    goto tr560;

                case 44:
                    goto tr560;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr560;

                goto st0;
tr559:

                {
                    expr_start = p;
                }
                goto st303;
st303:

                if ( ++p == pe )
                    goto _test_eof303;

            case 303:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr561;

                case 19:
                    goto st303;

                case 23:
                    goto st304;

                case 37:
                    goto st303;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st304;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st304;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st304;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st304;
                }
                else
                    goto st304;

                goto st0;
tr560:

                {
                    expr_start = p;
                }
                goto st304;
st304:

                if ( ++p == pe )
                    goto _test_eof304;

            case 304:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st303;

                case 5:
                    goto st303;

                case 8:
                    goto st303;

                case 13:
                    goto st304;

                case 18:
                    goto st304;

                case 21:
                    goto st304;

                case 23:
                    goto st304;

                case 36:
                    goto st304;

                case 44:
                    goto st304;
                }

                goto st0;
st305:

                if ( ++p == pe )
                    goto _test_eof305;

            case 305:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr564;

                goto st0;
st306:

                if ( ++p == pe )
                    goto _test_eof306;

            case 306:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr565;

                goto st0;
st307:

                if ( ++p == pe )
                    goto _test_eof307;

            case 307:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr566;

                goto st0;
st308:

                if ( ++p == pe )
                    goto _test_eof308;

            case 308:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr567;

                goto st0;
st309:

                if ( ++p == pe )
                    goto _test_eof309;

            case 309:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr568;

                goto st0;
st310:

                if ( ++p == pe )
                    goto _test_eof310;

            case 310:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr569;

                goto st0;
st311:

                if ( ++p == pe )
                    goto _test_eof311;

            case 311:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr570;

                case 5:
                    goto tr570;

                case 8:
                    goto tr570;

                case 18:
                    goto tr571;

                case 21:
                    goto tr571;

                case 23:
                    goto tr571;

                case 36:
                    goto tr571;

                case 44:
                    goto tr571;

                case 48:
                    goto st314;

                case 53:
                    goto st315;

                case 54:
                    goto st316;

                case 55:
                    goto st317;

                case 56:
                    goto st318;

                case 57:
                    goto st319;

                case 58:
                    goto st320;

                case 59:
                    goto st321;

                case 60:
                    goto st322;

                case 61:
                    goto st323;

                case 62:
                    goto st324;

                case 79:
                    goto st327;

                case 80:
                    goto st328;

                case 81:
                    goto st338;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr571;

                goto st0;
tr570:

                {
                    expr_start = p;
                }
                goto st312;
st312:

                if ( ++p == pe )
                    goto _test_eof312;

            case 312:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr586;

                case 19:
                    goto st312;

                case 23:
                    goto st313;

                case 37:
                    goto st312;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st313;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st313;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st313;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st313;
                }
                else
                    goto st313;

                goto st0;
tr571:

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
                case 3:
                    goto st312;

                case 5:
                    goto st312;

                case 8:
                    goto st312;

                case 13:
                    goto st313;

                case 18:
                    goto st313;

                case 21:
                    goto st313;

                case 23:
                    goto st313;

                case 36:
                    goto st313;

                case 44:
                    goto st313;
                }

                goto st0;
st314:

                if ( ++p == pe )
                    goto _test_eof314;

            case 314:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr589;

                goto st0;
st315:

                if ( ++p == pe )
                    goto _test_eof315;

            case 315:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr590;

                goto st0;
st316:

                if ( ++p == pe )
                    goto _test_eof316;

            case 316:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr591;

                goto st0;
st317:

                if ( ++p == pe )
                    goto _test_eof317;

            case 317:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr592;

                goto st0;
st318:

                if ( ++p == pe )
                    goto _test_eof318;

            case 318:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr593;

                goto st0;
st319:

                if ( ++p == pe )
                    goto _test_eof319;

            case 319:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr594;

                goto st0;
st320:

                if ( ++p == pe )
                    goto _test_eof320;

            case 320:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr595;

                goto st0;
st321:

                if ( ++p == pe )
                    goto _test_eof321;

            case 321:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr596;

                goto st0;
st322:

                if ( ++p == pe )
                    goto _test_eof322;

            case 322:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr597;

                goto st0;
st323:

                if ( ++p == pe )
                    goto _test_eof323;

            case 323:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr598;

                goto st0;
st324:

                if ( ++p == pe )
                    goto _test_eof324;

            case 324:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr599;

                case 22:
                    goto st325;
                }

                goto st0;
st325:

                if ( ++p == pe )
                    goto _test_eof325;

            case 325:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr570;

                case 5:
                    goto tr570;

                case 8:
                    goto tr570;

                case 18:
                    goto tr571;

                case 21:
                    goto tr571;

                case 23:
                    goto tr571;

                case 36:
                    goto tr571;

                case 44:
                    goto tr571;

                case 48:
                    goto st314;

                case 53:
                    goto st315;

                case 54:
                    goto st316;

                case 55:
                    goto st317;

                case 56:
                    goto st318;

                case 57:
                    goto st319;

                case 58:
                    goto st320;

                case 59:
                    goto st321;

                case 60:
                    goto st322;

                case 61:
                    goto st323;

                case 62:
                    goto st326;

                case 79:
                    goto st327;

                case 80:
                    goto st328;

                case 81:
                    goto st338;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr571;

                goto st0;
st326:

                if ( ++p == pe )
                    goto _test_eof326;

            case 326:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr599;

                goto st0;
st327:

                if ( ++p == pe )
                    goto _test_eof327;

            case 327:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr602;

                goto st0;
st328:

                if ( ++p == pe )
                    goto _test_eof328;

            case 328:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st329;

                case 21:
                    goto st330;

                case 23:
                    goto st334;
                }

                goto st0;
st329:

                if ( ++p == pe )
                    goto _test_eof329;

            case 329:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr606;

                goto st0;
st330:

                if ( ++p == pe )
                    goto _test_eof330;

            case 330:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr607;

                case 5:
                    goto tr607;

                case 8:
                    goto tr607;

                case 18:
                    goto tr608;

                case 21:
                    goto tr608;

                case 23:
                    goto tr608;

                case 36:
                    goto tr608;

                case 44:
                    goto tr608;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr608;

                goto st0;
tr607:

                {
                    expr_start = p;
                }
                goto st331;
st331:

                if ( ++p == pe )
                    goto _test_eof331;

            case 331:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr609;

                case 23:
                    goto st24;

                case 37:
                    goto st331;
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
tr609:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st332;
st332:

                if ( ++p == pe )
                    goto _test_eof332;

            case 332:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr611;

                case 19:
                    goto tr609;

                case 23:
                    goto st24;

                case 37:
                    goto st331;
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
tr608:

                {
                    expr_start = p;
                }
                goto st333;
st333:

                if ( ++p == pe )
                    goto _test_eof333;

            case 333:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st331;

                case 5:
                    goto st331;

                case 8:
                    goto st331;

                case 13:
                    goto st333;

                case 18:
                    goto st333;

                case 21:
                    goto st333;

                case 23:
                    goto st333;

                case 36:
                    goto st333;

                case 44:
                    goto st333;
                }

                goto st0;
st334:

                if ( ++p == pe )
                    goto _test_eof334;

            case 334:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr613;

                case 5:
                    goto tr613;

                case 8:
                    goto tr613;

                case 18:
                    goto tr614;

                case 21:
                    goto tr614;

                case 23:
                    goto tr614;

                case 36:
                    goto tr614;

                case 44:
                    goto tr614;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr614;

                goto st0;
tr613:

                {
                    expr_start = p;
                }
                goto st335;
st335:

                if ( ++p == pe )
                    goto _test_eof335;

            case 335:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr615;

                case 23:
                    goto st24;

                case 37:
                    goto st335;
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
tr615:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st336;
st336:

                if ( ++p == pe )
                    goto _test_eof336;

            case 336:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr617;

                case 19:
                    goto tr615;

                case 23:
                    goto st24;

                case 37:
                    goto st335;
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
tr614:

                {
                    expr_start = p;
                }
                goto st337;
st337:

                if ( ++p == pe )
                    goto _test_eof337;

            case 337:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st335;

                case 5:
                    goto st335;

                case 8:
                    goto st335;

                case 13:
                    goto st337;

                case 18:
                    goto st337;

                case 21:
                    goto st337;

                case 23:
                    goto st337;

                case 36:
                    goto st337;

                case 44:
                    goto st337;
                }

                goto st0;
st338:

                if ( ++p == pe )
                    goto _test_eof338;

            case 338:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st339;

                case 21:
                    goto st340;

                case 23:
                    goto st344;
                }

                goto st0;
st339:

                if ( ++p == pe )
                    goto _test_eof339;

            case 339:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr622;

                goto st0;
st340:

                if ( ++p == pe )
                    goto _test_eof340;

            case 340:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr623;

                case 5:
                    goto tr623;

                case 8:
                    goto tr623;

                case 18:
                    goto tr624;

                case 21:
                    goto tr624;

                case 23:
                    goto tr624;

                case 36:
                    goto tr624;

                case 44:
                    goto tr624;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr624;

                goto st0;
tr623:

                {
                    expr_start = p;
                }
                goto st341;
st341:

                if ( ++p == pe )
                    goto _test_eof341;

            case 341:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr625;

                case 23:
                    goto st24;

                case 37:
                    goto st341;
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
tr625:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st342;
st342:

                if ( ++p == pe )
                    goto _test_eof342;

            case 342:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr627;

                case 19:
                    goto tr625;

                case 23:
                    goto st24;

                case 37:
                    goto st341;
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
tr624:

                {
                    expr_start = p;
                }
                goto st343;
st343:

                if ( ++p == pe )
                    goto _test_eof343;

            case 343:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st341;

                case 5:
                    goto st341;

                case 8:
                    goto st341;

                case 13:
                    goto st343;

                case 18:
                    goto st343;

                case 21:
                    goto st343;

                case 23:
                    goto st343;

                case 36:
                    goto st343;

                case 44:
                    goto st343;
                }

                goto st0;
st344:

                if ( ++p == pe )
                    goto _test_eof344;

            case 344:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr629;

                case 5:
                    goto tr629;

                case 8:
                    goto tr629;

                case 18:
                    goto tr630;

                case 21:
                    goto tr630;

                case 23:
                    goto tr630;

                case 36:
                    goto tr630;

                case 44:
                    goto tr630;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr630;

                goto st0;
tr629:

                {
                    expr_start = p;
                }
                goto st345;
st345:

                if ( ++p == pe )
                    goto _test_eof345;

            case 345:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr631;

                case 23:
                    goto st24;

                case 37:
                    goto st345;
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
tr631:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st346;
st346:

                if ( ++p == pe )
                    goto _test_eof346;

            case 346:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr633;

                case 19:
                    goto tr631;

                case 23:
                    goto st24;

                case 37:
                    goto st345;
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
tr630:

                {
                    expr_start = p;
                }
                goto st347;
st347:

                if ( ++p == pe )
                    goto _test_eof347;

            case 347:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st345;

                case 5:
                    goto st345;

                case 8:
                    goto st345;

                case 13:
                    goto st347;

                case 18:
                    goto st347;

                case 21:
                    goto st347;

                case 23:
                    goto st347;

                case 36:
                    goto st347;

                case 44:
                    goto st347;
                }

                goto st0;
st348:

                if ( ++p == pe )
                    goto _test_eof348;

            case 348:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr635;

                goto st0;
st349:

                if ( ++p == pe )
                    goto _test_eof349;

            case 349:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr636;

                goto st0;
st350:

                if ( ++p == pe )
                    goto _test_eof350;

            case 350:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr637;

                goto st0;
st351:

                if ( ++p == pe )
                    goto _test_eof351;

            case 351:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr638;

                goto st0;
st352:

                if ( ++p == pe )
                    goto _test_eof352;

            case 352:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st353;

                case 70:
                    goto st354;

                case 71:
                    goto st355;

                case 72:
                    goto st356;

                case 73:
                    goto st357;

                case 74:
                    goto st358;
                }

                goto st0;
st353:

                if ( ++p == pe )
                    goto _test_eof353;

            case 353:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr645;

                goto st0;
st354:

                if ( ++p == pe )
                    goto _test_eof354;

            case 354:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr646;

                goto st0;
st355:

                if ( ++p == pe )
                    goto _test_eof355;

            case 355:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr647;

                goto st0;
st356:

                if ( ++p == pe )
                    goto _test_eof356;

            case 356:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr648;

                goto st0;
st357:

                if ( ++p == pe )
                    goto _test_eof357;

            case 357:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr649;

                goto st0;
st358:

                if ( ++p == pe )
                    goto _test_eof358;

            case 358:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr650;

                goto st0;
st359:

                if ( ++p == pe )
                    goto _test_eof359;

            case 359:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st360;

                case 70:
                    goto st361;

                case 71:
                    goto st362;

                case 72:
                    goto st363;

                case 73:
                    goto st364;

                case 74:
                    goto st365;
                }

                goto st0;
st360:

                if ( ++p == pe )
                    goto _test_eof360;

            case 360:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr657;

                goto st0;
st361:

                if ( ++p == pe )
                    goto _test_eof361;

            case 361:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr658;

                goto st0;
st362:

                if ( ++p == pe )
                    goto _test_eof362;

            case 362:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr659;

                goto st0;
st363:

                if ( ++p == pe )
                    goto _test_eof363;

            case 363:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr660;

                goto st0;
st364:

                if ( ++p == pe )
                    goto _test_eof364;

            case 364:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr661;

                goto st0;
st365:

                if ( ++p == pe )
                    goto _test_eof365;

            case 365:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr662;

                goto st0;
st366:

                if ( ++p == pe )
                    goto _test_eof366;

            case 366:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr663;

                case 45:
                    goto st367;

                case 46:
                    goto st368;

                case 47:
                    goto st369;

                case 48:
                    goto st370;

                case 49:
                    goto st371;

                case 50:
                    goto st372;

                case 51:
                    goto st373;

                case 52:
                    goto st374;
                }

                goto st0;
st367:

                if ( ++p == pe )
                    goto _test_eof367;

            case 367:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr672;

                goto st0;
st368:

                if ( ++p == pe )
                    goto _test_eof368;

            case 368:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr673;

                goto st0;
st369:

                if ( ++p == pe )
                    goto _test_eof369;

            case 369:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr674;

                goto st0;
st370:

                if ( ++p == pe )
                    goto _test_eof370;

            case 370:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr675;

                goto st0;
st371:

                if ( ++p == pe )
                    goto _test_eof371;

            case 371:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr676;

                goto st0;
st372:

                if ( ++p == pe )
                    goto _test_eof372;

            case 372:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr677;

                goto st0;
st373:

                if ( ++p == pe )
                    goto _test_eof373;

            case 373:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr678;

                goto st0;
st374:

                if ( ++p == pe )
                    goto _test_eof374;

            case 374:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr679;

                goto st0;
st375:

                if ( ++p == pe )
                    goto _test_eof375;

            case 375:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr680;

                goto st0;
st376:

                if ( ++p == pe )
                    goto _test_eof376;

            case 376:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr681;

                goto st0;
st377:

                if ( ++p == pe )
                    goto _test_eof377;

            case 377:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr682;

                goto st0;
st378:

                if ( ++p == pe )
                    goto _test_eof378;

            case 378:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr683;

                goto st0;
st379:

                if ( ++p == pe )
                    goto _test_eof379;

            case 379:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr684;

                goto st0;
st380:

                if ( ++p == pe )
                    goto _test_eof380;

            case 380:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr685;

                goto st0;
st381:

                if ( ++p == pe )
                    goto _test_eof381;

            case 381:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr686;

                goto st0;
st382:

                if ( ++p == pe )
                    goto _test_eof382;

            case 382:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr687;

                goto st0;
st383:

                if ( ++p == pe )
                    goto _test_eof383;

            case 383:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr688;

                case 5:
                    goto tr688;

                case 8:
                    goto tr688;

                case 18:
                    goto tr689;

                case 21:
                    goto tr689;

                case 23:
                    goto tr689;

                case 36:
                    goto tr689;

                case 44:
                    goto tr689;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr689;

                goto st0;
tr688:

                {
                    expr_start = p;
                }
                goto st384;
st384:

                if ( ++p == pe )
                    goto _test_eof384;

            case 384:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr690;

                case 19:
                    goto st384;

                case 23:
                    goto st385;

                case 37:
                    goto st384;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st385;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st385;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st385;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st385;
                }
                else
                    goto st385;

                goto st0;
tr689:

                {
                    expr_start = p;
                }
                goto st385;
st385:

                if ( ++p == pe )
                    goto _test_eof385;

            case 385:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st384;

                case 5:
                    goto st384;

                case 8:
                    goto st384;

                case 13:
                    goto st385;

                case 18:
                    goto st385;

                case 21:
                    goto st385;

                case 23:
                    goto st385;

                case 36:
                    goto st385;

                case 44:
                    goto st385;
                }

                goto st0;
st386:

                if ( ++p == pe )
                    goto _test_eof386;

            case 386:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr693;

                case 5:
                    goto tr693;

                case 8:
                    goto tr693;

                case 18:
                    goto tr694;

                case 21:
                    goto tr694;

                case 23:
                    goto tr694;

                case 36:
                    goto tr694;

                case 44:
                    goto tr694;

                case 48:
                    goto st389;

                case 53:
                    goto st390;

                case 54:
                    goto st391;

                case 55:
                    goto st392;

                case 56:
                    goto st393;

                case 57:
                    goto st394;

                case 58:
                    goto st395;

                case 59:
                    goto st396;

                case 60:
                    goto st397;

                case 61:
                    goto st398;

                case 62:
                    goto st399;

                case 71:
                    goto st423;

                case 79:
                    goto st402;

                case 80:
                    goto st403;

                case 81:
                    goto st413;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr694;

                goto st0;
tr693:

                {
                    expr_start = p;
                }
                goto st387;
st387:

                if ( ++p == pe )
                    goto _test_eof387;

            case 387:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr710;

                case 19:
                    goto st387;

                case 23:
                    goto st388;

                case 37:
                    goto st387;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st388;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st388;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st388;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st388;
                }
                else
                    goto st388;

                goto st0;
tr694:

                {
                    expr_start = p;
                }
                goto st388;
st388:

                if ( ++p == pe )
                    goto _test_eof388;

            case 388:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st387;

                case 5:
                    goto st387;

                case 8:
                    goto st387;

                case 13:
                    goto st388;

                case 18:
                    goto st388;

                case 21:
                    goto st388;

                case 23:
                    goto st388;

                case 36:
                    goto st388;

                case 44:
                    goto st388;
                }

                goto st0;
st389:

                if ( ++p == pe )
                    goto _test_eof389;

            case 389:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr713;

                goto st0;
st390:

                if ( ++p == pe )
                    goto _test_eof390;

            case 390:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr714;

                goto st0;
st391:

                if ( ++p == pe )
                    goto _test_eof391;

            case 391:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr715;

                goto st0;
st392:

                if ( ++p == pe )
                    goto _test_eof392;

            case 392:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr716;

                goto st0;
st393:

                if ( ++p == pe )
                    goto _test_eof393;

            case 393:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr717;

                goto st0;
st394:

                if ( ++p == pe )
                    goto _test_eof394;

            case 394:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr718;

                goto st0;
st395:

                if ( ++p == pe )
                    goto _test_eof395;

            case 395:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr719;

                goto st0;
st396:

                if ( ++p == pe )
                    goto _test_eof396;

            case 396:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr720;

                goto st0;
st397:

                if ( ++p == pe )
                    goto _test_eof397;

            case 397:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr721;

                goto st0;
st398:

                if ( ++p == pe )
                    goto _test_eof398;

            case 398:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr722;

                goto st0;
st399:

                if ( ++p == pe )
                    goto _test_eof399;

            case 399:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr723;

                case 22:
                    goto st400;
                }

                goto st0;
st400:

                if ( ++p == pe )
                    goto _test_eof400;

            case 400:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr693;

                case 5:
                    goto tr693;

                case 8:
                    goto tr693;

                case 18:
                    goto tr694;

                case 21:
                    goto tr694;

                case 23:
                    goto tr694;

                case 36:
                    goto tr694;

                case 44:
                    goto tr694;

                case 48:
                    goto st389;

                case 53:
                    goto st390;

                case 54:
                    goto st391;

                case 55:
                    goto st392;

                case 56:
                    goto st393;

                case 57:
                    goto st394;

                case 58:
                    goto st395;

                case 59:
                    goto st396;

                case 60:
                    goto st397;

                case 61:
                    goto st398;

                case 62:
                    goto st401;

                case 79:
                    goto st402;

                case 80:
                    goto st403;

                case 81:
                    goto st413;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr694;

                goto st0;
st401:

                if ( ++p == pe )
                    goto _test_eof401;

            case 401:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr723;

                goto st0;
st402:

                if ( ++p == pe )
                    goto _test_eof402;

            case 402:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr726;

                goto st0;
st403:

                if ( ++p == pe )
                    goto _test_eof403;

            case 403:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st404;

                case 21:
                    goto st405;

                case 23:
                    goto st409;
                }

                goto st0;
st404:

                if ( ++p == pe )
                    goto _test_eof404;

            case 404:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr730;

                goto st0;
st405:

                if ( ++p == pe )
                    goto _test_eof405;

            case 405:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr731;

                case 5:
                    goto tr731;

                case 8:
                    goto tr731;

                case 18:
                    goto tr732;

                case 21:
                    goto tr732;

                case 23:
                    goto tr732;

                case 36:
                    goto tr732;

                case 44:
                    goto tr732;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr732;

                goto st0;
tr731:

                {
                    expr_start = p;
                }
                goto st406;
st406:

                if ( ++p == pe )
                    goto _test_eof406;

            case 406:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr733;

                case 23:
                    goto st24;

                case 37:
                    goto st406;
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
tr733:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st407;
st407:

                if ( ++p == pe )
                    goto _test_eof407;

            case 407:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr735;

                case 19:
                    goto tr733;

                case 23:
                    goto st24;

                case 37:
                    goto st406;
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
tr732:

                {
                    expr_start = p;
                }
                goto st408;
st408:

                if ( ++p == pe )
                    goto _test_eof408;

            case 408:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st406;

                case 5:
                    goto st406;

                case 8:
                    goto st406;

                case 13:
                    goto st408;

                case 18:
                    goto st408;

                case 21:
                    goto st408;

                case 23:
                    goto st408;

                case 36:
                    goto st408;

                case 44:
                    goto st408;
                }

                goto st0;
st409:

                if ( ++p == pe )
                    goto _test_eof409;

            case 409:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr737;

                case 5:
                    goto tr737;

                case 8:
                    goto tr737;

                case 18:
                    goto tr738;

                case 21:
                    goto tr738;

                case 23:
                    goto tr738;

                case 36:
                    goto tr738;

                case 44:
                    goto tr738;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr738;

                goto st0;
tr737:

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
                case 19:
                    goto tr739;

                case 23:
                    goto st24;

                case 37:
                    goto st410;
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
tr739:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st411;
st411:

                if ( ++p == pe )
                    goto _test_eof411;

            case 411:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr741;

                case 19:
                    goto tr739;

                case 23:
                    goto st24;

                case 37:
                    goto st410;
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
tr738:

                {
                    expr_start = p;
                }
                goto st412;
st412:

                if ( ++p == pe )
                    goto _test_eof412;

            case 412:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st410;

                case 5:
                    goto st410;

                case 8:
                    goto st410;

                case 13:
                    goto st412;

                case 18:
                    goto st412;

                case 21:
                    goto st412;

                case 23:
                    goto st412;

                case 36:
                    goto st412;

                case 44:
                    goto st412;
                }

                goto st0;
st413:

                if ( ++p == pe )
                    goto _test_eof413;

            case 413:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st414;

                case 21:
                    goto st415;

                case 23:
                    goto st419;
                }

                goto st0;
st414:

                if ( ++p == pe )
                    goto _test_eof414;

            case 414:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr746;

                goto st0;
st415:

                if ( ++p == pe )
                    goto _test_eof415;

            case 415:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr747;

                case 5:
                    goto tr747;

                case 8:
                    goto tr747;

                case 18:
                    goto tr748;

                case 21:
                    goto tr748;

                case 23:
                    goto tr748;

                case 36:
                    goto tr748;

                case 44:
                    goto tr748;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr748;

                goto st0;
tr747:

                {
                    expr_start = p;
                }
                goto st416;
st416:

                if ( ++p == pe )
                    goto _test_eof416;

            case 416:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr749;

                case 23:
                    goto st24;

                case 37:
                    goto st416;
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
tr749:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st417;
st417:

                if ( ++p == pe )
                    goto _test_eof417;

            case 417:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr751;

                case 19:
                    goto tr749;

                case 23:
                    goto st24;

                case 37:
                    goto st416;
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
tr748:

                {
                    expr_start = p;
                }
                goto st418;
st418:

                if ( ++p == pe )
                    goto _test_eof418;

            case 418:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st416;

                case 5:
                    goto st416;

                case 8:
                    goto st416;

                case 13:
                    goto st418;

                case 18:
                    goto st418;

                case 21:
                    goto st418;

                case 23:
                    goto st418;

                case 36:
                    goto st418;

                case 44:
                    goto st418;
                }

                goto st0;
st419:

                if ( ++p == pe )
                    goto _test_eof419;

            case 419:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr753;

                case 5:
                    goto tr753;

                case 8:
                    goto tr753;

                case 18:
                    goto tr754;

                case 21:
                    goto tr754;

                case 23:
                    goto tr754;

                case 36:
                    goto tr754;

                case 44:
                    goto tr754;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr754;

                goto st0;
tr753:

                {
                    expr_start = p;
                }
                goto st420;
st420:

                if ( ++p == pe )
                    goto _test_eof420;

            case 420:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr755;

                case 23:
                    goto st24;

                case 37:
                    goto st420;
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
tr755:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st421;
st421:

                if ( ++p == pe )
                    goto _test_eof421;

            case 421:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr757;

                case 19:
                    goto tr755;

                case 23:
                    goto st24;

                case 37:
                    goto st420;
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
tr754:

                {
                    expr_start = p;
                }
                goto st422;
st422:

                if ( ++p == pe )
                    goto _test_eof422;

            case 422:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st420;

                case 5:
                    goto st420;

                case 8:
                    goto st420;

                case 13:
                    goto st422;

                case 18:
                    goto st422;

                case 21:
                    goto st422;

                case 23:
                    goto st422;

                case 36:
                    goto st422;

                case 44:
                    goto st422;
                }

                goto st0;
st423:

                if ( ++p == pe )
                    goto _test_eof423;

            case 423:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st424;

                goto st0;
st424:

                if ( ++p == pe )
                    goto _test_eof424;

            case 424:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st425;

                case 70:
                    goto st426;

                case 71:
                    goto st427;

                case 75:
                    goto st428;
                }

                goto st0;
st425:

                if ( ++p == pe )
                    goto _test_eof425;

            case 425:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr764;

                goto st0;
st426:

                if ( ++p == pe )
                    goto _test_eof426;

            case 426:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr765;

                goto st0;
st427:

                if ( ++p == pe )
                    goto _test_eof427;

            case 427:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr766;

                goto st0;
st428:

                if ( ++p == pe )
                    goto _test_eof428;

            case 428:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr767;

                goto st0;
st429:

                if ( ++p == pe )
                    goto _test_eof429;

            case 429:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr768;

                goto st0;
st430:

                if ( ++p == pe )
                    goto _test_eof430;

            case 430:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr769;

                case 5:
                    goto tr769;

                case 8:
                    goto tr769;

                case 18:
                    goto tr770;

                case 21:
                    goto tr770;

                case 23:
                    goto tr770;

                case 36:
                    goto tr770;

                case 44:
                    goto tr770;

                case 48:
                    goto st433;

                case 53:
                    goto st434;

                case 54:
                    goto st435;

                case 55:
                    goto st436;

                case 56:
                    goto st437;

                case 57:
                    goto st438;

                case 58:
                    goto st439;

                case 59:
                    goto st440;

                case 60:
                    goto st441;

                case 61:
                    goto st442;

                case 62:
                    goto st443;

                case 79:
                    goto st446;

                case 80:
                    goto st447;

                case 81:
                    goto st457;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr770;

                goto st0;
tr769:

                {
                    expr_start = p;
                }
                goto st431;
st431:

                if ( ++p == pe )
                    goto _test_eof431;

            case 431:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr785;

                case 19:
                    goto st431;

                case 23:
                    goto st432;

                case 37:
                    goto st431;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st432;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st432;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st432;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st432;
                }
                else
                    goto st432;

                goto st0;
tr770:

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
                case 3:
                    goto st431;

                case 5:
                    goto st431;

                case 8:
                    goto st431;

                case 13:
                    goto st432;

                case 18:
                    goto st432;

                case 21:
                    goto st432;

                case 23:
                    goto st432;

                case 36:
                    goto st432;

                case 44:
                    goto st432;
                }

                goto st0;
st433:

                if ( ++p == pe )
                    goto _test_eof433;

            case 433:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr788;

                goto st0;
st434:

                if ( ++p == pe )
                    goto _test_eof434;

            case 434:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr789;

                goto st0;
st435:

                if ( ++p == pe )
                    goto _test_eof435;

            case 435:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr790;

                goto st0;
st436:

                if ( ++p == pe )
                    goto _test_eof436;

            case 436:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr791;

                goto st0;
st437:

                if ( ++p == pe )
                    goto _test_eof437;

            case 437:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr792;

                goto st0;
st438:

                if ( ++p == pe )
                    goto _test_eof438;

            case 438:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr793;

                goto st0;
st439:

                if ( ++p == pe )
                    goto _test_eof439;

            case 439:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr794;

                goto st0;
st440:

                if ( ++p == pe )
                    goto _test_eof440;

            case 440:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr795;

                goto st0;
st441:

                if ( ++p == pe )
                    goto _test_eof441;

            case 441:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr796;

                goto st0;
st442:

                if ( ++p == pe )
                    goto _test_eof442;

            case 442:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr797;

                goto st0;
st443:

                if ( ++p == pe )
                    goto _test_eof443;

            case 443:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr798;

                case 22:
                    goto st444;
                }

                goto st0;
st444:

                if ( ++p == pe )
                    goto _test_eof444;

            case 444:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr769;

                case 5:
                    goto tr769;

                case 8:
                    goto tr769;

                case 18:
                    goto tr770;

                case 21:
                    goto tr770;

                case 23:
                    goto tr770;

                case 36:
                    goto tr770;

                case 44:
                    goto tr770;

                case 48:
                    goto st433;

                case 53:
                    goto st434;

                case 54:
                    goto st435;

                case 55:
                    goto st436;

                case 56:
                    goto st437;

                case 57:
                    goto st438;

                case 58:
                    goto st439;

                case 59:
                    goto st440;

                case 60:
                    goto st441;

                case 61:
                    goto st442;

                case 62:
                    goto st445;

                case 79:
                    goto st446;

                case 80:
                    goto st447;

                case 81:
                    goto st457;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr770;

                goto st0;
st445:

                if ( ++p == pe )
                    goto _test_eof445;

            case 445:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr798;

                goto st0;
st446:

                if ( ++p == pe )
                    goto _test_eof446;

            case 446:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr801;

                goto st0;
st447:

                if ( ++p == pe )
                    goto _test_eof447;

            case 447:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st448;

                case 21:
                    goto st449;

                case 23:
                    goto st453;
                }

                goto st0;
st448:

                if ( ++p == pe )
                    goto _test_eof448;

            case 448:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr805;

                goto st0;
st449:

                if ( ++p == pe )
                    goto _test_eof449;

            case 449:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr806;

                case 5:
                    goto tr806;

                case 8:
                    goto tr806;

                case 18:
                    goto tr807;

                case 21:
                    goto tr807;

                case 23:
                    goto tr807;

                case 36:
                    goto tr807;

                case 44:
                    goto tr807;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr807;

                goto st0;
tr806:

                {
                    expr_start = p;
                }
                goto st450;
st450:

                if ( ++p == pe )
                    goto _test_eof450;

            case 450:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr808;

                case 23:
                    goto st24;

                case 37:
                    goto st450;
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
tr808:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st451;
st451:

                if ( ++p == pe )
                    goto _test_eof451;

            case 451:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr810;

                case 19:
                    goto tr808;

                case 23:
                    goto st24;

                case 37:
                    goto st450;
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
tr807:

                {
                    expr_start = p;
                }
                goto st452;
st452:

                if ( ++p == pe )
                    goto _test_eof452;

            case 452:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st450;

                case 5:
                    goto st450;

                case 8:
                    goto st450;

                case 13:
                    goto st452;

                case 18:
                    goto st452;

                case 21:
                    goto st452;

                case 23:
                    goto st452;

                case 36:
                    goto st452;

                case 44:
                    goto st452;
                }

                goto st0;
st453:

                if ( ++p == pe )
                    goto _test_eof453;

            case 453:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr812;

                case 5:
                    goto tr812;

                case 8:
                    goto tr812;

                case 18:
                    goto tr813;

                case 21:
                    goto tr813;

                case 23:
                    goto tr813;

                case 36:
                    goto tr813;

                case 44:
                    goto tr813;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr813;

                goto st0;
tr812:

                {
                    expr_start = p;
                }
                goto st454;
st454:

                if ( ++p == pe )
                    goto _test_eof454;

            case 454:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr814;

                case 23:
                    goto st24;

                case 37:
                    goto st454;
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
tr814:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st455;
st455:

                if ( ++p == pe )
                    goto _test_eof455;

            case 455:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr816;

                case 19:
                    goto tr814;

                case 23:
                    goto st24;

                case 37:
                    goto st454;
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
tr813:

                {
                    expr_start = p;
                }
                goto st456;
st456:

                if ( ++p == pe )
                    goto _test_eof456;

            case 456:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st454;

                case 5:
                    goto st454;

                case 8:
                    goto st454;

                case 13:
                    goto st456;

                case 18:
                    goto st456;

                case 21:
                    goto st456;

                case 23:
                    goto st456;

                case 36:
                    goto st456;

                case 44:
                    goto st456;
                }

                goto st0;
st457:

                if ( ++p == pe )
                    goto _test_eof457;

            case 457:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st458;

                case 21:
                    goto st459;

                case 23:
                    goto st463;
                }

                goto st0;
st458:

                if ( ++p == pe )
                    goto _test_eof458;

            case 458:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr821;

                goto st0;
st459:

                if ( ++p == pe )
                    goto _test_eof459;

            case 459:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr822;

                case 5:
                    goto tr822;

                case 8:
                    goto tr822;

                case 18:
                    goto tr823;

                case 21:
                    goto tr823;

                case 23:
                    goto tr823;

                case 36:
                    goto tr823;

                case 44:
                    goto tr823;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr823;

                goto st0;
tr822:

                {
                    expr_start = p;
                }
                goto st460;
st460:

                if ( ++p == pe )
                    goto _test_eof460;

            case 460:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr824;

                case 23:
                    goto st24;

                case 37:
                    goto st460;
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
tr824:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st461;
st461:

                if ( ++p == pe )
                    goto _test_eof461;

            case 461:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr826;

                case 19:
                    goto tr824;

                case 23:
                    goto st24;

                case 37:
                    goto st460;
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
tr823:

                {
                    expr_start = p;
                }
                goto st462;
st462:

                if ( ++p == pe )
                    goto _test_eof462;

            case 462:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st460;

                case 5:
                    goto st460;

                case 8:
                    goto st460;

                case 13:
                    goto st462;

                case 18:
                    goto st462;

                case 21:
                    goto st462;

                case 23:
                    goto st462;

                case 36:
                    goto st462;

                case 44:
                    goto st462;
                }

                goto st0;
st463:

                if ( ++p == pe )
                    goto _test_eof463;

            case 463:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr828;

                case 5:
                    goto tr828;

                case 8:
                    goto tr828;

                case 18:
                    goto tr829;

                case 21:
                    goto tr829;

                case 23:
                    goto tr829;

                case 36:
                    goto tr829;

                case 44:
                    goto tr829;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr829;

                goto st0;
tr828:

                {
                    expr_start = p;
                }
                goto st464;
st464:

                if ( ++p == pe )
                    goto _test_eof464;

            case 464:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr830;

                case 23:
                    goto st24;

                case 37:
                    goto st464;
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
tr830:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st465;
st465:

                if ( ++p == pe )
                    goto _test_eof465;

            case 465:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr832;

                case 19:
                    goto tr830;

                case 23:
                    goto st24;

                case 37:
                    goto st464;
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
tr829:

                {
                    expr_start = p;
                }
                goto st466;
st466:

                if ( ++p == pe )
                    goto _test_eof466;

            case 466:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st464;

                case 5:
                    goto st464;

                case 8:
                    goto st464;

                case 13:
                    goto st466;

                case 18:
                    goto st466;

                case 21:
                    goto st466;

                case 23:
                    goto st466;

                case 36:
                    goto st466;

                case 44:
                    goto st466;
                }

                goto st0;
st467:

                if ( ++p == pe )
                    goto _test_eof467;

            case 467:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr834;

                case 5:
                    goto tr834;

                case 8:
                    goto tr834;

                case 18:
                    goto tr835;

                case 21:
                    goto tr835;

                case 23:
                    goto tr835;

                case 36:
                    goto tr835;

                case 44:
                    goto tr835;

                case 48:
                    goto st470;

                case 53:
                    goto st471;

                case 54:
                    goto st472;

                case 55:
                    goto st473;

                case 56:
                    goto st474;

                case 57:
                    goto st475;

                case 58:
                    goto st476;

                case 59:
                    goto st477;

                case 60:
                    goto st478;

                case 61:
                    goto st479;

                case 62:
                    goto st480;

                case 79:
                    goto st483;

                case 80:
                    goto st484;

                case 81:
                    goto st494;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr835;

                goto st0;
tr834:

                {
                    expr_start = p;
                }
                goto st468;
st468:

                if ( ++p == pe )
                    goto _test_eof468;

            case 468:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr850;

                case 19:
                    goto st468;

                case 23:
                    goto st469;

                case 37:
                    goto st468;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st469;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st469;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st469;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st469;
                }
                else
                    goto st469;

                goto st0;
tr835:

                {
                    expr_start = p;
                }
                goto st469;
st469:

                if ( ++p == pe )
                    goto _test_eof469;

            case 469:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st468;

                case 5:
                    goto st468;

                case 8:
                    goto st468;

                case 13:
                    goto st469;

                case 18:
                    goto st469;

                case 21:
                    goto st469;

                case 23:
                    goto st469;

                case 36:
                    goto st469;

                case 44:
                    goto st469;
                }

                goto st0;
st470:

                if ( ++p == pe )
                    goto _test_eof470;

            case 470:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr853;

                goto st0;
st471:

                if ( ++p == pe )
                    goto _test_eof471;

            case 471:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr854;

                goto st0;
st472:

                if ( ++p == pe )
                    goto _test_eof472;

            case 472:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr855;

                goto st0;
st473:

                if ( ++p == pe )
                    goto _test_eof473;

            case 473:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr856;

                goto st0;
st474:

                if ( ++p == pe )
                    goto _test_eof474;

            case 474:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr857;

                goto st0;
st475:

                if ( ++p == pe )
                    goto _test_eof475;

            case 475:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr858;

                goto st0;
st476:

                if ( ++p == pe )
                    goto _test_eof476;

            case 476:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr859;

                goto st0;
st477:

                if ( ++p == pe )
                    goto _test_eof477;

            case 477:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr860;

                goto st0;
st478:

                if ( ++p == pe )
                    goto _test_eof478;

            case 478:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr861;

                goto st0;
st479:

                if ( ++p == pe )
                    goto _test_eof479;

            case 479:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr862;

                goto st0;
st480:

                if ( ++p == pe )
                    goto _test_eof480;

            case 480:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr863;

                case 22:
                    goto st481;
                }

                goto st0;
st481:

                if ( ++p == pe )
                    goto _test_eof481;

            case 481:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr834;

                case 5:
                    goto tr834;

                case 8:
                    goto tr834;

                case 18:
                    goto tr835;

                case 21:
                    goto tr835;

                case 23:
                    goto tr835;

                case 36:
                    goto tr835;

                case 44:
                    goto tr835;

                case 48:
                    goto st470;

                case 53:
                    goto st471;

                case 54:
                    goto st472;

                case 55:
                    goto st473;

                case 56:
                    goto st474;

                case 57:
                    goto st475;

                case 58:
                    goto st476;

                case 59:
                    goto st477;

                case 60:
                    goto st478;

                case 61:
                    goto st479;

                case 62:
                    goto st482;

                case 79:
                    goto st483;

                case 80:
                    goto st484;

                case 81:
                    goto st494;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr835;

                goto st0;
st482:

                if ( ++p == pe )
                    goto _test_eof482;

            case 482:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr863;

                goto st0;
st483:

                if ( ++p == pe )
                    goto _test_eof483;

            case 483:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr866;

                goto st0;
st484:

                if ( ++p == pe )
                    goto _test_eof484;

            case 484:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st485;

                case 21:
                    goto st486;

                case 23:
                    goto st490;
                }

                goto st0;
st485:

                if ( ++p == pe )
                    goto _test_eof485;

            case 485:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr870;

                goto st0;
st486:

                if ( ++p == pe )
                    goto _test_eof486;

            case 486:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr871;

                case 5:
                    goto tr871;

                case 8:
                    goto tr871;

                case 18:
                    goto tr872;

                case 21:
                    goto tr872;

                case 23:
                    goto tr872;

                case 36:
                    goto tr872;

                case 44:
                    goto tr872;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr872;

                goto st0;
tr871:

                {
                    expr_start = p;
                }
                goto st487;
st487:

                if ( ++p == pe )
                    goto _test_eof487;

            case 487:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr873;

                case 23:
                    goto st24;

                case 37:
                    goto st487;
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
tr873:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st488;
st488:

                if ( ++p == pe )
                    goto _test_eof488;

            case 488:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr875;

                case 19:
                    goto tr873;

                case 23:
                    goto st24;

                case 37:
                    goto st487;
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
tr872:

                {
                    expr_start = p;
                }
                goto st489;
st489:

                if ( ++p == pe )
                    goto _test_eof489;

            case 489:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st487;

                case 5:
                    goto st487;

                case 8:
                    goto st487;

                case 13:
                    goto st489;

                case 18:
                    goto st489;

                case 21:
                    goto st489;

                case 23:
                    goto st489;

                case 36:
                    goto st489;

                case 44:
                    goto st489;
                }

                goto st0;
st490:

                if ( ++p == pe )
                    goto _test_eof490;

            case 490:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr877;

                case 5:
                    goto tr877;

                case 8:
                    goto tr877;

                case 18:
                    goto tr878;

                case 21:
                    goto tr878;

                case 23:
                    goto tr878;

                case 36:
                    goto tr878;

                case 44:
                    goto tr878;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr878;

                goto st0;
tr877:

                {
                    expr_start = p;
                }
                goto st491;
st491:

                if ( ++p == pe )
                    goto _test_eof491;

            case 491:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr879;

                case 23:
                    goto st24;

                case 37:
                    goto st491;
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
tr879:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st492;
st492:

                if ( ++p == pe )
                    goto _test_eof492;

            case 492:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr881;

                case 19:
                    goto tr879;

                case 23:
                    goto st24;

                case 37:
                    goto st491;
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
tr878:

                {
                    expr_start = p;
                }
                goto st493;
st493:

                if ( ++p == pe )
                    goto _test_eof493;

            case 493:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st491;

                case 5:
                    goto st491;

                case 8:
                    goto st491;

                case 13:
                    goto st493;

                case 18:
                    goto st493;

                case 21:
                    goto st493;

                case 23:
                    goto st493;

                case 36:
                    goto st493;

                case 44:
                    goto st493;
                }

                goto st0;
st494:

                if ( ++p == pe )
                    goto _test_eof494;

            case 494:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st495;

                case 21:
                    goto st496;

                case 23:
                    goto st500;
                }

                goto st0;
st495:

                if ( ++p == pe )
                    goto _test_eof495;

            case 495:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr886;

                goto st0;
st496:

                if ( ++p == pe )
                    goto _test_eof496;

            case 496:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr887;

                case 5:
                    goto tr887;

                case 8:
                    goto tr887;

                case 18:
                    goto tr888;

                case 21:
                    goto tr888;

                case 23:
                    goto tr888;

                case 36:
                    goto tr888;

                case 44:
                    goto tr888;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr888;

                goto st0;
tr887:

                {
                    expr_start = p;
                }
                goto st497;
st497:

                if ( ++p == pe )
                    goto _test_eof497;

            case 497:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr889;

                case 23:
                    goto st24;

                case 37:
                    goto st497;
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
tr889:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st498;
st498:

                if ( ++p == pe )
                    goto _test_eof498;

            case 498:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr891;

                case 19:
                    goto tr889;

                case 23:
                    goto st24;

                case 37:
                    goto st497;
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
tr888:

                {
                    expr_start = p;
                }
                goto st499;
st499:

                if ( ++p == pe )
                    goto _test_eof499;

            case 499:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st497;

                case 5:
                    goto st497;

                case 8:
                    goto st497;

                case 13:
                    goto st499;

                case 18:
                    goto st499;

                case 21:
                    goto st499;

                case 23:
                    goto st499;

                case 36:
                    goto st499;

                case 44:
                    goto st499;
                }

                goto st0;
st500:

                if ( ++p == pe )
                    goto _test_eof500;

            case 500:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr893;

                case 5:
                    goto tr893;

                case 8:
                    goto tr893;

                case 18:
                    goto tr894;

                case 21:
                    goto tr894;

                case 23:
                    goto tr894;

                case 36:
                    goto tr894;

                case 44:
                    goto tr894;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr894;

                goto st0;
tr893:

                {
                    expr_start = p;
                }
                goto st501;
st501:

                if ( ++p == pe )
                    goto _test_eof501;

            case 501:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr895;

                case 23:
                    goto st24;

                case 37:
                    goto st501;
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
tr895:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st502;
st502:

                if ( ++p == pe )
                    goto _test_eof502;

            case 502:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr897;

                case 19:
                    goto tr895;

                case 23:
                    goto st24;

                case 37:
                    goto st501;
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
tr894:

                {
                    expr_start = p;
                }
                goto st503;
st503:

                if ( ++p == pe )
                    goto _test_eof503;

            case 503:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st501;

                case 5:
                    goto st501;

                case 8:
                    goto st501;

                case 13:
                    goto st503;

                case 18:
                    goto st503;

                case 21:
                    goto st503;

                case 23:
                    goto st503;

                case 36:
                    goto st503;

                case 44:
                    goto st503;
                }

                goto st0;
            }

_test_eof504:
            cs = 504;
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

                504

           )
            return TRUE;
    }

    return FALSE;
}

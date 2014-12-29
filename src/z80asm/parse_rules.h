




















static const int parser_start = 1;
static const int parser_first_final = 870;
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
                    goto st870;

                case 4:
                    goto tr2;

                case 12:
                    goto st870;

                case 87:
                    goto st3;

                case 88:
                    goto st48;

                case 89:
                    goto st103;

                case 90:
                    goto st140;

                case 91:
                    goto st172;

                case 92:
                    goto st207;

                case 93:
                    goto st208;

                case 94:
                    goto st245;

                case 95:
                    goto st246;

                case 96:
                    goto st247;

                case 97:
                    goto st248;

                case 98:
                    goto st249;

                case 99:
                    goto st250;

                case 100:
                    goto st251;

                case 101:
                    goto st252;

                case 102:
                    goto st255;

                case 103:
                    goto st256;

                case 104:
                    goto st269;

                case 105:
                    goto st270;

                case 106:
                    goto st271;

                case 107:
                    goto st274;

                case 108:
                    goto st298;

                case 109:
                    goto st299;

                case 110:
                    goto st300;

                case 111:
                    goto st301;

                case 112:
                    goto st302;

                case 113:
                    goto st342;

                case 114:
                    goto st361;

                case 115:
                    goto st362;

                case 116:
                    goto st363;

                case 117:
                    goto st364;

                case 118:
                    goto st365;

                case 119:
                    goto st366;

                case 120:
                    goto st367;

                case 121:
                    goto st404;

                case 122:
                    goto st405;

                case 123:
                    goto st406;

                case 124:
                    goto st420;

                case 125:
                    goto st421;

                case 126:
                    goto st422;

                case 127:
                    goto st429;

                case 128:
                    goto st436;

                case 129:
                    goto st468;

                case 130:
                    goto st477;

                case 131:
                    goto st478;

                case 132:
                    goto st479;

                case 133:
                    goto st508;

                case 134:
                    goto st509;

                case 135:
                    goto st538;

                case 136:
                    goto st539;

                case 137:
                    goto st540;

                case 138:
                    goto st569;

                case 139:
                    goto st570;

                case 140:
                    goto st599;

                case 141:
                    goto st600;

                case 142:
                    goto st601;

                case 143:
                    goto st604;

                case 144:
                    goto st647;

                case 145:
                    goto st648;

                case 146:
                    goto st680;

                case 147:
                    goto st709;

                case 148:
                    goto st738;

                case 149:
                    goto st767;

                case 150:
                    goto st796;

                case 151:
                    goto st833;
                }

                goto st0;
st0:
                cs = 0;
                goto _out;
tr68:

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
                goto st870;
tr86:

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
                goto st870;
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

                        add_opcode( Z80_ADC( REG_C ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_ADC( REG_B ) );
                    };
                }
                goto st870;
tr91:

                {
                    if ( compile_active )
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
                goto st870;
tr92:

                {
                    if ( compile_active )
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
                goto st870;
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

                        add_opcode( Z80_ADC( REG_H ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_ADC( REG_H ) + P_IX );
                    };
                }
                goto st870;
tr95:

                {
                    if ( compile_active )
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
                goto st870;
tr96:

                {
                    if ( compile_active )
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
                goto st870;
tr97:

                {
                    if ( compile_active )
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
                goto st870;
tr98:

                {
                    if ( compile_active )
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
                goto st870;
tr99:

                {
                    if ( compile_active )
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
                goto st870;
tr102:

                {
                    if ( compile_active )
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
                goto st870;
tr106:

                {
                    if ( compile_active )
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
                goto st870;
tr113:

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
                goto st870;
tr119:

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
                goto st870;
tr124:

                {
                    if ( compile_active )
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
                goto st870;
tr129:

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
                goto st870;
tr135:

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
                goto st870;
tr142:

                {
                    if ( compile_active )
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
                goto st870;
tr143:

                {
                    if ( compile_active )
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
                goto st870;
tr144:

                {
                    if ( compile_active )
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
                goto st870;
tr145:

                {
                    if ( compile_active )
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
                goto st870;
tr165:

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
                goto st870;
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

                        add_opcode( Z80_ADD( REG_C ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_ADD( REG_B ) );
                    };
                }
                goto st870;
tr170:

                {
                    if ( compile_active )
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
                goto st870;
tr171:

                {
                    if ( compile_active )
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
                goto st870;
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

                        add_opcode( Z80_ADD( REG_H ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_ADD( REG_H ) + P_IX );
                    };
                }
                goto st870;
tr174:

                {
                    if ( compile_active )
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
                goto st870;
tr175:

                {
                    if ( compile_active )
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
                goto st870;
tr176:

                {
                    if ( compile_active )
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
                goto st870;
tr177:

                {
                    if ( compile_active )
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
                goto st870;
tr178:

                {
                    if ( compile_active )
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
                goto st870;
tr181:

                {
                    if ( compile_active )
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
                goto st870;
tr185:

                {
                    if ( compile_active )
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
                goto st870;
tr190:

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
                goto st870;
tr196:

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
                goto st870;
tr201:

                {
                    if ( compile_active )
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
                goto st870;
tr206:

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
                goto st870;
tr212:

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
                goto st870;
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

                        add_opcode( Z80_ADD16( REG_BC ) + 0 );
                    };
                }
                goto st870;
tr220:

                {
                    if ( compile_active )
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
                goto st870;
tr221:

                {
                    if ( compile_active )
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
                goto st870;
tr222:

                {
                    if ( compile_active )
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
                goto st870;
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

                        add_opcode( Z80_ADD16( REG_BC ) + P_IX );
                    };
                }
                goto st870;
tr229:

                {
                    if ( compile_active )
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
                goto st870;
tr230:

                {
                    if ( compile_active )
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
                goto st870;
tr231:

                {
                    if ( compile_active )
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
                goto st870;
tr237:

                {
                    if ( compile_active )
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
                goto st870;
tr238:

                {
                    if ( compile_active )
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
                goto st870;
tr239:

                {
                    if ( compile_active )
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
                goto st870;
tr240:

                {
                    if ( compile_active )
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
                goto st870;
tr257:

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
                goto st870;
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

                        add_opcode( Z80_AND( REG_C ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_AND( REG_B ) );
                    };
                }
                goto st870;
tr262:

                {
                    if ( compile_active )
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
                goto st870;
tr263:

                {
                    if ( compile_active )
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
                goto st870;
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

                        add_opcode( Z80_AND( REG_H ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_AND( REG_H ) + P_IX );
                    };
                }
                goto st870;
tr266:

                {
                    if ( compile_active )
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
                goto st870;
tr267:

                {
                    if ( compile_active )
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
                goto st870;
tr268:

                {
                    if ( compile_active )
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
                goto st870;
tr269:

                {
                    if ( compile_active )
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
                goto st870;
tr270:

                {
                    if ( compile_active )
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
                goto st870;
tr273:

                {
                    if ( compile_active )
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
                goto st870;
tr277:

                {
                    if ( compile_active )
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
                goto st870;
tr282:

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
                goto st870;
tr288:

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
                goto st870;
tr293:

                {
                    if ( compile_active )
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
                goto st870;
tr298:

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
                goto st870;
tr304:

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
                goto st870;
tr321:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_BIT( expr_value, REG_C ) );
                        };
                }
                goto st870;
tr322:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_BIT( expr_value, REG_B ) );
                        };
                }
                goto st870;
tr323:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_BIT( expr_value, REG_D ) );
                        };
                }
                goto st870;
tr324:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_BIT( expr_value, REG_E ) );
                        };
                }
                goto st870;
tr325:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_BIT( expr_value, REG_H ) );
                        };
                }
                goto st870;
tr326:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_BIT( expr_value, REG_L ) );
                        };
                }
                goto st870;
tr327:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_BIT( expr_value, REG_A ) );
                        };
                }
                goto st870;
tr328:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_BIT( expr_value, REG_idx ) );
                        };
                }
                goto st870;
tr332:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( ( ( P_IX << 16 ) & 0xFF000000 ) + ( ( Z80_BIT( expr_value, REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_BIT( expr_value, REG_idx ) << 0 ) & 0xFF ) );
                        };
                }
                goto st870;
tr337:

                {
                    if ( ! expr_error )
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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_BIT( expr_value, REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr343:

                {
                    if ( ! expr_error )
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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_BIT( expr_value, REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr348:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( ( ( P_IY << 16 ) & 0xFF000000 ) + ( ( Z80_BIT( expr_value, REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_BIT( expr_value, REG_idx ) << 0 ) & 0xFF ) );
                        };
                }
                goto st870;
tr353:

                {
                    if ( ! expr_error )
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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_BIT( expr_value, REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr359:

                {
                    if ( ! expr_error )
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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_BIT( expr_value, REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
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

                            add_opcode_nn( ( Z80_CALL ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr377:

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
                goto st870;
tr383:

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
                goto st870;
tr389:

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
                goto st870;
tr395:

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
                goto st870;
tr401:

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
                goto st870;
tr407:

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
                goto st870;
tr413:

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
                goto st870;
tr419:

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
                goto st870;
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

                        add_opcode( Z80_CCF );
                    };
                }
                goto st870;
tr439:

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
                goto st870;
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

                        add_opcode( Z80_CP( REG_C ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_CP( REG_B ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_CP( REG_D ) );
                    };
                }
                goto st870;
tr445:

                {
                    if ( compile_active )
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
                goto st870;
tr446:

                {
                    if ( compile_active )
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
                goto st870;
tr447:

                {
                    if ( compile_active )
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
                goto st870;
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

                        add_opcode( Z80_CP( REG_H ) + P_IY );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_CP( REG_L ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_CP( REG_L ) + P_IX );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_CP( REG_L ) + P_IY );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_CP( REG_A ) );
                    };
                }
                goto st870;
tr455:

                {
                    if ( compile_active )
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
                goto st870;
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

                        add_opcode( ( Z80_CP( REG_idx ) + P_IX ) << 8 );
                    };
                }
                goto st870;
tr464:

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
                goto st870;
tr470:

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
                goto st870;
tr475:

                {
                    if ( compile_active )
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
                goto st870;
tr480:

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
                goto st870;
tr486:

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
                goto st870;
tr488:

                {
                    if ( compile_active )
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
                goto st870;
tr489:

                {
                    if ( compile_active )
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
                goto st870;
tr490:

                {
                    if ( compile_active )
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
                goto st870;
tr491:

                {
                    if ( compile_active )
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
                goto st870;
tr492:

                {
                    if ( compile_active )
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
                goto st870;
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

                        add_opcode( Z80_DAA );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_DI );
                    };
                }
                goto st870;
tr497:

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
                goto st870;
tr500:

                {
                    if ( compile_active )
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
                goto st870;
tr506:

                {
                    if ( compile_active )
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
                goto st870;
tr510:

                {
                    if ( compile_active )
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
                goto st870;
tr511:

                {
                    if ( compile_active )
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
                goto st870;
tr516:

                {
                    if ( compile_active )
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
                goto st870;
tr517:

                {
                    if ( compile_active )
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
                goto st870;
tr518:

                {
                    if ( compile_active )
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
                goto st870;
tr519:

                {
                    if ( compile_active )
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
                goto st870;
tr520:

                {
                    if ( compile_active )
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
                goto st870;
tr523:

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
                goto st870;
tr535:

                {
                    if ( compile_active )
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
                goto st870;
tr538:

                {
                    if ( compile_active )
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
                goto st870;
tr541:

                {
                    if ( compile_active )
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
                goto st870;
tr544:

                {
                    if ( compile_active )
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
                goto st870;
tr547:

                {
                    if ( compile_active )
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
                goto st870;
tr550:

                {
                    if ( compile_active )
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
                goto st870;
tr555:

                {
                    if ( expr_start->tok != TK_LPAREN )
                        return FALSE;

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

                            add_opcode_n( ( Z80_IN_A_n ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr558:

                {
                    if ( compile_active )
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
                goto st870;
tr559:

                {
                    if ( compile_active )
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
                goto st870;
tr560:

                {
                    if ( compile_active )
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
                goto st870;
tr561:

                {
                    if ( compile_active )
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
                goto st870;
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

                        add_opcode( Z80_INIR );
                    };
                }
                goto st870;
tr576:

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
                goto st870;
tr582:

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
                goto st870;
tr588:

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
                goto st870;
tr594:

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
                goto st870;
tr600:

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
                goto st870;
tr606:

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
                goto st870;
tr612:

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
                goto st870;
tr618:

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
                goto st870;
tr624:

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
                goto st870;
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

                        add_opcode( ( Z80_JP_idx ) );
                    };
                }
                goto st870;
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

                        add_opcode( ( Z80_JP_idx + P_IX ) );
                    };
                }
                goto st870;
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

                        add_opcode( ( Z80_JP_idx + P_IY ) );
                    };
                }
                goto st870;
tr638:

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
                goto st870;
tr644:

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
                goto st870;
tr650:

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
                goto st870;
tr656:

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
                goto st870;
tr662:

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
                goto st870;
tr665:

                {
                    if ( compile_active )
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
                goto st870;
tr666:

                {
                    if ( compile_active )
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
                goto st870;
tr667:

                {
                    if ( compile_active )
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
                goto st870;
tr668:

                {
                    if ( compile_active )
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
                goto st870;
tr669:

                {
                    if ( compile_active )
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
                goto st870;
tr670:

                {
                    if ( compile_active )
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
                goto st870;
tr687:

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
                goto st870;
tr690:

                {
                    if ( compile_active )
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
                goto st870;
tr691:

                {
                    if ( compile_active )
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
                goto st870;
tr692:

                {
                    if ( compile_active )
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
                goto st870;
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

                        add_opcode( Z80_OR( REG_E ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_OR( REG_H ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_OR( REG_H ) + P_IX );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_OR( REG_H ) + P_IY );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_OR( REG_L ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_OR( REG_L ) + P_IX );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_OR( REG_L ) + P_IY );
                    };
                }
                goto st870;
tr700:

                {
                    if ( compile_active )
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
                goto st870;
tr703:

                {
                    if ( compile_active )
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
                goto st870;
tr707:

                {
                    if ( compile_active )
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
                goto st870;
tr712:

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
                goto st870;
tr718:

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
                goto st870;
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

                        add_opcode( ( Z80_OR( REG_idx ) + P_IY ) << 8 );
                    };
                }
                goto st870;
tr728:

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
                goto st870;
tr734:

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
                goto st870;
tr736:

                {
                    if ( compile_active )
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
                goto st870;
tr737:

                {
                    if ( compile_active )
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
                goto st870;
tr745:

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

                            add_opcode_n( ( Z80_OUT_n_A ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_OUT_C_REG( REG_C ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_OUT_C_REG( REG_B ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_OUT_C_REG( REG_D ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_OUT_C_REG( REG_E ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_OUT_C_REG( REG_H ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_OUT_C_REG( REG_L ) );
                    };
                }
                goto st870;
tr760:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_OUT_C_REG( REG_A ) );
                    };
                }
                goto st870;
tr761:

                {
                    if ( compile_active )
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
                goto st870;
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

                        add_opcode( Z80_OUTI );
                    };
                }
                goto st870;
tr769:

                {
                    if ( compile_active )
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
                goto st870;
tr770:

                {
                    if ( compile_active )
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
                goto st870;
tr771:

                {
                    if ( compile_active )
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
                goto st870;
tr772:

                {
                    if ( compile_active )
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
                goto st870;
tr773:

                {
                    if ( compile_active )
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
                goto st870;
tr774:

                {
                    if ( compile_active )
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
                goto st870;
tr781:

                {
                    if ( compile_active )
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
                goto st870;
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

                        add_opcode( Z80_PUSH( REG_DE ) );
                    };
                }
                goto st870;
tr783:

                {
                    if ( compile_active )
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
                goto st870;
tr784:

                {
                    if ( compile_active )
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
                goto st870;
tr785:

                {
                    if ( compile_active )
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
                goto st870;
tr786:

                {
                    if ( compile_active )
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
                goto st870;
tr802:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_RES( expr_value, REG_C ) );
                        };
                }
                goto st870;
tr803:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_RES( expr_value, REG_B ) );
                        };
                }
                goto st870;
tr804:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_RES( expr_value, REG_D ) );
                        };
                }
                goto st870;
tr805:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_RES( expr_value, REG_E ) );
                        };
                }
                goto st870;
tr806:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_RES( expr_value, REG_H ) );
                        };
                }
                goto st870;
tr807:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_RES( expr_value, REG_L ) );
                        };
                }
                goto st870;
tr808:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_RES( expr_value, REG_A ) );
                        };
                }
                goto st870;
tr809:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_RES( expr_value, REG_idx ) );
                        };
                }
                goto st870;
tr813:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( ( ( P_IX << 16 ) & 0xFF000000 ) + ( ( Z80_RES( expr_value, REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_RES( expr_value, REG_idx ) << 0 ) & 0xFF ) );
                        };
                }
                goto st870;
tr818:

                {
                    if ( ! expr_error )
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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_RES( expr_value, REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr824:

                {
                    if ( ! expr_error )
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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_RES( expr_value, REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr829:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( ( ( P_IY << 16 ) & 0xFF000000 ) + ( ( Z80_RES( expr_value, REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_RES( expr_value, REG_idx ) << 0 ) & 0xFF ) );
                        };
                }
                goto st870;
tr834:

                {
                    if ( ! expr_error )
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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_RES( expr_value, REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr840:

                {
                    if ( ! expr_error )
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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_RES( expr_value, REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr842:

                {
                    if ( compile_active )
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
                goto st870;
tr851:

                {
                    if ( compile_active )
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
                goto st870;
tr852:

                {
                    if ( compile_active )
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
                goto st870;
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

                        add_opcode( Z80_RET_FLAG( FLAG_NC ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_RET_FLAG( FLAG_C ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_RET_FLAG( FLAG_PO ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_RET_FLAG( FLAG_PE ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_RET_FLAG( FLAG_P ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_RET_FLAG( FLAG_M ) );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_RETI );
                    };
                }
                goto st870;
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

                        add_opcode( Z80_RETN );
                    };
                }
                goto st870;
tr871:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RL( REG_C ) );
                    };
                }
                goto st870;
tr872:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RL( REG_B ) );
                    };
                }
                goto st870;
tr873:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RL( REG_D ) );
                    };
                }
                goto st870;
tr874:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RL( REG_E ) );
                    };
                }
                goto st870;
tr875:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RL( REG_H ) );
                    };
                }
                goto st870;
tr876:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RL( REG_L ) );
                    };
                }
                goto st870;
tr877:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RL( REG_A ) );
                    };
                }
                goto st870;
tr878:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RL( REG_idx ) );
                    };
                }
                goto st870;
tr882:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IX << 16 ) & 0xFF000000 ) + ( ( Z80_RL( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_RL( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr887:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_RL( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr893:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_RL( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
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

                        add_opcode( ( ( P_IY << 16 ) & 0xFF000000 ) + ( ( Z80_RL( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_RL( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr903:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_RL( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr909:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_RL( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr911:

                {
                    if ( compile_active )
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
                goto st870;
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

                        add_opcode( Z80_RLC( REG_C ) );
                    };
                }
                goto st870;
tr923:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RLC( REG_B ) );
                    };
                }
                goto st870;
tr924:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RLC( REG_D ) );
                    };
                }
                goto st870;
tr925:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RLC( REG_E ) );
                    };
                }
                goto st870;
tr926:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RLC( REG_H ) );
                    };
                }
                goto st870;
tr927:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RLC( REG_L ) );
                    };
                }
                goto st870;
tr928:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RLC( REG_A ) );
                    };
                }
                goto st870;
tr929:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RLC( REG_idx ) );
                    };
                }
                goto st870;
tr933:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IX << 16 ) & 0xFF000000 ) + ( ( Z80_RLC( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_RLC( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr938:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_RLC( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr944:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_RLC( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr949:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IY << 16 ) & 0xFF000000 ) + ( ( Z80_RLC( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_RLC( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr954:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_RLC( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr960:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_RLC( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr962:

                {
                    if ( compile_active )
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
                goto st870;
tr963:

                {
                    if ( compile_active )
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
                goto st870;
tr974:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RR( REG_C ) );
                    };
                }
                goto st870;
tr975:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RR( REG_B ) );
                    };
                }
                goto st870;
tr976:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RR( REG_D ) );
                    };
                }
                goto st870;
tr977:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RR( REG_E ) );
                    };
                }
                goto st870;
tr978:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RR( REG_H ) );
                    };
                }
                goto st870;
tr979:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RR( REG_L ) );
                    };
                }
                goto st870;
tr980:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RR( REG_A ) );
                    };
                }
                goto st870;
tr981:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RR( REG_idx ) );
                    };
                }
                goto st870;
tr985:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IX << 16 ) & 0xFF000000 ) + ( ( Z80_RR( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_RR( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr990:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_RR( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr996:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_RR( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1001:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IY << 16 ) & 0xFF000000 ) + ( ( Z80_RR( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_RR( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr1006:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_RR( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1012:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_RR( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1014:

                {
                    if ( compile_active )
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
                goto st870;
tr1025:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RRC( REG_C ) );
                    };
                }
                goto st870;
tr1026:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RRC( REG_B ) );
                    };
                }
                goto st870;
tr1027:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RRC( REG_D ) );
                    };
                }
                goto st870;
tr1028:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RRC( REG_E ) );
                    };
                }
                goto st870;
tr1029:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RRC( REG_H ) );
                    };
                }
                goto st870;
tr1030:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RRC( REG_L ) );
                    };
                }
                goto st870;
tr1031:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RRC( REG_A ) );
                    };
                }
                goto st870;
tr1032:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_RRC( REG_idx ) );
                    };
                }
                goto st870;
tr1036:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IX << 16 ) & 0xFF000000 ) + ( ( Z80_RRC( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_RRC( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr1041:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_RRC( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1047:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_RRC( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1052:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IY << 16 ) & 0xFF000000 ) + ( ( Z80_RRC( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_RRC( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr1057:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_RRC( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1063:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_RRC( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1065:

                {
                    if ( compile_active )
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
                goto st870;
tr1066:

                {
                    if ( compile_active )
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
                goto st870;
tr1069:

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
                goto st870;
tr1089:

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
                goto st870;
tr1092:

                {
                    if ( compile_active )
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
                goto st870;
tr1093:

                {
                    if ( compile_active )
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
                goto st870;
tr1094:

                {
                    if ( compile_active )
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
                goto st870;
tr1095:

                {
                    if ( compile_active )
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
                goto st870;
tr1096:

                {
                    if ( compile_active )
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
                goto st870;
tr1097:

                {
                    if ( compile_active )
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
                goto st870;
tr1098:

                {
                    if ( compile_active )
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
                goto st870;
tr1099:

                {
                    if ( compile_active )
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
                goto st870;
tr1100:

                {
                    if ( compile_active )
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
                goto st870;
tr1101:

                {
                    if ( compile_active )
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
                goto st870;
tr1102:

                {
                    if ( compile_active )
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
                goto st870;
tr1105:

                {
                    if ( compile_active )
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
                goto st870;
tr1109:

                {
                    if ( compile_active )
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
                goto st870;
tr1114:

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
                goto st870;
tr1120:

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
                goto st870;
tr1125:

                {
                    if ( compile_active )
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
                goto st870;
tr1130:

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
                goto st870;
tr1136:

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
                goto st870;
tr1143:

                {
                    if ( compile_active )
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
                goto st870;
tr1144:

                {
                    if ( compile_active )
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
                goto st870;
tr1145:

                {
                    if ( compile_active )
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
                goto st870;
tr1146:

                {
                    if ( compile_active )
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
                goto st870;
tr1147:

                {
                    if ( compile_active )
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
                goto st870;
tr1163:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_SET( expr_value, REG_C ) );
                        };
                }
                goto st870;
tr1164:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_SET( expr_value, REG_B ) );
                        };
                }
                goto st870;
tr1165:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_SET( expr_value, REG_D ) );
                        };
                }
                goto st870;
tr1166:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_SET( expr_value, REG_E ) );
                        };
                }
                goto st870;
tr1167:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_SET( expr_value, REG_H ) );
                        };
                }
                goto st870;
tr1168:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_SET( expr_value, REG_L ) );
                        };
                }
                goto st870;
tr1169:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_SET( expr_value, REG_A ) );
                        };
                }
                goto st870;
tr1170:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( Z80_SET( expr_value, REG_idx ) );
                        };
                }
                goto st870;
tr1174:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( ( ( P_IX << 16 ) & 0xFF000000 ) + ( ( Z80_SET( expr_value, REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_SET( expr_value, REG_idx ) << 0 ) & 0xFF ) );
                        };
                }
                goto st870;
tr1179:

                {
                    if ( ! expr_error )
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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_SET( expr_value, REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1185:

                {
                    if ( ! expr_error )
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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_SET( expr_value, REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1190:

                {
                    if ( ! expr_error ) if ( compile_active )
                        {
                            if ( stmt_label )
                            {
                                if ( compile_active )
                                {
                                    define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                                };

                                stmt_label = NULL;
                            };

                            add_opcode( ( ( P_IY << 16 ) & 0xFF000000 ) + ( ( Z80_SET( expr_value, REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_SET( expr_value, REG_idx ) << 0 ) & 0xFF ) );
                        };
                }
                goto st870;
tr1195:

                {
                    if ( ! expr_error )
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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_SET( expr_value, REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1201:

                {
                    if ( ! expr_error )
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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_SET( expr_value, REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1213:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLA( REG_C ) );
                    };
                }
                goto st870;
tr1214:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLA( REG_B ) );
                    };
                }
                goto st870;
tr1215:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLA( REG_D ) );
                    };
                }
                goto st870;
tr1216:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLA( REG_E ) );
                    };
                }
                goto st870;
tr1217:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLA( REG_H ) );
                    };
                }
                goto st870;
tr1218:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLA( REG_L ) );
                    };
                }
                goto st870;
tr1219:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLA( REG_A ) );
                    };
                }
                goto st870;
tr1220:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLA( REG_idx ) );
                    };
                }
                goto st870;
tr1224:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IX << 16 ) & 0xFF000000 ) + ( ( Z80_SLA( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_SLA( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr1229:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_SLA( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1235:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_SLA( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1240:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IY << 16 ) & 0xFF000000 ) + ( ( Z80_SLA( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_SLA( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr1245:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_SLA( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1251:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_SLA( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1263:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLL( REG_C ) );
                    };
                }
                goto st870;
tr1264:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLL( REG_B ) );
                    };
                }
                goto st870;
tr1265:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLL( REG_D ) );
                    };
                }
                goto st870;
tr1266:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLL( REG_E ) );
                    };
                }
                goto st870;
tr1267:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLL( REG_H ) );
                    };
                }
                goto st870;
tr1268:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLL( REG_L ) );
                    };
                }
                goto st870;
tr1269:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLL( REG_A ) );
                    };
                }
                goto st870;
tr1270:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SLL( REG_idx ) );
                    };
                }
                goto st870;
tr1274:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IX << 16 ) & 0xFF000000 ) + ( ( Z80_SLL( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_SLL( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr1279:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_SLL( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1285:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_SLL( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1290:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IY << 16 ) & 0xFF000000 ) + ( ( Z80_SLL( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_SLL( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr1295:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_SLL( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1301:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_SLL( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1313:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRA( REG_C ) );
                    };
                }
                goto st870;
tr1314:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRA( REG_B ) );
                    };
                }
                goto st870;
tr1315:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRA( REG_D ) );
                    };
                }
                goto st870;
tr1316:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRA( REG_E ) );
                    };
                }
                goto st870;
tr1317:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRA( REG_H ) );
                    };
                }
                goto st870;
tr1318:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRA( REG_L ) );
                    };
                }
                goto st870;
tr1319:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRA( REG_A ) );
                    };
                }
                goto st870;
tr1320:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRA( REG_idx ) );
                    };
                }
                goto st870;
tr1324:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IX << 16 ) & 0xFF000000 ) + ( ( Z80_SRA( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_SRA( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr1329:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_SRA( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1335:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_SRA( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1340:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IY << 16 ) & 0xFF000000 ) + ( ( Z80_SRA( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_SRA( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr1345:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_SRA( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1351:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_SRA( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1363:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRL( REG_C ) );
                    };
                }
                goto st870;
tr1364:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRL( REG_B ) );
                    };
                }
                goto st870;
tr1365:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRL( REG_D ) );
                    };
                }
                goto st870;
tr1366:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRL( REG_E ) );
                    };
                }
                goto st870;
tr1367:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRL( REG_H ) );
                    };
                }
                goto st870;
tr1368:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRL( REG_L ) );
                    };
                }
                goto st870;
tr1369:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRL( REG_A ) );
                    };
                }
                goto st870;
tr1370:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( Z80_SRL( REG_idx ) );
                    };
                }
                goto st870;
tr1374:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IX << 16 ) & 0xFF000000 ) + ( ( Z80_SRL( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_SRL( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr1379:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_SRL( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1385:

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

                            add_opcode_idx( ( ( ( P_IX << 8 ) & 0xFF0000 ) + Z80_SRL( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1390:

                {
                    if ( compile_active )
                    {
                        if ( stmt_label )
                        {
                            if ( compile_active )
                            {
                                define_symbol( ( stmt_label ), get_PC() + ( 0 ), TYPE_ADDRESS, SYM_TOUCHED );
                            };

                            stmt_label = NULL;
                        };

                        add_opcode( ( ( P_IY << 16 ) & 0xFF000000 ) + ( ( Z80_SRL( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_SRL( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st870;
tr1395:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_SRL( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1401:

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

                            add_opcode_idx( ( ( ( P_IY << 8 ) & 0xFF0000 ) + Z80_SRL( REG_idx ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st870;
tr1419:

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
                goto st870;
tr1422:

                {
                    if ( compile_active )
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
                goto st870;
tr1423:

                {
                    if ( compile_active )
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
                goto st870;
tr1424:

                {
                    if ( compile_active )
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
                goto st870;
tr1425:

                {
                    if ( compile_active )
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
                goto st870;
tr1426:

                {
                    if ( compile_active )
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
                goto st870;
tr1427:

                {
                    if ( compile_active )
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
                goto st870;
tr1428:

                {
                    if ( compile_active )
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
                goto st870;
tr1429:

                {
                    if ( compile_active )
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
                goto st870;
tr1430:

                {
                    if ( compile_active )
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
                goto st870;
tr1431:

                {
                    if ( compile_active )
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
                goto st870;
tr1432:

                {
                    if ( compile_active )
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
                goto st870;
tr1435:

                {
                    if ( compile_active )
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
                goto st870;
tr1439:

                {
                    if ( compile_active )
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
                goto st870;
tr1444:

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
                goto st870;
tr1450:

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
                goto st870;
tr1455:

                {
                    if ( compile_active )
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
                goto st870;
tr1460:

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
                goto st870;
tr1466:

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
                goto st870;
tr1484:

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
                goto st870;
tr1487:

                {
                    if ( compile_active )
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
                goto st870;
tr1488:

                {
                    if ( compile_active )
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
                goto st870;
tr1489:

                {
                    if ( compile_active )
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
                goto st870;
tr1490:

                {
                    if ( compile_active )
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
                goto st870;
tr1491:

                {
                    if ( compile_active )
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
                goto st870;
tr1492:

                {
                    if ( compile_active )
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
                goto st870;
tr1493:

                {
                    if ( compile_active )
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
                goto st870;
tr1494:

                {
                    if ( compile_active )
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
                goto st870;
tr1495:

                {
                    if ( compile_active )
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
                goto st870;
tr1496:

                {
                    if ( compile_active )
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
                goto st870;
tr1497:

                {
                    if ( compile_active )
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
                goto st870;
tr1500:

                {
                    if ( compile_active )
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
                goto st870;
tr1504:

                {
                    if ( compile_active )
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
                goto st870;
tr1509:

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
                goto st870;
tr1515:

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
                goto st870;
tr1520:

                {
                    if ( compile_active )
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
                goto st870;
tr1525:

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
                goto st870;
tr1531:

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
                goto st870;
st870:

                if ( ++p == pe )
                    goto _test_eof870;

            case 870:

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
                    goto tr68;

                case 87:
                    goto st3;

                case 88:
                    goto st48;

                case 89:
                    goto st103;

                case 90:
                    goto st140;

                case 91:
                    goto st172;

                case 92:
                    goto st207;

                case 93:
                    goto st208;

                case 94:
                    goto st245;

                case 95:
                    goto st246;

                case 96:
                    goto st247;

                case 97:
                    goto st248;

                case 98:
                    goto st249;

                case 99:
                    goto st250;

                case 100:
                    goto st251;

                case 101:
                    goto st252;

                case 102:
                    goto st255;

                case 103:
                    goto st256;

                case 104:
                    goto st269;

                case 105:
                    goto st270;

                case 106:
                    goto st271;

                case 107:
                    goto st274;

                case 108:
                    goto st298;

                case 109:
                    goto st299;

                case 110:
                    goto st300;

                case 111:
                    goto st301;

                case 112:
                    goto st302;

                case 113:
                    goto st342;

                case 114:
                    goto st361;

                case 115:
                    goto st362;

                case 116:
                    goto st363;

                case 117:
                    goto st364;

                case 118:
                    goto st365;

                case 119:
                    goto st366;

                case 120:
                    goto st367;

                case 121:
                    goto st404;

                case 122:
                    goto st405;

                case 123:
                    goto st406;

                case 124:
                    goto st420;

                case 125:
                    goto st421;

                case 126:
                    goto st422;

                case 127:
                    goto st429;

                case 128:
                    goto st436;

                case 129:
                    goto st468;

                case 130:
                    goto st477;

                case 131:
                    goto st478;

                case 132:
                    goto st479;

                case 133:
                    goto st508;

                case 134:
                    goto st509;

                case 135:
                    goto st538;

                case 136:
                    goto st539;

                case 137:
                    goto st540;

                case 138:
                    goto st569;

                case 139:
                    goto st570;

                case 140:
                    goto st599;

                case 141:
                    goto st600;

                case 142:
                    goto st601;

                case 143:
                    goto st604;

                case 144:
                    goto st647;

                case 145:
                    goto st648;

                case 146:
                    goto st680;

                case 147:
                    goto st709;

                case 148:
                    goto st738;

                case 149:
                    goto st767;

                case 150:
                    goto st796;

                case 151:
                    goto st833;
                }

                goto st0;
st3:

                if ( ++p == pe )
                    goto _test_eof3;

            case 3:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr69;

                case 5:
                    goto tr69;

                case 8:
                    goto tr69;

                case 18:
                    goto tr70;

                case 21:
                    goto tr70;

                case 23:
                    goto tr70;

                case 36:
                    goto tr70;

                case 44:
                    goto tr70;

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
                    goto tr70;

                goto st0;
tr69:

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
                    goto tr86;

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
tr70:

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
                    goto tr89;

                goto st0;
st7:

                if ( ++p == pe )
                    goto _test_eof7;

            case 7:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr90;

                goto st0;
st8:

                if ( ++p == pe )
                    goto _test_eof8;

            case 8:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr91;

                goto st0;
st9:

                if ( ++p == pe )
                    goto _test_eof9;

            case 9:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr92;

                goto st0;
st10:

                if ( ++p == pe )
                    goto _test_eof10;

            case 10:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr93;

                goto st0;
st11:

                if ( ++p == pe )
                    goto _test_eof11;

            case 11:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr94;

                goto st0;
st12:

                if ( ++p == pe )
                    goto _test_eof12;

            case 12:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr95;

                goto st0;
st13:

                if ( ++p == pe )
                    goto _test_eof13;

            case 13:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr96;

                goto st0;
st14:

                if ( ++p == pe )
                    goto _test_eof14;

            case 14:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr97;

                goto st0;
st15:

                if ( ++p == pe )
                    goto _test_eof15;

            case 15:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr98;

                goto st0;
st16:

                if ( ++p == pe )
                    goto _test_eof16;

            case 16:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr99;

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
                    goto tr69;

                case 5:
                    goto tr69;

                case 8:
                    goto tr69;

                case 18:
                    goto tr70;

                case 21:
                    goto tr70;

                case 23:
                    goto tr70;

                case 36:
                    goto tr70;

                case 44:
                    goto tr70;

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
                    goto tr70;

                goto st0;
st18:

                if ( ++p == pe )
                    goto _test_eof18;

            case 18:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr99;

                goto st0;
st19:

                if ( ++p == pe )
                    goto _test_eof19;

            case 19:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr102;

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
                    goto tr106;

                goto st0;
st22:

                if ( ++p == pe )
                    goto _test_eof22;

            case 22:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr107;

                case 5:
                    goto tr107;

                case 8:
                    goto tr107;

                case 18:
                    goto tr108;

                case 21:
                    goto tr108;

                case 23:
                    goto tr108;

                case 36:
                    goto tr108;

                case 44:
                    goto tr108;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr108;

                goto st0;
tr107:

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
                    goto tr110;

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
tr110:

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
                    goto tr113;

                case 19:
                    goto tr110;

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
tr108:

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
                    goto tr115;

                case 5:
                    goto tr115;

                case 8:
                    goto tr115;

                case 18:
                    goto tr116;

                case 21:
                    goto tr116;

                case 23:
                    goto tr116;

                case 36:
                    goto tr116;

                case 44:
                    goto tr116;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr116;

                goto st0;
tr115:

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
                    goto tr117;

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
tr117:

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
                    goto tr119;

                case 19:
                    goto tr117;

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
tr116:

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
                    goto tr124;

                goto st0;
st34:

                if ( ++p == pe )
                    goto _test_eof34;

            case 34:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr125;

                case 5:
                    goto tr125;

                case 8:
                    goto tr125;

                case 18:
                    goto tr126;

                case 21:
                    goto tr126;

                case 23:
                    goto tr126;

                case 36:
                    goto tr126;

                case 44:
                    goto tr126;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr126;

                goto st0;
tr125:

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
                    goto tr127;

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
tr127:

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
                    goto tr129;

                case 19:
                    goto tr127;

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
tr126:

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
                    goto tr131;

                case 5:
                    goto tr131;

                case 8:
                    goto tr131;

                case 18:
                    goto tr132;

                case 21:
                    goto tr132;

                case 23:
                    goto tr132;

                case 36:
                    goto tr132;

                case 44:
                    goto tr132;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr132;

                goto st0;
tr131:

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
                    goto tr133;

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
tr133:

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
                    goto tr135;

                case 19:
                    goto tr133;

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
tr132:

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
                    goto tr142;

                goto st0;
st45:

                if ( ++p == pe )
                    goto _test_eof45;

            case 45:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr143;

                goto st0;
st46:

                if ( ++p == pe )
                    goto _test_eof46;

            case 46:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr144;

                goto st0;
st47:

                if ( ++p == pe )
                    goto _test_eof47;

            case 47:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr145;

                goto st0;
st48:

                if ( ++p == pe )
                    goto _test_eof48;

            case 48:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr146;

                case 5:
                    goto tr146;

                case 8:
                    goto tr146;

                case 18:
                    goto tr147;

                case 21:
                    goto tr147;

                case 23:
                    goto tr147;

                case 36:
                    goto tr147;

                case 44:
                    goto tr147;

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
                    goto tr147;

                goto st0;
tr146:

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
                    goto tr165;

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
tr147:

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
                    goto tr168;

                goto st0;
st52:

                if ( ++p == pe )
                    goto _test_eof52;

            case 52:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr169;

                goto st0;
st53:

                if ( ++p == pe )
                    goto _test_eof53;

            case 53:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr170;

                goto st0;
st54:

                if ( ++p == pe )
                    goto _test_eof54;

            case 54:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr171;

                goto st0;
st55:

                if ( ++p == pe )
                    goto _test_eof55;

            case 55:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr172;

                goto st0;
st56:

                if ( ++p == pe )
                    goto _test_eof56;

            case 56:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr173;

                goto st0;
st57:

                if ( ++p == pe )
                    goto _test_eof57;

            case 57:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr174;

                goto st0;
st58:

                if ( ++p == pe )
                    goto _test_eof58;

            case 58:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr175;

                goto st0;
st59:

                if ( ++p == pe )
                    goto _test_eof59;

            case 59:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr176;

                goto st0;
st60:

                if ( ++p == pe )
                    goto _test_eof60;

            case 60:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr177;

                goto st0;
st61:

                if ( ++p == pe )
                    goto _test_eof61;

            case 61:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr178;

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
                    goto tr146;

                case 5:
                    goto tr146;

                case 8:
                    goto tr146;

                case 18:
                    goto tr147;

                case 21:
                    goto tr147;

                case 23:
                    goto tr147;

                case 36:
                    goto tr147;

                case 44:
                    goto tr147;

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
                    goto tr147;

                goto st0;
st63:

                if ( ++p == pe )
                    goto _test_eof63;

            case 63:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr178;

                goto st0;
st64:

                if ( ++p == pe )
                    goto _test_eof64;

            case 64:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr181;

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
                    goto tr185;

                goto st0;
st67:

                if ( ++p == pe )
                    goto _test_eof67;

            case 67:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr186;

                case 5:
                    goto tr186;

                case 8:
                    goto tr186;

                case 18:
                    goto tr187;

                case 21:
                    goto tr187;

                case 23:
                    goto tr187;

                case 36:
                    goto tr187;

                case 44:
                    goto tr187;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr187;

                goto st0;
tr186:

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
                    goto tr188;

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
tr188:

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
                    goto tr190;

                case 19:
                    goto tr188;

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
tr187:

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
                    goto tr192;

                case 5:
                    goto tr192;

                case 8:
                    goto tr192;

                case 18:
                    goto tr193;

                case 21:
                    goto tr193;

                case 23:
                    goto tr193;

                case 36:
                    goto tr193;

                case 44:
                    goto tr193;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr193;

                goto st0;
tr192:

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
                    goto tr194;

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
tr194:

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
                    goto tr196;

                case 19:
                    goto tr194;

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
tr193:

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
                    goto tr201;

                goto st0;
st77:

                if ( ++p == pe )
                    goto _test_eof77;

            case 77:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr202;

                case 5:
                    goto tr202;

                case 8:
                    goto tr202;

                case 18:
                    goto tr203;

                case 21:
                    goto tr203;

                case 23:
                    goto tr203;

                case 36:
                    goto tr203;

                case 44:
                    goto tr203;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr203;

                goto st0;
tr202:

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
                    goto tr204;

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
tr204:

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
                    goto tr206;

                case 19:
                    goto tr204;

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
tr203:

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
                    goto tr208;

                case 5:
                    goto tr208;

                case 8:
                    goto tr208;

                case 18:
                    goto tr209;

                case 21:
                    goto tr209;

                case 23:
                    goto tr209;

                case 36:
                    goto tr209;

                case 44:
                    goto tr209;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr209;

                goto st0;
tr208:

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
                    goto tr210;

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
tr210:

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
                    goto tr212;

                case 19:
                    goto tr210;

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
tr209:

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
                    goto tr219;

                goto st0;
st88:

                if ( ++p == pe )
                    goto _test_eof88;

            case 88:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr220;

                goto st0;
st89:

                if ( ++p == pe )
                    goto _test_eof89;

            case 89:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr221;

                goto st0;
st90:

                if ( ++p == pe )
                    goto _test_eof90;

            case 90:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr222;

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
                    goto tr228;

                goto st0;
st94:

                if ( ++p == pe )
                    goto _test_eof94;

            case 94:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr229;

                goto st0;
st95:

                if ( ++p == pe )
                    goto _test_eof95;

            case 95:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr230;

                goto st0;
st96:

                if ( ++p == pe )
                    goto _test_eof96;

            case 96:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr231;

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
                    goto tr237;

                goto st0;
st100:

                if ( ++p == pe )
                    goto _test_eof100;

            case 100:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr238;

                goto st0;
st101:

                if ( ++p == pe )
                    goto _test_eof101;

            case 101:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr239;

                goto st0;
st102:

                if ( ++p == pe )
                    goto _test_eof102;

            case 102:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr240;

                goto st0;
st103:

                if ( ++p == pe )
                    goto _test_eof103;

            case 103:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr241;

                case 5:
                    goto tr241;

                case 8:
                    goto tr241;

                case 18:
                    goto tr242;

                case 21:
                    goto tr242;

                case 23:
                    goto tr242;

                case 36:
                    goto tr242;

                case 44:
                    goto tr242;

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
                    goto tr242;

                goto st0;
tr241:

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
                    goto tr257;

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
tr242:

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
                    goto tr260;

                goto st0;
st107:

                if ( ++p == pe )
                    goto _test_eof107;

            case 107:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr261;

                goto st0;
st108:

                if ( ++p == pe )
                    goto _test_eof108;

            case 108:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr262;

                goto st0;
st109:

                if ( ++p == pe )
                    goto _test_eof109;

            case 109:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr263;

                goto st0;
st110:

                if ( ++p == pe )
                    goto _test_eof110;

            case 110:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr264;

                goto st0;
st111:

                if ( ++p == pe )
                    goto _test_eof111;

            case 111:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr265;

                goto st0;
st112:

                if ( ++p == pe )
                    goto _test_eof112;

            case 112:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr266;

                goto st0;
st113:

                if ( ++p == pe )
                    goto _test_eof113;

            case 113:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr267;

                goto st0;
st114:

                if ( ++p == pe )
                    goto _test_eof114;

            case 114:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr268;

                goto st0;
st115:

                if ( ++p == pe )
                    goto _test_eof115;

            case 115:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr269;

                goto st0;
st116:

                if ( ++p == pe )
                    goto _test_eof116;

            case 116:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr270;

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
                    goto tr241;

                case 5:
                    goto tr241;

                case 8:
                    goto tr241;

                case 18:
                    goto tr242;

                case 21:
                    goto tr242;

                case 23:
                    goto tr242;

                case 36:
                    goto tr242;

                case 44:
                    goto tr242;

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
                    goto tr242;

                goto st0;
st118:

                if ( ++p == pe )
                    goto _test_eof118;

            case 118:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr270;

                goto st0;
st119:

                if ( ++p == pe )
                    goto _test_eof119;

            case 119:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr273;

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
                    goto tr277;

                goto st0;
st122:

                if ( ++p == pe )
                    goto _test_eof122;

            case 122:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr278;

                case 5:
                    goto tr278;

                case 8:
                    goto tr278;

                case 18:
                    goto tr279;

                case 21:
                    goto tr279;

                case 23:
                    goto tr279;

                case 36:
                    goto tr279;

                case 44:
                    goto tr279;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr279;

                goto st0;
tr278:

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
                    goto tr280;

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
tr280:

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
                    goto tr282;

                case 19:
                    goto tr280;

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
tr279:

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
                    goto tr284;

                case 5:
                    goto tr284;

                case 8:
                    goto tr284;

                case 18:
                    goto tr285;

                case 21:
                    goto tr285;

                case 23:
                    goto tr285;

                case 36:
                    goto tr285;

                case 44:
                    goto tr285;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr285;

                goto st0;
tr284:

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
                    goto tr286;

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
tr286:

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
                    goto tr288;

                case 19:
                    goto tr286;

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
tr285:

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
                    goto tr293;

                goto st0;
st132:

                if ( ++p == pe )
                    goto _test_eof132;

            case 132:
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
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr295;

                goto st0;
tr294:

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
                    goto tr296;

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
tr296:

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
                    goto tr298;

                case 19:
                    goto tr296;

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
tr295:

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
                    goto tr300;

                case 5:
                    goto tr300;

                case 8:
                    goto tr300;

                case 18:
                    goto tr301;

                case 21:
                    goto tr301;

                case 23:
                    goto tr301;

                case 36:
                    goto tr301;

                case 44:
                    goto tr301;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr301;

                goto st0;
tr300:

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
                    goto tr302;

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
tr302:

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
                    goto tr304;

                case 19:
                    goto tr302;

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
tr301:

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
                    goto tr306;

                case 5:
                    goto tr306;

                case 8:
                    goto tr306;

                case 18:
                    goto tr307;

                case 21:
                    goto tr307;

                case 23:
                    goto tr307;

                case 36:
                    goto tr307;

                case 44:
                    goto tr307;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr307;

                goto st0;
tr306:

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
                case 19:
                    goto st141;

                case 22:
                    goto tr310;

                case 37:
                    goto st141;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 23 )
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
tr307:

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
tr310:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    pop_eval_expr( &expr_value, &expr_error );
                }
                goto st143;
st143:

                if ( ++p == pe )
                    goto _test_eof143;

            case 143:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st144;

                case 53:
                    goto st145;

                case 54:
                    goto st146;

                case 55:
                    goto st147;

                case 56:
                    goto st148;

                case 59:
                    goto st149;

                case 62:
                    goto st150;

                case 79:
                    goto st151;

                case 80:
                    goto st152;

                case 81:
                    goto st162;
                }

                goto st0;
st144:

                if ( ++p == pe )
                    goto _test_eof144;

            case 144:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr321;

                goto st0;
st145:

                if ( ++p == pe )
                    goto _test_eof145;

            case 145:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr322;

                goto st0;
st146:

                if ( ++p == pe )
                    goto _test_eof146;

            case 146:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr323;

                goto st0;
st147:

                if ( ++p == pe )
                    goto _test_eof147;

            case 147:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr324;

                goto st0;
st148:

                if ( ++p == pe )
                    goto _test_eof148;

            case 148:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr325;

                goto st0;
st149:

                if ( ++p == pe )
                    goto _test_eof149;

            case 149:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr326;

                goto st0;
st150:

                if ( ++p == pe )
                    goto _test_eof150;

            case 150:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr327;

                goto st0;
st151:

                if ( ++p == pe )
                    goto _test_eof151;

            case 151:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr328;

                goto st0;
st152:

                if ( ++p == pe )
                    goto _test_eof152;

            case 152:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st153;

                case 21:
                    goto st154;

                case 23:
                    goto st158;
                }

                goto st0;
st153:

                if ( ++p == pe )
                    goto _test_eof153;

            case 153:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr332;

                goto st0;
st154:

                if ( ++p == pe )
                    goto _test_eof154;

            case 154:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr333;

                case 5:
                    goto tr333;

                case 8:
                    goto tr333;

                case 18:
                    goto tr334;

                case 21:
                    goto tr334;

                case 23:
                    goto tr334;

                case 36:
                    goto tr334;

                case 44:
                    goto tr334;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr334;

                goto st0;
tr333:

                {
                    expr_start = p;
                }
                goto st155;
st155:

                if ( ++p == pe )
                    goto _test_eof155;

            case 155:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr335;

                case 23:
                    goto st24;

                case 37:
                    goto st155;
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
tr335:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st156;
st156:

                if ( ++p == pe )
                    goto _test_eof156;

            case 156:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr337;

                case 19:
                    goto tr335;

                case 23:
                    goto st24;

                case 37:
                    goto st155;
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
tr334:

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
                case 3:
                    goto st155;

                case 5:
                    goto st155;

                case 8:
                    goto st155;

                case 13:
                    goto st157;

                case 18:
                    goto st157;

                case 21:
                    goto st157;

                case 23:
                    goto st157;

                case 36:
                    goto st157;

                case 44:
                    goto st157;
                }

                goto st0;
st158:

                if ( ++p == pe )
                    goto _test_eof158;

            case 158:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr339;

                case 5:
                    goto tr339;

                case 8:
                    goto tr339;

                case 18:
                    goto tr340;

                case 21:
                    goto tr340;

                case 23:
                    goto tr340;

                case 36:
                    goto tr340;

                case 44:
                    goto tr340;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr340;

                goto st0;
tr339:

                {
                    expr_start = p;
                }
                goto st159;
st159:

                if ( ++p == pe )
                    goto _test_eof159;

            case 159:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr341;

                case 23:
                    goto st24;

                case 37:
                    goto st159;
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
tr341:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st160;
st160:

                if ( ++p == pe )
                    goto _test_eof160;

            case 160:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr343;

                case 19:
                    goto tr341;

                case 23:
                    goto st24;

                case 37:
                    goto st159;
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
tr340:

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
                case 3:
                    goto st159;

                case 5:
                    goto st159;

                case 8:
                    goto st159;

                case 13:
                    goto st161;

                case 18:
                    goto st161;

                case 21:
                    goto st161;

                case 23:
                    goto st161;

                case 36:
                    goto st161;

                case 44:
                    goto st161;
                }

                goto st0;
st162:

                if ( ++p == pe )
                    goto _test_eof162;

            case 162:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st163;

                case 21:
                    goto st164;

                case 23:
                    goto st168;
                }

                goto st0;
st163:

                if ( ++p == pe )
                    goto _test_eof163;

            case 163:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr348;

                goto st0;
st164:

                if ( ++p == pe )
                    goto _test_eof164;

            case 164:
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
                goto st165;
st165:

                if ( ++p == pe )
                    goto _test_eof165;

            case 165:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr351;

                case 23:
                    goto st24;

                case 37:
                    goto st165;
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
tr351:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st166;
st166:

                if ( ++p == pe )
                    goto _test_eof166;

            case 166:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr353;

                case 19:
                    goto tr351;

                case 23:
                    goto st24;

                case 37:
                    goto st165;
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
tr350:

                {
                    expr_start = p;
                }
                goto st167;
st167:

                if ( ++p == pe )
                    goto _test_eof167;

            case 167:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st165;

                case 5:
                    goto st165;

                case 8:
                    goto st165;

                case 13:
                    goto st167;

                case 18:
                    goto st167;

                case 21:
                    goto st167;

                case 23:
                    goto st167;

                case 36:
                    goto st167;

                case 44:
                    goto st167;
                }

                goto st0;
st168:

                if ( ++p == pe )
                    goto _test_eof168;

            case 168:
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
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr356;

                goto st0;
tr355:

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
                case 19:
                    goto tr357;

                case 23:
                    goto st24;

                case 37:
                    goto st169;
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
tr357:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st170;
st170:

                if ( ++p == pe )
                    goto _test_eof170;

            case 170:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr359;

                case 19:
                    goto tr357;

                case 23:
                    goto st24;

                case 37:
                    goto st169;
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
tr356:

                {
                    expr_start = p;
                }
                goto st171;
st171:

                if ( ++p == pe )
                    goto _test_eof171;

            case 171:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st169;

                case 5:
                    goto st169;

                case 8:
                    goto st169;

                case 13:
                    goto st171;

                case 18:
                    goto st171;

                case 21:
                    goto st171;

                case 23:
                    goto st171;

                case 36:
                    goto st171;

                case 44:
                    goto st171;
                }

                goto st0;
st172:

                if ( ++p == pe )
                    goto _test_eof172;

            case 172:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr361;

                case 5:
                    goto tr361;

                case 8:
                    goto tr361;

                case 18:
                    goto tr362;

                case 21:
                    goto tr362;

                case 23:
                    goto tr362;

                case 36:
                    goto tr362;

                case 44:
                    goto tr362;

                case 45:
                    goto st175;

                case 46:
                    goto st179;

                case 47:
                    goto st183;

                case 48:
                    goto st187;

                case 49:
                    goto st191;

                case 50:
                    goto st195;

                case 51:
                    goto st199;

                case 52:
                    goto st203;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr362;

                goto st0;
tr361:

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
                    goto tr371;

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
tr362:

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
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st176;

                goto st0;
st176:

                if ( ++p == pe )
                    goto _test_eof176;

            case 176:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr375;

                case 5:
                    goto tr375;

                case 8:
                    goto tr375;

                case 18:
                    goto tr376;

                case 21:
                    goto tr376;

                case 23:
                    goto tr376;

                case 36:
                    goto tr376;

                case 44:
                    goto tr376;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr376;

                goto st0;
tr375:

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
                    goto tr377;

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
tr376:

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
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st180;

                goto st0;
st180:

                if ( ++p == pe )
                    goto _test_eof180;

            case 180:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr381;

                case 5:
                    goto tr381;

                case 8:
                    goto tr381;

                case 18:
                    goto tr382;

                case 21:
                    goto tr382;

                case 23:
                    goto tr382;

                case 36:
                    goto tr382;

                case 44:
                    goto tr382;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr382;

                goto st0;
tr381:

                {
                    expr_start = p;
                }
                goto st181;
st181:

                if ( ++p == pe )
                    goto _test_eof181;

            case 181:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr383;

                case 19:
                    goto st181;

                case 23:
                    goto st182;

                case 37:
                    goto st181;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st182;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st182;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st182;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st182;
                }
                else
                    goto st182;

                goto st0;
tr382:

                {
                    expr_start = p;
                }
                goto st182;
st182:

                if ( ++p == pe )
                    goto _test_eof182;

            case 182:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st181;

                case 5:
                    goto st181;

                case 8:
                    goto st181;

                case 13:
                    goto st182;

                case 18:
                    goto st182;

                case 21:
                    goto st182;

                case 23:
                    goto st182;

                case 36:
                    goto st182;

                case 44:
                    goto st182;
                }

                goto st0;
st183:

                if ( ++p == pe )
                    goto _test_eof183;

            case 183:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st184;

                goto st0;
st184:

                if ( ++p == pe )
                    goto _test_eof184;

            case 184:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr387;

                case 5:
                    goto tr387;

                case 8:
                    goto tr387;

                case 18:
                    goto tr388;

                case 21:
                    goto tr388;

                case 23:
                    goto tr388;

                case 36:
                    goto tr388;

                case 44:
                    goto tr388;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr388;

                goto st0;
tr387:

                {
                    expr_start = p;
                }
                goto st185;
st185:

                if ( ++p == pe )
                    goto _test_eof185;

            case 185:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr389;

                case 19:
                    goto st185;

                case 23:
                    goto st186;

                case 37:
                    goto st185;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st186;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st186;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st186;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st186;
                }
                else
                    goto st186;

                goto st0;
tr388:

                {
                    expr_start = p;
                }
                goto st186;
st186:

                if ( ++p == pe )
                    goto _test_eof186;

            case 186:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st185;

                case 5:
                    goto st185;

                case 8:
                    goto st185;

                case 13:
                    goto st186;

                case 18:
                    goto st186;

                case 21:
                    goto st186;

                case 23:
                    goto st186;

                case 36:
                    goto st186;

                case 44:
                    goto st186;
                }

                goto st0;
st187:

                if ( ++p == pe )
                    goto _test_eof187;

            case 187:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st188;

                goto st0;
st188:

                if ( ++p == pe )
                    goto _test_eof188;

            case 188:
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
                goto st189;
st189:

                if ( ++p == pe )
                    goto _test_eof189;

            case 189:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr395;

                case 19:
                    goto st189;

                case 23:
                    goto st190;

                case 37:
                    goto st189;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st190;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st190;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st190;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st190;
                }
                else
                    goto st190;

                goto st0;
tr394:

                {
                    expr_start = p;
                }
                goto st190;
st190:

                if ( ++p == pe )
                    goto _test_eof190;

            case 190:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st189;

                case 5:
                    goto st189;

                case 8:
                    goto st189;

                case 13:
                    goto st190;

                case 18:
                    goto st190;

                case 21:
                    goto st190;

                case 23:
                    goto st190;

                case 36:
                    goto st190;

                case 44:
                    goto st190;
                }

                goto st0;
st191:

                if ( ++p == pe )
                    goto _test_eof191;

            case 191:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st192;

                goto st0;
st192:

                if ( ++p == pe )
                    goto _test_eof192;

            case 192:
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
                goto st193;
st193:

                if ( ++p == pe )
                    goto _test_eof193;

            case 193:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr401;

                case 19:
                    goto st193;

                case 23:
                    goto st194;

                case 37:
                    goto st193;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st194;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st194;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st194;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st194;
                }
                else
                    goto st194;

                goto st0;
tr400:

                {
                    expr_start = p;
                }
                goto st194;
st194:

                if ( ++p == pe )
                    goto _test_eof194;

            case 194:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st193;

                case 5:
                    goto st193;

                case 8:
                    goto st193;

                case 13:
                    goto st194;

                case 18:
                    goto st194;

                case 21:
                    goto st194;

                case 23:
                    goto st194;

                case 36:
                    goto st194;

                case 44:
                    goto st194;
                }

                goto st0;
st195:

                if ( ++p == pe )
                    goto _test_eof195;

            case 195:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st196;

                goto st0;
st196:

                if ( ++p == pe )
                    goto _test_eof196;

            case 196:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr405;

                case 5:
                    goto tr405;

                case 8:
                    goto tr405;

                case 18:
                    goto tr406;

                case 21:
                    goto tr406;

                case 23:
                    goto tr406;

                case 36:
                    goto tr406;

                case 44:
                    goto tr406;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr406;

                goto st0;
tr405:

                {
                    expr_start = p;
                }
                goto st197;
st197:

                if ( ++p == pe )
                    goto _test_eof197;

            case 197:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr407;

                case 19:
                    goto st197;

                case 23:
                    goto st198;

                case 37:
                    goto st197;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st198;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st198;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st198;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st198;
                }
                else
                    goto st198;

                goto st0;
tr406:

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
                    goto st197;

                case 5:
                    goto st197;

                case 8:
                    goto st197;

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
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st200;

                goto st0;
st200:

                if ( ++p == pe )
                    goto _test_eof200;

            case 200:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr411;

                case 5:
                    goto tr411;

                case 8:
                    goto tr411;

                case 18:
                    goto tr412;

                case 21:
                    goto tr412;

                case 23:
                    goto tr412;

                case 36:
                    goto tr412;

                case 44:
                    goto tr412;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr412;

                goto st0;
tr411:

                {
                    expr_start = p;
                }
                goto st201;
st201:

                if ( ++p == pe )
                    goto _test_eof201;

            case 201:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr413;

                case 19:
                    goto st201;

                case 23:
                    goto st202;

                case 37:
                    goto st201;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st202;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st202;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st202;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st202;
                }
                else
                    goto st202;

                goto st0;
tr412:

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
                    goto st201;

                case 5:
                    goto st201;

                case 8:
                    goto st201;

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
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st204;

                goto st0;
st204:

                if ( ++p == pe )
                    goto _test_eof204;

            case 204:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr417;

                case 5:
                    goto tr417;

                case 8:
                    goto tr417;

                case 18:
                    goto tr418;

                case 21:
                    goto tr418;

                case 23:
                    goto tr418;

                case 36:
                    goto tr418;

                case 44:
                    goto tr418;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr418;

                goto st0;
tr417:

                {
                    expr_start = p;
                }
                goto st205;
st205:

                if ( ++p == pe )
                    goto _test_eof205;

            case 205:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr419;

                case 19:
                    goto st205;

                case 23:
                    goto st206;

                case 37:
                    goto st205;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st206;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st206;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st206;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st206;
                }
                else
                    goto st206;

                goto st0;
tr418:

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
                case 3:
                    goto st205;

                case 5:
                    goto st205;

                case 8:
                    goto st205;

                case 13:
                    goto st206;

                case 18:
                    goto st206;

                case 21:
                    goto st206;

                case 23:
                    goto st206;

                case 36:
                    goto st206;

                case 44:
                    goto st206;
                }

                goto st0;
st207:

                if ( ++p == pe )
                    goto _test_eof207;

            case 207:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr422;

                goto st0;
st208:

                if ( ++p == pe )
                    goto _test_eof208;

            case 208:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr423;

                case 5:
                    goto tr423;

                case 8:
                    goto tr423;

                case 18:
                    goto tr424;

                case 21:
                    goto tr424;

                case 23:
                    goto tr424;

                case 36:
                    goto tr424;

                case 44:
                    goto tr424;

                case 48:
                    goto st211;

                case 53:
                    goto st212;

                case 54:
                    goto st213;

                case 55:
                    goto st214;

                case 56:
                    goto st215;

                case 57:
                    goto st216;

                case 58:
                    goto st217;

                case 59:
                    goto st218;

                case 60:
                    goto st219;

                case 61:
                    goto st220;

                case 62:
                    goto st221;

                case 79:
                    goto st224;

                case 80:
                    goto st225;

                case 81:
                    goto st235;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr424;

                goto st0;
tr423:

                {
                    expr_start = p;
                }
                goto st209;
st209:

                if ( ++p == pe )
                    goto _test_eof209;

            case 209:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr439;

                case 19:
                    goto st209;

                case 23:
                    goto st210;

                case 37:
                    goto st209;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st210;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st210;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st210;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st210;
                }
                else
                    goto st210;

                goto st0;
tr424:

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
                case 3:
                    goto st209;

                case 5:
                    goto st209;

                case 8:
                    goto st209;

                case 13:
                    goto st210;

                case 18:
                    goto st210;

                case 21:
                    goto st210;

                case 23:
                    goto st210;

                case 36:
                    goto st210;

                case 44:
                    goto st210;
                }

                goto st0;
st211:

                if ( ++p == pe )
                    goto _test_eof211;

            case 211:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr442;

                goto st0;
st212:

                if ( ++p == pe )
                    goto _test_eof212;

            case 212:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr443;

                goto st0;
st213:

                if ( ++p == pe )
                    goto _test_eof213;

            case 213:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr444;

                goto st0;
st214:

                if ( ++p == pe )
                    goto _test_eof214;

            case 214:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr445;

                goto st0;
st215:

                if ( ++p == pe )
                    goto _test_eof215;

            case 215:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr446;

                goto st0;
st216:

                if ( ++p == pe )
                    goto _test_eof216;

            case 216:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr447;

                goto st0;
st217:

                if ( ++p == pe )
                    goto _test_eof217;

            case 217:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr448;

                goto st0;
st218:

                if ( ++p == pe )
                    goto _test_eof218;

            case 218:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr449;

                goto st0;
st219:

                if ( ++p == pe )
                    goto _test_eof219;

            case 219:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr450;

                goto st0;
st220:

                if ( ++p == pe )
                    goto _test_eof220;

            case 220:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr451;

                goto st0;
st221:

                if ( ++p == pe )
                    goto _test_eof221;

            case 221:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr452;

                case 22:
                    goto st222;
                }

                goto st0;
st222:

                if ( ++p == pe )
                    goto _test_eof222;

            case 222:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr423;

                case 5:
                    goto tr423;

                case 8:
                    goto tr423;

                case 18:
                    goto tr424;

                case 21:
                    goto tr424;

                case 23:
                    goto tr424;

                case 36:
                    goto tr424;

                case 44:
                    goto tr424;

                case 48:
                    goto st211;

                case 53:
                    goto st212;

                case 54:
                    goto st213;

                case 55:
                    goto st214;

                case 56:
                    goto st215;

                case 57:
                    goto st216;

                case 58:
                    goto st217;

                case 59:
                    goto st218;

                case 60:
                    goto st219;

                case 61:
                    goto st220;

                case 62:
                    goto st223;

                case 79:
                    goto st224;

                case 80:
                    goto st225;

                case 81:
                    goto st235;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr424;

                goto st0;
st223:

                if ( ++p == pe )
                    goto _test_eof223;

            case 223:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr452;

                goto st0;
st224:

                if ( ++p == pe )
                    goto _test_eof224;

            case 224:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr455;

                goto st0;
st225:

                if ( ++p == pe )
                    goto _test_eof225;

            case 225:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st226;

                case 21:
                    goto st227;

                case 23:
                    goto st231;
                }

                goto st0;
st226:

                if ( ++p == pe )
                    goto _test_eof226;

            case 226:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr459;

                goto st0;
st227:

                if ( ++p == pe )
                    goto _test_eof227;

            case 227:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr460;

                case 5:
                    goto tr460;

                case 8:
                    goto tr460;

                case 18:
                    goto tr461;

                case 21:
                    goto tr461;

                case 23:
                    goto tr461;

                case 36:
                    goto tr461;

                case 44:
                    goto tr461;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr461;

                goto st0;
tr460:

                {
                    expr_start = p;
                }
                goto st228;
st228:

                if ( ++p == pe )
                    goto _test_eof228;

            case 228:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr462;

                case 23:
                    goto st24;

                case 37:
                    goto st228;
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
tr462:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st229;
st229:

                if ( ++p == pe )
                    goto _test_eof229;

            case 229:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr464;

                case 19:
                    goto tr462;

                case 23:
                    goto st24;

                case 37:
                    goto st228;
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
tr461:

                {
                    expr_start = p;
                }
                goto st230;
st230:

                if ( ++p == pe )
                    goto _test_eof230;

            case 230:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st228;

                case 5:
                    goto st228;

                case 8:
                    goto st228;

                case 13:
                    goto st230;

                case 18:
                    goto st230;

                case 21:
                    goto st230;

                case 23:
                    goto st230;

                case 36:
                    goto st230;

                case 44:
                    goto st230;
                }

                goto st0;
st231:

                if ( ++p == pe )
                    goto _test_eof231;

            case 231:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr466;

                case 5:
                    goto tr466;

                case 8:
                    goto tr466;

                case 18:
                    goto tr467;

                case 21:
                    goto tr467;

                case 23:
                    goto tr467;

                case 36:
                    goto tr467;

                case 44:
                    goto tr467;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr467;

                goto st0;
tr466:

                {
                    expr_start = p;
                }
                goto st232;
st232:

                if ( ++p == pe )
                    goto _test_eof232;

            case 232:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr468;

                case 23:
                    goto st24;

                case 37:
                    goto st232;
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
tr468:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st233;
st233:

                if ( ++p == pe )
                    goto _test_eof233;

            case 233:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr470;

                case 19:
                    goto tr468;

                case 23:
                    goto st24;

                case 37:
                    goto st232;
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
tr467:

                {
                    expr_start = p;
                }
                goto st234;
st234:

                if ( ++p == pe )
                    goto _test_eof234;

            case 234:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st232;

                case 5:
                    goto st232;

                case 8:
                    goto st232;

                case 13:
                    goto st234;

                case 18:
                    goto st234;

                case 21:
                    goto st234;

                case 23:
                    goto st234;

                case 36:
                    goto st234;

                case 44:
                    goto st234;
                }

                goto st0;
st235:

                if ( ++p == pe )
                    goto _test_eof235;

            case 235:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st236;

                case 21:
                    goto st237;

                case 23:
                    goto st241;
                }

                goto st0;
st236:

                if ( ++p == pe )
                    goto _test_eof236;

            case 236:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr475;

                goto st0;
st237:

                if ( ++p == pe )
                    goto _test_eof237;

            case 237:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr476;

                case 5:
                    goto tr476;

                case 8:
                    goto tr476;

                case 18:
                    goto tr477;

                case 21:
                    goto tr477;

                case 23:
                    goto tr477;

                case 36:
                    goto tr477;

                case 44:
                    goto tr477;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr477;

                goto st0;
tr476:

                {
                    expr_start = p;
                }
                goto st238;
st238:

                if ( ++p == pe )
                    goto _test_eof238;

            case 238:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr478;

                case 23:
                    goto st24;

                case 37:
                    goto st238;
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
tr478:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st239;
st239:

                if ( ++p == pe )
                    goto _test_eof239;

            case 239:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr480;

                case 19:
                    goto tr478;

                case 23:
                    goto st24;

                case 37:
                    goto st238;
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
tr477:

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
                case 3:
                    goto st238;

                case 5:
                    goto st238;

                case 8:
                    goto st238;

                case 13:
                    goto st240;

                case 18:
                    goto st240;

                case 21:
                    goto st240;

                case 23:
                    goto st240;

                case 36:
                    goto st240;

                case 44:
                    goto st240;
                }

                goto st0;
st241:

                if ( ++p == pe )
                    goto _test_eof241;

            case 241:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr482;

                case 5:
                    goto tr482;

                case 8:
                    goto tr482;

                case 18:
                    goto tr483;

                case 21:
                    goto tr483;

                case 23:
                    goto tr483;

                case 36:
                    goto tr483;

                case 44:
                    goto tr483;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr483;

                goto st0;
tr482:

                {
                    expr_start = p;
                }
                goto st242;
st242:

                if ( ++p == pe )
                    goto _test_eof242;

            case 242:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr484;

                case 23:
                    goto st24;

                case 37:
                    goto st242;
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
tr484:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st243;
st243:

                if ( ++p == pe )
                    goto _test_eof243;

            case 243:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr486;

                case 19:
                    goto tr484;

                case 23:
                    goto st24;

                case 37:
                    goto st242;
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
tr483:

                {
                    expr_start = p;
                }
                goto st244;
st244:

                if ( ++p == pe )
                    goto _test_eof244;

            case 244:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st242;

                case 5:
                    goto st242;

                case 8:
                    goto st242;

                case 13:
                    goto st244;

                case 18:
                    goto st244;

                case 21:
                    goto st244;

                case 23:
                    goto st244;

                case 36:
                    goto st244;

                case 44:
                    goto st244;
                }

                goto st0;
st245:

                if ( ++p == pe )
                    goto _test_eof245;

            case 245:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr488;

                goto st0;
st246:

                if ( ++p == pe )
                    goto _test_eof246;

            case 246:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr489;

                goto st0;
st247:

                if ( ++p == pe )
                    goto _test_eof247;

            case 247:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr490;

                goto st0;
st248:

                if ( ++p == pe )
                    goto _test_eof248;

            case 248:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr491;

                goto st0;
st249:

                if ( ++p == pe )
                    goto _test_eof249;

            case 249:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr492;

                goto st0;
st250:

                if ( ++p == pe )
                    goto _test_eof250;

            case 250:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr493;

                goto st0;
st251:

                if ( ++p == pe )
                    goto _test_eof251;

            case 251:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr494;

                goto st0;
st252:

                if ( ++p == pe )
                    goto _test_eof252;

            case 252:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr495;

                case 5:
                    goto tr495;

                case 8:
                    goto tr495;

                case 18:
                    goto tr496;

                case 21:
                    goto tr496;

                case 23:
                    goto tr496;

                case 36:
                    goto tr496;

                case 44:
                    goto tr496;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr496;

                goto st0;
tr495:

                {
                    expr_start = p;
                }
                goto st253;
st253:

                if ( ++p == pe )
                    goto _test_eof253;

            case 253:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr497;

                case 19:
                    goto st253;

                case 23:
                    goto st254;

                case 37:
                    goto st253;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st254;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st254;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st254;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st254;
                }
                else
                    goto st254;

                goto st0;
tr496:

                {
                    expr_start = p;
                }
                goto st254;
st254:

                if ( ++p == pe )
                    goto _test_eof254;

            case 254:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st253;

                case 5:
                    goto st253;

                case 8:
                    goto st253;

                case 13:
                    goto st254;

                case 18:
                    goto st254;

                case 21:
                    goto st254;

                case 23:
                    goto st254;

                case 36:
                    goto st254;

                case 44:
                    goto st254;
                }

                goto st0;
st255:

                if ( ++p == pe )
                    goto _test_eof255;

            case 255:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr500;

                goto st0;
st256:

                if ( ++p == pe )
                    goto _test_eof256;

            case 256:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 70:
                    goto st257;

                case 74:
                    goto st260;

                case 82:
                    goto st264;
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
                if ( ( ( ( int ) p->tok ) ) == 71 )
                    goto st259;

                goto st0;
st259:

                if ( ++p == pe )
                    goto _test_eof259;

            case 259:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr506;

                goto st0;
st260:

                if ( ++p == pe )
                    goto _test_eof260;

            case 260:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st261;

                goto st0;
st261:

                if ( ++p == pe )
                    goto _test_eof261;

            case 261:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 74:
                    goto st262;

                case 76:
                    goto st263;
                }

                goto st0;
st262:

                if ( ++p == pe )
                    goto _test_eof262;

            case 262:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr510;

                goto st0;
st263:

                if ( ++p == pe )
                    goto _test_eof263;

            case 263:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr511;

                goto st0;
st264:

                if ( ++p == pe )
                    goto _test_eof264;

            case 264:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st265;

                goto st0;
st265:

                if ( ++p == pe )
                    goto _test_eof265;

            case 265:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 71:
                    goto st266;

                case 72:
                    goto st267;

                case 73:
                    goto st268;
                }

                goto st0;
st266:

                if ( ++p == pe )
                    goto _test_eof266;

            case 266:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr516;

                goto st0;
st267:

                if ( ++p == pe )
                    goto _test_eof267;

            case 267:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr517;

                goto st0;
st268:

                if ( ++p == pe )
                    goto _test_eof268;

            case 268:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr518;

                goto st0;
st269:

                if ( ++p == pe )
                    goto _test_eof269;

            case 269:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr519;

                goto st0;
st270:

                if ( ++p == pe )
                    goto _test_eof270;

            case 270:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr520;

                goto st0;
st271:

                if ( ++p == pe )
                    goto _test_eof271;

            case 271:
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
                goto st272;
st272:

                if ( ++p == pe )
                    goto _test_eof272;

            case 272:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr523;

                case 19:
                    goto st272;

                case 23:
                    goto st273;

                case 37:
                    goto st272;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st273;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st273;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st273;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st273;
                }
                else
                    goto st273;

                goto st0;
tr522:

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
                case 3:
                    goto st272;

                case 5:
                    goto st272;

                case 8:
                    goto st272;

                case 13:
                    goto st273;

                case 18:
                    goto st273;

                case 21:
                    goto st273;

                case 23:
                    goto st273;

                case 36:
                    goto st273;

                case 44:
                    goto st273;
                }

                goto st0;
st274:

                if ( ++p == pe )
                    goto _test_eof274;

            case 274:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st275;

                case 53:
                    goto st278;

                case 54:
                    goto st281;

                case 55:
                    goto st284;

                case 56:
                    goto st287;

                case 59:
                    goto st290;

                case 62:
                    goto st293;
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
                if ( ( ( ( int ) p->tok ) ) == 68 )
                    goto st277;

                goto st0;
st277:

                if ( ++p == pe )
                    goto _test_eof277;

            case 277:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr535;

                goto st0;
st278:

                if ( ++p == pe )
                    goto _test_eof278;

            case 278:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st279;

                goto st0;
st279:

                if ( ++p == pe )
                    goto _test_eof279;

            case 279:
                if ( ( ( ( int ) p->tok ) ) == 68 )
                    goto st280;

                goto st0;
st280:

                if ( ++p == pe )
                    goto _test_eof280;

            case 280:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr538;

                goto st0;
st281:

                if ( ++p == pe )
                    goto _test_eof281;

            case 281:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st282;

                goto st0;
st282:

                if ( ++p == pe )
                    goto _test_eof282;

            case 282:
                if ( ( ( ( int ) p->tok ) ) == 68 )
                    goto st283;

                goto st0;
st283:

                if ( ++p == pe )
                    goto _test_eof283;

            case 283:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr541;

                goto st0;
st284:

                if ( ++p == pe )
                    goto _test_eof284;

            case 284:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st285;

                goto st0;
st285:

                if ( ++p == pe )
                    goto _test_eof285;

            case 285:
                if ( ( ( ( int ) p->tok ) ) == 68 )
                    goto st286;

                goto st0;
st286:

                if ( ++p == pe )
                    goto _test_eof286;

            case 286:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr544;

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
                if ( ( ( ( int ) p->tok ) ) == 68 )
                    goto st289;

                goto st0;
st289:

                if ( ++p == pe )
                    goto _test_eof289;

            case 289:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr547;

                goto st0;
st290:

                if ( ++p == pe )
                    goto _test_eof290;

            case 290:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st291;

                goto st0;
st291:

                if ( ++p == pe )
                    goto _test_eof291;

            case 291:
                if ( ( ( ( int ) p->tok ) ) == 68 )
                    goto st292;

                goto st0;
st292:

                if ( ++p == pe )
                    goto _test_eof292;

            case 292:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr550;

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
                    goto tr552;

                case 5:
                    goto tr552;

                case 8:
                    goto tr552;

                case 18:
                    goto tr553;

                case 21:
                    goto tr553;

                case 23:
                    goto tr553;

                case 36:
                    goto tr553;

                case 44:
                    goto tr553;

                case 68:
                    goto st297;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr553;

                goto st0;
tr552:

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
                    goto tr555;

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
tr553:

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
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr558;

                goto st0;
st298:

                if ( ++p == pe )
                    goto _test_eof298;

            case 298:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr559;

                goto st0;
st299:

                if ( ++p == pe )
                    goto _test_eof299;

            case 299:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr560;

                goto st0;
st300:

                if ( ++p == pe )
                    goto _test_eof300;

            case 300:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr561;

                goto st0;
st301:

                if ( ++p == pe )
                    goto _test_eof301;

            case 301:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr562;

                goto st0;
st302:

                if ( ++p == pe )
                    goto _test_eof302;

            case 302:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr563;

                case 5:
                    goto tr563;

                case 8:
                    goto tr563;

                case 18:
                    goto tr564;

                case 21:
                    goto tr564;

                case 23:
                    goto tr564;

                case 36:
                    goto tr564;

                case 44:
                    goto tr564;

                case 45:
                    goto st305;

                case 46:
                    goto st309;

                case 47:
                    goto st313;

                case 48:
                    goto st317;

                case 49:
                    goto st321;

                case 50:
                    goto st325;

                case 51:
                    goto st329;

                case 52:
                    goto st333;

                case 79:
                    goto st337;

                case 80:
                    goto st338;

                case 81:
                    goto st340;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr564;

                goto st0;
tr563:

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
                    goto tr576;

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
tr564:

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
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st306;

                goto st0;
st306:

                if ( ++p == pe )
                    goto _test_eof306;

            case 306:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr580;

                case 5:
                    goto tr580;

                case 8:
                    goto tr580;

                case 18:
                    goto tr581;

                case 21:
                    goto tr581;

                case 23:
                    goto tr581;

                case 36:
                    goto tr581;

                case 44:
                    goto tr581;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr581;

                goto st0;
tr580:

                {
                    expr_start = p;
                }
                goto st307;
st307:

                if ( ++p == pe )
                    goto _test_eof307;

            case 307:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr582;

                case 19:
                    goto st307;

                case 23:
                    goto st308;

                case 37:
                    goto st307;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st308;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st308;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st308;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st308;
                }
                else
                    goto st308;

                goto st0;
tr581:

                {
                    expr_start = p;
                }
                goto st308;
st308:

                if ( ++p == pe )
                    goto _test_eof308;

            case 308:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st307;

                case 5:
                    goto st307;

                case 8:
                    goto st307;

                case 13:
                    goto st308;

                case 18:
                    goto st308;

                case 21:
                    goto st308;

                case 23:
                    goto st308;

                case 36:
                    goto st308;

                case 44:
                    goto st308;
                }

                goto st0;
st309:

                if ( ++p == pe )
                    goto _test_eof309;

            case 309:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st310;

                goto st0;
st310:

                if ( ++p == pe )
                    goto _test_eof310;

            case 310:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr586;

                case 5:
                    goto tr586;

                case 8:
                    goto tr586;

                case 18:
                    goto tr587;

                case 21:
                    goto tr587;

                case 23:
                    goto tr587;

                case 36:
                    goto tr587;

                case 44:
                    goto tr587;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr587;

                goto st0;
tr586:

                {
                    expr_start = p;
                }
                goto st311;
st311:

                if ( ++p == pe )
                    goto _test_eof311;

            case 311:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr588;

                case 19:
                    goto st311;

                case 23:
                    goto st312;

                case 37:
                    goto st311;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st312;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st312;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st312;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st312;
                }
                else
                    goto st312;

                goto st0;
tr587:

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
                case 3:
                    goto st311;

                case 5:
                    goto st311;

                case 8:
                    goto st311;

                case 13:
                    goto st312;

                case 18:
                    goto st312;

                case 21:
                    goto st312;

                case 23:
                    goto st312;

                case 36:
                    goto st312;

                case 44:
                    goto st312;
                }

                goto st0;
st313:

                if ( ++p == pe )
                    goto _test_eof313;

            case 313:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st314;

                goto st0;
st314:

                if ( ++p == pe )
                    goto _test_eof314;

            case 314:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr592;

                case 5:
                    goto tr592;

                case 8:
                    goto tr592;

                case 18:
                    goto tr593;

                case 21:
                    goto tr593;

                case 23:
                    goto tr593;

                case 36:
                    goto tr593;

                case 44:
                    goto tr593;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr593;

                goto st0;
tr592:

                {
                    expr_start = p;
                }
                goto st315;
st315:

                if ( ++p == pe )
                    goto _test_eof315;

            case 315:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr594;

                case 19:
                    goto st315;

                case 23:
                    goto st316;

                case 37:
                    goto st315;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st316;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st316;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st316;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st316;
                }
                else
                    goto st316;

                goto st0;
tr593:

                {
                    expr_start = p;
                }
                goto st316;
st316:

                if ( ++p == pe )
                    goto _test_eof316;

            case 316:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st315;

                case 5:
                    goto st315;

                case 8:
                    goto st315;

                case 13:
                    goto st316;

                case 18:
                    goto st316;

                case 21:
                    goto st316;

                case 23:
                    goto st316;

                case 36:
                    goto st316;

                case 44:
                    goto st316;
                }

                goto st0;
st317:

                if ( ++p == pe )
                    goto _test_eof317;

            case 317:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st318;

                goto st0;
st318:

                if ( ++p == pe )
                    goto _test_eof318;

            case 318:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr598;

                case 5:
                    goto tr598;

                case 8:
                    goto tr598;

                case 18:
                    goto tr599;

                case 21:
                    goto tr599;

                case 23:
                    goto tr599;

                case 36:
                    goto tr599;

                case 44:
                    goto tr599;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr599;

                goto st0;
tr598:

                {
                    expr_start = p;
                }
                goto st319;
st319:

                if ( ++p == pe )
                    goto _test_eof319;

            case 319:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr600;

                case 19:
                    goto st319;

                case 23:
                    goto st320;

                case 37:
                    goto st319;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st320;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st320;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st320;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st320;
                }
                else
                    goto st320;

                goto st0;
tr599:

                {
                    expr_start = p;
                }
                goto st320;
st320:

                if ( ++p == pe )
                    goto _test_eof320;

            case 320:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st319;

                case 5:
                    goto st319;

                case 8:
                    goto st319;

                case 13:
                    goto st320;

                case 18:
                    goto st320;

                case 21:
                    goto st320;

                case 23:
                    goto st320;

                case 36:
                    goto st320;

                case 44:
                    goto st320;
                }

                goto st0;
st321:

                if ( ++p == pe )
                    goto _test_eof321;

            case 321:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st322;

                goto st0;
st322:

                if ( ++p == pe )
                    goto _test_eof322;

            case 322:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr604;

                case 5:
                    goto tr604;

                case 8:
                    goto tr604;

                case 18:
                    goto tr605;

                case 21:
                    goto tr605;

                case 23:
                    goto tr605;

                case 36:
                    goto tr605;

                case 44:
                    goto tr605;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr605;

                goto st0;
tr604:

                {
                    expr_start = p;
                }
                goto st323;
st323:

                if ( ++p == pe )
                    goto _test_eof323;

            case 323:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr606;

                case 19:
                    goto st323;

                case 23:
                    goto st324;

                case 37:
                    goto st323;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st324;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st324;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st324;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st324;
                }
                else
                    goto st324;

                goto st0;
tr605:

                {
                    expr_start = p;
                }
                goto st324;
st324:

                if ( ++p == pe )
                    goto _test_eof324;

            case 324:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st323;

                case 5:
                    goto st323;

                case 8:
                    goto st323;

                case 13:
                    goto st324;

                case 18:
                    goto st324;

                case 21:
                    goto st324;

                case 23:
                    goto st324;

                case 36:
                    goto st324;

                case 44:
                    goto st324;
                }

                goto st0;
st325:

                if ( ++p == pe )
                    goto _test_eof325;

            case 325:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st326;

                goto st0;
st326:

                if ( ++p == pe )
                    goto _test_eof326;

            case 326:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr610;

                case 5:
                    goto tr610;

                case 8:
                    goto tr610;

                case 18:
                    goto tr611;

                case 21:
                    goto tr611;

                case 23:
                    goto tr611;

                case 36:
                    goto tr611;

                case 44:
                    goto tr611;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr611;

                goto st0;
tr610:

                {
                    expr_start = p;
                }
                goto st327;
st327:

                if ( ++p == pe )
                    goto _test_eof327;

            case 327:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr612;

                case 19:
                    goto st327;

                case 23:
                    goto st328;

                case 37:
                    goto st327;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st328;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st328;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st328;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st328;
                }
                else
                    goto st328;

                goto st0;
tr611:

                {
                    expr_start = p;
                }
                goto st328;
st328:

                if ( ++p == pe )
                    goto _test_eof328;

            case 328:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st327;

                case 5:
                    goto st327;

                case 8:
                    goto st327;

                case 13:
                    goto st328;

                case 18:
                    goto st328;

                case 21:
                    goto st328;

                case 23:
                    goto st328;

                case 36:
                    goto st328;

                case 44:
                    goto st328;
                }

                goto st0;
st329:

                if ( ++p == pe )
                    goto _test_eof329;

            case 329:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st330;

                goto st0;
st330:

                if ( ++p == pe )
                    goto _test_eof330;

            case 330:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr616;

                case 5:
                    goto tr616;

                case 8:
                    goto tr616;

                case 18:
                    goto tr617;

                case 21:
                    goto tr617;

                case 23:
                    goto tr617;

                case 36:
                    goto tr617;

                case 44:
                    goto tr617;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr617;

                goto st0;
tr616:

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
                case 12:
                    goto tr618;

                case 19:
                    goto st331;

                case 23:
                    goto st332;

                case 37:
                    goto st331;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st332;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st332;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st332;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st332;
                }
                else
                    goto st332;

                goto st0;
tr617:

                {
                    expr_start = p;
                }
                goto st332;
st332:

                if ( ++p == pe )
                    goto _test_eof332;

            case 332:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st331;

                case 5:
                    goto st331;

                case 8:
                    goto st331;

                case 13:
                    goto st332;

                case 18:
                    goto st332;

                case 21:
                    goto st332;

                case 23:
                    goto st332;

                case 36:
                    goto st332;

                case 44:
                    goto st332;
                }

                goto st0;
st333:

                if ( ++p == pe )
                    goto _test_eof333;

            case 333:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st334;

                goto st0;
st334:

                if ( ++p == pe )
                    goto _test_eof334;

            case 334:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr622;

                case 5:
                    goto tr622;

                case 8:
                    goto tr622;

                case 18:
                    goto tr623;

                case 21:
                    goto tr623;

                case 23:
                    goto tr623;

                case 36:
                    goto tr623;

                case 44:
                    goto tr623;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr623;

                goto st0;
tr622:

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
                case 12:
                    goto tr624;

                case 19:
                    goto st335;

                case 23:
                    goto st336;

                case 37:
                    goto st335;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st336;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st336;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st336;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st336;
                }
                else
                    goto st336;

                goto st0;
tr623:

                {
                    expr_start = p;
                }
                goto st336;
st336:

                if ( ++p == pe )
                    goto _test_eof336;

            case 336:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st335;

                case 5:
                    goto st335;

                case 8:
                    goto st335;

                case 13:
                    goto st336;

                case 18:
                    goto st336;

                case 21:
                    goto st336;

                case 23:
                    goto st336;

                case 36:
                    goto st336;

                case 44:
                    goto st336;
                }

                goto st0;
st337:

                if ( ++p == pe )
                    goto _test_eof337;

            case 337:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr627;

                goto st0;
st338:

                if ( ++p == pe )
                    goto _test_eof338;

            case 338:
                if ( ( ( ( int ) p->tok ) ) == 19 )
                    goto st339;

                goto st0;
st339:

                if ( ++p == pe )
                    goto _test_eof339;

            case 339:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr629;

                goto st0;
st340:

                if ( ++p == pe )
                    goto _test_eof340;

            case 340:
                if ( ( ( ( int ) p->tok ) ) == 19 )
                    goto st341;

                goto st0;
st341:

                if ( ++p == pe )
                    goto _test_eof341;

            case 341:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr631;

                goto st0;
st342:

                if ( ++p == pe )
                    goto _test_eof342;

            case 342:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr632;

                case 5:
                    goto tr632;

                case 8:
                    goto tr632;

                case 18:
                    goto tr633;

                case 21:
                    goto tr633;

                case 23:
                    goto tr633;

                case 36:
                    goto tr633;

                case 44:
                    goto tr633;

                case 45:
                    goto st345;

                case 46:
                    goto st349;

                case 47:
                    goto st353;

                case 48:
                    goto st357;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr633;

                goto st0;
tr632:

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
                case 12:
                    goto tr638;

                case 19:
                    goto st343;

                case 23:
                    goto st344;

                case 37:
                    goto st343;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st344;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st344;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st344;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st344;
                }
                else
                    goto st344;

                goto st0;
tr633:

                {
                    expr_start = p;
                }
                goto st344;
st344:

                if ( ++p == pe )
                    goto _test_eof344;

            case 344:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st343;

                case 5:
                    goto st343;

                case 8:
                    goto st343;

                case 13:
                    goto st344;

                case 18:
                    goto st344;

                case 21:
                    goto st344;

                case 23:
                    goto st344;

                case 36:
                    goto st344;

                case 44:
                    goto st344;
                }

                goto st0;
st345:

                if ( ++p == pe )
                    goto _test_eof345;

            case 345:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st346;

                goto st0;
st346:

                if ( ++p == pe )
                    goto _test_eof346;

            case 346:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr642;

                case 5:
                    goto tr642;

                case 8:
                    goto tr642;

                case 18:
                    goto tr643;

                case 21:
                    goto tr643;

                case 23:
                    goto tr643;

                case 36:
                    goto tr643;

                case 44:
                    goto tr643;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr643;

                goto st0;
tr642:

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
                case 12:
                    goto tr644;

                case 19:
                    goto st347;

                case 23:
                    goto st348;

                case 37:
                    goto st347;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st348;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st348;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st348;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st348;
                }
                else
                    goto st348;

                goto st0;
tr643:

                {
                    expr_start = p;
                }
                goto st348;
st348:

                if ( ++p == pe )
                    goto _test_eof348;

            case 348:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st347;

                case 5:
                    goto st347;

                case 8:
                    goto st347;

                case 13:
                    goto st348;

                case 18:
                    goto st348;

                case 21:
                    goto st348;

                case 23:
                    goto st348;

                case 36:
                    goto st348;

                case 44:
                    goto st348;
                }

                goto st0;
st349:

                if ( ++p == pe )
                    goto _test_eof349;

            case 349:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st350;

                goto st0;
st350:

                if ( ++p == pe )
                    goto _test_eof350;

            case 350:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr648;

                case 5:
                    goto tr648;

                case 8:
                    goto tr648;

                case 18:
                    goto tr649;

                case 21:
                    goto tr649;

                case 23:
                    goto tr649;

                case 36:
                    goto tr649;

                case 44:
                    goto tr649;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr649;

                goto st0;
tr648:

                {
                    expr_start = p;
                }
                goto st351;
st351:

                if ( ++p == pe )
                    goto _test_eof351;

            case 351:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr650;

                case 19:
                    goto st351;

                case 23:
                    goto st352;

                case 37:
                    goto st351;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st352;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st352;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st352;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st352;
                }
                else
                    goto st352;

                goto st0;
tr649:

                {
                    expr_start = p;
                }
                goto st352;
st352:

                if ( ++p == pe )
                    goto _test_eof352;

            case 352:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st351;

                case 5:
                    goto st351;

                case 8:
                    goto st351;

                case 13:
                    goto st352;

                case 18:
                    goto st352;

                case 21:
                    goto st352;

                case 23:
                    goto st352;

                case 36:
                    goto st352;

                case 44:
                    goto st352;
                }

                goto st0;
st353:

                if ( ++p == pe )
                    goto _test_eof353;

            case 353:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st354;

                goto st0;
st354:

                if ( ++p == pe )
                    goto _test_eof354;

            case 354:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr654;

                case 5:
                    goto tr654;

                case 8:
                    goto tr654;

                case 18:
                    goto tr655;

                case 21:
                    goto tr655;

                case 23:
                    goto tr655;

                case 36:
                    goto tr655;

                case 44:
                    goto tr655;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr655;

                goto st0;
tr654:

                {
                    expr_start = p;
                }
                goto st355;
st355:

                if ( ++p == pe )
                    goto _test_eof355;

            case 355:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr656;

                case 19:
                    goto st355;

                case 23:
                    goto st356;

                case 37:
                    goto st355;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st356;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st356;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st356;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st356;
                }
                else
                    goto st356;

                goto st0;
tr655:

                {
                    expr_start = p;
                }
                goto st356;
st356:

                if ( ++p == pe )
                    goto _test_eof356;

            case 356:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st355;

                case 5:
                    goto st355;

                case 8:
                    goto st355;

                case 13:
                    goto st356;

                case 18:
                    goto st356;

                case 21:
                    goto st356;

                case 23:
                    goto st356;

                case 36:
                    goto st356;

                case 44:
                    goto st356;
                }

                goto st0;
st357:

                if ( ++p == pe )
                    goto _test_eof357;

            case 357:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st358;

                goto st0;
st358:

                if ( ++p == pe )
                    goto _test_eof358;

            case 358:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr660;

                case 5:
                    goto tr660;

                case 8:
                    goto tr660;

                case 18:
                    goto tr661;

                case 21:
                    goto tr661;

                case 23:
                    goto tr661;

                case 36:
                    goto tr661;

                case 44:
                    goto tr661;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr661;

                goto st0;
tr660:

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
                case 12:
                    goto tr662;

                case 19:
                    goto st359;

                case 23:
                    goto st360;

                case 37:
                    goto st359;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st360;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st360;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st360;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st360;
                }
                else
                    goto st360;

                goto st0;
tr661:

                {
                    expr_start = p;
                }
                goto st360;
st360:

                if ( ++p == pe )
                    goto _test_eof360;

            case 360:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st359;

                case 5:
                    goto st359;

                case 8:
                    goto st359;

                case 13:
                    goto st360;

                case 18:
                    goto st360;

                case 21:
                    goto st360;

                case 23:
                    goto st360;

                case 36:
                    goto st360;

                case 44:
                    goto st360;
                }

                goto st0;
st361:

                if ( ++p == pe )
                    goto _test_eof361;

            case 361:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr665;

                goto st0;
st362:

                if ( ++p == pe )
                    goto _test_eof362;

            case 362:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr666;

                goto st0;
st363:

                if ( ++p == pe )
                    goto _test_eof363;

            case 363:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr667;

                goto st0;
st364:

                if ( ++p == pe )
                    goto _test_eof364;

            case 364:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr668;

                goto st0;
st365:

                if ( ++p == pe )
                    goto _test_eof365;

            case 365:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr669;

                goto st0;
st366:

                if ( ++p == pe )
                    goto _test_eof366;

            case 366:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr670;

                goto st0;
st367:

                if ( ++p == pe )
                    goto _test_eof367;

            case 367:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr671;

                case 5:
                    goto tr671;

                case 8:
                    goto tr671;

                case 18:
                    goto tr672;

                case 21:
                    goto tr672;

                case 23:
                    goto tr672;

                case 36:
                    goto tr672;

                case 44:
                    goto tr672;

                case 48:
                    goto st370;

                case 53:
                    goto st371;

                case 54:
                    goto st372;

                case 55:
                    goto st373;

                case 56:
                    goto st374;

                case 57:
                    goto st375;

                case 58:
                    goto st376;

                case 59:
                    goto st377;

                case 60:
                    goto st378;

                case 61:
                    goto st379;

                case 62:
                    goto st380;

                case 79:
                    goto st383;

                case 80:
                    goto st384;

                case 81:
                    goto st394;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr672;

                goto st0;
tr671:

                {
                    expr_start = p;
                }
                goto st368;
st368:

                if ( ++p == pe )
                    goto _test_eof368;

            case 368:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr687;

                case 19:
                    goto st368;

                case 23:
                    goto st369;

                case 37:
                    goto st368;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st369;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st369;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st369;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st369;
                }
                else
                    goto st369;

                goto st0;
tr672:

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
                    goto st368;

                case 5:
                    goto st368;

                case 8:
                    goto st368;

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
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr690;

                goto st0;
st371:

                if ( ++p == pe )
                    goto _test_eof371;

            case 371:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr691;

                goto st0;
st372:

                if ( ++p == pe )
                    goto _test_eof372;

            case 372:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr692;

                goto st0;
st373:

                if ( ++p == pe )
                    goto _test_eof373;

            case 373:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr693;

                goto st0;
st374:

                if ( ++p == pe )
                    goto _test_eof374;

            case 374:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr694;

                goto st0;
st375:

                if ( ++p == pe )
                    goto _test_eof375;

            case 375:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr695;

                goto st0;
st376:

                if ( ++p == pe )
                    goto _test_eof376;

            case 376:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr696;

                goto st0;
st377:

                if ( ++p == pe )
                    goto _test_eof377;

            case 377:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr697;

                goto st0;
st378:

                if ( ++p == pe )
                    goto _test_eof378;

            case 378:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr698;

                goto st0;
st379:

                if ( ++p == pe )
                    goto _test_eof379;

            case 379:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr699;

                goto st0;
st380:

                if ( ++p == pe )
                    goto _test_eof380;

            case 380:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr700;

                case 22:
                    goto st381;
                }

                goto st0;
st381:

                if ( ++p == pe )
                    goto _test_eof381;

            case 381:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr671;

                case 5:
                    goto tr671;

                case 8:
                    goto tr671;

                case 18:
                    goto tr672;

                case 21:
                    goto tr672;

                case 23:
                    goto tr672;

                case 36:
                    goto tr672;

                case 44:
                    goto tr672;

                case 48:
                    goto st370;

                case 53:
                    goto st371;

                case 54:
                    goto st372;

                case 55:
                    goto st373;

                case 56:
                    goto st374;

                case 57:
                    goto st375;

                case 58:
                    goto st376;

                case 59:
                    goto st377;

                case 60:
                    goto st378;

                case 61:
                    goto st379;

                case 62:
                    goto st382;

                case 79:
                    goto st383;

                case 80:
                    goto st384;

                case 81:
                    goto st394;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr672;

                goto st0;
st382:

                if ( ++p == pe )
                    goto _test_eof382;

            case 382:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr700;

                goto st0;
st383:

                if ( ++p == pe )
                    goto _test_eof383;

            case 383:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr703;

                goto st0;
st384:

                if ( ++p == pe )
                    goto _test_eof384;

            case 384:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st385;

                case 21:
                    goto st386;

                case 23:
                    goto st390;
                }

                goto st0;
st385:

                if ( ++p == pe )
                    goto _test_eof385;

            case 385:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr707;

                goto st0;
st386:

                if ( ++p == pe )
                    goto _test_eof386;

            case 386:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr708;

                case 5:
                    goto tr708;

                case 8:
                    goto tr708;

                case 18:
                    goto tr709;

                case 21:
                    goto tr709;

                case 23:
                    goto tr709;

                case 36:
                    goto tr709;

                case 44:
                    goto tr709;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr709;

                goto st0;
tr708:

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
                case 19:
                    goto tr710;

                case 23:
                    goto st24;

                case 37:
                    goto st387;
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
tr710:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st388;
st388:

                if ( ++p == pe )
                    goto _test_eof388;

            case 388:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr712;

                case 19:
                    goto tr710;

                case 23:
                    goto st24;

                case 37:
                    goto st387;
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
tr709:

                {
                    expr_start = p;
                }
                goto st389;
st389:

                if ( ++p == pe )
                    goto _test_eof389;

            case 389:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st387;

                case 5:
                    goto st387;

                case 8:
                    goto st387;

                case 13:
                    goto st389;

                case 18:
                    goto st389;

                case 21:
                    goto st389;

                case 23:
                    goto st389;

                case 36:
                    goto st389;

                case 44:
                    goto st389;
                }

                goto st0;
st390:

                if ( ++p == pe )
                    goto _test_eof390;

            case 390:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr714;

                case 5:
                    goto tr714;

                case 8:
                    goto tr714;

                case 18:
                    goto tr715;

                case 21:
                    goto tr715;

                case 23:
                    goto tr715;

                case 36:
                    goto tr715;

                case 44:
                    goto tr715;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr715;

                goto st0;
tr714:

                {
                    expr_start = p;
                }
                goto st391;
st391:

                if ( ++p == pe )
                    goto _test_eof391;

            case 391:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr716;

                case 23:
                    goto st24;

                case 37:
                    goto st391;
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
tr716:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st392;
st392:

                if ( ++p == pe )
                    goto _test_eof392;

            case 392:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr718;

                case 19:
                    goto tr716;

                case 23:
                    goto st24;

                case 37:
                    goto st391;
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
tr715:

                {
                    expr_start = p;
                }
                goto st393;
st393:

                if ( ++p == pe )
                    goto _test_eof393;

            case 393:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st391;

                case 5:
                    goto st391;

                case 8:
                    goto st391;

                case 13:
                    goto st393;

                case 18:
                    goto st393;

                case 21:
                    goto st393;

                case 23:
                    goto st393;

                case 36:
                    goto st393;

                case 44:
                    goto st393;
                }

                goto st0;
st394:

                if ( ++p == pe )
                    goto _test_eof394;

            case 394:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st395;

                case 21:
                    goto st396;

                case 23:
                    goto st400;
                }

                goto st0;
st395:

                if ( ++p == pe )
                    goto _test_eof395;

            case 395:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr723;

                goto st0;
st396:

                if ( ++p == pe )
                    goto _test_eof396;

            case 396:
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
                goto st397;
st397:

                if ( ++p == pe )
                    goto _test_eof397;

            case 397:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr726;

                case 23:
                    goto st24;

                case 37:
                    goto st397;
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
tr726:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st398;
st398:

                if ( ++p == pe )
                    goto _test_eof398;

            case 398:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr728;

                case 19:
                    goto tr726;

                case 23:
                    goto st24;

                case 37:
                    goto st397;
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
tr725:

                {
                    expr_start = p;
                }
                goto st399;
st399:

                if ( ++p == pe )
                    goto _test_eof399;

            case 399:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st397;

                case 5:
                    goto st397;

                case 8:
                    goto st397;

                case 13:
                    goto st399;

                case 18:
                    goto st399;

                case 21:
                    goto st399;

                case 23:
                    goto st399;

                case 36:
                    goto st399;

                case 44:
                    goto st399;
                }

                goto st0;
st400:

                if ( ++p == pe )
                    goto _test_eof400;

            case 400:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr730;

                case 5:
                    goto tr730;

                case 8:
                    goto tr730;

                case 18:
                    goto tr731;

                case 21:
                    goto tr731;

                case 23:
                    goto tr731;

                case 36:
                    goto tr731;

                case 44:
                    goto tr731;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr731;

                goto st0;
tr730:

                {
                    expr_start = p;
                }
                goto st401;
st401:

                if ( ++p == pe )
                    goto _test_eof401;

            case 401:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr732;

                case 23:
                    goto st24;

                case 37:
                    goto st401;
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
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st402;
st402:

                if ( ++p == pe )
                    goto _test_eof402;

            case 402:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr734;

                case 19:
                    goto tr732;

                case 23:
                    goto st24;

                case 37:
                    goto st401;
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
tr731:

                {
                    expr_start = p;
                }
                goto st403;
st403:

                if ( ++p == pe )
                    goto _test_eof403;

            case 403:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st401;

                case 5:
                    goto st401;

                case 8:
                    goto st401;

                case 13:
                    goto st403;

                case 18:
                    goto st403;

                case 21:
                    goto st403;

                case 23:
                    goto st403;

                case 36:
                    goto st403;

                case 44:
                    goto st403;
                }

                goto st0;
st404:

                if ( ++p == pe )
                    goto _test_eof404;

            case 404:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr736;

                goto st0;
st405:

                if ( ++p == pe )
                    goto _test_eof405;

            case 405:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr737;

                goto st0;
st406:

                if ( ++p == pe )
                    goto _test_eof406;

            case 406:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr738;

                case 5:
                    goto tr738;

                case 8:
                    goto tr738;

                case 18:
                    goto tr739;

                case 21:
                    goto tr739;

                case 23:
                    goto tr739;

                case 36:
                    goto tr739;

                case 44:
                    goto tr739;

                case 68:
                    goto st411;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr739;

                goto st0;
tr738:

                {
                    expr_start = p;
                }
                goto st407;
st407:

                if ( ++p == pe )
                    goto _test_eof407;

            case 407:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st407;

                case 22:
                    goto tr743;

                case 37:
                    goto st407;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 23 )
                            goto st408;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st408;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st408;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st408;
                }
                else
                    goto st408;

                goto st0;
tr739:

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
                    goto st407;

                case 5:
                    goto st407;

                case 8:
                    goto st407;

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
tr743:

                {
                    if ( expr_start->tok != TK_LPAREN )
                        return FALSE;

                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st409;
st409:

                if ( ++p == pe )
                    goto _test_eof409;

            case 409:

                if ( ( ( ( int ) p->tok ) ) == 62 )
                    goto st410;

                goto st0;
st410:

                if ( ++p == pe )
                    goto _test_eof410;

            case 410:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr745;

                goto st0;
st411:

                if ( ++p == pe )
                    goto _test_eof411;

            case 411:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st412;

                goto st0;
st412:

                if ( ++p == pe )
                    goto _test_eof412;

            case 412:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st413;

                case 53:
                    goto st414;

                case 54:
                    goto st415;

                case 55:
                    goto st416;

                case 56:
                    goto st417;

                case 59:
                    goto st418;

                case 62:
                    goto st419;
                }

                goto st0;
st413:

                if ( ++p == pe )
                    goto _test_eof413;

            case 413:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr754;

                goto st0;
st414:

                if ( ++p == pe )
                    goto _test_eof414;

            case 414:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr755;

                goto st0;
st415:

                if ( ++p == pe )
                    goto _test_eof415;

            case 415:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr756;

                goto st0;
st416:

                if ( ++p == pe )
                    goto _test_eof416;

            case 416:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr757;

                goto st0;
st417:

                if ( ++p == pe )
                    goto _test_eof417;

            case 417:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr758;

                goto st0;
st418:

                if ( ++p == pe )
                    goto _test_eof418;

            case 418:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr759;

                goto st0;
st419:

                if ( ++p == pe )
                    goto _test_eof419;

            case 419:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr760;

                goto st0;
st420:

                if ( ++p == pe )
                    goto _test_eof420;

            case 420:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr761;

                goto st0;
st421:

                if ( ++p == pe )
                    goto _test_eof421;

            case 421:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr762;

                goto st0;
st422:

                if ( ++p == pe )
                    goto _test_eof422;

            case 422:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st423;

                case 70:
                    goto st424;

                case 71:
                    goto st425;

                case 72:
                    goto st426;

                case 73:
                    goto st427;

                case 74:
                    goto st428;
                }

                goto st0;
st423:

                if ( ++p == pe )
                    goto _test_eof423;

            case 423:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr769;

                goto st0;
st424:

                if ( ++p == pe )
                    goto _test_eof424;

            case 424:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr770;

                goto st0;
st425:

                if ( ++p == pe )
                    goto _test_eof425;

            case 425:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr771;

                goto st0;
st426:

                if ( ++p == pe )
                    goto _test_eof426;

            case 426:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr772;

                goto st0;
st427:

                if ( ++p == pe )
                    goto _test_eof427;

            case 427:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr773;

                goto st0;
st428:

                if ( ++p == pe )
                    goto _test_eof428;

            case 428:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr774;

                goto st0;
st429:

                if ( ++p == pe )
                    goto _test_eof429;

            case 429:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st430;

                case 70:
                    goto st431;

                case 71:
                    goto st432;

                case 72:
                    goto st433;

                case 73:
                    goto st434;

                case 74:
                    goto st435;
                }

                goto st0;
st430:

                if ( ++p == pe )
                    goto _test_eof430;

            case 430:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr781;

                goto st0;
st431:

                if ( ++p == pe )
                    goto _test_eof431;

            case 431:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr782;

                goto st0;
st432:

                if ( ++p == pe )
                    goto _test_eof432;

            case 432:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr783;

                goto st0;
st433:

                if ( ++p == pe )
                    goto _test_eof433;

            case 433:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr784;

                goto st0;
st434:

                if ( ++p == pe )
                    goto _test_eof434;

            case 434:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr785;

                goto st0;
st435:

                if ( ++p == pe )
                    goto _test_eof435;

            case 435:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr786;

                goto st0;
st436:

                if ( ++p == pe )
                    goto _test_eof436;

            case 436:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr787;

                case 5:
                    goto tr787;

                case 8:
                    goto tr787;

                case 18:
                    goto tr788;

                case 21:
                    goto tr788;

                case 23:
                    goto tr788;

                case 36:
                    goto tr788;

                case 44:
                    goto tr788;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr788;

                goto st0;
tr787:

                {
                    expr_start = p;
                }
                goto st437;
st437:

                if ( ++p == pe )
                    goto _test_eof437;

            case 437:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st437;

                case 22:
                    goto tr791;

                case 37:
                    goto st437;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 23 )
                            goto st438;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st438;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st438;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st438;
                }
                else
                    goto st438;

                goto st0;
tr788:

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
                    goto st437;

                case 5:
                    goto st437;

                case 8:
                    goto st437;

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
tr791:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    pop_eval_expr( &expr_value, &expr_error );
                }
                goto st439;
st439:

                if ( ++p == pe )
                    goto _test_eof439;

            case 439:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st440;

                case 53:
                    goto st441;

                case 54:
                    goto st442;

                case 55:
                    goto st443;

                case 56:
                    goto st444;

                case 59:
                    goto st445;

                case 62:
                    goto st446;

                case 79:
                    goto st447;

                case 80:
                    goto st448;

                case 81:
                    goto st458;
                }

                goto st0;
st440:

                if ( ++p == pe )
                    goto _test_eof440;

            case 440:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr802;

                goto st0;
st441:

                if ( ++p == pe )
                    goto _test_eof441;

            case 441:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr803;

                goto st0;
st442:

                if ( ++p == pe )
                    goto _test_eof442;

            case 442:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr804;

                goto st0;
st443:

                if ( ++p == pe )
                    goto _test_eof443;

            case 443:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr805;

                goto st0;
st444:

                if ( ++p == pe )
                    goto _test_eof444;

            case 444:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr806;

                goto st0;
st445:

                if ( ++p == pe )
                    goto _test_eof445;

            case 445:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr807;

                goto st0;
st446:

                if ( ++p == pe )
                    goto _test_eof446;

            case 446:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr808;

                goto st0;
st447:

                if ( ++p == pe )
                    goto _test_eof447;

            case 447:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr809;

                goto st0;
st448:

                if ( ++p == pe )
                    goto _test_eof448;

            case 448:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st449;

                case 21:
                    goto st450;

                case 23:
                    goto st454;
                }

                goto st0;
st449:

                if ( ++p == pe )
                    goto _test_eof449;

            case 449:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr813;

                goto st0;
st450:

                if ( ++p == pe )
                    goto _test_eof450;

            case 450:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr814;

                case 5:
                    goto tr814;

                case 8:
                    goto tr814;

                case 18:
                    goto tr815;

                case 21:
                    goto tr815;

                case 23:
                    goto tr815;

                case 36:
                    goto tr815;

                case 44:
                    goto tr815;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr815;

                goto st0;
tr814:

                {
                    expr_start = p;
                }
                goto st451;
st451:

                if ( ++p == pe )
                    goto _test_eof451;

            case 451:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr816;

                case 23:
                    goto st24;

                case 37:
                    goto st451;
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
tr816:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st452;
st452:

                if ( ++p == pe )
                    goto _test_eof452;

            case 452:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr818;

                case 19:
                    goto tr816;

                case 23:
                    goto st24;

                case 37:
                    goto st451;
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
tr815:

                {
                    expr_start = p;
                }
                goto st453;
st453:

                if ( ++p == pe )
                    goto _test_eof453;

            case 453:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st451;

                case 5:
                    goto st451;

                case 8:
                    goto st451;

                case 13:
                    goto st453;

                case 18:
                    goto st453;

                case 21:
                    goto st453;

                case 23:
                    goto st453;

                case 36:
                    goto st453;

                case 44:
                    goto st453;
                }

                goto st0;
st454:

                if ( ++p == pe )
                    goto _test_eof454;

            case 454:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr820;

                case 5:
                    goto tr820;

                case 8:
                    goto tr820;

                case 18:
                    goto tr821;

                case 21:
                    goto tr821;

                case 23:
                    goto tr821;

                case 36:
                    goto tr821;

                case 44:
                    goto tr821;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr821;

                goto st0;
tr820:

                {
                    expr_start = p;
                }
                goto st455;
st455:

                if ( ++p == pe )
                    goto _test_eof455;

            case 455:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr822;

                case 23:
                    goto st24;

                case 37:
                    goto st455;
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
tr822:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st456;
st456:

                if ( ++p == pe )
                    goto _test_eof456;

            case 456:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr824;

                case 19:
                    goto tr822;

                case 23:
                    goto st24;

                case 37:
                    goto st455;
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
tr821:

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
                case 3:
                    goto st455;

                case 5:
                    goto st455;

                case 8:
                    goto st455;

                case 13:
                    goto st457;

                case 18:
                    goto st457;

                case 21:
                    goto st457;

                case 23:
                    goto st457;

                case 36:
                    goto st457;

                case 44:
                    goto st457;
                }

                goto st0;
st458:

                if ( ++p == pe )
                    goto _test_eof458;

            case 458:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st459;

                case 21:
                    goto st460;

                case 23:
                    goto st464;
                }

                goto st0;
st459:

                if ( ++p == pe )
                    goto _test_eof459;

            case 459:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr829;

                goto st0;
st460:

                if ( ++p == pe )
                    goto _test_eof460;

            case 460:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr830;

                case 5:
                    goto tr830;

                case 8:
                    goto tr830;

                case 18:
                    goto tr831;

                case 21:
                    goto tr831;

                case 23:
                    goto tr831;

                case 36:
                    goto tr831;

                case 44:
                    goto tr831;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr831;

                goto st0;
tr830:

                {
                    expr_start = p;
                }
                goto st461;
st461:

                if ( ++p == pe )
                    goto _test_eof461;

            case 461:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr832;

                case 23:
                    goto st24;

                case 37:
                    goto st461;
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
tr832:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st462;
st462:

                if ( ++p == pe )
                    goto _test_eof462;

            case 462:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr834;

                case 19:
                    goto tr832;

                case 23:
                    goto st24;

                case 37:
                    goto st461;
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
tr831:

                {
                    expr_start = p;
                }
                goto st463;
st463:

                if ( ++p == pe )
                    goto _test_eof463;

            case 463:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st461;

                case 5:
                    goto st461;

                case 8:
                    goto st461;

                case 13:
                    goto st463;

                case 18:
                    goto st463;

                case 21:
                    goto st463;

                case 23:
                    goto st463;

                case 36:
                    goto st463;

                case 44:
                    goto st463;
                }

                goto st0;
st464:

                if ( ++p == pe )
                    goto _test_eof464;

            case 464:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr836;

                case 5:
                    goto tr836;

                case 8:
                    goto tr836;

                case 18:
                    goto tr837;

                case 21:
                    goto tr837;

                case 23:
                    goto tr837;

                case 36:
                    goto tr837;

                case 44:
                    goto tr837;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr837;

                goto st0;
tr836:

                {
                    expr_start = p;
                }
                goto st465;
st465:

                if ( ++p == pe )
                    goto _test_eof465;

            case 465:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr838;

                case 23:
                    goto st24;

                case 37:
                    goto st465;
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
tr838:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st466;
st466:

                if ( ++p == pe )
                    goto _test_eof466;

            case 466:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr840;

                case 19:
                    goto tr838;

                case 23:
                    goto st24;

                case 37:
                    goto st465;
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
tr837:

                {
                    expr_start = p;
                }
                goto st467;
st467:

                if ( ++p == pe )
                    goto _test_eof467;

            case 467:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st465;

                case 5:
                    goto st465;

                case 8:
                    goto st465;

                case 13:
                    goto st467;

                case 18:
                    goto st467;

                case 21:
                    goto st467;

                case 23:
                    goto st467;

                case 36:
                    goto st467;

                case 44:
                    goto st467;
                }

                goto st0;
st468:

                if ( ++p == pe )
                    goto _test_eof468;

            case 468:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr842;

                case 45:
                    goto st469;

                case 46:
                    goto st470;

                case 47:
                    goto st471;

                case 48:
                    goto st472;

                case 49:
                    goto st473;

                case 50:
                    goto st474;

                case 51:
                    goto st475;

                case 52:
                    goto st476;
                }

                goto st0;
st469:

                if ( ++p == pe )
                    goto _test_eof469;

            case 469:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr851;

                goto st0;
st470:

                if ( ++p == pe )
                    goto _test_eof470;

            case 470:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr852;

                goto st0;
st471:

                if ( ++p == pe )
                    goto _test_eof471;

            case 471:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr853;

                goto st0;
st472:

                if ( ++p == pe )
                    goto _test_eof472;

            case 472:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr854;

                goto st0;
st473:

                if ( ++p == pe )
                    goto _test_eof473;

            case 473:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr855;

                goto st0;
st474:

                if ( ++p == pe )
                    goto _test_eof474;

            case 474:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr856;

                goto st0;
st475:

                if ( ++p == pe )
                    goto _test_eof475;

            case 475:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr857;

                goto st0;
st476:

                if ( ++p == pe )
                    goto _test_eof476;

            case 476:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr858;

                goto st0;
st477:

                if ( ++p == pe )
                    goto _test_eof477;

            case 477:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr859;

                goto st0;
st478:

                if ( ++p == pe )
                    goto _test_eof478;

            case 478:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr860;

                goto st0;
st479:

                if ( ++p == pe )
                    goto _test_eof479;

            case 479:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st480;

                case 53:
                    goto st481;

                case 54:
                    goto st482;

                case 55:
                    goto st483;

                case 56:
                    goto st484;

                case 59:
                    goto st485;

                case 62:
                    goto st486;

                case 79:
                    goto st487;

                case 80:
                    goto st488;

                case 81:
                    goto st498;
                }

                goto st0;
st480:

                if ( ++p == pe )
                    goto _test_eof480;

            case 480:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr871;

                goto st0;
st481:

                if ( ++p == pe )
                    goto _test_eof481;

            case 481:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr872;

                goto st0;
st482:

                if ( ++p == pe )
                    goto _test_eof482;

            case 482:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr873;

                goto st0;
st483:

                if ( ++p == pe )
                    goto _test_eof483;

            case 483:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr874;

                goto st0;
st484:

                if ( ++p == pe )
                    goto _test_eof484;

            case 484:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr875;

                goto st0;
st485:

                if ( ++p == pe )
                    goto _test_eof485;

            case 485:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr876;

                goto st0;
st486:

                if ( ++p == pe )
                    goto _test_eof486;

            case 486:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr877;

                goto st0;
st487:

                if ( ++p == pe )
                    goto _test_eof487;

            case 487:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr878;

                goto st0;
st488:

                if ( ++p == pe )
                    goto _test_eof488;

            case 488:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st489;

                case 21:
                    goto st490;

                case 23:
                    goto st494;
                }

                goto st0;
st489:

                if ( ++p == pe )
                    goto _test_eof489;

            case 489:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr882;

                goto st0;
st490:

                if ( ++p == pe )
                    goto _test_eof490;

            case 490:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr883;

                case 5:
                    goto tr883;

                case 8:
                    goto tr883;

                case 18:
                    goto tr884;

                case 21:
                    goto tr884;

                case 23:
                    goto tr884;

                case 36:
                    goto tr884;

                case 44:
                    goto tr884;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr884;

                goto st0;
tr883:

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
                    goto tr885;

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
tr885:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st492;
st492:

                if ( ++p == pe )
                    goto _test_eof492;

            case 492:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr887;

                case 19:
                    goto tr885;

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
tr884:

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
                case 3:
                    goto tr889;

                case 5:
                    goto tr889;

                case 8:
                    goto tr889;

                case 18:
                    goto tr890;

                case 21:
                    goto tr890;

                case 23:
                    goto tr890;

                case 36:
                    goto tr890;

                case 44:
                    goto tr890;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr890;

                goto st0;
tr889:

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
                case 19:
                    goto tr891;

                case 23:
                    goto st24;

                case 37:
                    goto st495;
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
tr891:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st496;
st496:

                if ( ++p == pe )
                    goto _test_eof496;

            case 496:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr893;

                case 19:
                    goto tr891;

                case 23:
                    goto st24;

                case 37:
                    goto st495;
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
tr890:

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
                case 3:
                    goto st495;

                case 5:
                    goto st495;

                case 8:
                    goto st495;

                case 13:
                    goto st497;

                case 18:
                    goto st497;

                case 21:
                    goto st497;

                case 23:
                    goto st497;

                case 36:
                    goto st497;

                case 44:
                    goto st497;
                }

                goto st0;
st498:

                if ( ++p == pe )
                    goto _test_eof498;

            case 498:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st499;

                case 21:
                    goto st500;

                case 23:
                    goto st504;
                }

                goto st0;
st499:

                if ( ++p == pe )
                    goto _test_eof499;

            case 499:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr898;

                goto st0;
st500:

                if ( ++p == pe )
                    goto _test_eof500;

            case 500:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr899;

                case 5:
                    goto tr899;

                case 8:
                    goto tr899;

                case 18:
                    goto tr900;

                case 21:
                    goto tr900;

                case 23:
                    goto tr900;

                case 36:
                    goto tr900;

                case 44:
                    goto tr900;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr900;

                goto st0;
tr899:

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
                    goto tr901;

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
tr901:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st502;
st502:

                if ( ++p == pe )
                    goto _test_eof502;

            case 502:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr903;

                case 19:
                    goto tr901;

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
tr900:

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
st504:

                if ( ++p == pe )
                    goto _test_eof504;

            case 504:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr905;

                case 5:
                    goto tr905;

                case 8:
                    goto tr905;

                case 18:
                    goto tr906;

                case 21:
                    goto tr906;

                case 23:
                    goto tr906;

                case 36:
                    goto tr906;

                case 44:
                    goto tr906;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr906;

                goto st0;
tr905:

                {
                    expr_start = p;
                }
                goto st505;
st505:

                if ( ++p == pe )
                    goto _test_eof505;

            case 505:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr907;

                case 23:
                    goto st24;

                case 37:
                    goto st505;
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
tr907:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st506;
st506:

                if ( ++p == pe )
                    goto _test_eof506;

            case 506:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr909;

                case 19:
                    goto tr907;

                case 23:
                    goto st24;

                case 37:
                    goto st505;
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
tr906:

                {
                    expr_start = p;
                }
                goto st507;
st507:

                if ( ++p == pe )
                    goto _test_eof507;

            case 507:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st505;

                case 5:
                    goto st505;

                case 8:
                    goto st505;

                case 13:
                    goto st507;

                case 18:
                    goto st507;

                case 21:
                    goto st507;

                case 23:
                    goto st507;

                case 36:
                    goto st507;

                case 44:
                    goto st507;
                }

                goto st0;
st508:

                if ( ++p == pe )
                    goto _test_eof508;

            case 508:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr911;

                goto st0;
st509:

                if ( ++p == pe )
                    goto _test_eof509;

            case 509:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st510;

                case 53:
                    goto st511;

                case 54:
                    goto st512;

                case 55:
                    goto st513;

                case 56:
                    goto st514;

                case 59:
                    goto st515;

                case 62:
                    goto st516;

                case 79:
                    goto st517;

                case 80:
                    goto st518;

                case 81:
                    goto st528;
                }

                goto st0;
st510:

                if ( ++p == pe )
                    goto _test_eof510;

            case 510:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr922;

                goto st0;
st511:

                if ( ++p == pe )
                    goto _test_eof511;

            case 511:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr923;

                goto st0;
st512:

                if ( ++p == pe )
                    goto _test_eof512;

            case 512:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr924;

                goto st0;
st513:

                if ( ++p == pe )
                    goto _test_eof513;

            case 513:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr925;

                goto st0;
st514:

                if ( ++p == pe )
                    goto _test_eof514;

            case 514:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr926;

                goto st0;
st515:

                if ( ++p == pe )
                    goto _test_eof515;

            case 515:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr927;

                goto st0;
st516:

                if ( ++p == pe )
                    goto _test_eof516;

            case 516:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr928;

                goto st0;
st517:

                if ( ++p == pe )
                    goto _test_eof517;

            case 517:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr929;

                goto st0;
st518:

                if ( ++p == pe )
                    goto _test_eof518;

            case 518:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st519;

                case 21:
                    goto st520;

                case 23:
                    goto st524;
                }

                goto st0;
st519:

                if ( ++p == pe )
                    goto _test_eof519;

            case 519:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr933;

                goto st0;
st520:

                if ( ++p == pe )
                    goto _test_eof520;

            case 520:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr934;

                case 5:
                    goto tr934;

                case 8:
                    goto tr934;

                case 18:
                    goto tr935;

                case 21:
                    goto tr935;

                case 23:
                    goto tr935;

                case 36:
                    goto tr935;

                case 44:
                    goto tr935;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr935;

                goto st0;
tr934:

                {
                    expr_start = p;
                }
                goto st521;
st521:

                if ( ++p == pe )
                    goto _test_eof521;

            case 521:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr936;

                case 23:
                    goto st24;

                case 37:
                    goto st521;
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
tr936:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st522;
st522:

                if ( ++p == pe )
                    goto _test_eof522;

            case 522:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr938;

                case 19:
                    goto tr936;

                case 23:
                    goto st24;

                case 37:
                    goto st521;
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
tr935:

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
                case 3:
                    goto st521;

                case 5:
                    goto st521;

                case 8:
                    goto st521;

                case 13:
                    goto st523;

                case 18:
                    goto st523;

                case 21:
                    goto st523;

                case 23:
                    goto st523;

                case 36:
                    goto st523;

                case 44:
                    goto st523;
                }

                goto st0;
st524:

                if ( ++p == pe )
                    goto _test_eof524;

            case 524:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr940;

                case 5:
                    goto tr940;

                case 8:
                    goto tr940;

                case 18:
                    goto tr941;

                case 21:
                    goto tr941;

                case 23:
                    goto tr941;

                case 36:
                    goto tr941;

                case 44:
                    goto tr941;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr941;

                goto st0;
tr940:

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
                case 19:
                    goto tr942;

                case 23:
                    goto st24;

                case 37:
                    goto st525;
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
tr942:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st526;
st526:

                if ( ++p == pe )
                    goto _test_eof526;

            case 526:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr944;

                case 19:
                    goto tr942;

                case 23:
                    goto st24;

                case 37:
                    goto st525;
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
tr941:

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
                case 3:
                    goto st525;

                case 5:
                    goto st525;

                case 8:
                    goto st525;

                case 13:
                    goto st527;

                case 18:
                    goto st527;

                case 21:
                    goto st527;

                case 23:
                    goto st527;

                case 36:
                    goto st527;

                case 44:
                    goto st527;
                }

                goto st0;
st528:

                if ( ++p == pe )
                    goto _test_eof528;

            case 528:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st529;

                case 21:
                    goto st530;

                case 23:
                    goto st534;
                }

                goto st0;
st529:

                if ( ++p == pe )
                    goto _test_eof529;

            case 529:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr949;

                goto st0;
st530:

                if ( ++p == pe )
                    goto _test_eof530;

            case 530:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr950;

                case 5:
                    goto tr950;

                case 8:
                    goto tr950;

                case 18:
                    goto tr951;

                case 21:
                    goto tr951;

                case 23:
                    goto tr951;

                case 36:
                    goto tr951;

                case 44:
                    goto tr951;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr951;

                goto st0;
tr950:

                {
                    expr_start = p;
                }
                goto st531;
st531:

                if ( ++p == pe )
                    goto _test_eof531;

            case 531:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr952;

                case 23:
                    goto st24;

                case 37:
                    goto st531;
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
tr952:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st532;
st532:

                if ( ++p == pe )
                    goto _test_eof532;

            case 532:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr954;

                case 19:
                    goto tr952;

                case 23:
                    goto st24;

                case 37:
                    goto st531;
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
tr951:

                {
                    expr_start = p;
                }
                goto st533;
st533:

                if ( ++p == pe )
                    goto _test_eof533;

            case 533:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st531;

                case 5:
                    goto st531;

                case 8:
                    goto st531;

                case 13:
                    goto st533;

                case 18:
                    goto st533;

                case 21:
                    goto st533;

                case 23:
                    goto st533;

                case 36:
                    goto st533;

                case 44:
                    goto st533;
                }

                goto st0;
st534:

                if ( ++p == pe )
                    goto _test_eof534;

            case 534:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr956;

                case 5:
                    goto tr956;

                case 8:
                    goto tr956;

                case 18:
                    goto tr957;

                case 21:
                    goto tr957;

                case 23:
                    goto tr957;

                case 36:
                    goto tr957;

                case 44:
                    goto tr957;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr957;

                goto st0;
tr956:

                {
                    expr_start = p;
                }
                goto st535;
st535:

                if ( ++p == pe )
                    goto _test_eof535;

            case 535:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr958;

                case 23:
                    goto st24;

                case 37:
                    goto st535;
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
tr958:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st536;
st536:

                if ( ++p == pe )
                    goto _test_eof536;

            case 536:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr960;

                case 19:
                    goto tr958;

                case 23:
                    goto st24;

                case 37:
                    goto st535;
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
tr957:

                {
                    expr_start = p;
                }
                goto st537;
st537:

                if ( ++p == pe )
                    goto _test_eof537;

            case 537:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st535;

                case 5:
                    goto st535;

                case 8:
                    goto st535;

                case 13:
                    goto st537;

                case 18:
                    goto st537;

                case 21:
                    goto st537;

                case 23:
                    goto st537;

                case 36:
                    goto st537;

                case 44:
                    goto st537;
                }

                goto st0;
st538:

                if ( ++p == pe )
                    goto _test_eof538;

            case 538:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr962;

                goto st0;
st539:

                if ( ++p == pe )
                    goto _test_eof539;

            case 539:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr963;

                goto st0;
st540:

                if ( ++p == pe )
                    goto _test_eof540;

            case 540:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st541;

                case 53:
                    goto st542;

                case 54:
                    goto st543;

                case 55:
                    goto st544;

                case 56:
                    goto st545;

                case 59:
                    goto st546;

                case 62:
                    goto st547;

                case 79:
                    goto st548;

                case 80:
                    goto st549;

                case 81:
                    goto st559;
                }

                goto st0;
st541:

                if ( ++p == pe )
                    goto _test_eof541;

            case 541:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr974;

                goto st0;
st542:

                if ( ++p == pe )
                    goto _test_eof542;

            case 542:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr975;

                goto st0;
st543:

                if ( ++p == pe )
                    goto _test_eof543;

            case 543:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr976;

                goto st0;
st544:

                if ( ++p == pe )
                    goto _test_eof544;

            case 544:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr977;

                goto st0;
st545:

                if ( ++p == pe )
                    goto _test_eof545;

            case 545:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr978;

                goto st0;
st546:

                if ( ++p == pe )
                    goto _test_eof546;

            case 546:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr979;

                goto st0;
st547:

                if ( ++p == pe )
                    goto _test_eof547;

            case 547:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr980;

                goto st0;
st548:

                if ( ++p == pe )
                    goto _test_eof548;

            case 548:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr981;

                goto st0;
st549:

                if ( ++p == pe )
                    goto _test_eof549;

            case 549:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st550;

                case 21:
                    goto st551;

                case 23:
                    goto st555;
                }

                goto st0;
st550:

                if ( ++p == pe )
                    goto _test_eof550;

            case 550:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr985;

                goto st0;
st551:

                if ( ++p == pe )
                    goto _test_eof551;

            case 551:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr986;

                case 5:
                    goto tr986;

                case 8:
                    goto tr986;

                case 18:
                    goto tr987;

                case 21:
                    goto tr987;

                case 23:
                    goto tr987;

                case 36:
                    goto tr987;

                case 44:
                    goto tr987;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr987;

                goto st0;
tr986:

                {
                    expr_start = p;
                }
                goto st552;
st552:

                if ( ++p == pe )
                    goto _test_eof552;

            case 552:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr988;

                case 23:
                    goto st24;

                case 37:
                    goto st552;
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
tr988:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st553;
st553:

                if ( ++p == pe )
                    goto _test_eof553;

            case 553:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr990;

                case 19:
                    goto tr988;

                case 23:
                    goto st24;

                case 37:
                    goto st552;
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
tr987:

                {
                    expr_start = p;
                }
                goto st554;
st554:

                if ( ++p == pe )
                    goto _test_eof554;

            case 554:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st552;

                case 5:
                    goto st552;

                case 8:
                    goto st552;

                case 13:
                    goto st554;

                case 18:
                    goto st554;

                case 21:
                    goto st554;

                case 23:
                    goto st554;

                case 36:
                    goto st554;

                case 44:
                    goto st554;
                }

                goto st0;
st555:

                if ( ++p == pe )
                    goto _test_eof555;

            case 555:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr992;

                case 5:
                    goto tr992;

                case 8:
                    goto tr992;

                case 18:
                    goto tr993;

                case 21:
                    goto tr993;

                case 23:
                    goto tr993;

                case 36:
                    goto tr993;

                case 44:
                    goto tr993;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr993;

                goto st0;
tr992:

                {
                    expr_start = p;
                }
                goto st556;
st556:

                if ( ++p == pe )
                    goto _test_eof556;

            case 556:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr994;

                case 23:
                    goto st24;

                case 37:
                    goto st556;
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
tr994:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st557;
st557:

                if ( ++p == pe )
                    goto _test_eof557;

            case 557:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr996;

                case 19:
                    goto tr994;

                case 23:
                    goto st24;

                case 37:
                    goto st556;
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
tr993:

                {
                    expr_start = p;
                }
                goto st558;
st558:

                if ( ++p == pe )
                    goto _test_eof558;

            case 558:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st556;

                case 5:
                    goto st556;

                case 8:
                    goto st556;

                case 13:
                    goto st558;

                case 18:
                    goto st558;

                case 21:
                    goto st558;

                case 23:
                    goto st558;

                case 36:
                    goto st558;

                case 44:
                    goto st558;
                }

                goto st0;
st559:

                if ( ++p == pe )
                    goto _test_eof559;

            case 559:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st560;

                case 21:
                    goto st561;

                case 23:
                    goto st565;
                }

                goto st0;
st560:

                if ( ++p == pe )
                    goto _test_eof560;

            case 560:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1001;

                goto st0;
st561:

                if ( ++p == pe )
                    goto _test_eof561;

            case 561:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1002;

                case 5:
                    goto tr1002;

                case 8:
                    goto tr1002;

                case 18:
                    goto tr1003;

                case 21:
                    goto tr1003;

                case 23:
                    goto tr1003;

                case 36:
                    goto tr1003;

                case 44:
                    goto tr1003;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1003;

                goto st0;
tr1002:

                {
                    expr_start = p;
                }
                goto st562;
st562:

                if ( ++p == pe )
                    goto _test_eof562;

            case 562:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1004;

                case 23:
                    goto st24;

                case 37:
                    goto st562;
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
tr1004:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st563;
st563:

                if ( ++p == pe )
                    goto _test_eof563;

            case 563:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1006;

                case 19:
                    goto tr1004;

                case 23:
                    goto st24;

                case 37:
                    goto st562;
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
tr1003:

                {
                    expr_start = p;
                }
                goto st564;
st564:

                if ( ++p == pe )
                    goto _test_eof564;

            case 564:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st562;

                case 5:
                    goto st562;

                case 8:
                    goto st562;

                case 13:
                    goto st564;

                case 18:
                    goto st564;

                case 21:
                    goto st564;

                case 23:
                    goto st564;

                case 36:
                    goto st564;

                case 44:
                    goto st564;
                }

                goto st0;
st565:

                if ( ++p == pe )
                    goto _test_eof565;

            case 565:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1008;

                case 5:
                    goto tr1008;

                case 8:
                    goto tr1008;

                case 18:
                    goto tr1009;

                case 21:
                    goto tr1009;

                case 23:
                    goto tr1009;

                case 36:
                    goto tr1009;

                case 44:
                    goto tr1009;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1009;

                goto st0;
tr1008:

                {
                    expr_start = p;
                }
                goto st566;
st566:

                if ( ++p == pe )
                    goto _test_eof566;

            case 566:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1010;

                case 23:
                    goto st24;

                case 37:
                    goto st566;
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
tr1010:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st567;
st567:

                if ( ++p == pe )
                    goto _test_eof567;

            case 567:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1012;

                case 19:
                    goto tr1010;

                case 23:
                    goto st24;

                case 37:
                    goto st566;
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
tr1009:

                {
                    expr_start = p;
                }
                goto st568;
st568:

                if ( ++p == pe )
                    goto _test_eof568;

            case 568:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st566;

                case 5:
                    goto st566;

                case 8:
                    goto st566;

                case 13:
                    goto st568;

                case 18:
                    goto st568;

                case 21:
                    goto st568;

                case 23:
                    goto st568;

                case 36:
                    goto st568;

                case 44:
                    goto st568;
                }

                goto st0;
st569:

                if ( ++p == pe )
                    goto _test_eof569;

            case 569:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1014;

                goto st0;
st570:

                if ( ++p == pe )
                    goto _test_eof570;

            case 570:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st571;

                case 53:
                    goto st572;

                case 54:
                    goto st573;

                case 55:
                    goto st574;

                case 56:
                    goto st575;

                case 59:
                    goto st576;

                case 62:
                    goto st577;

                case 79:
                    goto st578;

                case 80:
                    goto st579;

                case 81:
                    goto st589;
                }

                goto st0;
st571:

                if ( ++p == pe )
                    goto _test_eof571;

            case 571:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1025;

                goto st0;
st572:

                if ( ++p == pe )
                    goto _test_eof572;

            case 572:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1026;

                goto st0;
st573:

                if ( ++p == pe )
                    goto _test_eof573;

            case 573:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1027;

                goto st0;
st574:

                if ( ++p == pe )
                    goto _test_eof574;

            case 574:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1028;

                goto st0;
st575:

                if ( ++p == pe )
                    goto _test_eof575;

            case 575:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1029;

                goto st0;
st576:

                if ( ++p == pe )
                    goto _test_eof576;

            case 576:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1030;

                goto st0;
st577:

                if ( ++p == pe )
                    goto _test_eof577;

            case 577:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1031;

                goto st0;
st578:

                if ( ++p == pe )
                    goto _test_eof578;

            case 578:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1032;

                goto st0;
st579:

                if ( ++p == pe )
                    goto _test_eof579;

            case 579:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st580;

                case 21:
                    goto st581;

                case 23:
                    goto st585;
                }

                goto st0;
st580:

                if ( ++p == pe )
                    goto _test_eof580;

            case 580:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1036;

                goto st0;
st581:

                if ( ++p == pe )
                    goto _test_eof581;

            case 581:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1037;

                case 5:
                    goto tr1037;

                case 8:
                    goto tr1037;

                case 18:
                    goto tr1038;

                case 21:
                    goto tr1038;

                case 23:
                    goto tr1038;

                case 36:
                    goto tr1038;

                case 44:
                    goto tr1038;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1038;

                goto st0;
tr1037:

                {
                    expr_start = p;
                }
                goto st582;
st582:

                if ( ++p == pe )
                    goto _test_eof582;

            case 582:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1039;

                case 23:
                    goto st24;

                case 37:
                    goto st582;
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
tr1039:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st583;
st583:

                if ( ++p == pe )
                    goto _test_eof583;

            case 583:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1041;

                case 19:
                    goto tr1039;

                case 23:
                    goto st24;

                case 37:
                    goto st582;
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
tr1038:

                {
                    expr_start = p;
                }
                goto st584;
st584:

                if ( ++p == pe )
                    goto _test_eof584;

            case 584:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st582;

                case 5:
                    goto st582;

                case 8:
                    goto st582;

                case 13:
                    goto st584;

                case 18:
                    goto st584;

                case 21:
                    goto st584;

                case 23:
                    goto st584;

                case 36:
                    goto st584;

                case 44:
                    goto st584;
                }

                goto st0;
st585:

                if ( ++p == pe )
                    goto _test_eof585;

            case 585:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1043;

                case 5:
                    goto tr1043;

                case 8:
                    goto tr1043;

                case 18:
                    goto tr1044;

                case 21:
                    goto tr1044;

                case 23:
                    goto tr1044;

                case 36:
                    goto tr1044;

                case 44:
                    goto tr1044;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1044;

                goto st0;
tr1043:

                {
                    expr_start = p;
                }
                goto st586;
st586:

                if ( ++p == pe )
                    goto _test_eof586;

            case 586:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1045;

                case 23:
                    goto st24;

                case 37:
                    goto st586;
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
tr1045:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st587;
st587:

                if ( ++p == pe )
                    goto _test_eof587;

            case 587:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1047;

                case 19:
                    goto tr1045;

                case 23:
                    goto st24;

                case 37:
                    goto st586;
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
tr1044:

                {
                    expr_start = p;
                }
                goto st588;
st588:

                if ( ++p == pe )
                    goto _test_eof588;

            case 588:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st586;

                case 5:
                    goto st586;

                case 8:
                    goto st586;

                case 13:
                    goto st588;

                case 18:
                    goto st588;

                case 21:
                    goto st588;

                case 23:
                    goto st588;

                case 36:
                    goto st588;

                case 44:
                    goto st588;
                }

                goto st0;
st589:

                if ( ++p == pe )
                    goto _test_eof589;

            case 589:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st590;

                case 21:
                    goto st591;

                case 23:
                    goto st595;
                }

                goto st0;
st590:

                if ( ++p == pe )
                    goto _test_eof590;

            case 590:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1052;

                goto st0;
st591:

                if ( ++p == pe )
                    goto _test_eof591;

            case 591:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1053;

                case 5:
                    goto tr1053;

                case 8:
                    goto tr1053;

                case 18:
                    goto tr1054;

                case 21:
                    goto tr1054;

                case 23:
                    goto tr1054;

                case 36:
                    goto tr1054;

                case 44:
                    goto tr1054;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1054;

                goto st0;
tr1053:

                {
                    expr_start = p;
                }
                goto st592;
st592:

                if ( ++p == pe )
                    goto _test_eof592;

            case 592:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1055;

                case 23:
                    goto st24;

                case 37:
                    goto st592;
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
tr1055:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st593;
st593:

                if ( ++p == pe )
                    goto _test_eof593;

            case 593:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1057;

                case 19:
                    goto tr1055;

                case 23:
                    goto st24;

                case 37:
                    goto st592;
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
tr1054:

                {
                    expr_start = p;
                }
                goto st594;
st594:

                if ( ++p == pe )
                    goto _test_eof594;

            case 594:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st592;

                case 5:
                    goto st592;

                case 8:
                    goto st592;

                case 13:
                    goto st594;

                case 18:
                    goto st594;

                case 21:
                    goto st594;

                case 23:
                    goto st594;

                case 36:
                    goto st594;

                case 44:
                    goto st594;
                }

                goto st0;
st595:

                if ( ++p == pe )
                    goto _test_eof595;

            case 595:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1059;

                case 5:
                    goto tr1059;

                case 8:
                    goto tr1059;

                case 18:
                    goto tr1060;

                case 21:
                    goto tr1060;

                case 23:
                    goto tr1060;

                case 36:
                    goto tr1060;

                case 44:
                    goto tr1060;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1060;

                goto st0;
tr1059:

                {
                    expr_start = p;
                }
                goto st596;
st596:

                if ( ++p == pe )
                    goto _test_eof596;

            case 596:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1061;

                case 23:
                    goto st24;

                case 37:
                    goto st596;
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
tr1061:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st597;
st597:

                if ( ++p == pe )
                    goto _test_eof597;

            case 597:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1063;

                case 19:
                    goto tr1061;

                case 23:
                    goto st24;

                case 37:
                    goto st596;
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
tr1060:

                {
                    expr_start = p;
                }
                goto st598;
st598:

                if ( ++p == pe )
                    goto _test_eof598;

            case 598:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st596;

                case 5:
                    goto st596;

                case 8:
                    goto st596;

                case 13:
                    goto st598;

                case 18:
                    goto st598;

                case 21:
                    goto st598;

                case 23:
                    goto st598;

                case 36:
                    goto st598;

                case 44:
                    goto st598;
                }

                goto st0;
st599:

                if ( ++p == pe )
                    goto _test_eof599;

            case 599:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1065;

                goto st0;
st600:

                if ( ++p == pe )
                    goto _test_eof600;

            case 600:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1066;

                goto st0;
st601:

                if ( ++p == pe )
                    goto _test_eof601;

            case 601:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1067;

                case 5:
                    goto tr1067;

                case 8:
                    goto tr1067;

                case 18:
                    goto tr1068;

                case 21:
                    goto tr1068;

                case 23:
                    goto tr1068;

                case 36:
                    goto tr1068;

                case 44:
                    goto tr1068;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1068;

                goto st0;
tr1067:

                {
                    expr_start = p;
                }
                goto st602;
st602:

                if ( ++p == pe )
                    goto _test_eof602;

            case 602:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1069;

                case 19:
                    goto st602;

                case 23:
                    goto st603;

                case 37:
                    goto st602;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st603;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st603;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st603;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st603;
                }
                else
                    goto st603;

                goto st0;
tr1068:

                {
                    expr_start = p;
                }
                goto st603;
st603:

                if ( ++p == pe )
                    goto _test_eof603;

            case 603:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st602;

                case 5:
                    goto st602;

                case 8:
                    goto st602;

                case 13:
                    goto st603;

                case 18:
                    goto st603;

                case 21:
                    goto st603;

                case 23:
                    goto st603;

                case 36:
                    goto st603;

                case 44:
                    goto st603;
                }

                goto st0;
st604:

                if ( ++p == pe )
                    goto _test_eof604;

            case 604:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1072;

                case 5:
                    goto tr1072;

                case 8:
                    goto tr1072;

                case 18:
                    goto tr1073;

                case 21:
                    goto tr1073;

                case 23:
                    goto tr1073;

                case 36:
                    goto tr1073;

                case 44:
                    goto tr1073;

                case 48:
                    goto st607;

                case 53:
                    goto st608;

                case 54:
                    goto st609;

                case 55:
                    goto st610;

                case 56:
                    goto st611;

                case 57:
                    goto st612;

                case 58:
                    goto st613;

                case 59:
                    goto st614;

                case 60:
                    goto st615;

                case 61:
                    goto st616;

                case 62:
                    goto st617;

                case 71:
                    goto st641;

                case 79:
                    goto st620;

                case 80:
                    goto st621;

                case 81:
                    goto st631;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1073;

                goto st0;
tr1072:

                {
                    expr_start = p;
                }
                goto st605;
st605:

                if ( ++p == pe )
                    goto _test_eof605;

            case 605:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1089;

                case 19:
                    goto st605;

                case 23:
                    goto st606;

                case 37:
                    goto st605;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st606;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st606;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st606;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st606;
                }
                else
                    goto st606;

                goto st0;
tr1073:

                {
                    expr_start = p;
                }
                goto st606;
st606:

                if ( ++p == pe )
                    goto _test_eof606;

            case 606:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st605;

                case 5:
                    goto st605;

                case 8:
                    goto st605;

                case 13:
                    goto st606;

                case 18:
                    goto st606;

                case 21:
                    goto st606;

                case 23:
                    goto st606;

                case 36:
                    goto st606;

                case 44:
                    goto st606;
                }

                goto st0;
st607:

                if ( ++p == pe )
                    goto _test_eof607;

            case 607:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1092;

                goto st0;
st608:

                if ( ++p == pe )
                    goto _test_eof608;

            case 608:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1093;

                goto st0;
st609:

                if ( ++p == pe )
                    goto _test_eof609;

            case 609:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1094;

                goto st0;
st610:

                if ( ++p == pe )
                    goto _test_eof610;

            case 610:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1095;

                goto st0;
st611:

                if ( ++p == pe )
                    goto _test_eof611;

            case 611:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1096;

                goto st0;
st612:

                if ( ++p == pe )
                    goto _test_eof612;

            case 612:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1097;

                goto st0;
st613:

                if ( ++p == pe )
                    goto _test_eof613;

            case 613:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1098;

                goto st0;
st614:

                if ( ++p == pe )
                    goto _test_eof614;

            case 614:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1099;

                goto st0;
st615:

                if ( ++p == pe )
                    goto _test_eof615;

            case 615:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1100;

                goto st0;
st616:

                if ( ++p == pe )
                    goto _test_eof616;

            case 616:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1101;

                goto st0;
st617:

                if ( ++p == pe )
                    goto _test_eof617;

            case 617:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1102;

                case 22:
                    goto st618;
                }

                goto st0;
st618:

                if ( ++p == pe )
                    goto _test_eof618;

            case 618:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1072;

                case 5:
                    goto tr1072;

                case 8:
                    goto tr1072;

                case 18:
                    goto tr1073;

                case 21:
                    goto tr1073;

                case 23:
                    goto tr1073;

                case 36:
                    goto tr1073;

                case 44:
                    goto tr1073;

                case 48:
                    goto st607;

                case 53:
                    goto st608;

                case 54:
                    goto st609;

                case 55:
                    goto st610;

                case 56:
                    goto st611;

                case 57:
                    goto st612;

                case 58:
                    goto st613;

                case 59:
                    goto st614;

                case 60:
                    goto st615;

                case 61:
                    goto st616;

                case 62:
                    goto st619;

                case 79:
                    goto st620;

                case 80:
                    goto st621;

                case 81:
                    goto st631;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1073;

                goto st0;
st619:

                if ( ++p == pe )
                    goto _test_eof619;

            case 619:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1102;

                goto st0;
st620:

                if ( ++p == pe )
                    goto _test_eof620;

            case 620:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1105;

                goto st0;
st621:

                if ( ++p == pe )
                    goto _test_eof621;

            case 621:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st622;

                case 21:
                    goto st623;

                case 23:
                    goto st627;
                }

                goto st0;
st622:

                if ( ++p == pe )
                    goto _test_eof622;

            case 622:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1109;

                goto st0;
st623:

                if ( ++p == pe )
                    goto _test_eof623;

            case 623:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1110;

                case 5:
                    goto tr1110;

                case 8:
                    goto tr1110;

                case 18:
                    goto tr1111;

                case 21:
                    goto tr1111;

                case 23:
                    goto tr1111;

                case 36:
                    goto tr1111;

                case 44:
                    goto tr1111;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1111;

                goto st0;
tr1110:

                {
                    expr_start = p;
                }
                goto st624;
st624:

                if ( ++p == pe )
                    goto _test_eof624;

            case 624:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1112;

                case 23:
                    goto st24;

                case 37:
                    goto st624;
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
tr1112:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st625;
st625:

                if ( ++p == pe )
                    goto _test_eof625;

            case 625:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1114;

                case 19:
                    goto tr1112;

                case 23:
                    goto st24;

                case 37:
                    goto st624;
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
tr1111:

                {
                    expr_start = p;
                }
                goto st626;
st626:

                if ( ++p == pe )
                    goto _test_eof626;

            case 626:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st624;

                case 5:
                    goto st624;

                case 8:
                    goto st624;

                case 13:
                    goto st626;

                case 18:
                    goto st626;

                case 21:
                    goto st626;

                case 23:
                    goto st626;

                case 36:
                    goto st626;

                case 44:
                    goto st626;
                }

                goto st0;
st627:

                if ( ++p == pe )
                    goto _test_eof627;

            case 627:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1116;

                case 5:
                    goto tr1116;

                case 8:
                    goto tr1116;

                case 18:
                    goto tr1117;

                case 21:
                    goto tr1117;

                case 23:
                    goto tr1117;

                case 36:
                    goto tr1117;

                case 44:
                    goto tr1117;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1117;

                goto st0;
tr1116:

                {
                    expr_start = p;
                }
                goto st628;
st628:

                if ( ++p == pe )
                    goto _test_eof628;

            case 628:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1118;

                case 23:
                    goto st24;

                case 37:
                    goto st628;
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
tr1118:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st629;
st629:

                if ( ++p == pe )
                    goto _test_eof629;

            case 629:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1120;

                case 19:
                    goto tr1118;

                case 23:
                    goto st24;

                case 37:
                    goto st628;
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
tr1117:

                {
                    expr_start = p;
                }
                goto st630;
st630:

                if ( ++p == pe )
                    goto _test_eof630;

            case 630:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st628;

                case 5:
                    goto st628;

                case 8:
                    goto st628;

                case 13:
                    goto st630;

                case 18:
                    goto st630;

                case 21:
                    goto st630;

                case 23:
                    goto st630;

                case 36:
                    goto st630;

                case 44:
                    goto st630;
                }

                goto st0;
st631:

                if ( ++p == pe )
                    goto _test_eof631;

            case 631:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st632;

                case 21:
                    goto st633;

                case 23:
                    goto st637;
                }

                goto st0;
st632:

                if ( ++p == pe )
                    goto _test_eof632;

            case 632:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1125;

                goto st0;
st633:

                if ( ++p == pe )
                    goto _test_eof633;

            case 633:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1126;

                case 5:
                    goto tr1126;

                case 8:
                    goto tr1126;

                case 18:
                    goto tr1127;

                case 21:
                    goto tr1127;

                case 23:
                    goto tr1127;

                case 36:
                    goto tr1127;

                case 44:
                    goto tr1127;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1127;

                goto st0;
tr1126:

                {
                    expr_start = p;
                }
                goto st634;
st634:

                if ( ++p == pe )
                    goto _test_eof634;

            case 634:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1128;

                case 23:
                    goto st24;

                case 37:
                    goto st634;
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
tr1128:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st635;
st635:

                if ( ++p == pe )
                    goto _test_eof635;

            case 635:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1130;

                case 19:
                    goto tr1128;

                case 23:
                    goto st24;

                case 37:
                    goto st634;
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
tr1127:

                {
                    expr_start = p;
                }
                goto st636;
st636:

                if ( ++p == pe )
                    goto _test_eof636;

            case 636:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st634;

                case 5:
                    goto st634;

                case 8:
                    goto st634;

                case 13:
                    goto st636;

                case 18:
                    goto st636;

                case 21:
                    goto st636;

                case 23:
                    goto st636;

                case 36:
                    goto st636;

                case 44:
                    goto st636;
                }

                goto st0;
st637:

                if ( ++p == pe )
                    goto _test_eof637;

            case 637:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1132;

                case 5:
                    goto tr1132;

                case 8:
                    goto tr1132;

                case 18:
                    goto tr1133;

                case 21:
                    goto tr1133;

                case 23:
                    goto tr1133;

                case 36:
                    goto tr1133;

                case 44:
                    goto tr1133;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1133;

                goto st0;
tr1132:

                {
                    expr_start = p;
                }
                goto st638;
st638:

                if ( ++p == pe )
                    goto _test_eof638;

            case 638:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1134;

                case 23:
                    goto st24;

                case 37:
                    goto st638;
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
tr1134:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st639;
st639:

                if ( ++p == pe )
                    goto _test_eof639;

            case 639:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1136;

                case 19:
                    goto tr1134;

                case 23:
                    goto st24;

                case 37:
                    goto st638;
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
tr1133:

                {
                    expr_start = p;
                }
                goto st640;
st640:

                if ( ++p == pe )
                    goto _test_eof640;

            case 640:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st638;

                case 5:
                    goto st638;

                case 8:
                    goto st638;

                case 13:
                    goto st640;

                case 18:
                    goto st640;

                case 21:
                    goto st640;

                case 23:
                    goto st640;

                case 36:
                    goto st640;

                case 44:
                    goto st640;
                }

                goto st0;
st641:

                if ( ++p == pe )
                    goto _test_eof641;

            case 641:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st642;

                goto st0;
st642:

                if ( ++p == pe )
                    goto _test_eof642;

            case 642:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st643;

                case 70:
                    goto st644;

                case 71:
                    goto st645;

                case 75:
                    goto st646;
                }

                goto st0;
st643:

                if ( ++p == pe )
                    goto _test_eof643;

            case 643:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1143;

                goto st0;
st644:

                if ( ++p == pe )
                    goto _test_eof644;

            case 644:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1144;

                goto st0;
st645:

                if ( ++p == pe )
                    goto _test_eof645;

            case 645:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1145;

                goto st0;
st646:

                if ( ++p == pe )
                    goto _test_eof646;

            case 646:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1146;

                goto st0;
st647:

                if ( ++p == pe )
                    goto _test_eof647;

            case 647:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1147;

                goto st0;
st648:

                if ( ++p == pe )
                    goto _test_eof648;

            case 648:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1148;

                case 5:
                    goto tr1148;

                case 8:
                    goto tr1148;

                case 18:
                    goto tr1149;

                case 21:
                    goto tr1149;

                case 23:
                    goto tr1149;

                case 36:
                    goto tr1149;

                case 44:
                    goto tr1149;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1149;

                goto st0;
tr1148:

                {
                    expr_start = p;
                }
                goto st649;
st649:

                if ( ++p == pe )
                    goto _test_eof649;

            case 649:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st649;

                case 22:
                    goto tr1152;

                case 37:
                    goto st649;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 23 )
                            goto st650;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st650;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st650;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st650;
                }
                else
                    goto st650;

                goto st0;
tr1149:

                {
                    expr_start = p;
                }
                goto st650;
st650:

                if ( ++p == pe )
                    goto _test_eof650;

            case 650:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st649;

                case 5:
                    goto st649;

                case 8:
                    goto st649;

                case 13:
                    goto st650;

                case 18:
                    goto st650;

                case 21:
                    goto st650;

                case 23:
                    goto st650;

                case 36:
                    goto st650;

                case 44:
                    goto st650;
                }

                goto st0;
tr1152:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }

                {
                    pop_eval_expr( &expr_value, &expr_error );
                }
                goto st651;
st651:

                if ( ++p == pe )
                    goto _test_eof651;

            case 651:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st652;

                case 53:
                    goto st653;

                case 54:
                    goto st654;

                case 55:
                    goto st655;

                case 56:
                    goto st656;

                case 59:
                    goto st657;

                case 62:
                    goto st658;

                case 79:
                    goto st659;

                case 80:
                    goto st660;

                case 81:
                    goto st670;
                }

                goto st0;
st652:

                if ( ++p == pe )
                    goto _test_eof652;

            case 652:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1163;

                goto st0;
st653:

                if ( ++p == pe )
                    goto _test_eof653;

            case 653:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1164;

                goto st0;
st654:

                if ( ++p == pe )
                    goto _test_eof654;

            case 654:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1165;

                goto st0;
st655:

                if ( ++p == pe )
                    goto _test_eof655;

            case 655:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1166;

                goto st0;
st656:

                if ( ++p == pe )
                    goto _test_eof656;

            case 656:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1167;

                goto st0;
st657:

                if ( ++p == pe )
                    goto _test_eof657;

            case 657:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1168;

                goto st0;
st658:

                if ( ++p == pe )
                    goto _test_eof658;

            case 658:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1169;

                goto st0;
st659:

                if ( ++p == pe )
                    goto _test_eof659;

            case 659:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1170;

                goto st0;
st660:

                if ( ++p == pe )
                    goto _test_eof660;

            case 660:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st661;

                case 21:
                    goto st662;

                case 23:
                    goto st666;
                }

                goto st0;
st661:

                if ( ++p == pe )
                    goto _test_eof661;

            case 661:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1174;

                goto st0;
st662:

                if ( ++p == pe )
                    goto _test_eof662;

            case 662:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1175;

                case 5:
                    goto tr1175;

                case 8:
                    goto tr1175;

                case 18:
                    goto tr1176;

                case 21:
                    goto tr1176;

                case 23:
                    goto tr1176;

                case 36:
                    goto tr1176;

                case 44:
                    goto tr1176;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1176;

                goto st0;
tr1175:

                {
                    expr_start = p;
                }
                goto st663;
st663:

                if ( ++p == pe )
                    goto _test_eof663;

            case 663:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1177;

                case 23:
                    goto st24;

                case 37:
                    goto st663;
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
tr1177:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st664;
st664:

                if ( ++p == pe )
                    goto _test_eof664;

            case 664:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1179;

                case 19:
                    goto tr1177;

                case 23:
                    goto st24;

                case 37:
                    goto st663;
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
tr1176:

                {
                    expr_start = p;
                }
                goto st665;
st665:

                if ( ++p == pe )
                    goto _test_eof665;

            case 665:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st663;

                case 5:
                    goto st663;

                case 8:
                    goto st663;

                case 13:
                    goto st665;

                case 18:
                    goto st665;

                case 21:
                    goto st665;

                case 23:
                    goto st665;

                case 36:
                    goto st665;

                case 44:
                    goto st665;
                }

                goto st0;
st666:

                if ( ++p == pe )
                    goto _test_eof666;

            case 666:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1181;

                case 5:
                    goto tr1181;

                case 8:
                    goto tr1181;

                case 18:
                    goto tr1182;

                case 21:
                    goto tr1182;

                case 23:
                    goto tr1182;

                case 36:
                    goto tr1182;

                case 44:
                    goto tr1182;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1182;

                goto st0;
tr1181:

                {
                    expr_start = p;
                }
                goto st667;
st667:

                if ( ++p == pe )
                    goto _test_eof667;

            case 667:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1183;

                case 23:
                    goto st24;

                case 37:
                    goto st667;
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
tr1183:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st668;
st668:

                if ( ++p == pe )
                    goto _test_eof668;

            case 668:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1185;

                case 19:
                    goto tr1183;

                case 23:
                    goto st24;

                case 37:
                    goto st667;
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
tr1182:

                {
                    expr_start = p;
                }
                goto st669;
st669:

                if ( ++p == pe )
                    goto _test_eof669;

            case 669:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st667;

                case 5:
                    goto st667;

                case 8:
                    goto st667;

                case 13:
                    goto st669;

                case 18:
                    goto st669;

                case 21:
                    goto st669;

                case 23:
                    goto st669;

                case 36:
                    goto st669;

                case 44:
                    goto st669;
                }

                goto st0;
st670:

                if ( ++p == pe )
                    goto _test_eof670;

            case 670:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st671;

                case 21:
                    goto st672;

                case 23:
                    goto st676;
                }

                goto st0;
st671:

                if ( ++p == pe )
                    goto _test_eof671;

            case 671:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1190;

                goto st0;
st672:

                if ( ++p == pe )
                    goto _test_eof672;

            case 672:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1191;

                case 5:
                    goto tr1191;

                case 8:
                    goto tr1191;

                case 18:
                    goto tr1192;

                case 21:
                    goto tr1192;

                case 23:
                    goto tr1192;

                case 36:
                    goto tr1192;

                case 44:
                    goto tr1192;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1192;

                goto st0;
tr1191:

                {
                    expr_start = p;
                }
                goto st673;
st673:

                if ( ++p == pe )
                    goto _test_eof673;

            case 673:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1193;

                case 23:
                    goto st24;

                case 37:
                    goto st673;
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
tr1193:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st674;
st674:

                if ( ++p == pe )
                    goto _test_eof674;

            case 674:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1195;

                case 19:
                    goto tr1193;

                case 23:
                    goto st24;

                case 37:
                    goto st673;
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
tr1192:

                {
                    expr_start = p;
                }
                goto st675;
st675:

                if ( ++p == pe )
                    goto _test_eof675;

            case 675:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st673;

                case 5:
                    goto st673;

                case 8:
                    goto st673;

                case 13:
                    goto st675;

                case 18:
                    goto st675;

                case 21:
                    goto st675;

                case 23:
                    goto st675;

                case 36:
                    goto st675;

                case 44:
                    goto st675;
                }

                goto st0;
st676:

                if ( ++p == pe )
                    goto _test_eof676;

            case 676:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1197;

                case 5:
                    goto tr1197;

                case 8:
                    goto tr1197;

                case 18:
                    goto tr1198;

                case 21:
                    goto tr1198;

                case 23:
                    goto tr1198;

                case 36:
                    goto tr1198;

                case 44:
                    goto tr1198;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1198;

                goto st0;
tr1197:

                {
                    expr_start = p;
                }
                goto st677;
st677:

                if ( ++p == pe )
                    goto _test_eof677;

            case 677:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1199;

                case 23:
                    goto st24;

                case 37:
                    goto st677;
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
tr1199:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st678;
st678:

                if ( ++p == pe )
                    goto _test_eof678;

            case 678:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1201;

                case 19:
                    goto tr1199;

                case 23:
                    goto st24;

                case 37:
                    goto st677;
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
tr1198:

                {
                    expr_start = p;
                }
                goto st679;
st679:

                if ( ++p == pe )
                    goto _test_eof679;

            case 679:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st677;

                case 5:
                    goto st677;

                case 8:
                    goto st677;

                case 13:
                    goto st679;

                case 18:
                    goto st679;

                case 21:
                    goto st679;

                case 23:
                    goto st679;

                case 36:
                    goto st679;

                case 44:
                    goto st679;
                }

                goto st0;
st680:

                if ( ++p == pe )
                    goto _test_eof680;

            case 680:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st681;

                case 53:
                    goto st682;

                case 54:
                    goto st683;

                case 55:
                    goto st684;

                case 56:
                    goto st685;

                case 59:
                    goto st686;

                case 62:
                    goto st687;

                case 79:
                    goto st688;

                case 80:
                    goto st689;

                case 81:
                    goto st699;
                }

                goto st0;
st681:

                if ( ++p == pe )
                    goto _test_eof681;

            case 681:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1213;

                goto st0;
st682:

                if ( ++p == pe )
                    goto _test_eof682;

            case 682:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1214;

                goto st0;
st683:

                if ( ++p == pe )
                    goto _test_eof683;

            case 683:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1215;

                goto st0;
st684:

                if ( ++p == pe )
                    goto _test_eof684;

            case 684:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1216;

                goto st0;
st685:

                if ( ++p == pe )
                    goto _test_eof685;

            case 685:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1217;

                goto st0;
st686:

                if ( ++p == pe )
                    goto _test_eof686;

            case 686:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1218;

                goto st0;
st687:

                if ( ++p == pe )
                    goto _test_eof687;

            case 687:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1219;

                goto st0;
st688:

                if ( ++p == pe )
                    goto _test_eof688;

            case 688:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1220;

                goto st0;
st689:

                if ( ++p == pe )
                    goto _test_eof689;

            case 689:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st690;

                case 21:
                    goto st691;

                case 23:
                    goto st695;
                }

                goto st0;
st690:

                if ( ++p == pe )
                    goto _test_eof690;

            case 690:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1224;

                goto st0;
st691:

                if ( ++p == pe )
                    goto _test_eof691;

            case 691:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1225;

                case 5:
                    goto tr1225;

                case 8:
                    goto tr1225;

                case 18:
                    goto tr1226;

                case 21:
                    goto tr1226;

                case 23:
                    goto tr1226;

                case 36:
                    goto tr1226;

                case 44:
                    goto tr1226;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1226;

                goto st0;
tr1225:

                {
                    expr_start = p;
                }
                goto st692;
st692:

                if ( ++p == pe )
                    goto _test_eof692;

            case 692:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1227;

                case 23:
                    goto st24;

                case 37:
                    goto st692;
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
tr1227:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st693;
st693:

                if ( ++p == pe )
                    goto _test_eof693;

            case 693:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1229;

                case 19:
                    goto tr1227;

                case 23:
                    goto st24;

                case 37:
                    goto st692;
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
tr1226:

                {
                    expr_start = p;
                }
                goto st694;
st694:

                if ( ++p == pe )
                    goto _test_eof694;

            case 694:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st692;

                case 5:
                    goto st692;

                case 8:
                    goto st692;

                case 13:
                    goto st694;

                case 18:
                    goto st694;

                case 21:
                    goto st694;

                case 23:
                    goto st694;

                case 36:
                    goto st694;

                case 44:
                    goto st694;
                }

                goto st0;
st695:

                if ( ++p == pe )
                    goto _test_eof695;

            case 695:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1231;

                case 5:
                    goto tr1231;

                case 8:
                    goto tr1231;

                case 18:
                    goto tr1232;

                case 21:
                    goto tr1232;

                case 23:
                    goto tr1232;

                case 36:
                    goto tr1232;

                case 44:
                    goto tr1232;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1232;

                goto st0;
tr1231:

                {
                    expr_start = p;
                }
                goto st696;
st696:

                if ( ++p == pe )
                    goto _test_eof696;

            case 696:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1233;

                case 23:
                    goto st24;

                case 37:
                    goto st696;
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
tr1233:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st697;
st697:

                if ( ++p == pe )
                    goto _test_eof697;

            case 697:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1235;

                case 19:
                    goto tr1233;

                case 23:
                    goto st24;

                case 37:
                    goto st696;
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
tr1232:

                {
                    expr_start = p;
                }
                goto st698;
st698:

                if ( ++p == pe )
                    goto _test_eof698;

            case 698:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st696;

                case 5:
                    goto st696;

                case 8:
                    goto st696;

                case 13:
                    goto st698;

                case 18:
                    goto st698;

                case 21:
                    goto st698;

                case 23:
                    goto st698;

                case 36:
                    goto st698;

                case 44:
                    goto st698;
                }

                goto st0;
st699:

                if ( ++p == pe )
                    goto _test_eof699;

            case 699:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st700;

                case 21:
                    goto st701;

                case 23:
                    goto st705;
                }

                goto st0;
st700:

                if ( ++p == pe )
                    goto _test_eof700;

            case 700:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1240;

                goto st0;
st701:

                if ( ++p == pe )
                    goto _test_eof701;

            case 701:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1241;

                case 5:
                    goto tr1241;

                case 8:
                    goto tr1241;

                case 18:
                    goto tr1242;

                case 21:
                    goto tr1242;

                case 23:
                    goto tr1242;

                case 36:
                    goto tr1242;

                case 44:
                    goto tr1242;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1242;

                goto st0;
tr1241:

                {
                    expr_start = p;
                }
                goto st702;
st702:

                if ( ++p == pe )
                    goto _test_eof702;

            case 702:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1243;

                case 23:
                    goto st24;

                case 37:
                    goto st702;
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
tr1243:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st703;
st703:

                if ( ++p == pe )
                    goto _test_eof703;

            case 703:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1245;

                case 19:
                    goto tr1243;

                case 23:
                    goto st24;

                case 37:
                    goto st702;
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
tr1242:

                {
                    expr_start = p;
                }
                goto st704;
st704:

                if ( ++p == pe )
                    goto _test_eof704;

            case 704:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st702;

                case 5:
                    goto st702;

                case 8:
                    goto st702;

                case 13:
                    goto st704;

                case 18:
                    goto st704;

                case 21:
                    goto st704;

                case 23:
                    goto st704;

                case 36:
                    goto st704;

                case 44:
                    goto st704;
                }

                goto st0;
st705:

                if ( ++p == pe )
                    goto _test_eof705;

            case 705:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1247;

                case 5:
                    goto tr1247;

                case 8:
                    goto tr1247;

                case 18:
                    goto tr1248;

                case 21:
                    goto tr1248;

                case 23:
                    goto tr1248;

                case 36:
                    goto tr1248;

                case 44:
                    goto tr1248;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1248;

                goto st0;
tr1247:

                {
                    expr_start = p;
                }
                goto st706;
st706:

                if ( ++p == pe )
                    goto _test_eof706;

            case 706:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1249;

                case 23:
                    goto st24;

                case 37:
                    goto st706;
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
tr1249:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st707;
st707:

                if ( ++p == pe )
                    goto _test_eof707;

            case 707:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1251;

                case 19:
                    goto tr1249;

                case 23:
                    goto st24;

                case 37:
                    goto st706;
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
tr1248:

                {
                    expr_start = p;
                }
                goto st708;
st708:

                if ( ++p == pe )
                    goto _test_eof708;

            case 708:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st706;

                case 5:
                    goto st706;

                case 8:
                    goto st706;

                case 13:
                    goto st708;

                case 18:
                    goto st708;

                case 21:
                    goto st708;

                case 23:
                    goto st708;

                case 36:
                    goto st708;

                case 44:
                    goto st708;
                }

                goto st0;
st709:

                if ( ++p == pe )
                    goto _test_eof709;

            case 709:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st710;

                case 53:
                    goto st711;

                case 54:
                    goto st712;

                case 55:
                    goto st713;

                case 56:
                    goto st714;

                case 59:
                    goto st715;

                case 62:
                    goto st716;

                case 79:
                    goto st717;

                case 80:
                    goto st718;

                case 81:
                    goto st728;
                }

                goto st0;
st710:

                if ( ++p == pe )
                    goto _test_eof710;

            case 710:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1263;

                goto st0;
st711:

                if ( ++p == pe )
                    goto _test_eof711;

            case 711:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1264;

                goto st0;
st712:

                if ( ++p == pe )
                    goto _test_eof712;

            case 712:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1265;

                goto st0;
st713:

                if ( ++p == pe )
                    goto _test_eof713;

            case 713:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1266;

                goto st0;
st714:

                if ( ++p == pe )
                    goto _test_eof714;

            case 714:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1267;

                goto st0;
st715:

                if ( ++p == pe )
                    goto _test_eof715;

            case 715:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1268;

                goto st0;
st716:

                if ( ++p == pe )
                    goto _test_eof716;

            case 716:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1269;

                goto st0;
st717:

                if ( ++p == pe )
                    goto _test_eof717;

            case 717:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1270;

                goto st0;
st718:

                if ( ++p == pe )
                    goto _test_eof718;

            case 718:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st719;

                case 21:
                    goto st720;

                case 23:
                    goto st724;
                }

                goto st0;
st719:

                if ( ++p == pe )
                    goto _test_eof719;

            case 719:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1274;

                goto st0;
st720:

                if ( ++p == pe )
                    goto _test_eof720;

            case 720:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1275;

                case 5:
                    goto tr1275;

                case 8:
                    goto tr1275;

                case 18:
                    goto tr1276;

                case 21:
                    goto tr1276;

                case 23:
                    goto tr1276;

                case 36:
                    goto tr1276;

                case 44:
                    goto tr1276;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1276;

                goto st0;
tr1275:

                {
                    expr_start = p;
                }
                goto st721;
st721:

                if ( ++p == pe )
                    goto _test_eof721;

            case 721:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1277;

                case 23:
                    goto st24;

                case 37:
                    goto st721;
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
tr1277:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st722;
st722:

                if ( ++p == pe )
                    goto _test_eof722;

            case 722:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1279;

                case 19:
                    goto tr1277;

                case 23:
                    goto st24;

                case 37:
                    goto st721;
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
tr1276:

                {
                    expr_start = p;
                }
                goto st723;
st723:

                if ( ++p == pe )
                    goto _test_eof723;

            case 723:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st721;

                case 5:
                    goto st721;

                case 8:
                    goto st721;

                case 13:
                    goto st723;

                case 18:
                    goto st723;

                case 21:
                    goto st723;

                case 23:
                    goto st723;

                case 36:
                    goto st723;

                case 44:
                    goto st723;
                }

                goto st0;
st724:

                if ( ++p == pe )
                    goto _test_eof724;

            case 724:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1281;

                case 5:
                    goto tr1281;

                case 8:
                    goto tr1281;

                case 18:
                    goto tr1282;

                case 21:
                    goto tr1282;

                case 23:
                    goto tr1282;

                case 36:
                    goto tr1282;

                case 44:
                    goto tr1282;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1282;

                goto st0;
tr1281:

                {
                    expr_start = p;
                }
                goto st725;
st725:

                if ( ++p == pe )
                    goto _test_eof725;

            case 725:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1283;

                case 23:
                    goto st24;

                case 37:
                    goto st725;
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
tr1283:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st726;
st726:

                if ( ++p == pe )
                    goto _test_eof726;

            case 726:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1285;

                case 19:
                    goto tr1283;

                case 23:
                    goto st24;

                case 37:
                    goto st725;
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
tr1282:

                {
                    expr_start = p;
                }
                goto st727;
st727:

                if ( ++p == pe )
                    goto _test_eof727;

            case 727:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st725;

                case 5:
                    goto st725;

                case 8:
                    goto st725;

                case 13:
                    goto st727;

                case 18:
                    goto st727;

                case 21:
                    goto st727;

                case 23:
                    goto st727;

                case 36:
                    goto st727;

                case 44:
                    goto st727;
                }

                goto st0;
st728:

                if ( ++p == pe )
                    goto _test_eof728;

            case 728:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st729;

                case 21:
                    goto st730;

                case 23:
                    goto st734;
                }

                goto st0;
st729:

                if ( ++p == pe )
                    goto _test_eof729;

            case 729:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1290;

                goto st0;
st730:

                if ( ++p == pe )
                    goto _test_eof730;

            case 730:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1291;

                case 5:
                    goto tr1291;

                case 8:
                    goto tr1291;

                case 18:
                    goto tr1292;

                case 21:
                    goto tr1292;

                case 23:
                    goto tr1292;

                case 36:
                    goto tr1292;

                case 44:
                    goto tr1292;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1292;

                goto st0;
tr1291:

                {
                    expr_start = p;
                }
                goto st731;
st731:

                if ( ++p == pe )
                    goto _test_eof731;

            case 731:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1293;

                case 23:
                    goto st24;

                case 37:
                    goto st731;
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
tr1293:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st732;
st732:

                if ( ++p == pe )
                    goto _test_eof732;

            case 732:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1295;

                case 19:
                    goto tr1293;

                case 23:
                    goto st24;

                case 37:
                    goto st731;
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
tr1292:

                {
                    expr_start = p;
                }
                goto st733;
st733:

                if ( ++p == pe )
                    goto _test_eof733;

            case 733:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st731;

                case 5:
                    goto st731;

                case 8:
                    goto st731;

                case 13:
                    goto st733;

                case 18:
                    goto st733;

                case 21:
                    goto st733;

                case 23:
                    goto st733;

                case 36:
                    goto st733;

                case 44:
                    goto st733;
                }

                goto st0;
st734:

                if ( ++p == pe )
                    goto _test_eof734;

            case 734:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1297;

                case 5:
                    goto tr1297;

                case 8:
                    goto tr1297;

                case 18:
                    goto tr1298;

                case 21:
                    goto tr1298;

                case 23:
                    goto tr1298;

                case 36:
                    goto tr1298;

                case 44:
                    goto tr1298;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1298;

                goto st0;
tr1297:

                {
                    expr_start = p;
                }
                goto st735;
st735:

                if ( ++p == pe )
                    goto _test_eof735;

            case 735:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1299;

                case 23:
                    goto st24;

                case 37:
                    goto st735;
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
tr1299:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st736;
st736:

                if ( ++p == pe )
                    goto _test_eof736;

            case 736:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1301;

                case 19:
                    goto tr1299;

                case 23:
                    goto st24;

                case 37:
                    goto st735;
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
tr1298:

                {
                    expr_start = p;
                }
                goto st737;
st737:

                if ( ++p == pe )
                    goto _test_eof737;

            case 737:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st735;

                case 5:
                    goto st735;

                case 8:
                    goto st735;

                case 13:
                    goto st737;

                case 18:
                    goto st737;

                case 21:
                    goto st737;

                case 23:
                    goto st737;

                case 36:
                    goto st737;

                case 44:
                    goto st737;
                }

                goto st0;
st738:

                if ( ++p == pe )
                    goto _test_eof738;

            case 738:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st739;

                case 53:
                    goto st740;

                case 54:
                    goto st741;

                case 55:
                    goto st742;

                case 56:
                    goto st743;

                case 59:
                    goto st744;

                case 62:
                    goto st745;

                case 79:
                    goto st746;

                case 80:
                    goto st747;

                case 81:
                    goto st757;
                }

                goto st0;
st739:

                if ( ++p == pe )
                    goto _test_eof739;

            case 739:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1313;

                goto st0;
st740:

                if ( ++p == pe )
                    goto _test_eof740;

            case 740:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1314;

                goto st0;
st741:

                if ( ++p == pe )
                    goto _test_eof741;

            case 741:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1315;

                goto st0;
st742:

                if ( ++p == pe )
                    goto _test_eof742;

            case 742:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1316;

                goto st0;
st743:

                if ( ++p == pe )
                    goto _test_eof743;

            case 743:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1317;

                goto st0;
st744:

                if ( ++p == pe )
                    goto _test_eof744;

            case 744:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1318;

                goto st0;
st745:

                if ( ++p == pe )
                    goto _test_eof745;

            case 745:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1319;

                goto st0;
st746:

                if ( ++p == pe )
                    goto _test_eof746;

            case 746:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1320;

                goto st0;
st747:

                if ( ++p == pe )
                    goto _test_eof747;

            case 747:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st748;

                case 21:
                    goto st749;

                case 23:
                    goto st753;
                }

                goto st0;
st748:

                if ( ++p == pe )
                    goto _test_eof748;

            case 748:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1324;

                goto st0;
st749:

                if ( ++p == pe )
                    goto _test_eof749;

            case 749:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1325;

                case 5:
                    goto tr1325;

                case 8:
                    goto tr1325;

                case 18:
                    goto tr1326;

                case 21:
                    goto tr1326;

                case 23:
                    goto tr1326;

                case 36:
                    goto tr1326;

                case 44:
                    goto tr1326;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1326;

                goto st0;
tr1325:

                {
                    expr_start = p;
                }
                goto st750;
st750:

                if ( ++p == pe )
                    goto _test_eof750;

            case 750:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1327;

                case 23:
                    goto st24;

                case 37:
                    goto st750;
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
tr1327:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st751;
st751:

                if ( ++p == pe )
                    goto _test_eof751;

            case 751:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1329;

                case 19:
                    goto tr1327;

                case 23:
                    goto st24;

                case 37:
                    goto st750;
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
tr1326:

                {
                    expr_start = p;
                }
                goto st752;
st752:

                if ( ++p == pe )
                    goto _test_eof752;

            case 752:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st750;

                case 5:
                    goto st750;

                case 8:
                    goto st750;

                case 13:
                    goto st752;

                case 18:
                    goto st752;

                case 21:
                    goto st752;

                case 23:
                    goto st752;

                case 36:
                    goto st752;

                case 44:
                    goto st752;
                }

                goto st0;
st753:

                if ( ++p == pe )
                    goto _test_eof753;

            case 753:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1331;

                case 5:
                    goto tr1331;

                case 8:
                    goto tr1331;

                case 18:
                    goto tr1332;

                case 21:
                    goto tr1332;

                case 23:
                    goto tr1332;

                case 36:
                    goto tr1332;

                case 44:
                    goto tr1332;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1332;

                goto st0;
tr1331:

                {
                    expr_start = p;
                }
                goto st754;
st754:

                if ( ++p == pe )
                    goto _test_eof754;

            case 754:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1333;

                case 23:
                    goto st24;

                case 37:
                    goto st754;
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
tr1333:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st755;
st755:

                if ( ++p == pe )
                    goto _test_eof755;

            case 755:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1335;

                case 19:
                    goto tr1333;

                case 23:
                    goto st24;

                case 37:
                    goto st754;
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
tr1332:

                {
                    expr_start = p;
                }
                goto st756;
st756:

                if ( ++p == pe )
                    goto _test_eof756;

            case 756:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st754;

                case 5:
                    goto st754;

                case 8:
                    goto st754;

                case 13:
                    goto st756;

                case 18:
                    goto st756;

                case 21:
                    goto st756;

                case 23:
                    goto st756;

                case 36:
                    goto st756;

                case 44:
                    goto st756;
                }

                goto st0;
st757:

                if ( ++p == pe )
                    goto _test_eof757;

            case 757:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st758;

                case 21:
                    goto st759;

                case 23:
                    goto st763;
                }

                goto st0;
st758:

                if ( ++p == pe )
                    goto _test_eof758;

            case 758:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1340;

                goto st0;
st759:

                if ( ++p == pe )
                    goto _test_eof759;

            case 759:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1341;

                case 5:
                    goto tr1341;

                case 8:
                    goto tr1341;

                case 18:
                    goto tr1342;

                case 21:
                    goto tr1342;

                case 23:
                    goto tr1342;

                case 36:
                    goto tr1342;

                case 44:
                    goto tr1342;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1342;

                goto st0;
tr1341:

                {
                    expr_start = p;
                }
                goto st760;
st760:

                if ( ++p == pe )
                    goto _test_eof760;

            case 760:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1343;

                case 23:
                    goto st24;

                case 37:
                    goto st760;
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
tr1343:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st761;
st761:

                if ( ++p == pe )
                    goto _test_eof761;

            case 761:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1345;

                case 19:
                    goto tr1343;

                case 23:
                    goto st24;

                case 37:
                    goto st760;
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
tr1342:

                {
                    expr_start = p;
                }
                goto st762;
st762:

                if ( ++p == pe )
                    goto _test_eof762;

            case 762:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st760;

                case 5:
                    goto st760;

                case 8:
                    goto st760;

                case 13:
                    goto st762;

                case 18:
                    goto st762;

                case 21:
                    goto st762;

                case 23:
                    goto st762;

                case 36:
                    goto st762;

                case 44:
                    goto st762;
                }

                goto st0;
st763:

                if ( ++p == pe )
                    goto _test_eof763;

            case 763:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1347;

                case 5:
                    goto tr1347;

                case 8:
                    goto tr1347;

                case 18:
                    goto tr1348;

                case 21:
                    goto tr1348;

                case 23:
                    goto tr1348;

                case 36:
                    goto tr1348;

                case 44:
                    goto tr1348;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1348;

                goto st0;
tr1347:

                {
                    expr_start = p;
                }
                goto st764;
st764:

                if ( ++p == pe )
                    goto _test_eof764;

            case 764:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1349;

                case 23:
                    goto st24;

                case 37:
                    goto st764;
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
tr1349:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st765;
st765:

                if ( ++p == pe )
                    goto _test_eof765;

            case 765:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1351;

                case 19:
                    goto tr1349;

                case 23:
                    goto st24;

                case 37:
                    goto st764;
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
tr1348:

                {
                    expr_start = p;
                }
                goto st766;
st766:

                if ( ++p == pe )
                    goto _test_eof766;

            case 766:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st764;

                case 5:
                    goto st764;

                case 8:
                    goto st764;

                case 13:
                    goto st766;

                case 18:
                    goto st766;

                case 21:
                    goto st766;

                case 23:
                    goto st766;

                case 36:
                    goto st766;

                case 44:
                    goto st766;
                }

                goto st0;
st767:

                if ( ++p == pe )
                    goto _test_eof767;

            case 767:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st768;

                case 53:
                    goto st769;

                case 54:
                    goto st770;

                case 55:
                    goto st771;

                case 56:
                    goto st772;

                case 59:
                    goto st773;

                case 62:
                    goto st774;

                case 79:
                    goto st775;

                case 80:
                    goto st776;

                case 81:
                    goto st786;
                }

                goto st0;
st768:

                if ( ++p == pe )
                    goto _test_eof768;

            case 768:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1363;

                goto st0;
st769:

                if ( ++p == pe )
                    goto _test_eof769;

            case 769:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1364;

                goto st0;
st770:

                if ( ++p == pe )
                    goto _test_eof770;

            case 770:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1365;

                goto st0;
st771:

                if ( ++p == pe )
                    goto _test_eof771;

            case 771:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1366;

                goto st0;
st772:

                if ( ++p == pe )
                    goto _test_eof772;

            case 772:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1367;

                goto st0;
st773:

                if ( ++p == pe )
                    goto _test_eof773;

            case 773:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1368;

                goto st0;
st774:

                if ( ++p == pe )
                    goto _test_eof774;

            case 774:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1369;

                goto st0;
st775:

                if ( ++p == pe )
                    goto _test_eof775;

            case 775:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1370;

                goto st0;
st776:

                if ( ++p == pe )
                    goto _test_eof776;

            case 776:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st777;

                case 21:
                    goto st778;

                case 23:
                    goto st782;
                }

                goto st0;
st777:

                if ( ++p == pe )
                    goto _test_eof777;

            case 777:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1374;

                goto st0;
st778:

                if ( ++p == pe )
                    goto _test_eof778;

            case 778:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1375;

                case 5:
                    goto tr1375;

                case 8:
                    goto tr1375;

                case 18:
                    goto tr1376;

                case 21:
                    goto tr1376;

                case 23:
                    goto tr1376;

                case 36:
                    goto tr1376;

                case 44:
                    goto tr1376;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1376;

                goto st0;
tr1375:

                {
                    expr_start = p;
                }
                goto st779;
st779:

                if ( ++p == pe )
                    goto _test_eof779;

            case 779:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1377;

                case 23:
                    goto st24;

                case 37:
                    goto st779;
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
tr1377:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st780;
st780:

                if ( ++p == pe )
                    goto _test_eof780;

            case 780:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1379;

                case 19:
                    goto tr1377;

                case 23:
                    goto st24;

                case 37:
                    goto st779;
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
tr1376:

                {
                    expr_start = p;
                }
                goto st781;
st781:

                if ( ++p == pe )
                    goto _test_eof781;

            case 781:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st779;

                case 5:
                    goto st779;

                case 8:
                    goto st779;

                case 13:
                    goto st781;

                case 18:
                    goto st781;

                case 21:
                    goto st781;

                case 23:
                    goto st781;

                case 36:
                    goto st781;

                case 44:
                    goto st781;
                }

                goto st0;
st782:

                if ( ++p == pe )
                    goto _test_eof782;

            case 782:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1381;

                case 5:
                    goto tr1381;

                case 8:
                    goto tr1381;

                case 18:
                    goto tr1382;

                case 21:
                    goto tr1382;

                case 23:
                    goto tr1382;

                case 36:
                    goto tr1382;

                case 44:
                    goto tr1382;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1382;

                goto st0;
tr1381:

                {
                    expr_start = p;
                }
                goto st783;
st783:

                if ( ++p == pe )
                    goto _test_eof783;

            case 783:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1383;

                case 23:
                    goto st24;

                case 37:
                    goto st783;
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
tr1383:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st784;
st784:

                if ( ++p == pe )
                    goto _test_eof784;

            case 784:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1385;

                case 19:
                    goto tr1383;

                case 23:
                    goto st24;

                case 37:
                    goto st783;
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
tr1382:

                {
                    expr_start = p;
                }
                goto st785;
st785:

                if ( ++p == pe )
                    goto _test_eof785;

            case 785:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st783;

                case 5:
                    goto st783;

                case 8:
                    goto st783;

                case 13:
                    goto st785;

                case 18:
                    goto st785;

                case 21:
                    goto st785;

                case 23:
                    goto st785;

                case 36:
                    goto st785;

                case 44:
                    goto st785;
                }

                goto st0;
st786:

                if ( ++p == pe )
                    goto _test_eof786;

            case 786:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st787;

                case 21:
                    goto st788;

                case 23:
                    goto st792;
                }

                goto st0;
st787:

                if ( ++p == pe )
                    goto _test_eof787;

            case 787:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1390;

                goto st0;
st788:

                if ( ++p == pe )
                    goto _test_eof788;

            case 788:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1391;

                case 5:
                    goto tr1391;

                case 8:
                    goto tr1391;

                case 18:
                    goto tr1392;

                case 21:
                    goto tr1392;

                case 23:
                    goto tr1392;

                case 36:
                    goto tr1392;

                case 44:
                    goto tr1392;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1392;

                goto st0;
tr1391:

                {
                    expr_start = p;
                }
                goto st789;
st789:

                if ( ++p == pe )
                    goto _test_eof789;

            case 789:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1393;

                case 23:
                    goto st24;

                case 37:
                    goto st789;
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
tr1393:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st790;
st790:

                if ( ++p == pe )
                    goto _test_eof790;

            case 790:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1395;

                case 19:
                    goto tr1393;

                case 23:
                    goto st24;

                case 37:
                    goto st789;
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
tr1392:

                {
                    expr_start = p;
                }
                goto st791;
st791:

                if ( ++p == pe )
                    goto _test_eof791;

            case 791:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st789;

                case 5:
                    goto st789;

                case 8:
                    goto st789;

                case 13:
                    goto st791;

                case 18:
                    goto st791;

                case 21:
                    goto st791;

                case 23:
                    goto st791;

                case 36:
                    goto st791;

                case 44:
                    goto st791;
                }

                goto st0;
st792:

                if ( ++p == pe )
                    goto _test_eof792;

            case 792:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1397;

                case 5:
                    goto tr1397;

                case 8:
                    goto tr1397;

                case 18:
                    goto tr1398;

                case 21:
                    goto tr1398;

                case 23:
                    goto tr1398;

                case 36:
                    goto tr1398;

                case 44:
                    goto tr1398;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1398;

                goto st0;
tr1397:

                {
                    expr_start = p;
                }
                goto st793;
st793:

                if ( ++p == pe )
                    goto _test_eof793;

            case 793:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1399;

                case 23:
                    goto st24;

                case 37:
                    goto st793;
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
tr1399:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st794;
st794:

                if ( ++p == pe )
                    goto _test_eof794;

            case 794:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1401;

                case 19:
                    goto tr1399;

                case 23:
                    goto st24;

                case 37:
                    goto st793;
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
tr1398:

                {
                    expr_start = p;
                }
                goto st795;
st795:

                if ( ++p == pe )
                    goto _test_eof795;

            case 795:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st793;

                case 5:
                    goto st793;

                case 8:
                    goto st793;

                case 13:
                    goto st795;

                case 18:
                    goto st795;

                case 21:
                    goto st795;

                case 23:
                    goto st795;

                case 36:
                    goto st795;

                case 44:
                    goto st795;
                }

                goto st0;
st796:

                if ( ++p == pe )
                    goto _test_eof796;

            case 796:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1403;

                case 5:
                    goto tr1403;

                case 8:
                    goto tr1403;

                case 18:
                    goto tr1404;

                case 21:
                    goto tr1404;

                case 23:
                    goto tr1404;

                case 36:
                    goto tr1404;

                case 44:
                    goto tr1404;

                case 48:
                    goto st799;

                case 53:
                    goto st800;

                case 54:
                    goto st801;

                case 55:
                    goto st802;

                case 56:
                    goto st803;

                case 57:
                    goto st804;

                case 58:
                    goto st805;

                case 59:
                    goto st806;

                case 60:
                    goto st807;

                case 61:
                    goto st808;

                case 62:
                    goto st809;

                case 79:
                    goto st812;

                case 80:
                    goto st813;

                case 81:
                    goto st823;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1404;

                goto st0;
tr1403:

                {
                    expr_start = p;
                }
                goto st797;
st797:

                if ( ++p == pe )
                    goto _test_eof797;

            case 797:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1419;

                case 19:
                    goto st797;

                case 23:
                    goto st798;

                case 37:
                    goto st797;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st798;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st798;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st798;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st798;
                }
                else
                    goto st798;

                goto st0;
tr1404:

                {
                    expr_start = p;
                }
                goto st798;
st798:

                if ( ++p == pe )
                    goto _test_eof798;

            case 798:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st797;

                case 5:
                    goto st797;

                case 8:
                    goto st797;

                case 13:
                    goto st798;

                case 18:
                    goto st798;

                case 21:
                    goto st798;

                case 23:
                    goto st798;

                case 36:
                    goto st798;

                case 44:
                    goto st798;
                }

                goto st0;
st799:

                if ( ++p == pe )
                    goto _test_eof799;

            case 799:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1422;

                goto st0;
st800:

                if ( ++p == pe )
                    goto _test_eof800;

            case 800:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1423;

                goto st0;
st801:

                if ( ++p == pe )
                    goto _test_eof801;

            case 801:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1424;

                goto st0;
st802:

                if ( ++p == pe )
                    goto _test_eof802;

            case 802:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1425;

                goto st0;
st803:

                if ( ++p == pe )
                    goto _test_eof803;

            case 803:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1426;

                goto st0;
st804:

                if ( ++p == pe )
                    goto _test_eof804;

            case 804:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1427;

                goto st0;
st805:

                if ( ++p == pe )
                    goto _test_eof805;

            case 805:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1428;

                goto st0;
st806:

                if ( ++p == pe )
                    goto _test_eof806;

            case 806:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1429;

                goto st0;
st807:

                if ( ++p == pe )
                    goto _test_eof807;

            case 807:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1430;

                goto st0;
st808:

                if ( ++p == pe )
                    goto _test_eof808;

            case 808:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1431;

                goto st0;
st809:

                if ( ++p == pe )
                    goto _test_eof809;

            case 809:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1432;

                case 22:
                    goto st810;
                }

                goto st0;
st810:

                if ( ++p == pe )
                    goto _test_eof810;

            case 810:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1403;

                case 5:
                    goto tr1403;

                case 8:
                    goto tr1403;

                case 18:
                    goto tr1404;

                case 21:
                    goto tr1404;

                case 23:
                    goto tr1404;

                case 36:
                    goto tr1404;

                case 44:
                    goto tr1404;

                case 48:
                    goto st799;

                case 53:
                    goto st800;

                case 54:
                    goto st801;

                case 55:
                    goto st802;

                case 56:
                    goto st803;

                case 57:
                    goto st804;

                case 58:
                    goto st805;

                case 59:
                    goto st806;

                case 60:
                    goto st807;

                case 61:
                    goto st808;

                case 62:
                    goto st811;

                case 79:
                    goto st812;

                case 80:
                    goto st813;

                case 81:
                    goto st823;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1404;

                goto st0;
st811:

                if ( ++p == pe )
                    goto _test_eof811;

            case 811:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1432;

                goto st0;
st812:

                if ( ++p == pe )
                    goto _test_eof812;

            case 812:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1435;

                goto st0;
st813:

                if ( ++p == pe )
                    goto _test_eof813;

            case 813:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st814;

                case 21:
                    goto st815;

                case 23:
                    goto st819;
                }

                goto st0;
st814:

                if ( ++p == pe )
                    goto _test_eof814;

            case 814:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1439;

                goto st0;
st815:

                if ( ++p == pe )
                    goto _test_eof815;

            case 815:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1440;

                case 5:
                    goto tr1440;

                case 8:
                    goto tr1440;

                case 18:
                    goto tr1441;

                case 21:
                    goto tr1441;

                case 23:
                    goto tr1441;

                case 36:
                    goto tr1441;

                case 44:
                    goto tr1441;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1441;

                goto st0;
tr1440:

                {
                    expr_start = p;
                }
                goto st816;
st816:

                if ( ++p == pe )
                    goto _test_eof816;

            case 816:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1442;

                case 23:
                    goto st24;

                case 37:
                    goto st816;
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
tr1442:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st817;
st817:

                if ( ++p == pe )
                    goto _test_eof817;

            case 817:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1444;

                case 19:
                    goto tr1442;

                case 23:
                    goto st24;

                case 37:
                    goto st816;
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
tr1441:

                {
                    expr_start = p;
                }
                goto st818;
st818:

                if ( ++p == pe )
                    goto _test_eof818;

            case 818:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st816;

                case 5:
                    goto st816;

                case 8:
                    goto st816;

                case 13:
                    goto st818;

                case 18:
                    goto st818;

                case 21:
                    goto st818;

                case 23:
                    goto st818;

                case 36:
                    goto st818;

                case 44:
                    goto st818;
                }

                goto st0;
st819:

                if ( ++p == pe )
                    goto _test_eof819;

            case 819:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1446;

                case 5:
                    goto tr1446;

                case 8:
                    goto tr1446;

                case 18:
                    goto tr1447;

                case 21:
                    goto tr1447;

                case 23:
                    goto tr1447;

                case 36:
                    goto tr1447;

                case 44:
                    goto tr1447;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1447;

                goto st0;
tr1446:

                {
                    expr_start = p;
                }
                goto st820;
st820:

                if ( ++p == pe )
                    goto _test_eof820;

            case 820:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1448;

                case 23:
                    goto st24;

                case 37:
                    goto st820;
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
tr1448:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st821;
st821:

                if ( ++p == pe )
                    goto _test_eof821;

            case 821:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1450;

                case 19:
                    goto tr1448;

                case 23:
                    goto st24;

                case 37:
                    goto st820;
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
tr1447:

                {
                    expr_start = p;
                }
                goto st822;
st822:

                if ( ++p == pe )
                    goto _test_eof822;

            case 822:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st820;

                case 5:
                    goto st820;

                case 8:
                    goto st820;

                case 13:
                    goto st822;

                case 18:
                    goto st822;

                case 21:
                    goto st822;

                case 23:
                    goto st822;

                case 36:
                    goto st822;

                case 44:
                    goto st822;
                }

                goto st0;
st823:

                if ( ++p == pe )
                    goto _test_eof823;

            case 823:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st824;

                case 21:
                    goto st825;

                case 23:
                    goto st829;
                }

                goto st0;
st824:

                if ( ++p == pe )
                    goto _test_eof824;

            case 824:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1455;

                goto st0;
st825:

                if ( ++p == pe )
                    goto _test_eof825;

            case 825:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1456;

                case 5:
                    goto tr1456;

                case 8:
                    goto tr1456;

                case 18:
                    goto tr1457;

                case 21:
                    goto tr1457;

                case 23:
                    goto tr1457;

                case 36:
                    goto tr1457;

                case 44:
                    goto tr1457;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1457;

                goto st0;
tr1456:

                {
                    expr_start = p;
                }
                goto st826;
st826:

                if ( ++p == pe )
                    goto _test_eof826;

            case 826:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1458;

                case 23:
                    goto st24;

                case 37:
                    goto st826;
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
tr1458:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st827;
st827:

                if ( ++p == pe )
                    goto _test_eof827;

            case 827:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1460;

                case 19:
                    goto tr1458;

                case 23:
                    goto st24;

                case 37:
                    goto st826;
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
tr1457:

                {
                    expr_start = p;
                }
                goto st828;
st828:

                if ( ++p == pe )
                    goto _test_eof828;

            case 828:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st826;

                case 5:
                    goto st826;

                case 8:
                    goto st826;

                case 13:
                    goto st828;

                case 18:
                    goto st828;

                case 21:
                    goto st828;

                case 23:
                    goto st828;

                case 36:
                    goto st828;

                case 44:
                    goto st828;
                }

                goto st0;
st829:

                if ( ++p == pe )
                    goto _test_eof829;

            case 829:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1462;

                case 5:
                    goto tr1462;

                case 8:
                    goto tr1462;

                case 18:
                    goto tr1463;

                case 21:
                    goto tr1463;

                case 23:
                    goto tr1463;

                case 36:
                    goto tr1463;

                case 44:
                    goto tr1463;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1463;

                goto st0;
tr1462:

                {
                    expr_start = p;
                }
                goto st830;
st830:

                if ( ++p == pe )
                    goto _test_eof830;

            case 830:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1464;

                case 23:
                    goto st24;

                case 37:
                    goto st830;
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
tr1464:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st831;
st831:

                if ( ++p == pe )
                    goto _test_eof831;

            case 831:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1466;

                case 19:
                    goto tr1464;

                case 23:
                    goto st24;

                case 37:
                    goto st830;
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
tr1463:

                {
                    expr_start = p;
                }
                goto st832;
st832:

                if ( ++p == pe )
                    goto _test_eof832;

            case 832:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st830;

                case 5:
                    goto st830;

                case 8:
                    goto st830;

                case 13:
                    goto st832;

                case 18:
                    goto st832;

                case 21:
                    goto st832;

                case 23:
                    goto st832;

                case 36:
                    goto st832;

                case 44:
                    goto st832;
                }

                goto st0;
st833:

                if ( ++p == pe )
                    goto _test_eof833;

            case 833:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1468;

                case 5:
                    goto tr1468;

                case 8:
                    goto tr1468;

                case 18:
                    goto tr1469;

                case 21:
                    goto tr1469;

                case 23:
                    goto tr1469;

                case 36:
                    goto tr1469;

                case 44:
                    goto tr1469;

                case 48:
                    goto st836;

                case 53:
                    goto st837;

                case 54:
                    goto st838;

                case 55:
                    goto st839;

                case 56:
                    goto st840;

                case 57:
                    goto st841;

                case 58:
                    goto st842;

                case 59:
                    goto st843;

                case 60:
                    goto st844;

                case 61:
                    goto st845;

                case 62:
                    goto st846;

                case 79:
                    goto st849;

                case 80:
                    goto st850;

                case 81:
                    goto st860;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1469;

                goto st0;
tr1468:

                {
                    expr_start = p;
                }
                goto st834;
st834:

                if ( ++p == pe )
                    goto _test_eof834;

            case 834:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1484;

                case 19:
                    goto st834;

                case 23:
                    goto st835;

                case 37:
                    goto st834;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st835;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st835;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st835;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st835;
                }
                else
                    goto st835;

                goto st0;
tr1469:

                {
                    expr_start = p;
                }
                goto st835;
st835:

                if ( ++p == pe )
                    goto _test_eof835;

            case 835:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st834;

                case 5:
                    goto st834;

                case 8:
                    goto st834;

                case 13:
                    goto st835;

                case 18:
                    goto st835;

                case 21:
                    goto st835;

                case 23:
                    goto st835;

                case 36:
                    goto st835;

                case 44:
                    goto st835;
                }

                goto st0;
st836:

                if ( ++p == pe )
                    goto _test_eof836;

            case 836:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1487;

                goto st0;
st837:

                if ( ++p == pe )
                    goto _test_eof837;

            case 837:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1488;

                goto st0;
st838:

                if ( ++p == pe )
                    goto _test_eof838;

            case 838:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1489;

                goto st0;
st839:

                if ( ++p == pe )
                    goto _test_eof839;

            case 839:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1490;

                goto st0;
st840:

                if ( ++p == pe )
                    goto _test_eof840;

            case 840:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1491;

                goto st0;
st841:

                if ( ++p == pe )
                    goto _test_eof841;

            case 841:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1492;

                goto st0;
st842:

                if ( ++p == pe )
                    goto _test_eof842;

            case 842:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1493;

                goto st0;
st843:

                if ( ++p == pe )
                    goto _test_eof843;

            case 843:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1494;

                goto st0;
st844:

                if ( ++p == pe )
                    goto _test_eof844;

            case 844:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1495;

                goto st0;
st845:

                if ( ++p == pe )
                    goto _test_eof845;

            case 845:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1496;

                goto st0;
st846:

                if ( ++p == pe )
                    goto _test_eof846;

            case 846:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1497;

                case 22:
                    goto st847;
                }

                goto st0;
st847:

                if ( ++p == pe )
                    goto _test_eof847;

            case 847:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1468;

                case 5:
                    goto tr1468;

                case 8:
                    goto tr1468;

                case 18:
                    goto tr1469;

                case 21:
                    goto tr1469;

                case 23:
                    goto tr1469;

                case 36:
                    goto tr1469;

                case 44:
                    goto tr1469;

                case 48:
                    goto st836;

                case 53:
                    goto st837;

                case 54:
                    goto st838;

                case 55:
                    goto st839;

                case 56:
                    goto st840;

                case 57:
                    goto st841;

                case 58:
                    goto st842;

                case 59:
                    goto st843;

                case 60:
                    goto st844;

                case 61:
                    goto st845;

                case 62:
                    goto st848;

                case 79:
                    goto st849;

                case 80:
                    goto st850;

                case 81:
                    goto st860;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1469;

                goto st0;
st848:

                if ( ++p == pe )
                    goto _test_eof848;

            case 848:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1497;

                goto st0;
st849:

                if ( ++p == pe )
                    goto _test_eof849;

            case 849:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1500;

                goto st0;
st850:

                if ( ++p == pe )
                    goto _test_eof850;

            case 850:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st851;

                case 21:
                    goto st852;

                case 23:
                    goto st856;
                }

                goto st0;
st851:

                if ( ++p == pe )
                    goto _test_eof851;

            case 851:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1504;

                goto st0;
st852:

                if ( ++p == pe )
                    goto _test_eof852;

            case 852:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1505;

                case 5:
                    goto tr1505;

                case 8:
                    goto tr1505;

                case 18:
                    goto tr1506;

                case 21:
                    goto tr1506;

                case 23:
                    goto tr1506;

                case 36:
                    goto tr1506;

                case 44:
                    goto tr1506;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1506;

                goto st0;
tr1505:

                {
                    expr_start = p;
                }
                goto st853;
st853:

                if ( ++p == pe )
                    goto _test_eof853;

            case 853:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1507;

                case 23:
                    goto st24;

                case 37:
                    goto st853;
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
tr1507:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st854;
st854:

                if ( ++p == pe )
                    goto _test_eof854;

            case 854:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1509;

                case 19:
                    goto tr1507;

                case 23:
                    goto st24;

                case 37:
                    goto st853;
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
tr1506:

                {
                    expr_start = p;
                }
                goto st855;
st855:

                if ( ++p == pe )
                    goto _test_eof855;

            case 855:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st853;

                case 5:
                    goto st853;

                case 8:
                    goto st853;

                case 13:
                    goto st855;

                case 18:
                    goto st855;

                case 21:
                    goto st855;

                case 23:
                    goto st855;

                case 36:
                    goto st855;

                case 44:
                    goto st855;
                }

                goto st0;
st856:

                if ( ++p == pe )
                    goto _test_eof856;

            case 856:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1511;

                case 5:
                    goto tr1511;

                case 8:
                    goto tr1511;

                case 18:
                    goto tr1512;

                case 21:
                    goto tr1512;

                case 23:
                    goto tr1512;

                case 36:
                    goto tr1512;

                case 44:
                    goto tr1512;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1512;

                goto st0;
tr1511:

                {
                    expr_start = p;
                }
                goto st857;
st857:

                if ( ++p == pe )
                    goto _test_eof857;

            case 857:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1513;

                case 23:
                    goto st24;

                case 37:
                    goto st857;
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
tr1513:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st858;
st858:

                if ( ++p == pe )
                    goto _test_eof858;

            case 858:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1515;

                case 19:
                    goto tr1513;

                case 23:
                    goto st24;

                case 37:
                    goto st857;
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
tr1512:

                {
                    expr_start = p;
                }
                goto st859;
st859:

                if ( ++p == pe )
                    goto _test_eof859;

            case 859:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st857;

                case 5:
                    goto st857;

                case 8:
                    goto st857;

                case 13:
                    goto st859;

                case 18:
                    goto st859;

                case 21:
                    goto st859;

                case 23:
                    goto st859;

                case 36:
                    goto st859;

                case 44:
                    goto st859;
                }

                goto st0;
st860:

                if ( ++p == pe )
                    goto _test_eof860;

            case 860:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st861;

                case 21:
                    goto st862;

                case 23:
                    goto st866;
                }

                goto st0;
st861:

                if ( ++p == pe )
                    goto _test_eof861;

            case 861:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1520;

                goto st0;
st862:

                if ( ++p == pe )
                    goto _test_eof862;

            case 862:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1521;

                case 5:
                    goto tr1521;

                case 8:
                    goto tr1521;

                case 18:
                    goto tr1522;

                case 21:
                    goto tr1522;

                case 23:
                    goto tr1522;

                case 36:
                    goto tr1522;

                case 44:
                    goto tr1522;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1522;

                goto st0;
tr1521:

                {
                    expr_start = p;
                }
                goto st863;
st863:

                if ( ++p == pe )
                    goto _test_eof863;

            case 863:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1523;

                case 23:
                    goto st24;

                case 37:
                    goto st863;
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
tr1523:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st864;
st864:

                if ( ++p == pe )
                    goto _test_eof864;

            case 864:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1525;

                case 19:
                    goto tr1523;

                case 23:
                    goto st24;

                case 37:
                    goto st863;
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
tr1522:

                {
                    expr_start = p;
                }
                goto st865;
st865:

                if ( ++p == pe )
                    goto _test_eof865;

            case 865:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st863;

                case 5:
                    goto st863;

                case 8:
                    goto st863;

                case 13:
                    goto st865;

                case 18:
                    goto st865;

                case 21:
                    goto st865;

                case 23:
                    goto st865;

                case 36:
                    goto st865;

                case 44:
                    goto st865;
                }

                goto st0;
st866:

                if ( ++p == pe )
                    goto _test_eof866;

            case 866:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1527;

                case 5:
                    goto tr1527;

                case 8:
                    goto tr1527;

                case 18:
                    goto tr1528;

                case 21:
                    goto tr1528;

                case 23:
                    goto tr1528;

                case 36:
                    goto tr1528;

                case 44:
                    goto tr1528;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1528;

                goto st0;
tr1527:

                {
                    expr_start = p;
                }
                goto st867;
st867:

                if ( ++p == pe )
                    goto _test_eof867;

            case 867:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1529;

                case 23:
                    goto st24;

                case 37:
                    goto st867;
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
tr1529:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st868;
st868:

                if ( ++p == pe )
                    goto _test_eof868;

            case 868:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1531;

                case 19:
                    goto tr1529;

                case 23:
                    goto st24;

                case 37:
                    goto st867;
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
tr1528:

                {
                    expr_start = p;
                }
                goto st869;
st869:

                if ( ++p == pe )
                    goto _test_eof869;

            case 869:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st867;

                case 5:
                    goto st867;

                case 8:
                    goto st867;

                case 13:
                    goto st869;

                case 18:
                    goto st869;

                case 21:
                    goto st869;

                case 23:
                    goto st869;

                case 36:
                    goto st869;

                case 44:
                    goto st869;
                }

                goto st0;
            }

_test_eof870:
            cs = 870;
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
_test_eof530:
            cs = 530;
            goto _test_eof;
_test_eof531:
            cs = 531;
            goto _test_eof;
_test_eof532:
            cs = 532;
            goto _test_eof;
_test_eof533:
            cs = 533;
            goto _test_eof;
_test_eof534:
            cs = 534;
            goto _test_eof;
_test_eof535:
            cs = 535;
            goto _test_eof;
_test_eof536:
            cs = 536;
            goto _test_eof;
_test_eof537:
            cs = 537;
            goto _test_eof;
_test_eof538:
            cs = 538;
            goto _test_eof;
_test_eof539:
            cs = 539;
            goto _test_eof;
_test_eof540:
            cs = 540;
            goto _test_eof;
_test_eof541:
            cs = 541;
            goto _test_eof;
_test_eof542:
            cs = 542;
            goto _test_eof;
_test_eof543:
            cs = 543;
            goto _test_eof;
_test_eof544:
            cs = 544;
            goto _test_eof;
_test_eof545:
            cs = 545;
            goto _test_eof;
_test_eof546:
            cs = 546;
            goto _test_eof;
_test_eof547:
            cs = 547;
            goto _test_eof;
_test_eof548:
            cs = 548;
            goto _test_eof;
_test_eof549:
            cs = 549;
            goto _test_eof;
_test_eof550:
            cs = 550;
            goto _test_eof;
_test_eof551:
            cs = 551;
            goto _test_eof;
_test_eof552:
            cs = 552;
            goto _test_eof;
_test_eof553:
            cs = 553;
            goto _test_eof;
_test_eof554:
            cs = 554;
            goto _test_eof;
_test_eof555:
            cs = 555;
            goto _test_eof;
_test_eof556:
            cs = 556;
            goto _test_eof;
_test_eof557:
            cs = 557;
            goto _test_eof;
_test_eof558:
            cs = 558;
            goto _test_eof;
_test_eof559:
            cs = 559;
            goto _test_eof;
_test_eof560:
            cs = 560;
            goto _test_eof;
_test_eof561:
            cs = 561;
            goto _test_eof;
_test_eof562:
            cs = 562;
            goto _test_eof;
_test_eof563:
            cs = 563;
            goto _test_eof;
_test_eof564:
            cs = 564;
            goto _test_eof;
_test_eof565:
            cs = 565;
            goto _test_eof;
_test_eof566:
            cs = 566;
            goto _test_eof;
_test_eof567:
            cs = 567;
            goto _test_eof;
_test_eof568:
            cs = 568;
            goto _test_eof;
_test_eof569:
            cs = 569;
            goto _test_eof;
_test_eof570:
            cs = 570;
            goto _test_eof;
_test_eof571:
            cs = 571;
            goto _test_eof;
_test_eof572:
            cs = 572;
            goto _test_eof;
_test_eof573:
            cs = 573;
            goto _test_eof;
_test_eof574:
            cs = 574;
            goto _test_eof;
_test_eof575:
            cs = 575;
            goto _test_eof;
_test_eof576:
            cs = 576;
            goto _test_eof;
_test_eof577:
            cs = 577;
            goto _test_eof;
_test_eof578:
            cs = 578;
            goto _test_eof;
_test_eof579:
            cs = 579;
            goto _test_eof;
_test_eof580:
            cs = 580;
            goto _test_eof;
_test_eof581:
            cs = 581;
            goto _test_eof;
_test_eof582:
            cs = 582;
            goto _test_eof;
_test_eof583:
            cs = 583;
            goto _test_eof;
_test_eof584:
            cs = 584;
            goto _test_eof;
_test_eof585:
            cs = 585;
            goto _test_eof;
_test_eof586:
            cs = 586;
            goto _test_eof;
_test_eof587:
            cs = 587;
            goto _test_eof;
_test_eof588:
            cs = 588;
            goto _test_eof;
_test_eof589:
            cs = 589;
            goto _test_eof;
_test_eof590:
            cs = 590;
            goto _test_eof;
_test_eof591:
            cs = 591;
            goto _test_eof;
_test_eof592:
            cs = 592;
            goto _test_eof;
_test_eof593:
            cs = 593;
            goto _test_eof;
_test_eof594:
            cs = 594;
            goto _test_eof;
_test_eof595:
            cs = 595;
            goto _test_eof;
_test_eof596:
            cs = 596;
            goto _test_eof;
_test_eof597:
            cs = 597;
            goto _test_eof;
_test_eof598:
            cs = 598;
            goto _test_eof;
_test_eof599:
            cs = 599;
            goto _test_eof;
_test_eof600:
            cs = 600;
            goto _test_eof;
_test_eof601:
            cs = 601;
            goto _test_eof;
_test_eof602:
            cs = 602;
            goto _test_eof;
_test_eof603:
            cs = 603;
            goto _test_eof;
_test_eof604:
            cs = 604;
            goto _test_eof;
_test_eof605:
            cs = 605;
            goto _test_eof;
_test_eof606:
            cs = 606;
            goto _test_eof;
_test_eof607:
            cs = 607;
            goto _test_eof;
_test_eof608:
            cs = 608;
            goto _test_eof;
_test_eof609:
            cs = 609;
            goto _test_eof;
_test_eof610:
            cs = 610;
            goto _test_eof;
_test_eof611:
            cs = 611;
            goto _test_eof;
_test_eof612:
            cs = 612;
            goto _test_eof;
_test_eof613:
            cs = 613;
            goto _test_eof;
_test_eof614:
            cs = 614;
            goto _test_eof;
_test_eof615:
            cs = 615;
            goto _test_eof;
_test_eof616:
            cs = 616;
            goto _test_eof;
_test_eof617:
            cs = 617;
            goto _test_eof;
_test_eof618:
            cs = 618;
            goto _test_eof;
_test_eof619:
            cs = 619;
            goto _test_eof;
_test_eof620:
            cs = 620;
            goto _test_eof;
_test_eof621:
            cs = 621;
            goto _test_eof;
_test_eof622:
            cs = 622;
            goto _test_eof;
_test_eof623:
            cs = 623;
            goto _test_eof;
_test_eof624:
            cs = 624;
            goto _test_eof;
_test_eof625:
            cs = 625;
            goto _test_eof;
_test_eof626:
            cs = 626;
            goto _test_eof;
_test_eof627:
            cs = 627;
            goto _test_eof;
_test_eof628:
            cs = 628;
            goto _test_eof;
_test_eof629:
            cs = 629;
            goto _test_eof;
_test_eof630:
            cs = 630;
            goto _test_eof;
_test_eof631:
            cs = 631;
            goto _test_eof;
_test_eof632:
            cs = 632;
            goto _test_eof;
_test_eof633:
            cs = 633;
            goto _test_eof;
_test_eof634:
            cs = 634;
            goto _test_eof;
_test_eof635:
            cs = 635;
            goto _test_eof;
_test_eof636:
            cs = 636;
            goto _test_eof;
_test_eof637:
            cs = 637;
            goto _test_eof;
_test_eof638:
            cs = 638;
            goto _test_eof;
_test_eof639:
            cs = 639;
            goto _test_eof;
_test_eof640:
            cs = 640;
            goto _test_eof;
_test_eof641:
            cs = 641;
            goto _test_eof;
_test_eof642:
            cs = 642;
            goto _test_eof;
_test_eof643:
            cs = 643;
            goto _test_eof;
_test_eof644:
            cs = 644;
            goto _test_eof;
_test_eof645:
            cs = 645;
            goto _test_eof;
_test_eof646:
            cs = 646;
            goto _test_eof;
_test_eof647:
            cs = 647;
            goto _test_eof;
_test_eof648:
            cs = 648;
            goto _test_eof;
_test_eof649:
            cs = 649;
            goto _test_eof;
_test_eof650:
            cs = 650;
            goto _test_eof;
_test_eof651:
            cs = 651;
            goto _test_eof;
_test_eof652:
            cs = 652;
            goto _test_eof;
_test_eof653:
            cs = 653;
            goto _test_eof;
_test_eof654:
            cs = 654;
            goto _test_eof;
_test_eof655:
            cs = 655;
            goto _test_eof;
_test_eof656:
            cs = 656;
            goto _test_eof;
_test_eof657:
            cs = 657;
            goto _test_eof;
_test_eof658:
            cs = 658;
            goto _test_eof;
_test_eof659:
            cs = 659;
            goto _test_eof;
_test_eof660:
            cs = 660;
            goto _test_eof;
_test_eof661:
            cs = 661;
            goto _test_eof;
_test_eof662:
            cs = 662;
            goto _test_eof;
_test_eof663:
            cs = 663;
            goto _test_eof;
_test_eof664:
            cs = 664;
            goto _test_eof;
_test_eof665:
            cs = 665;
            goto _test_eof;
_test_eof666:
            cs = 666;
            goto _test_eof;
_test_eof667:
            cs = 667;
            goto _test_eof;
_test_eof668:
            cs = 668;
            goto _test_eof;
_test_eof669:
            cs = 669;
            goto _test_eof;
_test_eof670:
            cs = 670;
            goto _test_eof;
_test_eof671:
            cs = 671;
            goto _test_eof;
_test_eof672:
            cs = 672;
            goto _test_eof;
_test_eof673:
            cs = 673;
            goto _test_eof;
_test_eof674:
            cs = 674;
            goto _test_eof;
_test_eof675:
            cs = 675;
            goto _test_eof;
_test_eof676:
            cs = 676;
            goto _test_eof;
_test_eof677:
            cs = 677;
            goto _test_eof;
_test_eof678:
            cs = 678;
            goto _test_eof;
_test_eof679:
            cs = 679;
            goto _test_eof;
_test_eof680:
            cs = 680;
            goto _test_eof;
_test_eof681:
            cs = 681;
            goto _test_eof;
_test_eof682:
            cs = 682;
            goto _test_eof;
_test_eof683:
            cs = 683;
            goto _test_eof;
_test_eof684:
            cs = 684;
            goto _test_eof;
_test_eof685:
            cs = 685;
            goto _test_eof;
_test_eof686:
            cs = 686;
            goto _test_eof;
_test_eof687:
            cs = 687;
            goto _test_eof;
_test_eof688:
            cs = 688;
            goto _test_eof;
_test_eof689:
            cs = 689;
            goto _test_eof;
_test_eof690:
            cs = 690;
            goto _test_eof;
_test_eof691:
            cs = 691;
            goto _test_eof;
_test_eof692:
            cs = 692;
            goto _test_eof;
_test_eof693:
            cs = 693;
            goto _test_eof;
_test_eof694:
            cs = 694;
            goto _test_eof;
_test_eof695:
            cs = 695;
            goto _test_eof;
_test_eof696:
            cs = 696;
            goto _test_eof;
_test_eof697:
            cs = 697;
            goto _test_eof;
_test_eof698:
            cs = 698;
            goto _test_eof;
_test_eof699:
            cs = 699;
            goto _test_eof;
_test_eof700:
            cs = 700;
            goto _test_eof;
_test_eof701:
            cs = 701;
            goto _test_eof;
_test_eof702:
            cs = 702;
            goto _test_eof;
_test_eof703:
            cs = 703;
            goto _test_eof;
_test_eof704:
            cs = 704;
            goto _test_eof;
_test_eof705:
            cs = 705;
            goto _test_eof;
_test_eof706:
            cs = 706;
            goto _test_eof;
_test_eof707:
            cs = 707;
            goto _test_eof;
_test_eof708:
            cs = 708;
            goto _test_eof;
_test_eof709:
            cs = 709;
            goto _test_eof;
_test_eof710:
            cs = 710;
            goto _test_eof;
_test_eof711:
            cs = 711;
            goto _test_eof;
_test_eof712:
            cs = 712;
            goto _test_eof;
_test_eof713:
            cs = 713;
            goto _test_eof;
_test_eof714:
            cs = 714;
            goto _test_eof;
_test_eof715:
            cs = 715;
            goto _test_eof;
_test_eof716:
            cs = 716;
            goto _test_eof;
_test_eof717:
            cs = 717;
            goto _test_eof;
_test_eof718:
            cs = 718;
            goto _test_eof;
_test_eof719:
            cs = 719;
            goto _test_eof;
_test_eof720:
            cs = 720;
            goto _test_eof;
_test_eof721:
            cs = 721;
            goto _test_eof;
_test_eof722:
            cs = 722;
            goto _test_eof;
_test_eof723:
            cs = 723;
            goto _test_eof;
_test_eof724:
            cs = 724;
            goto _test_eof;
_test_eof725:
            cs = 725;
            goto _test_eof;
_test_eof726:
            cs = 726;
            goto _test_eof;
_test_eof727:
            cs = 727;
            goto _test_eof;
_test_eof728:
            cs = 728;
            goto _test_eof;
_test_eof729:
            cs = 729;
            goto _test_eof;
_test_eof730:
            cs = 730;
            goto _test_eof;
_test_eof731:
            cs = 731;
            goto _test_eof;
_test_eof732:
            cs = 732;
            goto _test_eof;
_test_eof733:
            cs = 733;
            goto _test_eof;
_test_eof734:
            cs = 734;
            goto _test_eof;
_test_eof735:
            cs = 735;
            goto _test_eof;
_test_eof736:
            cs = 736;
            goto _test_eof;
_test_eof737:
            cs = 737;
            goto _test_eof;
_test_eof738:
            cs = 738;
            goto _test_eof;
_test_eof739:
            cs = 739;
            goto _test_eof;
_test_eof740:
            cs = 740;
            goto _test_eof;
_test_eof741:
            cs = 741;
            goto _test_eof;
_test_eof742:
            cs = 742;
            goto _test_eof;
_test_eof743:
            cs = 743;
            goto _test_eof;
_test_eof744:
            cs = 744;
            goto _test_eof;
_test_eof745:
            cs = 745;
            goto _test_eof;
_test_eof746:
            cs = 746;
            goto _test_eof;
_test_eof747:
            cs = 747;
            goto _test_eof;
_test_eof748:
            cs = 748;
            goto _test_eof;
_test_eof749:
            cs = 749;
            goto _test_eof;
_test_eof750:
            cs = 750;
            goto _test_eof;
_test_eof751:
            cs = 751;
            goto _test_eof;
_test_eof752:
            cs = 752;
            goto _test_eof;
_test_eof753:
            cs = 753;
            goto _test_eof;
_test_eof754:
            cs = 754;
            goto _test_eof;
_test_eof755:
            cs = 755;
            goto _test_eof;
_test_eof756:
            cs = 756;
            goto _test_eof;
_test_eof757:
            cs = 757;
            goto _test_eof;
_test_eof758:
            cs = 758;
            goto _test_eof;
_test_eof759:
            cs = 759;
            goto _test_eof;
_test_eof760:
            cs = 760;
            goto _test_eof;
_test_eof761:
            cs = 761;
            goto _test_eof;
_test_eof762:
            cs = 762;
            goto _test_eof;
_test_eof763:
            cs = 763;
            goto _test_eof;
_test_eof764:
            cs = 764;
            goto _test_eof;
_test_eof765:
            cs = 765;
            goto _test_eof;
_test_eof766:
            cs = 766;
            goto _test_eof;
_test_eof767:
            cs = 767;
            goto _test_eof;
_test_eof768:
            cs = 768;
            goto _test_eof;
_test_eof769:
            cs = 769;
            goto _test_eof;
_test_eof770:
            cs = 770;
            goto _test_eof;
_test_eof771:
            cs = 771;
            goto _test_eof;
_test_eof772:
            cs = 772;
            goto _test_eof;
_test_eof773:
            cs = 773;
            goto _test_eof;
_test_eof774:
            cs = 774;
            goto _test_eof;
_test_eof775:
            cs = 775;
            goto _test_eof;
_test_eof776:
            cs = 776;
            goto _test_eof;
_test_eof777:
            cs = 777;
            goto _test_eof;
_test_eof778:
            cs = 778;
            goto _test_eof;
_test_eof779:
            cs = 779;
            goto _test_eof;
_test_eof780:
            cs = 780;
            goto _test_eof;
_test_eof781:
            cs = 781;
            goto _test_eof;
_test_eof782:
            cs = 782;
            goto _test_eof;
_test_eof783:
            cs = 783;
            goto _test_eof;
_test_eof784:
            cs = 784;
            goto _test_eof;
_test_eof785:
            cs = 785;
            goto _test_eof;
_test_eof786:
            cs = 786;
            goto _test_eof;
_test_eof787:
            cs = 787;
            goto _test_eof;
_test_eof788:
            cs = 788;
            goto _test_eof;
_test_eof789:
            cs = 789;
            goto _test_eof;
_test_eof790:
            cs = 790;
            goto _test_eof;
_test_eof791:
            cs = 791;
            goto _test_eof;
_test_eof792:
            cs = 792;
            goto _test_eof;
_test_eof793:
            cs = 793;
            goto _test_eof;
_test_eof794:
            cs = 794;
            goto _test_eof;
_test_eof795:
            cs = 795;
            goto _test_eof;
_test_eof796:
            cs = 796;
            goto _test_eof;
_test_eof797:
            cs = 797;
            goto _test_eof;
_test_eof798:
            cs = 798;
            goto _test_eof;
_test_eof799:
            cs = 799;
            goto _test_eof;
_test_eof800:
            cs = 800;
            goto _test_eof;
_test_eof801:
            cs = 801;
            goto _test_eof;
_test_eof802:
            cs = 802;
            goto _test_eof;
_test_eof803:
            cs = 803;
            goto _test_eof;
_test_eof804:
            cs = 804;
            goto _test_eof;
_test_eof805:
            cs = 805;
            goto _test_eof;
_test_eof806:
            cs = 806;
            goto _test_eof;
_test_eof807:
            cs = 807;
            goto _test_eof;
_test_eof808:
            cs = 808;
            goto _test_eof;
_test_eof809:
            cs = 809;
            goto _test_eof;
_test_eof810:
            cs = 810;
            goto _test_eof;
_test_eof811:
            cs = 811;
            goto _test_eof;
_test_eof812:
            cs = 812;
            goto _test_eof;
_test_eof813:
            cs = 813;
            goto _test_eof;
_test_eof814:
            cs = 814;
            goto _test_eof;
_test_eof815:
            cs = 815;
            goto _test_eof;
_test_eof816:
            cs = 816;
            goto _test_eof;
_test_eof817:
            cs = 817;
            goto _test_eof;
_test_eof818:
            cs = 818;
            goto _test_eof;
_test_eof819:
            cs = 819;
            goto _test_eof;
_test_eof820:
            cs = 820;
            goto _test_eof;
_test_eof821:
            cs = 821;
            goto _test_eof;
_test_eof822:
            cs = 822;
            goto _test_eof;
_test_eof823:
            cs = 823;
            goto _test_eof;
_test_eof824:
            cs = 824;
            goto _test_eof;
_test_eof825:
            cs = 825;
            goto _test_eof;
_test_eof826:
            cs = 826;
            goto _test_eof;
_test_eof827:
            cs = 827;
            goto _test_eof;
_test_eof828:
            cs = 828;
            goto _test_eof;
_test_eof829:
            cs = 829;
            goto _test_eof;
_test_eof830:
            cs = 830;
            goto _test_eof;
_test_eof831:
            cs = 831;
            goto _test_eof;
_test_eof832:
            cs = 832;
            goto _test_eof;
_test_eof833:
            cs = 833;
            goto _test_eof;
_test_eof834:
            cs = 834;
            goto _test_eof;
_test_eof835:
            cs = 835;
            goto _test_eof;
_test_eof836:
            cs = 836;
            goto _test_eof;
_test_eof837:
            cs = 837;
            goto _test_eof;
_test_eof838:
            cs = 838;
            goto _test_eof;
_test_eof839:
            cs = 839;
            goto _test_eof;
_test_eof840:
            cs = 840;
            goto _test_eof;
_test_eof841:
            cs = 841;
            goto _test_eof;
_test_eof842:
            cs = 842;
            goto _test_eof;
_test_eof843:
            cs = 843;
            goto _test_eof;
_test_eof844:
            cs = 844;
            goto _test_eof;
_test_eof845:
            cs = 845;
            goto _test_eof;
_test_eof846:
            cs = 846;
            goto _test_eof;
_test_eof847:
            cs = 847;
            goto _test_eof;
_test_eof848:
            cs = 848;
            goto _test_eof;
_test_eof849:
            cs = 849;
            goto _test_eof;
_test_eof850:
            cs = 850;
            goto _test_eof;
_test_eof851:
            cs = 851;
            goto _test_eof;
_test_eof852:
            cs = 852;
            goto _test_eof;
_test_eof853:
            cs = 853;
            goto _test_eof;
_test_eof854:
            cs = 854;
            goto _test_eof;
_test_eof855:
            cs = 855;
            goto _test_eof;
_test_eof856:
            cs = 856;
            goto _test_eof;
_test_eof857:
            cs = 857;
            goto _test_eof;
_test_eof858:
            cs = 858;
            goto _test_eof;
_test_eof859:
            cs = 859;
            goto _test_eof;
_test_eof860:
            cs = 860;
            goto _test_eof;
_test_eof861:
            cs = 861;
            goto _test_eof;
_test_eof862:
            cs = 862;
            goto _test_eof;
_test_eof863:
            cs = 863;
            goto _test_eof;
_test_eof864:
            cs = 864;
            goto _test_eof;
_test_eof865:
            cs = 865;
            goto _test_eof;
_test_eof866:
            cs = 866;
            goto _test_eof;
_test_eof867:
            cs = 867;
            goto _test_eof;
_test_eof868:
            cs = 868;
            goto _test_eof;
_test_eof869:
            cs = 869;
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

                870

           )
            return TRUE;
    }

    return FALSE;
}






















static const int parser_start = 1;
static const int parser_first_final = 774;
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
                    goto st774;

                case 4:
                    goto tr2;

                case 12:
                    goto st774;

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
                    goto st266;

                case 108:
                    goto st267;

                case 109:
                    goto st268;

                case 110:
                    goto st269;

                case 111:
                    goto st270;

                case 112:
                    goto st310;

                case 113:
                    goto st329;

                case 114:
                    goto st330;

                case 115:
                    goto st331;

                case 116:
                    goto st332;

                case 117:
                    goto st333;

                case 118:
                    goto st334;

                case 119:
                    goto st335;

                case 120:
                    goto st372;

                case 121:
                    goto st373;

                case 122:
                    goto st374;

                case 123:
                    goto st388;

                case 124:
                    goto st389;

                case 125:
                    goto st390;

                case 126:
                    goto st397;

                case 127:
                    goto st404;

                case 128:
                    goto st413;

                case 129:
                    goto st414;

                case 130:
                    goto st415;

                case 131:
                    goto st416;

                case 132:
                    goto st417;

                case 133:
                    goto st418;

                case 134:
                    goto st419;

                case 135:
                    goto st420;

                case 136:
                    goto st421;

                case 137:
                    goto st424;

                case 138:
                    goto st467;

                case 139:
                    goto st468;

                case 140:
                    goto st505;

                case 141:
                    goto st542;

                case 142:
                    goto st571;

                case 143:
                    goto st600;

                case 144:
                    goto st629;

                case 145:
                    goto st658;

                case 146:
                    goto st687;

                case 147:
                    goto st716;

                case 148:
                    goto st745;
                }

                goto st0;
st0:
                cs = 0;
                goto _out;
tr65:

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
                goto st774;
tr83:

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
                goto st774;
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

                        add_opcode( Z80_ADC( REG_C ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADC( REG_B ) );
                    };
                }
                goto st774;
tr88:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_ADC( REG_E ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADC( REG_H ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADC( REG_H ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADC( REG_H ) + P_IY );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADC( REG_L ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADC( REG_L ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADC( REG_L ) + P_IY );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADC( REG_A ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADC( REG_idx ) );
                    };
                }
                goto st774;
tr103:

                {
                    if ( compile_active )
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
                goto st774;
tr110:

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
                goto st774;
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

                            add_opcode_idx( ( Z80_ADC( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st774;
tr121:

                {
                    if ( compile_active )
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
                goto st774;
tr126:

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
                goto st774;
tr132:

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
                goto st774;
tr139:

                {
                    if ( compile_active )
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
                goto st774;
tr140:

                {
                    if ( compile_active )
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
                goto st774;
tr141:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_ADC16( REG_SP ) + 0 );
                    };
                }
                goto st774;
tr162:

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
                goto st774;
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

                        add_opcode( Z80_ADD( REG_C ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD( REG_B ) );
                    };
                }
                goto st774;
tr167:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_ADD( REG_E ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD( REG_H ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD( REG_H ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD( REG_H ) + P_IY );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD( REG_L ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD( REG_L ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD( REG_L ) + P_IY );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD( REG_A ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD( REG_idx ) );
                    };
                }
                goto st774;
tr182:

                {
                    if ( compile_active )
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
                goto st774;
tr187:

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
                goto st774;
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

                            add_opcode_idx( ( Z80_ADD( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st774;
tr198:

                {
                    if ( compile_active )
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
                goto st774;
tr203:

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
                goto st774;
tr209:

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
                goto st774;
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

                        add_opcode( Z80_ADD16( REG_BC ) + 0 );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD16( REG_DE ) + 0 );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD16( REG_HL ) + 0 );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD16( REG_SP ) + 0 );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD16( REG_BC ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD16( REG_DE ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD16( REG_IX ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_ADD16( REG_SP ) + P_IX );
                    };
                }
                goto st774;
tr234:

                {
                    if ( compile_active )
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
                goto st774;
tr235:

                {
                    if ( compile_active )
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
                goto st774;
tr236:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_ADD16( REG_SP ) + P_IY );
                    };
                }
                goto st774;
tr254:

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
                goto st774;
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

                        add_opcode( Z80_AND( REG_C ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_AND( REG_B ) );
                    };
                }
                goto st774;
tr259:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_AND( REG_E ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_AND( REG_H ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_AND( REG_H ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_AND( REG_H ) + P_IY );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_AND( REG_L ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_AND( REG_L ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_AND( REG_L ) + P_IY );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_AND( REG_A ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_AND( REG_idx ) );
                    };
                }
                goto st774;
tr274:

                {
                    if ( compile_active )
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
                goto st774;
tr279:

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
                goto st774;
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

                            add_opcode_idx( ( Z80_AND( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st774;
tr290:

                {
                    if ( compile_active )
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
                goto st774;
tr295:

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
                goto st774;
tr301:

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
                goto st774;
tr313:

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
                goto st774;
tr319:

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
                goto st774;
tr325:

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
                goto st774;
tr331:

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
                goto st774;
tr337:

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
                goto st774;
tr343:

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
                goto st774;
tr349:

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
                goto st774;
tr355:

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
                goto st774;
tr361:

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
                goto st774;
tr364:

                {
                    if ( compile_active )
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
                goto st774;
tr381:

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
                goto st774;
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

                        add_opcode( Z80_CP( REG_C ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_CP( REG_B ) );
                    };
                }
                goto st774;
tr386:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_CP( REG_E ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_CP( REG_H ) );
                    };
                }
                goto st774;
tr389:

                {
                    if ( compile_active )
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
                goto st774;
tr390:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_CP( REG_L ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_CP( REG_L ) + P_IX );
                    };
                }
                goto st774;
tr393:

                {
                    if ( compile_active )
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
                goto st774;
tr394:

                {
                    if ( compile_active )
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
                goto st774;
tr397:

                {
                    if ( compile_active )
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
                goto st774;
tr401:

                {
                    if ( compile_active )
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
                goto st774;
tr406:

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
                goto st774;
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

                            add_opcode_idx( ( Z80_CP( REG_idx ) + P_IX ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st774;
tr417:

                {
                    if ( compile_active )
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
                goto st774;
tr422:

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
                goto st774;
tr428:

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
                goto st774;
tr430:

                {
                    if ( compile_active )
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
                goto st774;
tr431:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode_emul( Z80_CPI, "rcmx_cpi" );
                    }
                }
                goto st774;
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

                        add_opcode_emul( Z80_CPIR, "rcmx_cpir" );
                    }
                }
                goto st774;
tr434:

                {
                    if ( compile_active )
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
                goto st774;
tr435:

                {
                    if ( compile_active )
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
                goto st774;
tr436:

                {
                    if ( compile_active )
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
                goto st774;
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

                            add_opcode_jr( ( Z80_DJNZ ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_EI );
                    };
                }
                goto st774;
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

                        add_opcode( ( Z80_EX_DE_HL ) );
                    };
                }
                goto st774;
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

                        add_opcode( ( Z80_EX_AF_AF ) );
                    };
                }
                goto st774;
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

                        add_opcode( ( Z80_EX_AF_AF ) );
                    };
                }
                goto st774;
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

                        add_opcode( ( Z80_EX_IND_SP_HL ) );
                    };
                }
                goto st774;
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

                        add_opcode( ( Z80_EX_IND_SP_idx + P_IX ) );
                    };
                }
                goto st774;
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

                        add_opcode( ( Z80_EX_IND_SP_idx + P_IY ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_EXX );
                    };
                }
                goto st774;
tr462:

                {
                    if ( compile_active )
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
                goto st774;
tr465:

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
                goto st774;
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

                        add_opcode( Z80_IN_REG_C( REG_C ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_IN_REG_C( REG_B ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_IN_REG_C( REG_D ) );
                    };
                }
                goto st774;
tr486:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_IN_REG_C( REG_H ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_IN_REG_C( REG_L ) );
                    };
                }
                goto st774;
tr497:

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
                goto st774;
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

                        add_opcode( Z80_IN_REG_C( REG_A ) );
                    };
                }
                goto st774;
tr501:

                {
                    if ( compile_active )
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
                goto st774;
tr502:

                {
                    if ( compile_active )
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
                goto st774;
tr503:

                {
                    if ( compile_active )
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
                goto st774;
tr504:

                {
                    if ( compile_active )
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
                goto st774;
tr518:

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
                goto st774;
tr524:

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
                goto st774;
tr530:

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
                goto st774;
tr536:

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
                goto st774;
tr542:

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
                goto st774;
tr548:

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
                goto st774;
tr554:

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
                goto st774;
tr560:

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
                goto st774;
tr566:

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
                goto st774;
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

                        add_opcode( ( Z80_JP_idx ) );
                    };
                }
                goto st774;
tr571:

                {
                    if ( compile_active )
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
                goto st774;
tr573:

                {
                    if ( compile_active )
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
                goto st774;
tr580:

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
                goto st774;
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

                            add_opcode_jr( ( Z80_JR_FLAG( FLAG_NZ ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st774;
tr592:

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
                goto st774;
tr598:

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
                goto st774;
tr604:

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
                goto st774;
tr607:

                {
                    if ( compile_active )
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
                goto st774;
tr608:

                {
                    if ( compile_active )
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
                goto st774;
tr609:

                {
                    if ( compile_active )
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
                goto st774;
tr610:

                {
                    if ( compile_active )
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
                goto st774;
tr611:

                {
                    if ( compile_active )
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
                goto st774;
tr612:

                {
                    if ( compile_active )
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
                goto st774;
tr629:

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
                goto st774;
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

                        add_opcode( Z80_OR( REG_C ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_OR( REG_B ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_OR( REG_D ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_OR( REG_E ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_OR( REG_H ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_OR( REG_H ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_OR( REG_H ) + P_IY );
                    };
                }
                goto st774;
tr639:

                {
                    if ( compile_active )
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
                goto st774;
tr640:

                {
                    if ( compile_active )
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
                goto st774;
tr641:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_OR( REG_A ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_OR( REG_idx ) );
                    };
                }
                goto st774;
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

                        add_opcode( ( Z80_OR( REG_idx ) + P_IX ) << 8 );
                    };
                }
                goto st774;
tr654:

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
                goto st774;
tr660:

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
                goto st774;
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

                        add_opcode( ( Z80_OR( REG_idx ) + P_IY ) << 8 );
                    };
                }
                goto st774;
tr670:

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
                goto st774;
tr676:

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
                goto st774;
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

                        add_opcode( Z80_OTDR );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_OTIR );
                    };
                }
                goto st774;
tr687:

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
                goto st774;
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

                        add_opcode( Z80_OUT_C_REG( REG_C ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_OUT_C_REG( REG_B ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_OUT_C_REG( REG_D ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_OUT_C_REG( REG_E ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_OUT_C_REG( REG_H ) );
                    };
                }
                goto st774;
tr701:

                {
                    if ( compile_active )
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
                goto st774;
tr702:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_OUTD );
                    };
                }
                goto st774;
tr704:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_POP( REG_BC ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_POP( REG_DE ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_POP( REG_HL ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_POP( REG_HL ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_POP( REG_HL ) + P_IY );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_POP( REG_AF ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_PUSH( REG_BC ) );
                    };
                }
                goto st774;
tr724:

                {
                    if ( compile_active )
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
                goto st774;
tr725:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_PUSH( REG_HL ) + P_IX );
                    };
                }
                goto st774;
tr727:

                {
                    if ( compile_active )
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
                goto st774;
tr728:

                {
                    if ( compile_active )
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
                goto st774;
tr729:

                {
                    if ( compile_active )
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
                goto st774;
tr738:

                {
                    if ( compile_active )
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
                goto st774;
tr739:

                {
                    if ( compile_active )
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
                goto st774;
tr740:

                {
                    if ( compile_active )
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
                goto st774;
tr741:

                {
                    if ( compile_active )
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
                goto st774;
tr742:

                {
                    if ( compile_active )
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
                goto st774;
tr743:

                {
                    if ( compile_active )
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
                goto st774;
tr744:

                {
                    if ( compile_active )
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
                goto st774;
tr745:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_RETI );
                    };
                }
                goto st774;
tr747:

                {
                    if ( compile_active )
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
                goto st774;
tr748:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_RLCA );
                    };
                }
                goto st774;
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

                        add_opcode_emul( Z80_RLD, "rcmx_rld" );
                    }
                }
                goto st774;
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

                        add_opcode( Z80_RRA );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_RRCA );
                    };
                }
                goto st774;
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

                        add_opcode_emul( Z80_RRD, "rcmx_rrd" );
                    }
                }
                goto st774;
tr756:

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
                goto st774;
tr776:

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
                goto st774;
tr779:

                {
                    if ( compile_active )
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
                goto st774;
tr780:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_SBC( REG_D ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SBC( REG_E ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SBC( REG_H ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SBC( REG_H ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SBC( REG_H ) + P_IY );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SBC( REG_L ) );
                    };
                }
                goto st774;
tr787:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_SBC( REG_L ) + P_IY );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SBC( REG_A ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SBC( REG_idx ) );
                    };
                }
                goto st774;
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

                        add_opcode( ( Z80_SBC( REG_idx ) + P_IX ) << 8 );
                    };
                }
                goto st774;
tr801:

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
                goto st774;
tr807:

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
                goto st774;
tr812:

                {
                    if ( compile_active )
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
                goto st774;
tr817:

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
                goto st774;
tr823:

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
                goto st774;
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

                        add_opcode( Z80_SBC16( REG_BC ) + 0 );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SBC16( REG_DE ) + 0 );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SBC16( REG_HL ) + 0 );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SBC16( REG_SP ) + 0 );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SCF );
                    };
                }
                goto st774;
tr851:

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
                goto st774;
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

                        add_opcode( Z80_SUB( REG_C ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SUB( REG_B ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SUB( REG_D ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SUB( REG_E ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SUB( REG_H ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SUB( REG_H ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SUB( REG_H ) + P_IY );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SUB( REG_L ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SUB( REG_L ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_SUB( REG_L ) + P_IY );
                    };
                }
                goto st774;
tr864:

                {
                    if ( compile_active )
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
                goto st774;
tr867:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( ( Z80_SUB( REG_idx ) + P_IX ) << 8 );
                    };
                }
                goto st774;
tr876:

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
                goto st774;
tr882:

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
                goto st774;
tr887:

                {
                    if ( compile_active )
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
                goto st774;
tr892:

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
                goto st774;
tr898:

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
                goto st774;
tr916:

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
                goto st774;
tr919:

                {
                    if ( compile_active )
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
                goto st774;
tr920:

                {
                    if ( compile_active )
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
                goto st774;
tr921:

                {
                    if ( compile_active )
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
                goto st774;
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

                        add_opcode( Z80_XOR( REG_E ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_XOR( REG_H ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_XOR( REG_H ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_XOR( REG_H ) + P_IY );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_XOR( REG_L ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_XOR( REG_L ) + P_IX );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_XOR( REG_L ) + P_IY );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_XOR( REG_A ) );
                    };
                }
                goto st774;
tr932:

                {
                    if ( compile_active )
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
                goto st774;
tr936:

                {
                    if ( compile_active )
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
                goto st774;
tr941:

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
                goto st774;
tr947:

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
                goto st774;
tr952:

                {
                    if ( compile_active )
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
                goto st774;
tr957:

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
                goto st774;
tr963:

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
                goto st774;
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

                        add_opcode( Z80_RLC( REG_C ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_RLC( REG_B ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_RLC( REG_D ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_RLC( REG_E ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_RLC( REG_H ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_RLC( REG_L ) );
                    };
                }
                goto st774;
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

                        add_opcode( Z80_RLC( REG_A ) );
                    };
                }
                goto st774;
tr982:

                {
                    if ( compile_active )
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
                goto st774;
tr986:

                {
                    if ( compile_active )
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
                goto st774;
tr991:

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
                goto st774;
tr997:

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
                goto st774;
tr1002:

                {
                    if ( compile_active )
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
                goto st774;
tr1007:

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
                goto st774;
tr1013:

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
                goto st774;
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
                goto st774;
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
                goto st774;
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
                goto st774;
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
                goto st774;
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
                goto st774;
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
                goto st774;
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
                goto st774;
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
                goto st774;
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
                goto st774;
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
                goto st774;
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
                goto st774;
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
                goto st774;
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
                goto st774;
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
                goto st774;
tr1075:

                {
                    if ( compile_active )
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
                goto st774;
tr1076:

                {
                    if ( compile_active )
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
                goto st774;
tr1077:

                {
                    if ( compile_active )
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
                goto st774;
tr1078:

                {
                    if ( compile_active )
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
                goto st774;
tr1079:

                {
                    if ( compile_active )
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
                goto st774;
tr1080:

                {
                    if ( compile_active )
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
                goto st774;
tr1081:

                {
                    if ( compile_active )
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
                goto st774;
tr1082:

                {
                    if ( compile_active )
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
                goto st774;
tr1086:

                {
                    if ( compile_active )
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
                goto st774;
tr1091:

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
                goto st774;
tr1097:

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
                goto st774;
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

                        add_opcode( ( ( P_IY << 16 ) & 0xFF000000 ) + ( ( Z80_RL( REG_idx ) << 8 ) & 0xFF0000 ) + ( ( 0 << 8 ) & 0xFF00 ) + ( ( Z80_RL( REG_idx ) << 0 ) & 0xFF ) );
                    };
                }
                goto st774;
tr1107:

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
                goto st774;
tr1113:

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
                goto st774;
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

                        add_opcode( Z80_RR( REG_C ) );
                    };
                }
                goto st774;
tr1126:

                {
                    if ( compile_active )
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
                goto st774;
tr1127:

                {
                    if ( compile_active )
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
                goto st774;
tr1128:

                {
                    if ( compile_active )
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
                goto st774;
tr1129:

                {
                    if ( compile_active )
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
                goto st774;
tr1130:

                {
                    if ( compile_active )
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
                goto st774;
tr1131:

                {
                    if ( compile_active )
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
                goto st774;
tr1132:

                {
                    if ( compile_active )
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
                goto st774;
tr1136:

                {
                    if ( compile_active )
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
                goto st774;
tr1141:

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
                goto st774;
tr1147:

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
                goto st774;
tr1152:

                {
                    if ( compile_active )
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
                goto st774;
tr1157:

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
                goto st774;
tr1163:

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
                goto st774;
tr1175:

                {
                    if ( compile_active )
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
                goto st774;
tr1176:

                {
                    if ( compile_active )
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
                goto st774;
tr1177:

                {
                    if ( compile_active )
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
                goto st774;
tr1178:

                {
                    if ( compile_active )
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
                goto st774;
tr1179:

                {
                    if ( compile_active )
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
                goto st774;
tr1180:

                {
                    if ( compile_active )
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
                goto st774;
tr1181:

                {
                    if ( compile_active )
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
                goto st774;
tr1182:

                {
                    if ( compile_active )
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
                goto st774;
tr1186:

                {
                    if ( compile_active )
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
                goto st774;
tr1191:

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
                goto st774;
tr1197:

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
                goto st774;
tr1202:

                {
                    if ( compile_active )
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
                goto st774;
tr1207:

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
                goto st774;
tr1213:

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
                goto st774;
tr1225:

                {
                    if ( compile_active )
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
                goto st774;
tr1226:

                {
                    if ( compile_active )
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
                goto st774;
tr1227:

                {
                    if ( compile_active )
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
                goto st774;
tr1228:

                {
                    if ( compile_active )
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
                goto st774;
tr1229:

                {
                    if ( compile_active )
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
                goto st774;
tr1230:

                {
                    if ( compile_active )
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
                goto st774;
tr1231:

                {
                    if ( compile_active )
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
                goto st774;
tr1232:

                {
                    if ( compile_active )
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
                goto st774;
tr1236:

                {
                    if ( compile_active )
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
                goto st774;
tr1241:

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
                goto st774;
tr1247:

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
                goto st774;
tr1252:

                {
                    if ( compile_active )
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
                goto st774;
tr1257:

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
                goto st774;
tr1263:

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
                goto st774;
tr1275:

                {
                    if ( compile_active )
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
                goto st774;
tr1276:

                {
                    if ( compile_active )
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
                goto st774;
tr1277:

                {
                    if ( compile_active )
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
                goto st774;
tr1278:

                {
                    if ( compile_active )
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
                goto st774;
tr1279:

                {
                    if ( compile_active )
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
                goto st774;
tr1280:

                {
                    if ( compile_active )
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
                goto st774;
tr1281:

                {
                    if ( compile_active )
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
                goto st774;
tr1282:

                {
                    if ( compile_active )
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
                goto st774;
tr1286:

                {
                    if ( compile_active )
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
                goto st774;
tr1291:

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
                goto st774;
tr1297:

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
                goto st774;
tr1302:

                {
                    if ( compile_active )
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
                goto st774;
tr1307:

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
                goto st774;
tr1313:

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
                goto st774;
tr1325:

                {
                    if ( compile_active )
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
                goto st774;
tr1326:

                {
                    if ( compile_active )
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
                goto st774;
tr1327:

                {
                    if ( compile_active )
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
                goto st774;
tr1328:

                {
                    if ( compile_active )
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
                goto st774;
tr1329:

                {
                    if ( compile_active )
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
                goto st774;
tr1330:

                {
                    if ( compile_active )
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
                goto st774;
tr1331:

                {
                    if ( compile_active )
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
                goto st774;
tr1332:

                {
                    if ( compile_active )
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
                goto st774;
tr1336:

                {
                    if ( compile_active )
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
                goto st774;
tr1341:

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
                goto st774;
tr1347:

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
                goto st774;
tr1352:

                {
                    if ( compile_active )
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
                goto st774;
tr1357:

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
                goto st774;
tr1363:

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
                goto st774;
st774:

                if ( ++p == pe )
                    goto _test_eof774;

            case 774:

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
                    goto tr65;

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
                    goto st266;

                case 108:
                    goto st267;

                case 109:
                    goto st268;

                case 110:
                    goto st269;

                case 111:
                    goto st270;

                case 112:
                    goto st310;

                case 113:
                    goto st329;

                case 114:
                    goto st330;

                case 115:
                    goto st331;

                case 116:
                    goto st332;

                case 117:
                    goto st333;

                case 118:
                    goto st334;

                case 119:
                    goto st335;

                case 120:
                    goto st372;

                case 121:
                    goto st373;

                case 122:
                    goto st374;

                case 123:
                    goto st388;

                case 124:
                    goto st389;

                case 125:
                    goto st390;

                case 126:
                    goto st397;

                case 127:
                    goto st404;

                case 128:
                    goto st413;

                case 129:
                    goto st414;

                case 130:
                    goto st415;

                case 131:
                    goto st416;

                case 132:
                    goto st417;

                case 133:
                    goto st418;

                case 134:
                    goto st419;

                case 135:
                    goto st420;

                case 136:
                    goto st421;

                case 137:
                    goto st424;

                case 138:
                    goto st467;

                case 139:
                    goto st468;

                case 140:
                    goto st505;

                case 141:
                    goto st542;

                case 142:
                    goto st571;

                case 143:
                    goto st600;

                case 144:
                    goto st629;

                case 145:
                    goto st658;

                case 146:
                    goto st687;

                case 147:
                    goto st716;

                case 148:
                    goto st745;
                }

                goto st0;
st3:

                if ( ++p == pe )
                    goto _test_eof3;

            case 3:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr66;

                case 5:
                    goto tr66;

                case 8:
                    goto tr66;

                case 18:
                    goto tr67;

                case 21:
                    goto tr67;

                case 23:
                    goto tr67;

                case 36:
                    goto tr67;

                case 44:
                    goto tr67;

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
                    goto tr67;

                goto st0;
tr66:

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
                    goto tr83;

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
tr67:

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
                    goto tr86;

                goto st0;
st7:

                if ( ++p == pe )
                    goto _test_eof7;

            case 7:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr87;

                goto st0;
st8:

                if ( ++p == pe )
                    goto _test_eof8;

            case 8:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr88;

                goto st0;
st9:

                if ( ++p == pe )
                    goto _test_eof9;

            case 9:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr89;

                goto st0;
st10:

                if ( ++p == pe )
                    goto _test_eof10;

            case 10:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr90;

                goto st0;
st11:

                if ( ++p == pe )
                    goto _test_eof11;

            case 11:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr91;

                goto st0;
st12:

                if ( ++p == pe )
                    goto _test_eof12;

            case 12:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr92;

                goto st0;
st13:

                if ( ++p == pe )
                    goto _test_eof13;

            case 13:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr93;

                goto st0;
st14:

                if ( ++p == pe )
                    goto _test_eof14;

            case 14:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr94;

                goto st0;
st15:

                if ( ++p == pe )
                    goto _test_eof15;

            case 15:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr95;

                goto st0;
st16:

                if ( ++p == pe )
                    goto _test_eof16;

            case 16:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr96;

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
                    goto tr66;

                case 5:
                    goto tr66;

                case 8:
                    goto tr66;

                case 18:
                    goto tr67;

                case 21:
                    goto tr67;

                case 23:
                    goto tr67;

                case 36:
                    goto tr67;

                case 44:
                    goto tr67;

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
                    goto tr67;

                goto st0;
st18:

                if ( ++p == pe )
                    goto _test_eof18;

            case 18:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr96;

                goto st0;
st19:

                if ( ++p == pe )
                    goto _test_eof19;

            case 19:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr99;

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
                    goto tr103;

                goto st0;
st22:

                if ( ++p == pe )
                    goto _test_eof22;

            case 22:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr104;

                case 5:
                    goto tr104;

                case 8:
                    goto tr104;

                case 18:
                    goto tr105;

                case 21:
                    goto tr105;

                case 23:
                    goto tr105;

                case 36:
                    goto tr105;

                case 44:
                    goto tr105;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr105;

                goto st0;
tr104:

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
                    goto tr107;

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
tr107:

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
                    goto tr110;

                case 19:
                    goto tr107;

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
tr105:

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
                goto st29;
st29:

                if ( ++p == pe )
                    goto _test_eof29;

            case 29:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr114;

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
tr114:

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
                    goto tr116;

                case 19:
                    goto tr114;

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
tr113:

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
                    goto tr121;

                goto st0;
st34:

                if ( ++p == pe )
                    goto _test_eof34;

            case 34:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr122;

                case 5:
                    goto tr122;

                case 8:
                    goto tr122;

                case 18:
                    goto tr123;

                case 21:
                    goto tr123;

                case 23:
                    goto tr123;

                case 36:
                    goto tr123;

                case 44:
                    goto tr123;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr123;

                goto st0;
tr122:

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
                    goto tr124;

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
tr124:

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
                    goto tr126;

                case 19:
                    goto tr124;

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
tr123:

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
                    goto tr128;

                case 5:
                    goto tr128;

                case 8:
                    goto tr128;

                case 18:
                    goto tr129;

                case 21:
                    goto tr129;

                case 23:
                    goto tr129;

                case 36:
                    goto tr129;

                case 44:
                    goto tr129;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr129;

                goto st0;
tr128:

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
                    goto tr130;

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
tr130:

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
                    goto tr132;

                case 19:
                    goto tr130;

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
tr129:

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
                    goto tr139;

                goto st0;
st45:

                if ( ++p == pe )
                    goto _test_eof45;

            case 45:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr140;

                goto st0;
st46:

                if ( ++p == pe )
                    goto _test_eof46;

            case 46:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr141;

                goto st0;
st47:

                if ( ++p == pe )
                    goto _test_eof47;

            case 47:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr142;

                goto st0;
st48:

                if ( ++p == pe )
                    goto _test_eof48;

            case 48:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr143;

                case 5:
                    goto tr143;

                case 8:
                    goto tr143;

                case 18:
                    goto tr144;

                case 21:
                    goto tr144;

                case 23:
                    goto tr144;

                case 36:
                    goto tr144;

                case 44:
                    goto tr144;

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
                    goto tr144;

                goto st0;
tr143:

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
                    goto tr162;

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
tr144:

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
                    goto tr165;

                goto st0;
st52:

                if ( ++p == pe )
                    goto _test_eof52;

            case 52:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr166;

                goto st0;
st53:

                if ( ++p == pe )
                    goto _test_eof53;

            case 53:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr167;

                goto st0;
st54:

                if ( ++p == pe )
                    goto _test_eof54;

            case 54:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr168;

                goto st0;
st55:

                if ( ++p == pe )
                    goto _test_eof55;

            case 55:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr169;

                goto st0;
st56:

                if ( ++p == pe )
                    goto _test_eof56;

            case 56:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr170;

                goto st0;
st57:

                if ( ++p == pe )
                    goto _test_eof57;

            case 57:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr171;

                goto st0;
st58:

                if ( ++p == pe )
                    goto _test_eof58;

            case 58:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr172;

                goto st0;
st59:

                if ( ++p == pe )
                    goto _test_eof59;

            case 59:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr173;

                goto st0;
st60:

                if ( ++p == pe )
                    goto _test_eof60;

            case 60:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr174;

                goto st0;
st61:

                if ( ++p == pe )
                    goto _test_eof61;

            case 61:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr175;

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
                    goto tr143;

                case 5:
                    goto tr143;

                case 8:
                    goto tr143;

                case 18:
                    goto tr144;

                case 21:
                    goto tr144;

                case 23:
                    goto tr144;

                case 36:
                    goto tr144;

                case 44:
                    goto tr144;

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
                    goto tr144;

                goto st0;
st63:

                if ( ++p == pe )
                    goto _test_eof63;

            case 63:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr175;

                goto st0;
st64:

                if ( ++p == pe )
                    goto _test_eof64;

            case 64:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr178;

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
                    goto tr182;

                goto st0;
st67:

                if ( ++p == pe )
                    goto _test_eof67;

            case 67:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr183;

                case 5:
                    goto tr183;

                case 8:
                    goto tr183;

                case 18:
                    goto tr184;

                case 21:
                    goto tr184;

                case 23:
                    goto tr184;

                case 36:
                    goto tr184;

                case 44:
                    goto tr184;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr184;

                goto st0;
tr183:

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
                    goto tr185;

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
tr185:

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
                    goto tr187;

                case 19:
                    goto tr185;

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
tr184:

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
                goto st72;
st72:

                if ( ++p == pe )
                    goto _test_eof72;

            case 72:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr191;

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
tr191:

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
                    goto tr193;

                case 19:
                    goto tr191;

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
tr190:

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
                    goto tr198;

                goto st0;
st77:

                if ( ++p == pe )
                    goto _test_eof77;

            case 77:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr199;

                case 5:
                    goto tr199;

                case 8:
                    goto tr199;

                case 18:
                    goto tr200;

                case 21:
                    goto tr200;

                case 23:
                    goto tr200;

                case 36:
                    goto tr200;

                case 44:
                    goto tr200;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr200;

                goto st0;
tr199:

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
                    goto tr201;

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
tr201:

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
                    goto tr203;

                case 19:
                    goto tr201;

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
tr200:

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
                    goto tr205;

                case 5:
                    goto tr205;

                case 8:
                    goto tr205;

                case 18:
                    goto tr206;

                case 21:
                    goto tr206;

                case 23:
                    goto tr206;

                case 36:
                    goto tr206;

                case 44:
                    goto tr206;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr206;

                goto st0;
tr205:

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
                    goto tr207;

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
tr207:

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
                    goto tr209;

                case 19:
                    goto tr207;

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
tr206:

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
                    goto tr216;

                goto st0;
st88:

                if ( ++p == pe )
                    goto _test_eof88;

            case 88:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr217;

                goto st0;
st89:

                if ( ++p == pe )
                    goto _test_eof89;

            case 89:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr218;

                goto st0;
st90:

                if ( ++p == pe )
                    goto _test_eof90;

            case 90:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr219;

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
                    goto tr225;

                goto st0;
st94:

                if ( ++p == pe )
                    goto _test_eof94;

            case 94:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr226;

                goto st0;
st95:

                if ( ++p == pe )
                    goto _test_eof95;

            case 95:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr227;

                goto st0;
st96:

                if ( ++p == pe )
                    goto _test_eof96;

            case 96:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr228;

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
                    goto tr234;

                goto st0;
st100:

                if ( ++p == pe )
                    goto _test_eof100;

            case 100:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr235;

                goto st0;
st101:

                if ( ++p == pe )
                    goto _test_eof101;

            case 101:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr236;

                goto st0;
st102:

                if ( ++p == pe )
                    goto _test_eof102;

            case 102:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr237;

                goto st0;
st103:

                if ( ++p == pe )
                    goto _test_eof103;

            case 103:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr238;

                case 5:
                    goto tr238;

                case 8:
                    goto tr238;

                case 18:
                    goto tr239;

                case 21:
                    goto tr239;

                case 23:
                    goto tr239;

                case 36:
                    goto tr239;

                case 44:
                    goto tr239;

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
                    goto tr239;

                goto st0;
tr238:

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
                    goto tr254;

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
tr239:

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
                    goto tr257;

                goto st0;
st107:

                if ( ++p == pe )
                    goto _test_eof107;

            case 107:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr258;

                goto st0;
st108:

                if ( ++p == pe )
                    goto _test_eof108;

            case 108:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr259;

                goto st0;
st109:

                if ( ++p == pe )
                    goto _test_eof109;

            case 109:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr260;

                goto st0;
st110:

                if ( ++p == pe )
                    goto _test_eof110;

            case 110:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr261;

                goto st0;
st111:

                if ( ++p == pe )
                    goto _test_eof111;

            case 111:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr262;

                goto st0;
st112:

                if ( ++p == pe )
                    goto _test_eof112;

            case 112:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr263;

                goto st0;
st113:

                if ( ++p == pe )
                    goto _test_eof113;

            case 113:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr264;

                goto st0;
st114:

                if ( ++p == pe )
                    goto _test_eof114;

            case 114:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr265;

                goto st0;
st115:

                if ( ++p == pe )
                    goto _test_eof115;

            case 115:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr266;

                goto st0;
st116:

                if ( ++p == pe )
                    goto _test_eof116;

            case 116:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr267;

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
                    goto tr238;

                case 5:
                    goto tr238;

                case 8:
                    goto tr238;

                case 18:
                    goto tr239;

                case 21:
                    goto tr239;

                case 23:
                    goto tr239;

                case 36:
                    goto tr239;

                case 44:
                    goto tr239;

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
                    goto tr239;

                goto st0;
st118:

                if ( ++p == pe )
                    goto _test_eof118;

            case 118:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr267;

                goto st0;
st119:

                if ( ++p == pe )
                    goto _test_eof119;

            case 119:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr270;

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
                    goto tr274;

                goto st0;
st122:

                if ( ++p == pe )
                    goto _test_eof122;

            case 122:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr275;

                case 5:
                    goto tr275;

                case 8:
                    goto tr275;

                case 18:
                    goto tr276;

                case 21:
                    goto tr276;

                case 23:
                    goto tr276;

                case 36:
                    goto tr276;

                case 44:
                    goto tr276;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr276;

                goto st0;
tr275:

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
                    goto tr277;

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
tr277:

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
                    goto tr279;

                case 19:
                    goto tr277;

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
tr276:

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
                goto st127;
st127:

                if ( ++p == pe )
                    goto _test_eof127;

            case 127:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr283;

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
tr283:

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
                    goto tr285;

                case 19:
                    goto tr283;

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
tr282:

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
                    goto tr290;

                goto st0;
st132:

                if ( ++p == pe )
                    goto _test_eof132;

            case 132:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr291;

                case 5:
                    goto tr291;

                case 8:
                    goto tr291;

                case 18:
                    goto tr292;

                case 21:
                    goto tr292;

                case 23:
                    goto tr292;

                case 36:
                    goto tr292;

                case 44:
                    goto tr292;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr292;

                goto st0;
tr291:

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
                    goto tr293;

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
tr293:

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
                    goto tr295;

                case 19:
                    goto tr293;

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
tr292:

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
                    goto tr297;

                case 5:
                    goto tr297;

                case 8:
                    goto tr297;

                case 18:
                    goto tr298;

                case 21:
                    goto tr298;

                case 23:
                    goto tr298;

                case 36:
                    goto tr298;

                case 44:
                    goto tr298;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr298;

                goto st0;
tr297:

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
                    goto tr299;

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
tr299:

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
                    goto tr301;

                case 19:
                    goto tr299;

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
tr298:

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
                    goto tr303;

                case 5:
                    goto tr303;

                case 8:
                    goto tr303;

                case 18:
                    goto tr304;

                case 21:
                    goto tr304;

                case 23:
                    goto tr304;

                case 36:
                    goto tr304;

                case 44:
                    goto tr304;

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
                    goto tr304;

                goto st0;
tr303:

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
                    goto tr313;

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
tr304:

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
                    goto tr317;

                case 5:
                    goto tr317;

                case 8:
                    goto tr317;

                case 18:
                    goto tr318;

                case 21:
                    goto tr318;

                case 23:
                    goto tr318;

                case 36:
                    goto tr318;

                case 44:
                    goto tr318;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr318;

                goto st0;
tr317:

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
                    goto tr319;

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
tr318:

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
                    goto tr323;

                case 5:
                    goto tr323;

                case 8:
                    goto tr323;

                case 18:
                    goto tr324;

                case 21:
                    goto tr324;

                case 23:
                    goto tr324;

                case 36:
                    goto tr324;

                case 44:
                    goto tr324;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr324;

                goto st0;
tr323:

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
                    goto tr325;

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
tr324:

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
                    goto tr329;

                case 5:
                    goto tr329;

                case 8:
                    goto tr329;

                case 18:
                    goto tr330;

                case 21:
                    goto tr330;

                case 23:
                    goto tr330;

                case 36:
                    goto tr330;

                case 44:
                    goto tr330;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr330;

                goto st0;
tr329:

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
                    goto tr331;

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
tr330:

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
                    goto tr335;

                case 5:
                    goto tr335;

                case 8:
                    goto tr335;

                case 18:
                    goto tr336;

                case 21:
                    goto tr336;

                case 23:
                    goto tr336;

                case 36:
                    goto tr336;

                case 44:
                    goto tr336;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr336;

                goto st0;
tr335:

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
                    goto tr337;

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
tr336:

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
                    goto tr341;

                case 5:
                    goto tr341;

                case 8:
                    goto tr341;

                case 18:
                    goto tr342;

                case 21:
                    goto tr342;

                case 23:
                    goto tr342;

                case 36:
                    goto tr342;

                case 44:
                    goto tr342;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr342;

                goto st0;
tr341:

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
                    goto tr343;

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
tr342:

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
                    goto tr347;

                case 5:
                    goto tr347;

                case 8:
                    goto tr347;

                case 18:
                    goto tr348;

                case 21:
                    goto tr348;

                case 23:
                    goto tr348;

                case 36:
                    goto tr348;

                case 44:
                    goto tr348;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr348;

                goto st0;
tr347:

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
                    goto tr349;

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
tr348:

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
                    goto tr353;

                case 5:
                    goto tr353;

                case 8:
                    goto tr353;

                case 18:
                    goto tr354;

                case 21:
                    goto tr354;

                case 23:
                    goto tr354;

                case 36:
                    goto tr354;

                case 44:
                    goto tr354;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr354;

                goto st0;
tr353:

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
                    goto tr355;

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
tr354:

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
                    goto tr359;

                case 5:
                    goto tr359;

                case 8:
                    goto tr359;

                case 18:
                    goto tr360;

                case 21:
                    goto tr360;

                case 23:
                    goto tr360;

                case 36:
                    goto tr360;

                case 44:
                    goto tr360;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr360;

                goto st0;
tr359:

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
                    goto tr361;

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
tr360:

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
                    goto tr364;

                goto st0;
st176:

                if ( ++p == pe )
                    goto _test_eof176;

            case 176:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr365;

                case 5:
                    goto tr365;

                case 8:
                    goto tr365;

                case 18:
                    goto tr366;

                case 21:
                    goto tr366;

                case 23:
                    goto tr366;

                case 36:
                    goto tr366;

                case 44:
                    goto tr366;

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
                    goto tr366;

                goto st0;
tr365:

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
                    goto tr381;

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
tr366:

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
                    goto tr384;

                goto st0;
st180:

                if ( ++p == pe )
                    goto _test_eof180;

            case 180:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr385;

                goto st0;
st181:

                if ( ++p == pe )
                    goto _test_eof181;

            case 181:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr386;

                goto st0;
st182:

                if ( ++p == pe )
                    goto _test_eof182;

            case 182:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr387;

                goto st0;
st183:

                if ( ++p == pe )
                    goto _test_eof183;

            case 183:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr388;

                goto st0;
st184:

                if ( ++p == pe )
                    goto _test_eof184;

            case 184:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr389;

                goto st0;
st185:

                if ( ++p == pe )
                    goto _test_eof185;

            case 185:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr390;

                goto st0;
st186:

                if ( ++p == pe )
                    goto _test_eof186;

            case 186:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr391;

                goto st0;
st187:

                if ( ++p == pe )
                    goto _test_eof187;

            case 187:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr392;

                goto st0;
st188:

                if ( ++p == pe )
                    goto _test_eof188;

            case 188:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr393;

                goto st0;
st189:

                if ( ++p == pe )
                    goto _test_eof189;

            case 189:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr394;

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
                    goto tr365;

                case 5:
                    goto tr365;

                case 8:
                    goto tr365;

                case 18:
                    goto tr366;

                case 21:
                    goto tr366;

                case 23:
                    goto tr366;

                case 36:
                    goto tr366;

                case 44:
                    goto tr366;

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
                    goto tr366;

                goto st0;
st191:

                if ( ++p == pe )
                    goto _test_eof191;

            case 191:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr394;

                goto st0;
st192:

                if ( ++p == pe )
                    goto _test_eof192;

            case 192:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr397;

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
                    goto tr401;

                goto st0;
st195:

                if ( ++p == pe )
                    goto _test_eof195;

            case 195:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr402;

                case 5:
                    goto tr402;

                case 8:
                    goto tr402;

                case 18:
                    goto tr403;

                case 21:
                    goto tr403;

                case 23:
                    goto tr403;

                case 36:
                    goto tr403;

                case 44:
                    goto tr403;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr403;

                goto st0;
tr402:

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
                    goto tr404;

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
tr404:

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
                    goto tr406;

                case 19:
                    goto tr404;

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
tr403:

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
                goto st200;
st200:

                if ( ++p == pe )
                    goto _test_eof200;

            case 200:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr410;

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
tr410:

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
                    goto tr412;

                case 19:
                    goto tr410;

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
tr409:

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
                    goto tr417;

                goto st0;
st205:

                if ( ++p == pe )
                    goto _test_eof205;

            case 205:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr418;

                case 5:
                    goto tr418;

                case 8:
                    goto tr418;

                case 18:
                    goto tr419;

                case 21:
                    goto tr419;

                case 23:
                    goto tr419;

                case 36:
                    goto tr419;

                case 44:
                    goto tr419;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr419;

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
                case 19:
                    goto tr420;

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
tr420:

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
                    goto tr422;

                case 19:
                    goto tr420;

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
tr419:

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
                    goto tr424;

                case 5:
                    goto tr424;

                case 8:
                    goto tr424;

                case 18:
                    goto tr425;

                case 21:
                    goto tr425;

                case 23:
                    goto tr425;

                case 36:
                    goto tr425;

                case 44:
                    goto tr425;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr425;

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
                case 19:
                    goto tr426;

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
tr426:

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
                    goto tr428;

                case 19:
                    goto tr426;

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
tr425:

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
                    goto tr430;

                goto st0;
st214:

                if ( ++p == pe )
                    goto _test_eof214;

            case 214:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr431;

                goto st0;
st215:

                if ( ++p == pe )
                    goto _test_eof215;

            case 215:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr432;

                goto st0;
st216:

                if ( ++p == pe )
                    goto _test_eof216;

            case 216:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr433;

                goto st0;
st217:

                if ( ++p == pe )
                    goto _test_eof217;

            case 217:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr434;

                goto st0;
st218:

                if ( ++p == pe )
                    goto _test_eof218;

            case 218:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr435;

                goto st0;
st219:

                if ( ++p == pe )
                    goto _test_eof219;

            case 219:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr436;

                goto st0;
st220:

                if ( ++p == pe )
                    goto _test_eof220;

            case 220:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr437;

                case 5:
                    goto tr437;

                case 8:
                    goto tr437;

                case 18:
                    goto tr438;

                case 21:
                    goto tr438;

                case 23:
                    goto tr438;

                case 36:
                    goto tr438;

                case 44:
                    goto tr438;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr438;

                goto st0;
tr437:

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
                    goto tr439;

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
tr438:

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
                    goto tr442;

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
                    goto tr448;

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
                    goto tr452;

                goto st0;
st231:

                if ( ++p == pe )
                    goto _test_eof231;

            case 231:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr453;

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
                    goto tr458;

                goto st0;
st235:

                if ( ++p == pe )
                    goto _test_eof235;

            case 235:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr459;

                goto st0;
st236:

                if ( ++p == pe )
                    goto _test_eof236;

            case 236:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr460;

                goto st0;
st237:

                if ( ++p == pe )
                    goto _test_eof237;

            case 237:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr461;

                goto st0;
st238:

                if ( ++p == pe )
                    goto _test_eof238;

            case 238:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr462;

                goto st0;
st239:

                if ( ++p == pe )
                    goto _test_eof239;

            case 239:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr463;

                case 5:
                    goto tr463;

                case 8:
                    goto tr463;

                case 18:
                    goto tr464;

                case 21:
                    goto tr464;

                case 23:
                    goto tr464;

                case 36:
                    goto tr464;

                case 44:
                    goto tr464;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr464;

                goto st0;
tr463:

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
                    goto tr465;

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
tr464:

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
                    goto tr477;

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
                    goto tr480;

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
                    goto tr483;

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
                    goto tr486;

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
                    goto tr489;

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
                    goto tr492;

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
                    goto tr494;

                case 5:
                    goto tr494;

                case 8:
                    goto tr494;

                case 18:
                    goto tr495;

                case 21:
                    goto tr495;

                case 23:
                    goto tr495;

                case 36:
                    goto tr495;

                case 44:
                    goto tr495;

                case 68:
                    goto st265;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr495;

                goto st0;
tr494:

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
                    goto tr497;

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
tr495:

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
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr500;

                goto st0;
st266:

                if ( ++p == pe )
                    goto _test_eof266;

            case 266:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr501;

                goto st0;
st267:

                if ( ++p == pe )
                    goto _test_eof267;

            case 267:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr502;

                goto st0;
st268:

                if ( ++p == pe )
                    goto _test_eof268;

            case 268:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr503;

                goto st0;
st269:

                if ( ++p == pe )
                    goto _test_eof269;

            case 269:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr504;

                goto st0;
st270:

                if ( ++p == pe )
                    goto _test_eof270;

            case 270:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr505;

                case 5:
                    goto tr505;

                case 8:
                    goto tr505;

                case 18:
                    goto tr506;

                case 21:
                    goto tr506;

                case 23:
                    goto tr506;

                case 36:
                    goto tr506;

                case 44:
                    goto tr506;

                case 45:
                    goto st273;

                case 46:
                    goto st277;

                case 47:
                    goto st281;

                case 48:
                    goto st285;

                case 49:
                    goto st289;

                case 50:
                    goto st293;

                case 51:
                    goto st297;

                case 52:
                    goto st301;

                case 79:
                    goto st305;

                case 80:
                    goto st306;

                case 81:
                    goto st308;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr506;

                goto st0;
tr505:

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
                    goto tr518;

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
tr506:

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
                    goto tr522;

                case 5:
                    goto tr522;

                case 8:
                    goto tr522;

                case 18:
                    goto tr523;

                case 21:
                    goto tr523;

                case 23:
                    goto tr523;

                case 36:
                    goto tr523;

                case 44:
                    goto tr523;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr523;

                goto st0;
tr522:

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
                    goto tr524;

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
tr523:

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
                    goto tr528;

                case 5:
                    goto tr528;

                case 8:
                    goto tr528;

                case 18:
                    goto tr529;

                case 21:
                    goto tr529;

                case 23:
                    goto tr529;

                case 36:
                    goto tr529;

                case 44:
                    goto tr529;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr529;

                goto st0;
tr528:

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
                    goto tr530;

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
tr529:

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
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st282;

                goto st0;
st282:

                if ( ++p == pe )
                    goto _test_eof282;

            case 282:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr534;

                case 5:
                    goto tr534;

                case 8:
                    goto tr534;

                case 18:
                    goto tr535;

                case 21:
                    goto tr535;

                case 23:
                    goto tr535;

                case 36:
                    goto tr535;

                case 44:
                    goto tr535;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr535;

                goto st0;
tr534:

                {
                    expr_start = p;
                }
                goto st283;
st283:

                if ( ++p == pe )
                    goto _test_eof283;

            case 283:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr536;

                case 19:
                    goto st283;

                case 23:
                    goto st284;

                case 37:
                    goto st283;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st284;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st284;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st284;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st284;
                }
                else
                    goto st284;

                goto st0;
tr535:

                {
                    expr_start = p;
                }
                goto st284;
st284:

                if ( ++p == pe )
                    goto _test_eof284;

            case 284:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st283;

                case 5:
                    goto st283;

                case 8:
                    goto st283;

                case 13:
                    goto st284;

                case 18:
                    goto st284;

                case 21:
                    goto st284;

                case 23:
                    goto st284;

                case 36:
                    goto st284;

                case 44:
                    goto st284;
                }

                goto st0;
st285:

                if ( ++p == pe )
                    goto _test_eof285;

            case 285:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st286;

                goto st0;
st286:

                if ( ++p == pe )
                    goto _test_eof286;

            case 286:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr540;

                case 5:
                    goto tr540;

                case 8:
                    goto tr540;

                case 18:
                    goto tr541;

                case 21:
                    goto tr541;

                case 23:
                    goto tr541;

                case 36:
                    goto tr541;

                case 44:
                    goto tr541;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr541;

                goto st0;
tr540:

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
                    goto tr542;

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
tr541:

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
                    goto tr546;

                case 5:
                    goto tr546;

                case 8:
                    goto tr546;

                case 18:
                    goto tr547;

                case 21:
                    goto tr547;

                case 23:
                    goto tr547;

                case 36:
                    goto tr547;

                case 44:
                    goto tr547;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr547;

                goto st0;
tr546:

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
                    goto tr548;

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
tr547:

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
                    goto tr554;

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
                    goto tr558;

                case 5:
                    goto tr558;

                case 8:
                    goto tr558;

                case 18:
                    goto tr559;

                case 21:
                    goto tr559;

                case 23:
                    goto tr559;

                case 36:
                    goto tr559;

                case 44:
                    goto tr559;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr559;

                goto st0;
tr558:

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
                    goto tr560;

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
tr559:

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
                    goto tr564;

                case 5:
                    goto tr564;

                case 8:
                    goto tr564;

                case 18:
                    goto tr565;

                case 21:
                    goto tr565;

                case 23:
                    goto tr565;

                case 36:
                    goto tr565;

                case 44:
                    goto tr565;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr565;

                goto st0;
tr564:

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
                    goto tr566;

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
tr565:

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
                    goto tr569;

                goto st0;
st306:

                if ( ++p == pe )
                    goto _test_eof306;

            case 306:
                if ( ( ( ( int ) p->tok ) ) == 19 )
                    goto st307;

                goto st0;
st307:

                if ( ++p == pe )
                    goto _test_eof307;

            case 307:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr571;

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
                    goto tr573;

                goto st0;
st310:

                if ( ++p == pe )
                    goto _test_eof310;

            case 310:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr574;

                case 5:
                    goto tr574;

                case 8:
                    goto tr574;

                case 18:
                    goto tr575;

                case 21:
                    goto tr575;

                case 23:
                    goto tr575;

                case 36:
                    goto tr575;

                case 44:
                    goto tr575;

                case 45:
                    goto st313;

                case 46:
                    goto st317;

                case 47:
                    goto st321;

                case 48:
                    goto st325;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr575;

                goto st0;
tr574:

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
                    goto tr580;

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
tr575:

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
                    goto tr584;

                case 5:
                    goto tr584;

                case 8:
                    goto tr584;

                case 18:
                    goto tr585;

                case 21:
                    goto tr585;

                case 23:
                    goto tr585;

                case 36:
                    goto tr585;

                case 44:
                    goto tr585;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr585;

                goto st0;
tr584:

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
                    goto tr586;

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
tr585:

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
                    goto tr590;

                case 5:
                    goto tr590;

                case 8:
                    goto tr590;

                case 18:
                    goto tr591;

                case 21:
                    goto tr591;

                case 23:
                    goto tr591;

                case 36:
                    goto tr591;

                case 44:
                    goto tr591;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr591;

                goto st0;
tr590:

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
                    goto tr592;

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
tr591:

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
                    goto tr596;

                case 5:
                    goto tr596;

                case 8:
                    goto tr596;

                case 18:
                    goto tr597;

                case 21:
                    goto tr597;

                case 23:
                    goto tr597;

                case 36:
                    goto tr597;

                case 44:
                    goto tr597;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr597;

                goto st0;
tr596:

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
                    goto tr598;

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
tr597:

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
                    goto tr602;

                case 5:
                    goto tr602;

                case 8:
                    goto tr602;

                case 18:
                    goto tr603;

                case 21:
                    goto tr603;

                case 23:
                    goto tr603;

                case 36:
                    goto tr603;

                case 44:
                    goto tr603;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr603;

                goto st0;
tr602:

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
                    goto tr604;

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
tr603:

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
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr607;

                goto st0;
st330:

                if ( ++p == pe )
                    goto _test_eof330;

            case 330:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr608;

                goto st0;
st331:

                if ( ++p == pe )
                    goto _test_eof331;

            case 331:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr609;

                goto st0;
st332:

                if ( ++p == pe )
                    goto _test_eof332;

            case 332:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr610;

                goto st0;
st333:

                if ( ++p == pe )
                    goto _test_eof333;

            case 333:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr611;

                goto st0;
st334:

                if ( ++p == pe )
                    goto _test_eof334;

            case 334:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr612;

                goto st0;
st335:

                if ( ++p == pe )
                    goto _test_eof335;

            case 335:
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

                case 48:
                    goto st338;

                case 53:
                    goto st339;

                case 54:
                    goto st340;

                case 55:
                    goto st341;

                case 56:
                    goto st342;

                case 57:
                    goto st343;

                case 58:
                    goto st344;

                case 59:
                    goto st345;

                case 60:
                    goto st346;

                case 61:
                    goto st347;

                case 62:
                    goto st348;

                case 79:
                    goto st351;

                case 80:
                    goto st352;

                case 81:
                    goto st362;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr614;

                goto st0;
tr613:

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
                case 12:
                    goto tr629;

                case 19:
                    goto st336;

                case 23:
                    goto st337;

                case 37:
                    goto st336;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st337;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st337;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st337;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st337;
                }
                else
                    goto st337;

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
                    goto st336;

                case 5:
                    goto st336;

                case 8:
                    goto st336;

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
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr632;

                goto st0;
st339:

                if ( ++p == pe )
                    goto _test_eof339;

            case 339:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr633;

                goto st0;
st340:

                if ( ++p == pe )
                    goto _test_eof340;

            case 340:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr634;

                goto st0;
st341:

                if ( ++p == pe )
                    goto _test_eof341;

            case 341:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr635;

                goto st0;
st342:

                if ( ++p == pe )
                    goto _test_eof342;

            case 342:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr636;

                goto st0;
st343:

                if ( ++p == pe )
                    goto _test_eof343;

            case 343:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr637;

                goto st0;
st344:

                if ( ++p == pe )
                    goto _test_eof344;

            case 344:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr638;

                goto st0;
st345:

                if ( ++p == pe )
                    goto _test_eof345;

            case 345:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr639;

                goto st0;
st346:

                if ( ++p == pe )
                    goto _test_eof346;

            case 346:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr640;

                goto st0;
st347:

                if ( ++p == pe )
                    goto _test_eof347;

            case 347:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr641;

                goto st0;
st348:

                if ( ++p == pe )
                    goto _test_eof348;

            case 348:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr642;

                case 22:
                    goto st349;
                }

                goto st0;
st349:

                if ( ++p == pe )
                    goto _test_eof349;

            case 349:
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

                case 48:
                    goto st338;

                case 53:
                    goto st339;

                case 54:
                    goto st340;

                case 55:
                    goto st341;

                case 56:
                    goto st342;

                case 57:
                    goto st343;

                case 58:
                    goto st344;

                case 59:
                    goto st345;

                case 60:
                    goto st346;

                case 61:
                    goto st347;

                case 62:
                    goto st350;

                case 79:
                    goto st351;

                case 80:
                    goto st352;

                case 81:
                    goto st362;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr614;

                goto st0;
st350:

                if ( ++p == pe )
                    goto _test_eof350;

            case 350:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr642;

                goto st0;
st351:

                if ( ++p == pe )
                    goto _test_eof351;

            case 351:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr645;

                goto st0;
st352:

                if ( ++p == pe )
                    goto _test_eof352;

            case 352:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st353;

                case 21:
                    goto st354;

                case 23:
                    goto st358;
                }

                goto st0;
st353:

                if ( ++p == pe )
                    goto _test_eof353;

            case 353:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr649;

                goto st0;
st354:

                if ( ++p == pe )
                    goto _test_eof354;

            case 354:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr650;

                case 5:
                    goto tr650;

                case 8:
                    goto tr650;

                case 18:
                    goto tr651;

                case 21:
                    goto tr651;

                case 23:
                    goto tr651;

                case 36:
                    goto tr651;

                case 44:
                    goto tr651;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr651;

                goto st0;
tr650:

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
                case 19:
                    goto tr652;

                case 23:
                    goto st24;

                case 37:
                    goto st355;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr652:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st356;
st356:

                if ( ++p == pe )
                    goto _test_eof356;

            case 356:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr654;

                case 19:
                    goto tr652;

                case 23:
                    goto st24;

                case 37:
                    goto st355;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                    expr_start = p;
                }
                goto st357;
st357:

                if ( ++p == pe )
                    goto _test_eof357;

            case 357:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st355;

                case 5:
                    goto st355;

                case 8:
                    goto st355;

                case 13:
                    goto st357;

                case 18:
                    goto st357;

                case 21:
                    goto st357;

                case 23:
                    goto st357;

                case 36:
                    goto st357;

                case 44:
                    goto st357;
                }

                goto st0;
st358:

                if ( ++p == pe )
                    goto _test_eof358;

            case 358:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr656;

                case 5:
                    goto tr656;

                case 8:
                    goto tr656;

                case 18:
                    goto tr657;

                case 21:
                    goto tr657;

                case 23:
                    goto tr657;

                case 36:
                    goto tr657;

                case 44:
                    goto tr657;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr657;

                goto st0;
tr656:

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
                case 19:
                    goto tr658;

                case 23:
                    goto st24;

                case 37:
                    goto st359;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr658:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st360;
st360:

                if ( ++p == pe )
                    goto _test_eof360;

            case 360:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr660;

                case 19:
                    goto tr658;

                case 23:
                    goto st24;

                case 37:
                    goto st359;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr657:

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
                case 3:
                    goto st359;

                case 5:
                    goto st359;

                case 8:
                    goto st359;

                case 13:
                    goto st361;

                case 18:
                    goto st361;

                case 21:
                    goto st361;

                case 23:
                    goto st361;

                case 36:
                    goto st361;

                case 44:
                    goto st361;
                }

                goto st0;
st362:

                if ( ++p == pe )
                    goto _test_eof362;

            case 362:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st363;

                case 21:
                    goto st364;

                case 23:
                    goto st368;
                }

                goto st0;
st363:

                if ( ++p == pe )
                    goto _test_eof363;

            case 363:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr665;

                goto st0;
st364:

                if ( ++p == pe )
                    goto _test_eof364;

            case 364:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr666;

                case 5:
                    goto tr666;

                case 8:
                    goto tr666;

                case 18:
                    goto tr667;

                case 21:
                    goto tr667;

                case 23:
                    goto tr667;

                case 36:
                    goto tr667;

                case 44:
                    goto tr667;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr667;

                goto st0;
tr666:

                {
                    expr_start = p;
                }
                goto st365;
st365:

                if ( ++p == pe )
                    goto _test_eof365;

            case 365:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr668;

                case 23:
                    goto st24;

                case 37:
                    goto st365;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr668:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st366;
st366:

                if ( ++p == pe )
                    goto _test_eof366;

            case 366:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr670;

                case 19:
                    goto tr668;

                case 23:
                    goto st24;

                case 37:
                    goto st365;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                    expr_start = p;
                }
                goto st367;
st367:

                if ( ++p == pe )
                    goto _test_eof367;

            case 367:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st365;

                case 5:
                    goto st365;

                case 8:
                    goto st365;

                case 13:
                    goto st367;

                case 18:
                    goto st367;

                case 21:
                    goto st367;

                case 23:
                    goto st367;

                case 36:
                    goto st367;

                case 44:
                    goto st367;
                }

                goto st0;
st368:

                if ( ++p == pe )
                    goto _test_eof368;

            case 368:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr672;

                case 5:
                    goto tr672;

                case 8:
                    goto tr672;

                case 18:
                    goto tr673;

                case 21:
                    goto tr673;

                case 23:
                    goto tr673;

                case 36:
                    goto tr673;

                case 44:
                    goto tr673;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr673;

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
                case 19:
                    goto tr674;

                case 23:
                    goto st24;

                case 37:
                    goto st369;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr674:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st370;
st370:

                if ( ++p == pe )
                    goto _test_eof370;

            case 370:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr676;

                case 19:
                    goto tr674;

                case 23:
                    goto st24;

                case 37:
                    goto st369;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr673:

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
                case 3:
                    goto st369;

                case 5:
                    goto st369;

                case 8:
                    goto st369;

                case 13:
                    goto st371;

                case 18:
                    goto st371;

                case 21:
                    goto st371;

                case 23:
                    goto st371;

                case 36:
                    goto st371;

                case 44:
                    goto st371;
                }

                goto st0;
st372:

                if ( ++p == pe )
                    goto _test_eof372;

            case 372:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr678;

                goto st0;
st373:

                if ( ++p == pe )
                    goto _test_eof373;

            case 373:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr679;

                goto st0;
st374:

                if ( ++p == pe )
                    goto _test_eof374;

            case 374:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr680;

                case 5:
                    goto tr680;

                case 8:
                    goto tr680;

                case 18:
                    goto tr681;

                case 21:
                    goto tr681;

                case 23:
                    goto tr681;

                case 36:
                    goto tr681;

                case 44:
                    goto tr681;

                case 68:
                    goto st379;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr681;

                goto st0;
tr680:

                {
                    expr_start = p;
                }
                goto st375;
st375:

                if ( ++p == pe )
                    goto _test_eof375;

            case 375:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st375;

                case 22:
                    goto tr685;

                case 37:
                    goto st375;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 23 )
                            goto st376;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st376;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st376;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st376;
                }
                else
                    goto st376;

                goto st0;
tr681:

                {
                    expr_start = p;
                }
                goto st376;
st376:

                if ( ++p == pe )
                    goto _test_eof376;

            case 376:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st375;

                case 5:
                    goto st375;

                case 8:
                    goto st375;

                case 13:
                    goto st376;

                case 18:
                    goto st376;

                case 21:
                    goto st376;

                case 23:
                    goto st376;

                case 36:
                    goto st376;

                case 44:
                    goto st376;
                }

                goto st0;
tr685:

                {
                    if ( expr_start->tok != TK_LPAREN )
                        return FALSE;

                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st377;
st377:

                if ( ++p == pe )
                    goto _test_eof377;

            case 377:

                if ( ( ( ( int ) p->tok ) ) == 62 )
                    goto st378;

                goto st0;
st378:

                if ( ++p == pe )
                    goto _test_eof378;

            case 378:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr687;

                goto st0;
st379:

                if ( ++p == pe )
                    goto _test_eof379;

            case 379:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st380;

                goto st0;
st380:

                if ( ++p == pe )
                    goto _test_eof380;

            case 380:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st381;

                case 53:
                    goto st382;

                case 54:
                    goto st383;

                case 55:
                    goto st384;

                case 56:
                    goto st385;

                case 59:
                    goto st386;

                case 62:
                    goto st387;
                }

                goto st0;
st381:

                if ( ++p == pe )
                    goto _test_eof381;

            case 381:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr696;

                goto st0;
st382:

                if ( ++p == pe )
                    goto _test_eof382;

            case 382:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr697;

                goto st0;
st383:

                if ( ++p == pe )
                    goto _test_eof383;

            case 383:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr698;

                goto st0;
st384:

                if ( ++p == pe )
                    goto _test_eof384;

            case 384:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr699;

                goto st0;
st385:

                if ( ++p == pe )
                    goto _test_eof385;

            case 385:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr700;

                goto st0;
st386:

                if ( ++p == pe )
                    goto _test_eof386;

            case 386:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr701;

                goto st0;
st387:

                if ( ++p == pe )
                    goto _test_eof387;

            case 387:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr702;

                goto st0;
st388:

                if ( ++p == pe )
                    goto _test_eof388;

            case 388:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr703;

                goto st0;
st389:

                if ( ++p == pe )
                    goto _test_eof389;

            case 389:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr704;

                goto st0;
st390:

                if ( ++p == pe )
                    goto _test_eof390;

            case 390:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st391;

                case 70:
                    goto st392;

                case 71:
                    goto st393;

                case 72:
                    goto st394;

                case 73:
                    goto st395;

                case 74:
                    goto st396;
                }

                goto st0;
st391:

                if ( ++p == pe )
                    goto _test_eof391;

            case 391:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr711;

                goto st0;
st392:

                if ( ++p == pe )
                    goto _test_eof392;

            case 392:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr712;

                goto st0;
st393:

                if ( ++p == pe )
                    goto _test_eof393;

            case 393:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr713;

                goto st0;
st394:

                if ( ++p == pe )
                    goto _test_eof394;

            case 394:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr714;

                goto st0;
st395:

                if ( ++p == pe )
                    goto _test_eof395;

            case 395:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr715;

                goto st0;
st396:

                if ( ++p == pe )
                    goto _test_eof396;

            case 396:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr716;

                goto st0;
st397:

                if ( ++p == pe )
                    goto _test_eof397;

            case 397:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st398;

                case 70:
                    goto st399;

                case 71:
                    goto st400;

                case 72:
                    goto st401;

                case 73:
                    goto st402;

                case 74:
                    goto st403;
                }

                goto st0;
st398:

                if ( ++p == pe )
                    goto _test_eof398;

            case 398:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr723;

                goto st0;
st399:

                if ( ++p == pe )
                    goto _test_eof399;

            case 399:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr724;

                goto st0;
st400:

                if ( ++p == pe )
                    goto _test_eof400;

            case 400:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr725;

                goto st0;
st401:

                if ( ++p == pe )
                    goto _test_eof401;

            case 401:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr726;

                goto st0;
st402:

                if ( ++p == pe )
                    goto _test_eof402;

            case 402:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr727;

                goto st0;
st403:

                if ( ++p == pe )
                    goto _test_eof403;

            case 403:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr728;

                goto st0;
st404:

                if ( ++p == pe )
                    goto _test_eof404;

            case 404:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr729;

                case 45:
                    goto st405;

                case 46:
                    goto st406;

                case 47:
                    goto st407;

                case 48:
                    goto st408;

                case 49:
                    goto st409;

                case 50:
                    goto st410;

                case 51:
                    goto st411;

                case 52:
                    goto st412;
                }

                goto st0;
st405:

                if ( ++p == pe )
                    goto _test_eof405;

            case 405:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr738;

                goto st0;
st406:

                if ( ++p == pe )
                    goto _test_eof406;

            case 406:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr739;

                goto st0;
st407:

                if ( ++p == pe )
                    goto _test_eof407;

            case 407:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr740;

                goto st0;
st408:

                if ( ++p == pe )
                    goto _test_eof408;

            case 408:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr741;

                goto st0;
st409:

                if ( ++p == pe )
                    goto _test_eof409;

            case 409:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr742;

                goto st0;
st410:

                if ( ++p == pe )
                    goto _test_eof410;

            case 410:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr743;

                goto st0;
st411:

                if ( ++p == pe )
                    goto _test_eof411;

            case 411:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr744;

                goto st0;
st412:

                if ( ++p == pe )
                    goto _test_eof412;

            case 412:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr745;

                goto st0;
st413:

                if ( ++p == pe )
                    goto _test_eof413;

            case 413:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr746;

                goto st0;
st414:

                if ( ++p == pe )
                    goto _test_eof414;

            case 414:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr747;

                goto st0;
st415:

                if ( ++p == pe )
                    goto _test_eof415;

            case 415:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr748;

                goto st0;
st416:

                if ( ++p == pe )
                    goto _test_eof416;

            case 416:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr749;

                goto st0;
st417:

                if ( ++p == pe )
                    goto _test_eof417;

            case 417:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr750;

                goto st0;
st418:

                if ( ++p == pe )
                    goto _test_eof418;

            case 418:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr751;

                goto st0;
st419:

                if ( ++p == pe )
                    goto _test_eof419;

            case 419:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr752;

                goto st0;
st420:

                if ( ++p == pe )
                    goto _test_eof420;

            case 420:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr753;

                goto st0;
st421:

                if ( ++p == pe )
                    goto _test_eof421;

            case 421:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr754;

                case 5:
                    goto tr754;

                case 8:
                    goto tr754;

                case 18:
                    goto tr755;

                case 21:
                    goto tr755;

                case 23:
                    goto tr755;

                case 36:
                    goto tr755;

                case 44:
                    goto tr755;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr755;

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
                case 12:
                    goto tr756;

                case 19:
                    goto st422;

                case 23:
                    goto st423;

                case 37:
                    goto st422;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st423;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st423;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st423;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st423;
                }
                else
                    goto st423;

                goto st0;
tr755:

                {
                    expr_start = p;
                }
                goto st423;
st423:

                if ( ++p == pe )
                    goto _test_eof423;

            case 423:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st422;

                case 5:
                    goto st422;

                case 8:
                    goto st422;

                case 13:
                    goto st423;

                case 18:
                    goto st423;

                case 21:
                    goto st423;

                case 23:
                    goto st423;

                case 36:
                    goto st423;

                case 44:
                    goto st423;
                }

                goto st0;
st424:

                if ( ++p == pe )
                    goto _test_eof424;

            case 424:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr759;

                case 5:
                    goto tr759;

                case 8:
                    goto tr759;

                case 18:
                    goto tr760;

                case 21:
                    goto tr760;

                case 23:
                    goto tr760;

                case 36:
                    goto tr760;

                case 44:
                    goto tr760;

                case 48:
                    goto st427;

                case 53:
                    goto st428;

                case 54:
                    goto st429;

                case 55:
                    goto st430;

                case 56:
                    goto st431;

                case 57:
                    goto st432;

                case 58:
                    goto st433;

                case 59:
                    goto st434;

                case 60:
                    goto st435;

                case 61:
                    goto st436;

                case 62:
                    goto st437;

                case 71:
                    goto st461;

                case 79:
                    goto st440;

                case 80:
                    goto st441;

                case 81:
                    goto st451;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr760;

                goto st0;
tr759:

                {
                    expr_start = p;
                }
                goto st425;
st425:

                if ( ++p == pe )
                    goto _test_eof425;

            case 425:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr776;

                case 19:
                    goto st425;

                case 23:
                    goto st426;

                case 37:
                    goto st425;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st426;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st426;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st426;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st426;
                }
                else
                    goto st426;

                goto st0;
tr760:

                {
                    expr_start = p;
                }
                goto st426;
st426:

                if ( ++p == pe )
                    goto _test_eof426;

            case 426:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st425;

                case 5:
                    goto st425;

                case 8:
                    goto st425;

                case 13:
                    goto st426;

                case 18:
                    goto st426;

                case 21:
                    goto st426;

                case 23:
                    goto st426;

                case 36:
                    goto st426;

                case 44:
                    goto st426;
                }

                goto st0;
st427:

                if ( ++p == pe )
                    goto _test_eof427;

            case 427:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr779;

                goto st0;
st428:

                if ( ++p == pe )
                    goto _test_eof428;

            case 428:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr780;

                goto st0;
st429:

                if ( ++p == pe )
                    goto _test_eof429;

            case 429:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr781;

                goto st0;
st430:

                if ( ++p == pe )
                    goto _test_eof430;

            case 430:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr782;

                goto st0;
st431:

                if ( ++p == pe )
                    goto _test_eof431;

            case 431:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr783;

                goto st0;
st432:

                if ( ++p == pe )
                    goto _test_eof432;

            case 432:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr784;

                goto st0;
st433:

                if ( ++p == pe )
                    goto _test_eof433;

            case 433:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr785;

                goto st0;
st434:

                if ( ++p == pe )
                    goto _test_eof434;

            case 434:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr786;

                goto st0;
st435:

                if ( ++p == pe )
                    goto _test_eof435;

            case 435:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr787;

                goto st0;
st436:

                if ( ++p == pe )
                    goto _test_eof436;

            case 436:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr788;

                goto st0;
st437:

                if ( ++p == pe )
                    goto _test_eof437;

            case 437:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr789;

                case 22:
                    goto st438;
                }

                goto st0;
st438:

                if ( ++p == pe )
                    goto _test_eof438;

            case 438:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr759;

                case 5:
                    goto tr759;

                case 8:
                    goto tr759;

                case 18:
                    goto tr760;

                case 21:
                    goto tr760;

                case 23:
                    goto tr760;

                case 36:
                    goto tr760;

                case 44:
                    goto tr760;

                case 48:
                    goto st427;

                case 53:
                    goto st428;

                case 54:
                    goto st429;

                case 55:
                    goto st430;

                case 56:
                    goto st431;

                case 57:
                    goto st432;

                case 58:
                    goto st433;

                case 59:
                    goto st434;

                case 60:
                    goto st435;

                case 61:
                    goto st436;

                case 62:
                    goto st439;

                case 79:
                    goto st440;

                case 80:
                    goto st441;

                case 81:
                    goto st451;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr760;

                goto st0;
st439:

                if ( ++p == pe )
                    goto _test_eof439;

            case 439:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr789;

                goto st0;
st440:

                if ( ++p == pe )
                    goto _test_eof440;

            case 440:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr792;

                goto st0;
st441:

                if ( ++p == pe )
                    goto _test_eof441;

            case 441:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st442;

                case 21:
                    goto st443;

                case 23:
                    goto st447;
                }

                goto st0;
st442:

                if ( ++p == pe )
                    goto _test_eof442;

            case 442:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr796;

                goto st0;
st443:

                if ( ++p == pe )
                    goto _test_eof443;

            case 443:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr797;

                case 5:
                    goto tr797;

                case 8:
                    goto tr797;

                case 18:
                    goto tr798;

                case 21:
                    goto tr798;

                case 23:
                    goto tr798;

                case 36:
                    goto tr798;

                case 44:
                    goto tr798;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr798;

                goto st0;
tr797:

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
                case 19:
                    goto tr799;

                case 23:
                    goto st24;

                case 37:
                    goto st444;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr799:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st445;
st445:

                if ( ++p == pe )
                    goto _test_eof445;

            case 445:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr801;

                case 19:
                    goto tr799;

                case 23:
                    goto st24;

                case 37:
                    goto st444;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr798:

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
                case 3:
                    goto st444;

                case 5:
                    goto st444;

                case 8:
                    goto st444;

                case 13:
                    goto st446;

                case 18:
                    goto st446;

                case 21:
                    goto st446;

                case 23:
                    goto st446;

                case 36:
                    goto st446;

                case 44:
                    goto st446;
                }

                goto st0;
st447:

                if ( ++p == pe )
                    goto _test_eof447;

            case 447:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr803;

                case 5:
                    goto tr803;

                case 8:
                    goto tr803;

                case 18:
                    goto tr804;

                case 21:
                    goto tr804;

                case 23:
                    goto tr804;

                case 36:
                    goto tr804;

                case 44:
                    goto tr804;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr804;

                goto st0;
tr803:

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
                case 19:
                    goto tr805;

                case 23:
                    goto st24;

                case 37:
                    goto st448;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr805:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st449;
st449:

                if ( ++p == pe )
                    goto _test_eof449;

            case 449:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr807;

                case 19:
                    goto tr805;

                case 23:
                    goto st24;

                case 37:
                    goto st448;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr804:

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
                case 3:
                    goto st448;

                case 5:
                    goto st448;

                case 8:
                    goto st448;

                case 13:
                    goto st450;

                case 18:
                    goto st450;

                case 21:
                    goto st450;

                case 23:
                    goto st450;

                case 36:
                    goto st450;

                case 44:
                    goto st450;
                }

                goto st0;
st451:

                if ( ++p == pe )
                    goto _test_eof451;

            case 451:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st452;

                case 21:
                    goto st453;

                case 23:
                    goto st457;
                }

                goto st0;
st452:

                if ( ++p == pe )
                    goto _test_eof452;

            case 452:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr812;

                goto st0;
st453:

                if ( ++p == pe )
                    goto _test_eof453;

            case 453:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr813;

                case 5:
                    goto tr813;

                case 8:
                    goto tr813;

                case 18:
                    goto tr814;

                case 21:
                    goto tr814;

                case 23:
                    goto tr814;

                case 36:
                    goto tr814;

                case 44:
                    goto tr814;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr814;

                goto st0;
tr813:

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
                    goto tr815;

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
tr815:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st455;
st455:

                if ( ++p == pe )
                    goto _test_eof455;

            case 455:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr817;

                case 19:
                    goto tr815;

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
                case 3:
                    goto tr819;

                case 5:
                    goto tr819;

                case 8:
                    goto tr819;

                case 18:
                    goto tr820;

                case 21:
                    goto tr820;

                case 23:
                    goto tr820;

                case 36:
                    goto tr820;

                case 44:
                    goto tr820;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr820;

                goto st0;
tr819:

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
                case 19:
                    goto tr821;

                case 23:
                    goto st24;

                case 37:
                    goto st458;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st459;
st459:

                if ( ++p == pe )
                    goto _test_eof459;

            case 459:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr823;

                case 19:
                    goto tr821;

                case 23:
                    goto st24;

                case 37:
                    goto st458;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr820:

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
                case 3:
                    goto st458;

                case 5:
                    goto st458;

                case 8:
                    goto st458;

                case 13:
                    goto st460;

                case 18:
                    goto st460;

                case 21:
                    goto st460;

                case 23:
                    goto st460;

                case 36:
                    goto st460;

                case 44:
                    goto st460;
                }

                goto st0;
st461:

                if ( ++p == pe )
                    goto _test_eof461;

            case 461:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st462;

                goto st0;
st462:

                if ( ++p == pe )
                    goto _test_eof462;

            case 462:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st463;

                case 70:
                    goto st464;

                case 71:
                    goto st465;

                case 75:
                    goto st466;
                }

                goto st0;
st463:

                if ( ++p == pe )
                    goto _test_eof463;

            case 463:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr830;

                goto st0;
st464:

                if ( ++p == pe )
                    goto _test_eof464;

            case 464:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr831;

                goto st0;
st465:

                if ( ++p == pe )
                    goto _test_eof465;

            case 465:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr832;

                goto st0;
st466:

                if ( ++p == pe )
                    goto _test_eof466;

            case 466:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr833;

                goto st0;
st467:

                if ( ++p == pe )
                    goto _test_eof467;

            case 467:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr834;

                goto st0;
st468:

                if ( ++p == pe )
                    goto _test_eof468;

            case 468:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr835;

                case 5:
                    goto tr835;

                case 8:
                    goto tr835;

                case 18:
                    goto tr836;

                case 21:
                    goto tr836;

                case 23:
                    goto tr836;

                case 36:
                    goto tr836;

                case 44:
                    goto tr836;

                case 48:
                    goto st471;

                case 53:
                    goto st472;

                case 54:
                    goto st473;

                case 55:
                    goto st474;

                case 56:
                    goto st475;

                case 57:
                    goto st476;

                case 58:
                    goto st477;

                case 59:
                    goto st478;

                case 60:
                    goto st479;

                case 61:
                    goto st480;

                case 62:
                    goto st481;

                case 79:
                    goto st484;

                case 80:
                    goto st485;

                case 81:
                    goto st495;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr836;

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
                case 12:
                    goto tr851;

                case 19:
                    goto st469;

                case 23:
                    goto st470;

                case 37:
                    goto st469;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st470;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st470;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st470;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st470;
                }
                else
                    goto st470;

                goto st0;
tr836:

                {
                    expr_start = p;
                }
                goto st470;
st470:

                if ( ++p == pe )
                    goto _test_eof470;

            case 470:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st469;

                case 5:
                    goto st469;

                case 8:
                    goto st469;

                case 13:
                    goto st470;

                case 18:
                    goto st470;

                case 21:
                    goto st470;

                case 23:
                    goto st470;

                case 36:
                    goto st470;

                case 44:
                    goto st470;
                }

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
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr863;

                goto st0;
st481:

                if ( ++p == pe )
                    goto _test_eof481;

            case 481:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr864;

                case 22:
                    goto st482;
                }

                goto st0;
st482:

                if ( ++p == pe )
                    goto _test_eof482;

            case 482:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr835;

                case 5:
                    goto tr835;

                case 8:
                    goto tr835;

                case 18:
                    goto tr836;

                case 21:
                    goto tr836;

                case 23:
                    goto tr836;

                case 36:
                    goto tr836;

                case 44:
                    goto tr836;

                case 48:
                    goto st471;

                case 53:
                    goto st472;

                case 54:
                    goto st473;

                case 55:
                    goto st474;

                case 56:
                    goto st475;

                case 57:
                    goto st476;

                case 58:
                    goto st477;

                case 59:
                    goto st478;

                case 60:
                    goto st479;

                case 61:
                    goto st480;

                case 62:
                    goto st483;

                case 79:
                    goto st484;

                case 80:
                    goto st485;

                case 81:
                    goto st495;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr836;

                goto st0;
st483:

                if ( ++p == pe )
                    goto _test_eof483;

            case 483:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr864;

                goto st0;
st484:

                if ( ++p == pe )
                    goto _test_eof484;

            case 484:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr867;

                goto st0;
st485:

                if ( ++p == pe )
                    goto _test_eof485;

            case 485:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st486;

                case 21:
                    goto st487;

                case 23:
                    goto st491;
                }

                goto st0;
st486:

                if ( ++p == pe )
                    goto _test_eof486;

            case 486:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr871;

                goto st0;
st487:

                if ( ++p == pe )
                    goto _test_eof487;

            case 487:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr872;

                case 5:
                    goto tr872;

                case 8:
                    goto tr872;

                case 18:
                    goto tr873;

                case 21:
                    goto tr873;

                case 23:
                    goto tr873;

                case 36:
                    goto tr873;

                case 44:
                    goto tr873;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr873;

                goto st0;
tr872:

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
                case 19:
                    goto tr874;

                case 23:
                    goto st24;

                case 37:
                    goto st488;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr874:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st489;
st489:

                if ( ++p == pe )
                    goto _test_eof489;

            case 489:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr876;

                case 19:
                    goto tr874;

                case 23:
                    goto st24;

                case 37:
                    goto st488;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                    expr_start = p;
                }
                goto st490;
st490:

                if ( ++p == pe )
                    goto _test_eof490;

            case 490:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st488;

                case 5:
                    goto st488;

                case 8:
                    goto st488;

                case 13:
                    goto st490;

                case 18:
                    goto st490;

                case 21:
                    goto st490;

                case 23:
                    goto st490;

                case 36:
                    goto st490;

                case 44:
                    goto st490;
                }

                goto st0;
st491:

                if ( ++p == pe )
                    goto _test_eof491;

            case 491:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr878;

                case 5:
                    goto tr878;

                case 8:
                    goto tr878;

                case 18:
                    goto tr879;

                case 21:
                    goto tr879;

                case 23:
                    goto tr879;

                case 36:
                    goto tr879;

                case 44:
                    goto tr879;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr879;

                goto st0;
tr878:

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
                case 19:
                    goto tr880;

                case 23:
                    goto st24;

                case 37:
                    goto st492;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr880:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st493;
st493:

                if ( ++p == pe )
                    goto _test_eof493;

            case 493:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr882;

                case 19:
                    goto tr880;

                case 23:
                    goto st24;

                case 37:
                    goto st492;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                    expr_start = p;
                }
                goto st494;
st494:

                if ( ++p == pe )
                    goto _test_eof494;

            case 494:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st492;

                case 5:
                    goto st492;

                case 8:
                    goto st492;

                case 13:
                    goto st494;

                case 18:
                    goto st494;

                case 21:
                    goto st494;

                case 23:
                    goto st494;

                case 36:
                    goto st494;

                case 44:
                    goto st494;
                }

                goto st0;
st495:

                if ( ++p == pe )
                    goto _test_eof495;

            case 495:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st496;

                case 21:
                    goto st497;

                case 23:
                    goto st501;
                }

                goto st0;
st496:

                if ( ++p == pe )
                    goto _test_eof496;

            case 496:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr887;

                goto st0;
st497:

                if ( ++p == pe )
                    goto _test_eof497;

            case 497:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr888;

                case 5:
                    goto tr888;

                case 8:
                    goto tr888;

                case 18:
                    goto tr889;

                case 21:
                    goto tr889;

                case 23:
                    goto tr889;

                case 36:
                    goto tr889;

                case 44:
                    goto tr889;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr889;

                goto st0;
tr888:

                {
                    expr_start = p;
                }
                goto st498;
st498:

                if ( ++p == pe )
                    goto _test_eof498;

            case 498:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr890;

                case 23:
                    goto st24;

                case 37:
                    goto st498;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st499;
st499:

                if ( ++p == pe )
                    goto _test_eof499;

            case 499:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr892;

                case 19:
                    goto tr890;

                case 23:
                    goto st24;

                case 37:
                    goto st498;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                    expr_start = p;
                }
                goto st500;
st500:

                if ( ++p == pe )
                    goto _test_eof500;

            case 500:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st498;

                case 5:
                    goto st498;

                case 8:
                    goto st498;

                case 13:
                    goto st500;

                case 18:
                    goto st500;

                case 21:
                    goto st500;

                case 23:
                    goto st500;

                case 36:
                    goto st500;

                case 44:
                    goto st500;
                }

                goto st0;
st501:

                if ( ++p == pe )
                    goto _test_eof501;

            case 501:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr894;

                case 5:
                    goto tr894;

                case 8:
                    goto tr894;

                case 18:
                    goto tr895;

                case 21:
                    goto tr895;

                case 23:
                    goto tr895;

                case 36:
                    goto tr895;

                case 44:
                    goto tr895;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr895;

                goto st0;
tr894:

                {
                    expr_start = p;
                }
                goto st502;
st502:

                if ( ++p == pe )
                    goto _test_eof502;

            case 502:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr896;

                case 23:
                    goto st24;

                case 37:
                    goto st502;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr896:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st503;
st503:

                if ( ++p == pe )
                    goto _test_eof503;

            case 503:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr898;

                case 19:
                    goto tr896;

                case 23:
                    goto st24;

                case 37:
                    goto st502;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                    expr_start = p;
                }
                goto st504;
st504:

                if ( ++p == pe )
                    goto _test_eof504;

            case 504:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st502;

                case 5:
                    goto st502;

                case 8:
                    goto st502;

                case 13:
                    goto st504;

                case 18:
                    goto st504;

                case 21:
                    goto st504;

                case 23:
                    goto st504;

                case 36:
                    goto st504;

                case 44:
                    goto st504;
                }

                goto st0;
st505:

                if ( ++p == pe )
                    goto _test_eof505;

            case 505:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr900;

                case 5:
                    goto tr900;

                case 8:
                    goto tr900;

                case 18:
                    goto tr901;

                case 21:
                    goto tr901;

                case 23:
                    goto tr901;

                case 36:
                    goto tr901;

                case 44:
                    goto tr901;

                case 48:
                    goto st508;

                case 53:
                    goto st509;

                case 54:
                    goto st510;

                case 55:
                    goto st511;

                case 56:
                    goto st512;

                case 57:
                    goto st513;

                case 58:
                    goto st514;

                case 59:
                    goto st515;

                case 60:
                    goto st516;

                case 61:
                    goto st517;

                case 62:
                    goto st518;

                case 79:
                    goto st521;

                case 80:
                    goto st522;

                case 81:
                    goto st532;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr901;

                goto st0;
tr900:

                {
                    expr_start = p;
                }
                goto st506;
st506:

                if ( ++p == pe )
                    goto _test_eof506;

            case 506:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr916;

                case 19:
                    goto st506;

                case 23:
                    goto st507;

                case 37:
                    goto st506;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st507;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st507;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st507;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st507;
                }
                else
                    goto st507;

                goto st0;
tr901:

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
                    goto st506;

                case 5:
                    goto st506;

                case 8:
                    goto st506;

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
                    goto tr919;

                goto st0;
st509:

                if ( ++p == pe )
                    goto _test_eof509;

            case 509:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr920;

                goto st0;
st510:

                if ( ++p == pe )
                    goto _test_eof510;

            case 510:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr921;

                goto st0;
st511:

                if ( ++p == pe )
                    goto _test_eof511;

            case 511:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr922;

                goto st0;
st512:

                if ( ++p == pe )
                    goto _test_eof512;

            case 512:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr923;

                goto st0;
st513:

                if ( ++p == pe )
                    goto _test_eof513;

            case 513:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr924;

                goto st0;
st514:

                if ( ++p == pe )
                    goto _test_eof514;

            case 514:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr925;

                goto st0;
st515:

                if ( ++p == pe )
                    goto _test_eof515;

            case 515:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr926;

                goto st0;
st516:

                if ( ++p == pe )
                    goto _test_eof516;

            case 516:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr927;

                goto st0;
st517:

                if ( ++p == pe )
                    goto _test_eof517;

            case 517:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr928;

                goto st0;
st518:

                if ( ++p == pe )
                    goto _test_eof518;

            case 518:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr929;

                case 22:
                    goto st519;
                }

                goto st0;
st519:

                if ( ++p == pe )
                    goto _test_eof519;

            case 519:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr900;

                case 5:
                    goto tr900;

                case 8:
                    goto tr900;

                case 18:
                    goto tr901;

                case 21:
                    goto tr901;

                case 23:
                    goto tr901;

                case 36:
                    goto tr901;

                case 44:
                    goto tr901;

                case 48:
                    goto st508;

                case 53:
                    goto st509;

                case 54:
                    goto st510;

                case 55:
                    goto st511;

                case 56:
                    goto st512;

                case 57:
                    goto st513;

                case 58:
                    goto st514;

                case 59:
                    goto st515;

                case 60:
                    goto st516;

                case 61:
                    goto st517;

                case 62:
                    goto st520;

                case 79:
                    goto st521;

                case 80:
                    goto st522;

                case 81:
                    goto st532;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr901;

                goto st0;
st520:

                if ( ++p == pe )
                    goto _test_eof520;

            case 520:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr929;

                goto st0;
st521:

                if ( ++p == pe )
                    goto _test_eof521;

            case 521:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr932;

                goto st0;
st522:

                if ( ++p == pe )
                    goto _test_eof522;

            case 522:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st523;

                case 21:
                    goto st524;

                case 23:
                    goto st528;
                }

                goto st0;
st523:

                if ( ++p == pe )
                    goto _test_eof523;

            case 523:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr936;

                goto st0;
st524:

                if ( ++p == pe )
                    goto _test_eof524;

            case 524:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr937;

                case 5:
                    goto tr937;

                case 8:
                    goto tr937;

                case 18:
                    goto tr938;

                case 21:
                    goto tr938;

                case 23:
                    goto tr938;

                case 36:
                    goto tr938;

                case 44:
                    goto tr938;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr938;

                goto st0;
tr937:

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
                    goto tr939;

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
tr939:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st526;
st526:

                if ( ++p == pe )
                    goto _test_eof526;

            case 526:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr941;

                case 19:
                    goto tr939;

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
tr938:

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
                case 3:
                    goto tr943;

                case 5:
                    goto tr943;

                case 8:
                    goto tr943;

                case 18:
                    goto tr944;

                case 21:
                    goto tr944;

                case 23:
                    goto tr944;

                case 36:
                    goto tr944;

                case 44:
                    goto tr944;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr944;

                goto st0;
tr943:

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
                case 19:
                    goto tr945;

                case 23:
                    goto st24;

                case 37:
                    goto st529;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr945:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st530;
st530:

                if ( ++p == pe )
                    goto _test_eof530;

            case 530:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr947;

                case 19:
                    goto tr945;

                case 23:
                    goto st24;

                case 37:
                    goto st529;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr944:

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
                case 3:
                    goto st529;

                case 5:
                    goto st529;

                case 8:
                    goto st529;

                case 13:
                    goto st531;

                case 18:
                    goto st531;

                case 21:
                    goto st531;

                case 23:
                    goto st531;

                case 36:
                    goto st531;

                case 44:
                    goto st531;
                }

                goto st0;
st532:

                if ( ++p == pe )
                    goto _test_eof532;

            case 532:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st533;

                case 21:
                    goto st534;

                case 23:
                    goto st538;
                }

                goto st0;
st533:

                if ( ++p == pe )
                    goto _test_eof533;

            case 533:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr952;

                goto st0;
st534:

                if ( ++p == pe )
                    goto _test_eof534;

            case 534:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr953;

                case 5:
                    goto tr953;

                case 8:
                    goto tr953;

                case 18:
                    goto tr954;

                case 21:
                    goto tr954;

                case 23:
                    goto tr954;

                case 36:
                    goto tr954;

                case 44:
                    goto tr954;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr954;

                goto st0;
tr953:

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
                    goto tr955;

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
tr955:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st536;
st536:

                if ( ++p == pe )
                    goto _test_eof536;

            case 536:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr957;

                case 19:
                    goto tr955;

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
tr954:

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
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr959;

                case 5:
                    goto tr959;

                case 8:
                    goto tr959;

                case 18:
                    goto tr960;

                case 21:
                    goto tr960;

                case 23:
                    goto tr960;

                case 36:
                    goto tr960;

                case 44:
                    goto tr960;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr960;

                goto st0;
tr959:

                {
                    expr_start = p;
                }
                goto st539;
st539:

                if ( ++p == pe )
                    goto _test_eof539;

            case 539:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr961;

                case 23:
                    goto st24;

                case 37:
                    goto st539;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr961:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st540;
st540:

                if ( ++p == pe )
                    goto _test_eof540;

            case 540:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr963;

                case 19:
                    goto tr961;

                case 23:
                    goto st24;

                case 37:
                    goto st539;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr960:

                {
                    expr_start = p;
                }
                goto st541;
st541:

                if ( ++p == pe )
                    goto _test_eof541;

            case 541:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st539;

                case 5:
                    goto st539;

                case 8:
                    goto st539;

                case 13:
                    goto st541;

                case 18:
                    goto st541;

                case 21:
                    goto st541;

                case 23:
                    goto st541;

                case 36:
                    goto st541;

                case 44:
                    goto st541;
                }

                goto st0;
st542:

                if ( ++p == pe )
                    goto _test_eof542;

            case 542:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st543;

                case 53:
                    goto st544;

                case 54:
                    goto st545;

                case 55:
                    goto st546;

                case 56:
                    goto st547;

                case 59:
                    goto st548;

                case 62:
                    goto st549;

                case 79:
                    goto st550;

                case 80:
                    goto st551;

                case 81:
                    goto st561;
                }

                goto st0;
st543:

                if ( ++p == pe )
                    goto _test_eof543;

            case 543:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr975;

                goto st0;
st544:

                if ( ++p == pe )
                    goto _test_eof544;

            case 544:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr976;

                goto st0;
st545:

                if ( ++p == pe )
                    goto _test_eof545;

            case 545:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr977;

                goto st0;
st546:

                if ( ++p == pe )
                    goto _test_eof546;

            case 546:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr978;

                goto st0;
st547:

                if ( ++p == pe )
                    goto _test_eof547;

            case 547:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr979;

                goto st0;
st548:

                if ( ++p == pe )
                    goto _test_eof548;

            case 548:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr980;

                goto st0;
st549:

                if ( ++p == pe )
                    goto _test_eof549;

            case 549:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr981;

                goto st0;
st550:

                if ( ++p == pe )
                    goto _test_eof550;

            case 550:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr982;

                goto st0;
st551:

                if ( ++p == pe )
                    goto _test_eof551;

            case 551:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st552;

                case 21:
                    goto st553;

                case 23:
                    goto st557;
                }

                goto st0;
st552:

                if ( ++p == pe )
                    goto _test_eof552;

            case 552:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr986;

                goto st0;
st553:

                if ( ++p == pe )
                    goto _test_eof553;

            case 553:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr987;

                case 5:
                    goto tr987;

                case 8:
                    goto tr987;

                case 18:
                    goto tr988;

                case 21:
                    goto tr988;

                case 23:
                    goto tr988;

                case 36:
                    goto tr988;

                case 44:
                    goto tr988;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr988;

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
                case 19:
                    goto tr989;

                case 23:
                    goto st24;

                case 37:
                    goto st554;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr989:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st555;
st555:

                if ( ++p == pe )
                    goto _test_eof555;

            case 555:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr991;

                case 19:
                    goto tr989;

                case 23:
                    goto st24;

                case 37:
                    goto st554;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                    expr_start = p;
                }
                goto st556;
st556:

                if ( ++p == pe )
                    goto _test_eof556;

            case 556:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st554;

                case 5:
                    goto st554;

                case 8:
                    goto st554;

                case 13:
                    goto st556;

                case 18:
                    goto st556;

                case 21:
                    goto st556;

                case 23:
                    goto st556;

                case 36:
                    goto st556;

                case 44:
                    goto st556;
                }

                goto st0;
st557:

                if ( ++p == pe )
                    goto _test_eof557;

            case 557:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr993;

                case 5:
                    goto tr993;

                case 8:
                    goto tr993;

                case 18:
                    goto tr994;

                case 21:
                    goto tr994;

                case 23:
                    goto tr994;

                case 36:
                    goto tr994;

                case 44:
                    goto tr994;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr994;

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
                case 19:
                    goto tr995;

                case 23:
                    goto st24;

                case 37:
                    goto st558;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr995:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st559;
st559:

                if ( ++p == pe )
                    goto _test_eof559;

            case 559:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr997;

                case 19:
                    goto tr995;

                case 23:
                    goto st24;

                case 37:
                    goto st558;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                    expr_start = p;
                }
                goto st560;
st560:

                if ( ++p == pe )
                    goto _test_eof560;

            case 560:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st558;

                case 5:
                    goto st558;

                case 8:
                    goto st558;

                case 13:
                    goto st560;

                case 18:
                    goto st560;

                case 21:
                    goto st560;

                case 23:
                    goto st560;

                case 36:
                    goto st560;

                case 44:
                    goto st560;
                }

                goto st0;
st561:

                if ( ++p == pe )
                    goto _test_eof561;

            case 561:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st562;

                case 21:
                    goto st563;

                case 23:
                    goto st567;
                }

                goto st0;
st562:

                if ( ++p == pe )
                    goto _test_eof562;

            case 562:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1002;

                goto st0;
st563:

                if ( ++p == pe )
                    goto _test_eof563;

            case 563:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1003;

                case 5:
                    goto tr1003;

                case 8:
                    goto tr1003;

                case 18:
                    goto tr1004;

                case 21:
                    goto tr1004;

                case 23:
                    goto tr1004;

                case 36:
                    goto tr1004;

                case 44:
                    goto tr1004;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1004;

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
                case 19:
                    goto tr1005;

                case 23:
                    goto st24;

                case 37:
                    goto st564;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1005:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st565;
st565:

                if ( ++p == pe )
                    goto _test_eof565;

            case 565:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1007;

                case 19:
                    goto tr1005;

                case 23:
                    goto st24;

                case 37:
                    goto st564;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                    expr_start = p;
                }
                goto st566;
st566:

                if ( ++p == pe )
                    goto _test_eof566;

            case 566:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st564;

                case 5:
                    goto st564;

                case 8:
                    goto st564;

                case 13:
                    goto st566;

                case 18:
                    goto st566;

                case 21:
                    goto st566;

                case 23:
                    goto st566;

                case 36:
                    goto st566;

                case 44:
                    goto st566;
                }

                goto st0;
st567:

                if ( ++p == pe )
                    goto _test_eof567;

            case 567:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1009;

                case 5:
                    goto tr1009;

                case 8:
                    goto tr1009;

                case 18:
                    goto tr1010;

                case 21:
                    goto tr1010;

                case 23:
                    goto tr1010;

                case 36:
                    goto tr1010;

                case 44:
                    goto tr1010;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1010;

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
                case 19:
                    goto tr1011;

                case 23:
                    goto st24;

                case 37:
                    goto st568;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1011:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st569;
st569:

                if ( ++p == pe )
                    goto _test_eof569;

            case 569:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1013;

                case 19:
                    goto tr1011;

                case 23:
                    goto st24;

                case 37:
                    goto st568;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                    expr_start = p;
                }
                goto st570;
st570:

                if ( ++p == pe )
                    goto _test_eof570;

            case 570:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st568;

                case 5:
                    goto st568;

                case 8:
                    goto st568;

                case 13:
                    goto st570;

                case 18:
                    goto st570;

                case 21:
                    goto st570;

                case 23:
                    goto st570;

                case 36:
                    goto st570;

                case 44:
                    goto st570;
                }

                goto st0;
st571:

                if ( ++p == pe )
                    goto _test_eof571;

            case 571:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st572;

                case 53:
                    goto st573;

                case 54:
                    goto st574;

                case 55:
                    goto st575;

                case 56:
                    goto st576;

                case 59:
                    goto st577;

                case 62:
                    goto st578;

                case 79:
                    goto st579;

                case 80:
                    goto st580;

                case 81:
                    goto st590;
                }

                goto st0;
st572:

                if ( ++p == pe )
                    goto _test_eof572;

            case 572:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1025;

                goto st0;
st573:

                if ( ++p == pe )
                    goto _test_eof573;

            case 573:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1026;

                goto st0;
st574:

                if ( ++p == pe )
                    goto _test_eof574;

            case 574:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1027;

                goto st0;
st575:

                if ( ++p == pe )
                    goto _test_eof575;

            case 575:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1028;

                goto st0;
st576:

                if ( ++p == pe )
                    goto _test_eof576;

            case 576:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1029;

                goto st0;
st577:

                if ( ++p == pe )
                    goto _test_eof577;

            case 577:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1030;

                goto st0;
st578:

                if ( ++p == pe )
                    goto _test_eof578;

            case 578:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1031;

                goto st0;
st579:

                if ( ++p == pe )
                    goto _test_eof579;

            case 579:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1032;

                goto st0;
st580:

                if ( ++p == pe )
                    goto _test_eof580;

            case 580:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st581;

                case 21:
                    goto st582;

                case 23:
                    goto st586;
                }

                goto st0;
st581:

                if ( ++p == pe )
                    goto _test_eof581;

            case 581:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1036;

                goto st0;
st582:

                if ( ++p == pe )
                    goto _test_eof582;

            case 582:
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
                goto st583;
st583:

                if ( ++p == pe )
                    goto _test_eof583;

            case 583:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1039;

                case 23:
                    goto st24;

                case 37:
                    goto st583;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                goto st584;
st584:

                if ( ++p == pe )
                    goto _test_eof584;

            case 584:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1041;

                case 19:
                    goto tr1039;

                case 23:
                    goto st24;

                case 37:
                    goto st583;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                goto st585;
st585:

                if ( ++p == pe )
                    goto _test_eof585;

            case 585:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st583;

                case 5:
                    goto st583;

                case 8:
                    goto st583;

                case 13:
                    goto st585;

                case 18:
                    goto st585;

                case 21:
                    goto st585;

                case 23:
                    goto st585;

                case 36:
                    goto st585;

                case 44:
                    goto st585;
                }

                goto st0;
st586:

                if ( ++p == pe )
                    goto _test_eof586;

            case 586:
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
                goto st587;
st587:

                if ( ++p == pe )
                    goto _test_eof587;

            case 587:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1045;

                case 23:
                    goto st24;

                case 37:
                    goto st587;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                goto st588;
st588:

                if ( ++p == pe )
                    goto _test_eof588;

            case 588:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1047;

                case 19:
                    goto tr1045;

                case 23:
                    goto st24;

                case 37:
                    goto st587;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                goto st589;
st589:

                if ( ++p == pe )
                    goto _test_eof589;

            case 589:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st587;

                case 5:
                    goto st587;

                case 8:
                    goto st587;

                case 13:
                    goto st589;

                case 18:
                    goto st589;

                case 21:
                    goto st589;

                case 23:
                    goto st589;

                case 36:
                    goto st589;

                case 44:
                    goto st589;
                }

                goto st0;
st590:

                if ( ++p == pe )
                    goto _test_eof590;

            case 590:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st591;

                case 21:
                    goto st592;

                case 23:
                    goto st596;
                }

                goto st0;
st591:

                if ( ++p == pe )
                    goto _test_eof591;

            case 591:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1052;

                goto st0;
st592:

                if ( ++p == pe )
                    goto _test_eof592;

            case 592:
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
                goto st593;
st593:

                if ( ++p == pe )
                    goto _test_eof593;

            case 593:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1055;

                case 23:
                    goto st24;

                case 37:
                    goto st593;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                goto st594;
st594:

                if ( ++p == pe )
                    goto _test_eof594;

            case 594:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1057;

                case 19:
                    goto tr1055;

                case 23:
                    goto st24;

                case 37:
                    goto st593;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                goto st595;
st595:

                if ( ++p == pe )
                    goto _test_eof595;

            case 595:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st593;

                case 5:
                    goto st593;

                case 8:
                    goto st593;

                case 13:
                    goto st595;

                case 18:
                    goto st595;

                case 21:
                    goto st595;

                case 23:
                    goto st595;

                case 36:
                    goto st595;

                case 44:
                    goto st595;
                }

                goto st0;
st596:

                if ( ++p == pe )
                    goto _test_eof596;

            case 596:
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
                goto st597;
st597:

                if ( ++p == pe )
                    goto _test_eof597;

            case 597:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1061;

                case 23:
                    goto st24;

                case 37:
                    goto st597;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                goto st598;
st598:

                if ( ++p == pe )
                    goto _test_eof598;

            case 598:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1063;

                case 19:
                    goto tr1061;

                case 23:
                    goto st24;

                case 37:
                    goto st597;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                goto st599;
st599:

                if ( ++p == pe )
                    goto _test_eof599;

            case 599:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st597;

                case 5:
                    goto st597;

                case 8:
                    goto st597;

                case 13:
                    goto st599;

                case 18:
                    goto st599;

                case 21:
                    goto st599;

                case 23:
                    goto st599;

                case 36:
                    goto st599;

                case 44:
                    goto st599;
                }

                goto st0;
st600:

                if ( ++p == pe )
                    goto _test_eof600;

            case 600:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st601;

                case 53:
                    goto st602;

                case 54:
                    goto st603;

                case 55:
                    goto st604;

                case 56:
                    goto st605;

                case 59:
                    goto st606;

                case 62:
                    goto st607;

                case 79:
                    goto st608;

                case 80:
                    goto st609;

                case 81:
                    goto st619;
                }

                goto st0;
st601:

                if ( ++p == pe )
                    goto _test_eof601;

            case 601:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1075;

                goto st0;
st602:

                if ( ++p == pe )
                    goto _test_eof602;

            case 602:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1076;

                goto st0;
st603:

                if ( ++p == pe )
                    goto _test_eof603;

            case 603:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1077;

                goto st0;
st604:

                if ( ++p == pe )
                    goto _test_eof604;

            case 604:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1078;

                goto st0;
st605:

                if ( ++p == pe )
                    goto _test_eof605;

            case 605:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1079;

                goto st0;
st606:

                if ( ++p == pe )
                    goto _test_eof606;

            case 606:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1080;

                goto st0;
st607:

                if ( ++p == pe )
                    goto _test_eof607;

            case 607:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1081;

                goto st0;
st608:

                if ( ++p == pe )
                    goto _test_eof608;

            case 608:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1082;

                goto st0;
st609:

                if ( ++p == pe )
                    goto _test_eof609;

            case 609:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st610;

                case 21:
                    goto st611;

                case 23:
                    goto st615;
                }

                goto st0;
st610:

                if ( ++p == pe )
                    goto _test_eof610;

            case 610:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1086;

                goto st0;
st611:

                if ( ++p == pe )
                    goto _test_eof611;

            case 611:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1087;

                case 5:
                    goto tr1087;

                case 8:
                    goto tr1087;

                case 18:
                    goto tr1088;

                case 21:
                    goto tr1088;

                case 23:
                    goto tr1088;

                case 36:
                    goto tr1088;

                case 44:
                    goto tr1088;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1088;

                goto st0;
tr1087:

                {
                    expr_start = p;
                }
                goto st612;
st612:

                if ( ++p == pe )
                    goto _test_eof612;

            case 612:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1089;

                case 23:
                    goto st24;

                case 37:
                    goto st612;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1089:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st613;
st613:

                if ( ++p == pe )
                    goto _test_eof613;

            case 613:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1091;

                case 19:
                    goto tr1089;

                case 23:
                    goto st24;

                case 37:
                    goto st612;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1088:

                {
                    expr_start = p;
                }
                goto st614;
st614:

                if ( ++p == pe )
                    goto _test_eof614;

            case 614:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st612;

                case 5:
                    goto st612;

                case 8:
                    goto st612;

                case 13:
                    goto st614;

                case 18:
                    goto st614;

                case 21:
                    goto st614;

                case 23:
                    goto st614;

                case 36:
                    goto st614;

                case 44:
                    goto st614;
                }

                goto st0;
st615:

                if ( ++p == pe )
                    goto _test_eof615;

            case 615:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1093;

                case 5:
                    goto tr1093;

                case 8:
                    goto tr1093;

                case 18:
                    goto tr1094;

                case 21:
                    goto tr1094;

                case 23:
                    goto tr1094;

                case 36:
                    goto tr1094;

                case 44:
                    goto tr1094;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1094;

                goto st0;
tr1093:

                {
                    expr_start = p;
                }
                goto st616;
st616:

                if ( ++p == pe )
                    goto _test_eof616;

            case 616:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1095;

                case 23:
                    goto st24;

                case 37:
                    goto st616;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1095:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st617;
st617:

                if ( ++p == pe )
                    goto _test_eof617;

            case 617:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1097;

                case 19:
                    goto tr1095;

                case 23:
                    goto st24;

                case 37:
                    goto st616;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1094:

                {
                    expr_start = p;
                }
                goto st618;
st618:

                if ( ++p == pe )
                    goto _test_eof618;

            case 618:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st616;

                case 5:
                    goto st616;

                case 8:
                    goto st616;

                case 13:
                    goto st618;

                case 18:
                    goto st618;

                case 21:
                    goto st618;

                case 23:
                    goto st618;

                case 36:
                    goto st618;

                case 44:
                    goto st618;
                }

                goto st0;
st619:

                if ( ++p == pe )
                    goto _test_eof619;

            case 619:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st620;

                case 21:
                    goto st621;

                case 23:
                    goto st625;
                }

                goto st0;
st620:

                if ( ++p == pe )
                    goto _test_eof620;

            case 620:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1102;

                goto st0;
st621:

                if ( ++p == pe )
                    goto _test_eof621;

            case 621:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1103;

                case 5:
                    goto tr1103;

                case 8:
                    goto tr1103;

                case 18:
                    goto tr1104;

                case 21:
                    goto tr1104;

                case 23:
                    goto tr1104;

                case 36:
                    goto tr1104;

                case 44:
                    goto tr1104;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1104;

                goto st0;
tr1103:

                {
                    expr_start = p;
                }
                goto st622;
st622:

                if ( ++p == pe )
                    goto _test_eof622;

            case 622:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1105;

                case 23:
                    goto st24;

                case 37:
                    goto st622;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1105:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st623;
st623:

                if ( ++p == pe )
                    goto _test_eof623;

            case 623:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1107;

                case 19:
                    goto tr1105;

                case 23:
                    goto st24;

                case 37:
                    goto st622;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1104:

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
                case 3:
                    goto st622;

                case 5:
                    goto st622;

                case 8:
                    goto st622;

                case 13:
                    goto st624;

                case 18:
                    goto st624;

                case 21:
                    goto st624;

                case 23:
                    goto st624;

                case 36:
                    goto st624;

                case 44:
                    goto st624;
                }

                goto st0;
st625:

                if ( ++p == pe )
                    goto _test_eof625;

            case 625:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1109;

                case 5:
                    goto tr1109;

                case 8:
                    goto tr1109;

                case 18:
                    goto tr1110;

                case 21:
                    goto tr1110;

                case 23:
                    goto tr1110;

                case 36:
                    goto tr1110;

                case 44:
                    goto tr1110;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1110;

                goto st0;
tr1109:

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
                case 19:
                    goto tr1111;

                case 23:
                    goto st24;

                case 37:
                    goto st626;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
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
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st627;
st627:

                if ( ++p == pe )
                    goto _test_eof627;

            case 627:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1113;

                case 19:
                    goto tr1111;

                case 23:
                    goto st24;

                case 37:
                    goto st626;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1110:

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
                case 3:
                    goto st626;

                case 5:
                    goto st626;

                case 8:
                    goto st626;

                case 13:
                    goto st628;

                case 18:
                    goto st628;

                case 21:
                    goto st628;

                case 23:
                    goto st628;

                case 36:
                    goto st628;

                case 44:
                    goto st628;
                }

                goto st0;
st629:

                if ( ++p == pe )
                    goto _test_eof629;

            case 629:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st630;

                case 53:
                    goto st631;

                case 54:
                    goto st632;

                case 55:
                    goto st633;

                case 56:
                    goto st634;

                case 59:
                    goto st635;

                case 62:
                    goto st636;

                case 79:
                    goto st637;

                case 80:
                    goto st638;

                case 81:
                    goto st648;
                }

                goto st0;
st630:

                if ( ++p == pe )
                    goto _test_eof630;

            case 630:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1125;

                goto st0;
st631:

                if ( ++p == pe )
                    goto _test_eof631;

            case 631:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1126;

                goto st0;
st632:

                if ( ++p == pe )
                    goto _test_eof632;

            case 632:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1127;

                goto st0;
st633:

                if ( ++p == pe )
                    goto _test_eof633;

            case 633:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1128;

                goto st0;
st634:

                if ( ++p == pe )
                    goto _test_eof634;

            case 634:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1129;

                goto st0;
st635:

                if ( ++p == pe )
                    goto _test_eof635;

            case 635:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1130;

                goto st0;
st636:

                if ( ++p == pe )
                    goto _test_eof636;

            case 636:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1131;

                goto st0;
st637:

                if ( ++p == pe )
                    goto _test_eof637;

            case 637:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1132;

                goto st0;
st638:

                if ( ++p == pe )
                    goto _test_eof638;

            case 638:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st639;

                case 21:
                    goto st640;

                case 23:
                    goto st644;
                }

                goto st0;
st639:

                if ( ++p == pe )
                    goto _test_eof639;

            case 639:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1136;

                goto st0;
st640:

                if ( ++p == pe )
                    goto _test_eof640;

            case 640:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1137;

                case 5:
                    goto tr1137;

                case 8:
                    goto tr1137;

                case 18:
                    goto tr1138;

                case 21:
                    goto tr1138;

                case 23:
                    goto tr1138;

                case 36:
                    goto tr1138;

                case 44:
                    goto tr1138;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1138;

                goto st0;
tr1137:

                {
                    expr_start = p;
                }
                goto st641;
st641:

                if ( ++p == pe )
                    goto _test_eof641;

            case 641:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1139;

                case 23:
                    goto st24;

                case 37:
                    goto st641;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1139:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st642;
st642:

                if ( ++p == pe )
                    goto _test_eof642;

            case 642:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1141;

                case 19:
                    goto tr1139;

                case 23:
                    goto st24;

                case 37:
                    goto st641;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1138:

                {
                    expr_start = p;
                }
                goto st643;
st643:

                if ( ++p == pe )
                    goto _test_eof643;

            case 643:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st641;

                case 5:
                    goto st641;

                case 8:
                    goto st641;

                case 13:
                    goto st643;

                case 18:
                    goto st643;

                case 21:
                    goto st643;

                case 23:
                    goto st643;

                case 36:
                    goto st643;

                case 44:
                    goto st643;
                }

                goto st0;
st644:

                if ( ++p == pe )
                    goto _test_eof644;

            case 644:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1143;

                case 5:
                    goto tr1143;

                case 8:
                    goto tr1143;

                case 18:
                    goto tr1144;

                case 21:
                    goto tr1144;

                case 23:
                    goto tr1144;

                case 36:
                    goto tr1144;

                case 44:
                    goto tr1144;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1144;

                goto st0;
tr1143:

                {
                    expr_start = p;
                }
                goto st645;
st645:

                if ( ++p == pe )
                    goto _test_eof645;

            case 645:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1145;

                case 23:
                    goto st24;

                case 37:
                    goto st645;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1145:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st646;
st646:

                if ( ++p == pe )
                    goto _test_eof646;

            case 646:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1147;

                case 19:
                    goto tr1145;

                case 23:
                    goto st24;

                case 37:
                    goto st645;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1144:

                {
                    expr_start = p;
                }
                goto st647;
st647:

                if ( ++p == pe )
                    goto _test_eof647;

            case 647:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st645;

                case 5:
                    goto st645;

                case 8:
                    goto st645;

                case 13:
                    goto st647;

                case 18:
                    goto st647;

                case 21:
                    goto st647;

                case 23:
                    goto st647;

                case 36:
                    goto st647;

                case 44:
                    goto st647;
                }

                goto st0;
st648:

                if ( ++p == pe )
                    goto _test_eof648;

            case 648:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st649;

                case 21:
                    goto st650;

                case 23:
                    goto st654;
                }

                goto st0;
st649:

                if ( ++p == pe )
                    goto _test_eof649;

            case 649:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1152;

                goto st0;
st650:

                if ( ++p == pe )
                    goto _test_eof650;

            case 650:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1153;

                case 5:
                    goto tr1153;

                case 8:
                    goto tr1153;

                case 18:
                    goto tr1154;

                case 21:
                    goto tr1154;

                case 23:
                    goto tr1154;

                case 36:
                    goto tr1154;

                case 44:
                    goto tr1154;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1154;

                goto st0;
tr1153:

                {
                    expr_start = p;
                }
                goto st651;
st651:

                if ( ++p == pe )
                    goto _test_eof651;

            case 651:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1155;

                case 23:
                    goto st24;

                case 37:
                    goto st651;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1155:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st652;
st652:

                if ( ++p == pe )
                    goto _test_eof652;

            case 652:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1157;

                case 19:
                    goto tr1155;

                case 23:
                    goto st24;

                case 37:
                    goto st651;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1154:

                {
                    expr_start = p;
                }
                goto st653;
st653:

                if ( ++p == pe )
                    goto _test_eof653;

            case 653:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st651;

                case 5:
                    goto st651;

                case 8:
                    goto st651;

                case 13:
                    goto st653;

                case 18:
                    goto st653;

                case 21:
                    goto st653;

                case 23:
                    goto st653;

                case 36:
                    goto st653;

                case 44:
                    goto st653;
                }

                goto st0;
st654:

                if ( ++p == pe )
                    goto _test_eof654;

            case 654:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1159;

                case 5:
                    goto tr1159;

                case 8:
                    goto tr1159;

                case 18:
                    goto tr1160;

                case 21:
                    goto tr1160;

                case 23:
                    goto tr1160;

                case 36:
                    goto tr1160;

                case 44:
                    goto tr1160;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1160;

                goto st0;
tr1159:

                {
                    expr_start = p;
                }
                goto st655;
st655:

                if ( ++p == pe )
                    goto _test_eof655;

            case 655:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1161;

                case 23:
                    goto st24;

                case 37:
                    goto st655;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1161:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st656;
st656:

                if ( ++p == pe )
                    goto _test_eof656;

            case 656:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1163;

                case 19:
                    goto tr1161;

                case 23:
                    goto st24;

                case 37:
                    goto st655;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1160:

                {
                    expr_start = p;
                }
                goto st657;
st657:

                if ( ++p == pe )
                    goto _test_eof657;

            case 657:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st655;

                case 5:
                    goto st655;

                case 8:
                    goto st655;

                case 13:
                    goto st657;

                case 18:
                    goto st657;

                case 21:
                    goto st657;

                case 23:
                    goto st657;

                case 36:
                    goto st657;

                case 44:
                    goto st657;
                }

                goto st0;
st658:

                if ( ++p == pe )
                    goto _test_eof658;

            case 658:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st659;

                case 53:
                    goto st660;

                case 54:
                    goto st661;

                case 55:
                    goto st662;

                case 56:
                    goto st663;

                case 59:
                    goto st664;

                case 62:
                    goto st665;

                case 79:
                    goto st666;

                case 80:
                    goto st667;

                case 81:
                    goto st677;
                }

                goto st0;
st659:

                if ( ++p == pe )
                    goto _test_eof659;

            case 659:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1175;

                goto st0;
st660:

                if ( ++p == pe )
                    goto _test_eof660;

            case 660:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1176;

                goto st0;
st661:

                if ( ++p == pe )
                    goto _test_eof661;

            case 661:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1177;

                goto st0;
st662:

                if ( ++p == pe )
                    goto _test_eof662;

            case 662:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1178;

                goto st0;
st663:

                if ( ++p == pe )
                    goto _test_eof663;

            case 663:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1179;

                goto st0;
st664:

                if ( ++p == pe )
                    goto _test_eof664;

            case 664:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1180;

                goto st0;
st665:

                if ( ++p == pe )
                    goto _test_eof665;

            case 665:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1181;

                goto st0;
st666:

                if ( ++p == pe )
                    goto _test_eof666;

            case 666:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1182;

                goto st0;
st667:

                if ( ++p == pe )
                    goto _test_eof667;

            case 667:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st668;

                case 21:
                    goto st669;

                case 23:
                    goto st673;
                }

                goto st0;
st668:

                if ( ++p == pe )
                    goto _test_eof668;

            case 668:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1186;

                goto st0;
st669:

                if ( ++p == pe )
                    goto _test_eof669;

            case 669:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1187;

                case 5:
                    goto tr1187;

                case 8:
                    goto tr1187;

                case 18:
                    goto tr1188;

                case 21:
                    goto tr1188;

                case 23:
                    goto tr1188;

                case 36:
                    goto tr1188;

                case 44:
                    goto tr1188;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1188;

                goto st0;
tr1187:

                {
                    expr_start = p;
                }
                goto st670;
st670:

                if ( ++p == pe )
                    goto _test_eof670;

            case 670:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1189;

                case 23:
                    goto st24;

                case 37:
                    goto st670;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1189:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st671;
st671:

                if ( ++p == pe )
                    goto _test_eof671;

            case 671:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1191;

                case 19:
                    goto tr1189;

                case 23:
                    goto st24;

                case 37:
                    goto st670;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1188:

                {
                    expr_start = p;
                }
                goto st672;
st672:

                if ( ++p == pe )
                    goto _test_eof672;

            case 672:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st670;

                case 5:
                    goto st670;

                case 8:
                    goto st670;

                case 13:
                    goto st672;

                case 18:
                    goto st672;

                case 21:
                    goto st672;

                case 23:
                    goto st672;

                case 36:
                    goto st672;

                case 44:
                    goto st672;
                }

                goto st0;
st673:

                if ( ++p == pe )
                    goto _test_eof673;

            case 673:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1193;

                case 5:
                    goto tr1193;

                case 8:
                    goto tr1193;

                case 18:
                    goto tr1194;

                case 21:
                    goto tr1194;

                case 23:
                    goto tr1194;

                case 36:
                    goto tr1194;

                case 44:
                    goto tr1194;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1194;

                goto st0;
tr1193:

                {
                    expr_start = p;
                }
                goto st674;
st674:

                if ( ++p == pe )
                    goto _test_eof674;

            case 674:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1195;

                case 23:
                    goto st24;

                case 37:
                    goto st674;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1195:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st675;
st675:

                if ( ++p == pe )
                    goto _test_eof675;

            case 675:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1197;

                case 19:
                    goto tr1195;

                case 23:
                    goto st24;

                case 37:
                    goto st674;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1194:

                {
                    expr_start = p;
                }
                goto st676;
st676:

                if ( ++p == pe )
                    goto _test_eof676;

            case 676:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st674;

                case 5:
                    goto st674;

                case 8:
                    goto st674;

                case 13:
                    goto st676;

                case 18:
                    goto st676;

                case 21:
                    goto st676;

                case 23:
                    goto st676;

                case 36:
                    goto st676;

                case 44:
                    goto st676;
                }

                goto st0;
st677:

                if ( ++p == pe )
                    goto _test_eof677;

            case 677:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st678;

                case 21:
                    goto st679;

                case 23:
                    goto st683;
                }

                goto st0;
st678:

                if ( ++p == pe )
                    goto _test_eof678;

            case 678:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1202;

                goto st0;
st679:

                if ( ++p == pe )
                    goto _test_eof679;

            case 679:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1203;

                case 5:
                    goto tr1203;

                case 8:
                    goto tr1203;

                case 18:
                    goto tr1204;

                case 21:
                    goto tr1204;

                case 23:
                    goto tr1204;

                case 36:
                    goto tr1204;

                case 44:
                    goto tr1204;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1204;

                goto st0;
tr1203:

                {
                    expr_start = p;
                }
                goto st680;
st680:

                if ( ++p == pe )
                    goto _test_eof680;

            case 680:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1205;

                case 23:
                    goto st24;

                case 37:
                    goto st680;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1205:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st681;
st681:

                if ( ++p == pe )
                    goto _test_eof681;

            case 681:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1207;

                case 19:
                    goto tr1205;

                case 23:
                    goto st24;

                case 37:
                    goto st680;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1204:

                {
                    expr_start = p;
                }
                goto st682;
st682:

                if ( ++p == pe )
                    goto _test_eof682;

            case 682:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st680;

                case 5:
                    goto st680;

                case 8:
                    goto st680;

                case 13:
                    goto st682;

                case 18:
                    goto st682;

                case 21:
                    goto st682;

                case 23:
                    goto st682;

                case 36:
                    goto st682;

                case 44:
                    goto st682;
                }

                goto st0;
st683:

                if ( ++p == pe )
                    goto _test_eof683;

            case 683:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1209;

                case 5:
                    goto tr1209;

                case 8:
                    goto tr1209;

                case 18:
                    goto tr1210;

                case 21:
                    goto tr1210;

                case 23:
                    goto tr1210;

                case 36:
                    goto tr1210;

                case 44:
                    goto tr1210;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1210;

                goto st0;
tr1209:

                {
                    expr_start = p;
                }
                goto st684;
st684:

                if ( ++p == pe )
                    goto _test_eof684;

            case 684:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1211;

                case 23:
                    goto st24;

                case 37:
                    goto st684;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1211:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st685;
st685:

                if ( ++p == pe )
                    goto _test_eof685;

            case 685:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1213;

                case 19:
                    goto tr1211;

                case 23:
                    goto st24;

                case 37:
                    goto st684;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1210:

                {
                    expr_start = p;
                }
                goto st686;
st686:

                if ( ++p == pe )
                    goto _test_eof686;

            case 686:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st684;

                case 5:
                    goto st684;

                case 8:
                    goto st684;

                case 13:
                    goto st686;

                case 18:
                    goto st686;

                case 21:
                    goto st686;

                case 23:
                    goto st686;

                case 36:
                    goto st686;

                case 44:
                    goto st686;
                }

                goto st0;
st687:

                if ( ++p == pe )
                    goto _test_eof687;

            case 687:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st688;

                case 53:
                    goto st689;

                case 54:
                    goto st690;

                case 55:
                    goto st691;

                case 56:
                    goto st692;

                case 59:
                    goto st693;

                case 62:
                    goto st694;

                case 79:
                    goto st695;

                case 80:
                    goto st696;

                case 81:
                    goto st706;
                }

                goto st0;
st688:

                if ( ++p == pe )
                    goto _test_eof688;

            case 688:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1225;

                goto st0;
st689:

                if ( ++p == pe )
                    goto _test_eof689;

            case 689:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1226;

                goto st0;
st690:

                if ( ++p == pe )
                    goto _test_eof690;

            case 690:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1227;

                goto st0;
st691:

                if ( ++p == pe )
                    goto _test_eof691;

            case 691:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1228;

                goto st0;
st692:

                if ( ++p == pe )
                    goto _test_eof692;

            case 692:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1229;

                goto st0;
st693:

                if ( ++p == pe )
                    goto _test_eof693;

            case 693:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1230;

                goto st0;
st694:

                if ( ++p == pe )
                    goto _test_eof694;

            case 694:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1231;

                goto st0;
st695:

                if ( ++p == pe )
                    goto _test_eof695;

            case 695:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1232;

                goto st0;
st696:

                if ( ++p == pe )
                    goto _test_eof696;

            case 696:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st697;

                case 21:
                    goto st698;

                case 23:
                    goto st702;
                }

                goto st0;
st697:

                if ( ++p == pe )
                    goto _test_eof697;

            case 697:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1236;

                goto st0;
st698:

                if ( ++p == pe )
                    goto _test_eof698;

            case 698:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1237;

                case 5:
                    goto tr1237;

                case 8:
                    goto tr1237;

                case 18:
                    goto tr1238;

                case 21:
                    goto tr1238;

                case 23:
                    goto tr1238;

                case 36:
                    goto tr1238;

                case 44:
                    goto tr1238;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1238;

                goto st0;
tr1237:

                {
                    expr_start = p;
                }
                goto st699;
st699:

                if ( ++p == pe )
                    goto _test_eof699;

            case 699:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1239;

                case 23:
                    goto st24;

                case 37:
                    goto st699;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1239:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st700;
st700:

                if ( ++p == pe )
                    goto _test_eof700;

            case 700:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1241;

                case 19:
                    goto tr1239;

                case 23:
                    goto st24;

                case 37:
                    goto st699;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1238:

                {
                    expr_start = p;
                }
                goto st701;
st701:

                if ( ++p == pe )
                    goto _test_eof701;

            case 701:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st699;

                case 5:
                    goto st699;

                case 8:
                    goto st699;

                case 13:
                    goto st701;

                case 18:
                    goto st701;

                case 21:
                    goto st701;

                case 23:
                    goto st701;

                case 36:
                    goto st701;

                case 44:
                    goto st701;
                }

                goto st0;
st702:

                if ( ++p == pe )
                    goto _test_eof702;

            case 702:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1243;

                case 5:
                    goto tr1243;

                case 8:
                    goto tr1243;

                case 18:
                    goto tr1244;

                case 21:
                    goto tr1244;

                case 23:
                    goto tr1244;

                case 36:
                    goto tr1244;

                case 44:
                    goto tr1244;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1244;

                goto st0;
tr1243:

                {
                    expr_start = p;
                }
                goto st703;
st703:

                if ( ++p == pe )
                    goto _test_eof703;

            case 703:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1245;

                case 23:
                    goto st24;

                case 37:
                    goto st703;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1245:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st704;
st704:

                if ( ++p == pe )
                    goto _test_eof704;

            case 704:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1247;

                case 19:
                    goto tr1245;

                case 23:
                    goto st24;

                case 37:
                    goto st703;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1244:

                {
                    expr_start = p;
                }
                goto st705;
st705:

                if ( ++p == pe )
                    goto _test_eof705;

            case 705:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st703;

                case 5:
                    goto st703;

                case 8:
                    goto st703;

                case 13:
                    goto st705;

                case 18:
                    goto st705;

                case 21:
                    goto st705;

                case 23:
                    goto st705;

                case 36:
                    goto st705;

                case 44:
                    goto st705;
                }

                goto st0;
st706:

                if ( ++p == pe )
                    goto _test_eof706;

            case 706:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st707;

                case 21:
                    goto st708;

                case 23:
                    goto st712;
                }

                goto st0;
st707:

                if ( ++p == pe )
                    goto _test_eof707;

            case 707:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1252;

                goto st0;
st708:

                if ( ++p == pe )
                    goto _test_eof708;

            case 708:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1253;

                case 5:
                    goto tr1253;

                case 8:
                    goto tr1253;

                case 18:
                    goto tr1254;

                case 21:
                    goto tr1254;

                case 23:
                    goto tr1254;

                case 36:
                    goto tr1254;

                case 44:
                    goto tr1254;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1254;

                goto st0;
tr1253:

                {
                    expr_start = p;
                }
                goto st709;
st709:

                if ( ++p == pe )
                    goto _test_eof709;

            case 709:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1255;

                case 23:
                    goto st24;

                case 37:
                    goto st709;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1255:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st710;
st710:

                if ( ++p == pe )
                    goto _test_eof710;

            case 710:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1257;

                case 19:
                    goto tr1255;

                case 23:
                    goto st24;

                case 37:
                    goto st709;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1254:

                {
                    expr_start = p;
                }
                goto st711;
st711:

                if ( ++p == pe )
                    goto _test_eof711;

            case 711:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st709;

                case 5:
                    goto st709;

                case 8:
                    goto st709;

                case 13:
                    goto st711;

                case 18:
                    goto st711;

                case 21:
                    goto st711;

                case 23:
                    goto st711;

                case 36:
                    goto st711;

                case 44:
                    goto st711;
                }

                goto st0;
st712:

                if ( ++p == pe )
                    goto _test_eof712;

            case 712:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1259;

                case 5:
                    goto tr1259;

                case 8:
                    goto tr1259;

                case 18:
                    goto tr1260;

                case 21:
                    goto tr1260;

                case 23:
                    goto tr1260;

                case 36:
                    goto tr1260;

                case 44:
                    goto tr1260;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1260;

                goto st0;
tr1259:

                {
                    expr_start = p;
                }
                goto st713;
st713:

                if ( ++p == pe )
                    goto _test_eof713;

            case 713:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1261;

                case 23:
                    goto st24;

                case 37:
                    goto st713;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1261:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st714;
st714:

                if ( ++p == pe )
                    goto _test_eof714;

            case 714:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1263;

                case 19:
                    goto tr1261;

                case 23:
                    goto st24;

                case 37:
                    goto st713;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1260:

                {
                    expr_start = p;
                }
                goto st715;
st715:

                if ( ++p == pe )
                    goto _test_eof715;

            case 715:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st713;

                case 5:
                    goto st713;

                case 8:
                    goto st713;

                case 13:
                    goto st715;

                case 18:
                    goto st715;

                case 21:
                    goto st715;

                case 23:
                    goto st715;

                case 36:
                    goto st715;

                case 44:
                    goto st715;
                }

                goto st0;
st716:

                if ( ++p == pe )
                    goto _test_eof716;

            case 716:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st717;

                case 53:
                    goto st718;

                case 54:
                    goto st719;

                case 55:
                    goto st720;

                case 56:
                    goto st721;

                case 59:
                    goto st722;

                case 62:
                    goto st723;

                case 79:
                    goto st724;

                case 80:
                    goto st725;

                case 81:
                    goto st735;
                }

                goto st0;
st717:

                if ( ++p == pe )
                    goto _test_eof717;

            case 717:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1275;

                goto st0;
st718:

                if ( ++p == pe )
                    goto _test_eof718;

            case 718:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1276;

                goto st0;
st719:

                if ( ++p == pe )
                    goto _test_eof719;

            case 719:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1277;

                goto st0;
st720:

                if ( ++p == pe )
                    goto _test_eof720;

            case 720:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1278;

                goto st0;
st721:

                if ( ++p == pe )
                    goto _test_eof721;

            case 721:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1279;

                goto st0;
st722:

                if ( ++p == pe )
                    goto _test_eof722;

            case 722:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1280;

                goto st0;
st723:

                if ( ++p == pe )
                    goto _test_eof723;

            case 723:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1281;

                goto st0;
st724:

                if ( ++p == pe )
                    goto _test_eof724;

            case 724:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1282;

                goto st0;
st725:

                if ( ++p == pe )
                    goto _test_eof725;

            case 725:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st726;

                case 21:
                    goto st727;

                case 23:
                    goto st731;
                }

                goto st0;
st726:

                if ( ++p == pe )
                    goto _test_eof726;

            case 726:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1286;

                goto st0;
st727:

                if ( ++p == pe )
                    goto _test_eof727;

            case 727:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1287;

                case 5:
                    goto tr1287;

                case 8:
                    goto tr1287;

                case 18:
                    goto tr1288;

                case 21:
                    goto tr1288;

                case 23:
                    goto tr1288;

                case 36:
                    goto tr1288;

                case 44:
                    goto tr1288;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1288;

                goto st0;
tr1287:

                {
                    expr_start = p;
                }
                goto st728;
st728:

                if ( ++p == pe )
                    goto _test_eof728;

            case 728:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1289;

                case 23:
                    goto st24;

                case 37:
                    goto st728;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1289:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st729;
st729:

                if ( ++p == pe )
                    goto _test_eof729;

            case 729:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1291;

                case 19:
                    goto tr1289;

                case 23:
                    goto st24;

                case 37:
                    goto st728;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1288:

                {
                    expr_start = p;
                }
                goto st730;
st730:

                if ( ++p == pe )
                    goto _test_eof730;

            case 730:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st728;

                case 5:
                    goto st728;

                case 8:
                    goto st728;

                case 13:
                    goto st730;

                case 18:
                    goto st730;

                case 21:
                    goto st730;

                case 23:
                    goto st730;

                case 36:
                    goto st730;

                case 44:
                    goto st730;
                }

                goto st0;
st731:

                if ( ++p == pe )
                    goto _test_eof731;

            case 731:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1293;

                case 5:
                    goto tr1293;

                case 8:
                    goto tr1293;

                case 18:
                    goto tr1294;

                case 21:
                    goto tr1294;

                case 23:
                    goto tr1294;

                case 36:
                    goto tr1294;

                case 44:
                    goto tr1294;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1294;

                goto st0;
tr1293:

                {
                    expr_start = p;
                }
                goto st732;
st732:

                if ( ++p == pe )
                    goto _test_eof732;

            case 732:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1295;

                case 23:
                    goto st24;

                case 37:
                    goto st732;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1295:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st733;
st733:

                if ( ++p == pe )
                    goto _test_eof733;

            case 733:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1297;

                case 19:
                    goto tr1295;

                case 23:
                    goto st24;

                case 37:
                    goto st732;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1294:

                {
                    expr_start = p;
                }
                goto st734;
st734:

                if ( ++p == pe )
                    goto _test_eof734;

            case 734:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st732;

                case 5:
                    goto st732;

                case 8:
                    goto st732;

                case 13:
                    goto st734;

                case 18:
                    goto st734;

                case 21:
                    goto st734;

                case 23:
                    goto st734;

                case 36:
                    goto st734;

                case 44:
                    goto st734;
                }

                goto st0;
st735:

                if ( ++p == pe )
                    goto _test_eof735;

            case 735:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st736;

                case 21:
                    goto st737;

                case 23:
                    goto st741;
                }

                goto st0;
st736:

                if ( ++p == pe )
                    goto _test_eof736;

            case 736:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1302;

                goto st0;
st737:

                if ( ++p == pe )
                    goto _test_eof737;

            case 737:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1303;

                case 5:
                    goto tr1303;

                case 8:
                    goto tr1303;

                case 18:
                    goto tr1304;

                case 21:
                    goto tr1304;

                case 23:
                    goto tr1304;

                case 36:
                    goto tr1304;

                case 44:
                    goto tr1304;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1304;

                goto st0;
tr1303:

                {
                    expr_start = p;
                }
                goto st738;
st738:

                if ( ++p == pe )
                    goto _test_eof738;

            case 738:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1305;

                case 23:
                    goto st24;

                case 37:
                    goto st738;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1305:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st739;
st739:

                if ( ++p == pe )
                    goto _test_eof739;

            case 739:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1307;

                case 19:
                    goto tr1305;

                case 23:
                    goto st24;

                case 37:
                    goto st738;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1304:

                {
                    expr_start = p;
                }
                goto st740;
st740:

                if ( ++p == pe )
                    goto _test_eof740;

            case 740:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st738;

                case 5:
                    goto st738;

                case 8:
                    goto st738;

                case 13:
                    goto st740;

                case 18:
                    goto st740;

                case 21:
                    goto st740;

                case 23:
                    goto st740;

                case 36:
                    goto st740;

                case 44:
                    goto st740;
                }

                goto st0;
st741:

                if ( ++p == pe )
                    goto _test_eof741;

            case 741:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1309;

                case 5:
                    goto tr1309;

                case 8:
                    goto tr1309;

                case 18:
                    goto tr1310;

                case 21:
                    goto tr1310;

                case 23:
                    goto tr1310;

                case 36:
                    goto tr1310;

                case 44:
                    goto tr1310;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1310;

                goto st0;
tr1309:

                {
                    expr_start = p;
                }
                goto st742;
st742:

                if ( ++p == pe )
                    goto _test_eof742;

            case 742:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1311;

                case 23:
                    goto st24;

                case 37:
                    goto st742;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1311:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st743;
st743:

                if ( ++p == pe )
                    goto _test_eof743;

            case 743:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1313;

                case 19:
                    goto tr1311;

                case 23:
                    goto st24;

                case 37:
                    goto st742;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1310:

                {
                    expr_start = p;
                }
                goto st744;
st744:

                if ( ++p == pe )
                    goto _test_eof744;

            case 744:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st742;

                case 5:
                    goto st742;

                case 8:
                    goto st742;

                case 13:
                    goto st744;

                case 18:
                    goto st744;

                case 21:
                    goto st744;

                case 23:
                    goto st744;

                case 36:
                    goto st744;

                case 44:
                    goto st744;
                }

                goto st0;
st745:

                if ( ++p == pe )
                    goto _test_eof745;

            case 745:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 48:
                    goto st746;

                case 53:
                    goto st747;

                case 54:
                    goto st748;

                case 55:
                    goto st749;

                case 56:
                    goto st750;

                case 59:
                    goto st751;

                case 62:
                    goto st752;

                case 79:
                    goto st753;

                case 80:
                    goto st754;

                case 81:
                    goto st764;
                }

                goto st0;
st746:

                if ( ++p == pe )
                    goto _test_eof746;

            case 746:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1325;

                goto st0;
st747:

                if ( ++p == pe )
                    goto _test_eof747;

            case 747:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1326;

                goto st0;
st748:

                if ( ++p == pe )
                    goto _test_eof748;

            case 748:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1327;

                goto st0;
st749:

                if ( ++p == pe )
                    goto _test_eof749;

            case 749:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1328;

                goto st0;
st750:

                if ( ++p == pe )
                    goto _test_eof750;

            case 750:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1329;

                goto st0;
st751:

                if ( ++p == pe )
                    goto _test_eof751;

            case 751:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1330;

                goto st0;
st752:

                if ( ++p == pe )
                    goto _test_eof752;

            case 752:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1331;

                goto st0;
st753:

                if ( ++p == pe )
                    goto _test_eof753;

            case 753:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1332;

                goto st0;
st754:

                if ( ++p == pe )
                    goto _test_eof754;

            case 754:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st755;

                case 21:
                    goto st756;

                case 23:
                    goto st760;
                }

                goto st0;
st755:

                if ( ++p == pe )
                    goto _test_eof755;

            case 755:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1336;

                goto st0;
st756:

                if ( ++p == pe )
                    goto _test_eof756;

            case 756:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1337;

                case 5:
                    goto tr1337;

                case 8:
                    goto tr1337;

                case 18:
                    goto tr1338;

                case 21:
                    goto tr1338;

                case 23:
                    goto tr1338;

                case 36:
                    goto tr1338;

                case 44:
                    goto tr1338;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1338;

                goto st0;
tr1337:

                {
                    expr_start = p;
                }
                goto st757;
st757:

                if ( ++p == pe )
                    goto _test_eof757;

            case 757:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1339;

                case 23:
                    goto st24;

                case 37:
                    goto st757;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1339:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st758;
st758:

                if ( ++p == pe )
                    goto _test_eof758;

            case 758:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1341;

                case 19:
                    goto tr1339;

                case 23:
                    goto st24;

                case 37:
                    goto st757;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1338:

                {
                    expr_start = p;
                }
                goto st759;
st759:

                if ( ++p == pe )
                    goto _test_eof759;

            case 759:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st757;

                case 5:
                    goto st757;

                case 8:
                    goto st757;

                case 13:
                    goto st759;

                case 18:
                    goto st759;

                case 21:
                    goto st759;

                case 23:
                    goto st759;

                case 36:
                    goto st759;

                case 44:
                    goto st759;
                }

                goto st0;
st760:

                if ( ++p == pe )
                    goto _test_eof760;

            case 760:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1343;

                case 5:
                    goto tr1343;

                case 8:
                    goto tr1343;

                case 18:
                    goto tr1344;

                case 21:
                    goto tr1344;

                case 23:
                    goto tr1344;

                case 36:
                    goto tr1344;

                case 44:
                    goto tr1344;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1344;

                goto st0;
tr1343:

                {
                    expr_start = p;
                }
                goto st761;
st761:

                if ( ++p == pe )
                    goto _test_eof761;

            case 761:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1345;

                case 23:
                    goto st24;

                case 37:
                    goto st761;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1345:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st762;
st762:

                if ( ++p == pe )
                    goto _test_eof762;

            case 762:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1347;

                case 19:
                    goto tr1345;

                case 23:
                    goto st24;

                case 37:
                    goto st761;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1344:

                {
                    expr_start = p;
                }
                goto st763;
st763:

                if ( ++p == pe )
                    goto _test_eof763;

            case 763:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st761;

                case 5:
                    goto st761;

                case 8:
                    goto st761;

                case 13:
                    goto st763;

                case 18:
                    goto st763;

                case 21:
                    goto st763;

                case 23:
                    goto st763;

                case 36:
                    goto st763;

                case 44:
                    goto st763;
                }

                goto st0;
st764:

                if ( ++p == pe )
                    goto _test_eof764;

            case 764:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st765;

                case 21:
                    goto st766;

                case 23:
                    goto st770;
                }

                goto st0;
st765:

                if ( ++p == pe )
                    goto _test_eof765;

            case 765:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr1352;

                goto st0;
st766:

                if ( ++p == pe )
                    goto _test_eof766;

            case 766:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1353;

                case 5:
                    goto tr1353;

                case 8:
                    goto tr1353;

                case 18:
                    goto tr1354;

                case 21:
                    goto tr1354;

                case 23:
                    goto tr1354;

                case 36:
                    goto tr1354;

                case 44:
                    goto tr1354;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1354;

                goto st0;
tr1353:

                {
                    expr_start = p;
                }
                goto st767;
st767:

                if ( ++p == pe )
                    goto _test_eof767;

            case 767:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1355;

                case 23:
                    goto st24;

                case 37:
                    goto st767;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1355:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st768;
st768:

                if ( ++p == pe )
                    goto _test_eof768;

            case 768:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1357;

                case 19:
                    goto tr1355;

                case 23:
                    goto st24;

                case 37:
                    goto st767;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1354:

                {
                    expr_start = p;
                }
                goto st769;
st769:

                if ( ++p == pe )
                    goto _test_eof769;

            case 769:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st767;

                case 5:
                    goto st767;

                case 8:
                    goto st767;

                case 13:
                    goto st769;

                case 18:
                    goto st769;

                case 21:
                    goto st769;

                case 23:
                    goto st769;

                case 36:
                    goto st769;

                case 44:
                    goto st769;
                }

                goto st0;
st770:

                if ( ++p == pe )
                    goto _test_eof770;

            case 770:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr1359;

                case 5:
                    goto tr1359;

                case 8:
                    goto tr1359;

                case 18:
                    goto tr1360;

                case 21:
                    goto tr1360;

                case 23:
                    goto tr1360;

                case 36:
                    goto tr1360;

                case 44:
                    goto tr1360;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr1360;

                goto st0;
tr1359:

                {
                    expr_start = p;
                }
                goto st771;
st771:

                if ( ++p == pe )
                    goto _test_eof771;

            case 771:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr1361;

                case 23:
                    goto st24;

                case 37:
                    goto st771;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1361:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st772;
st772:

                if ( ++p == pe )
                    goto _test_eof772;

            case 772:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr1363;

                case 19:
                    goto tr1361;

                case 23:
                    goto st24;

                case 37:
                    goto st771;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st24;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st24;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st24;
                }
                else
                    goto st24;

                goto st0;
tr1360:

                {
                    expr_start = p;
                }
                goto st773;
st773:

                if ( ++p == pe )
                    goto _test_eof773;

            case 773:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st771;

                case 5:
                    goto st771;

                case 8:
                    goto st771;

                case 13:
                    goto st773;

                case 18:
                    goto st773;

                case 21:
                    goto st773;

                case 23:
                    goto st773;

                case 36:
                    goto st773;

                case 44:
                    goto st773;
                }

                goto st0;
            }

_test_eof774:
            cs = 774;
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

                774

           )
            return TRUE;
    }

    return FALSE;
}

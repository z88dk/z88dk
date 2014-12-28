




















static const int parser_start = 1;
static const int parser_first_final = 215;
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
                    goto st215;

                case 4:
                    goto tr2;

                case 12:
                    goto st215;

                case 87:
                    goto st3;

                case 88:
                    goto st38;

                case 89:
                    goto st39;

                case 90:
                    goto st78;

                case 91:
                    goto st79;

                case 92:
                    goto st80;

                case 93:
                    goto st81;

                case 94:
                    goto st82;

                case 95:
                    goto st83;

                case 96:
                    goto st84;

                case 97:
                    goto st85;

                case 98:
                    goto st88;

                case 99:
                    goto st89;

                case 100:
                    goto st102;

                case 101:
                    goto st103;

                case 102:
                    goto st104;

                case 103:
                    goto st107;

                case 104:
                    goto st108;

                case 105:
                    goto st109;

                case 106:
                    goto st110;

                case 107:
                    goto st111;

                case 108:
                    goto st151;

                case 109:
                    goto st170;

                case 110:
                    goto st171;

                case 111:
                    goto st172;

                case 112:
                    goto st173;

                case 113:
                    goto st174;

                case 114:
                    goto st175;

                case 115:
                    goto st176;

                case 116:
                    goto st177;

                case 117:
                    goto st178;

                case 118:
                    goto st179;

                case 119:
                    goto st180;

                case 120:
                    goto st187;

                case 121:
                    goto st194;

                case 122:
                    goto st203;

                case 123:
                    goto st204;

                case 124:
                    goto st205;

                case 125:
                    goto st206;

                case 126:
                    goto st207;

                case 127:
                    goto st208;

                case 128:
                    goto st209;

                case 129:
                    goto st210;

                case 130:
                    goto st211;

                case 131:
                    goto st214;
                }

                goto st0;
st0:
                cs = 0;
                goto _out;
tr48:

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
                goto st215;
tr59:

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
                goto st215;
tr65:

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
                goto st215;
tr71:

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
                goto st215;
tr77:

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
                goto st215;
tr83:

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
                goto st215;
tr89:

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
                goto st215;
tr95:

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
                goto st215;
tr101:

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
                goto st215;
tr107:

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
                goto st215;
tr110:

                {
                    if ( compile_active )
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
                goto st215;
tr127:

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
                goto st215;
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

                        add_opcode( Z80_CP( REG_C ) );
                    };
                }
                goto st215;
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

                        add_opcode( Z80_CP( REG_B ) );
                    };
                }
                goto st215;
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

                        add_opcode( Z80_CP( REG_D ) );
                    };
                }
                goto st215;
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

                        add_opcode( Z80_CP( REG_E ) );
                    };
                }
                goto st215;
tr134:

                {
                    if ( compile_active )
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
                goto st215;
tr135:

                {
                    if ( compile_active )
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
                goto st215;
tr136:

                {
                    if ( compile_active )
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
                goto st215;
tr137:

                {
                    if ( compile_active )
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
                goto st215;
tr138:

                {
                    if ( compile_active )
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
                goto st215;
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

                        add_opcode( Z80_CP( REG_L ) + P_IY );
                    };
                }
                goto st215;
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

                        add_opcode( Z80_CP( REG_A ) );
                    };
                }
                goto st215;
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

                        add_opcode( Z80_CP( REG_idx ) );
                    };
                }
                goto st215;
tr147:

                {
                    if ( compile_active )
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
                goto st215;
tr154:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
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
                goto st215;
tr160:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
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
                goto st215;
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

                        add_opcode( ( Z80_CP( REG_idx ) + P_IY ) << 8 );
                    };
                }
                goto st215;
tr170:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
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
                goto st215;
tr176:

                {
                    {
                        Expr *expr = pop_expr();

                        if ( compile_active )
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
                goto st215;
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

                        add_opcode_emul( Z80_CPD, "rcmx_cpd" );
                    }
                }
                goto st215;
tr179:

                {
                    if ( compile_active )
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
                goto st215;
tr180:

                {
                    if ( compile_active )
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
                goto st215;
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

                        add_opcode_emul( Z80_CPIR, "rcmx_cpir" );
                    }
                }
                goto st215;
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

                        add_opcode( Z80_CPL );
                    };
                }
                goto st215;
tr183:

                {
                    if ( compile_active )
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
                goto st215;
tr184:

                {
                    if ( compile_active )
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
                goto st215;
tr187:

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
                goto st215;
tr190:

                {
                    if ( compile_active )
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
                goto st215;
tr196:

                {
                    if ( compile_active )
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
                goto st215;
tr200:

                {
                    if ( compile_active )
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
                goto st215;
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

                        add_opcode( ( Z80_EX_AF_AF ) );
                    };
                }
                goto st215;
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

                        add_opcode( ( Z80_EX_IND_SP_HL ) );
                    };
                }
                goto st215;
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

                        add_opcode( ( Z80_EX_IND_SP_idx + P_IX ) );
                    };
                }
                goto st215;
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

                        add_opcode( ( Z80_EX_IND_SP_idx + P_IY ) );
                    };
                }
                goto st215;
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

                        add_opcode( Z80_EXX );
                    };
                }
                goto st215;
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

                        add_opcode( Z80_HALT );
                    };
                }
                goto st215;
tr213:

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
                goto st215;
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

                        add_opcode( Z80_IND );
                    };
                }
                goto st215;
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

                        add_opcode( Z80_INDR );
                    };
                }
                goto st215;
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

                        add_opcode( Z80_INI );
                    };
                }
                goto st215;
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

                        add_opcode( Z80_INIR );
                    };
                }
                goto st215;
tr233:

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
                goto st215;
tr239:

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
                goto st215;
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

                            add_opcode_nn( ( Z80_JP_FLAG( FLAG_Z ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st215;
tr251:

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
                goto st215;
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

                            add_opcode_nn( ( Z80_JP_FLAG( FLAG_C ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st215;
tr263:

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
                goto st215;
tr269:

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
                goto st215;
tr275:

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
                goto st215;
tr281:

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
                goto st215;
tr284:

                {
                    if ( compile_active )
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
                goto st215;
tr286:

                {
                    if ( compile_active )
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
                goto st215;
tr288:

                {
                    if ( compile_active )
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
                goto st215;
tr295:

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
                goto st215;
tr301:

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
                goto st215;
tr307:

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
                goto st215;
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

                            add_opcode_jr( ( Z80_JR_FLAG( FLAG_NC ) ), expr );
                        }
                        else OBJ_DELETE( expr );
                    };
                }
                goto st215;
tr319:

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
                goto st215;
tr322:

                {
                    if ( compile_active )
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
                goto st215;
tr323:

                {
                    if ( compile_active )
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
                goto st215;
tr324:

                {
                    if ( compile_active )
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
                goto st215;
tr325:

                {
                    if ( compile_active )
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
                goto st215;
tr326:

                {
                    if ( compile_active )
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
                goto st215;
tr327:

                {
                    if ( compile_active )
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
                goto st215;
tr328:

                {
                    if ( compile_active )
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
                goto st215;
tr329:

                {
                    if ( compile_active )
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
                goto st215;
tr330:

                {
                    if ( compile_active )
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
                goto st215;
tr331:

                {
                    if ( compile_active )
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
                goto st215;
tr338:

                {
                    if ( compile_active )
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
                goto st215;
tr339:

                {
                    if ( compile_active )
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
                goto st215;
tr340:

                {
                    if ( compile_active )
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
                goto st215;
tr341:

                {
                    if ( compile_active )
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
                goto st215;
tr342:

                {
                    if ( compile_active )
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
                goto st215;
tr343:

                {
                    if ( compile_active )
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
                goto st215;
tr350:

                {
                    if ( compile_active )
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
                goto st215;
tr351:

                {
                    if ( compile_active )
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
                goto st215;
tr352:

                {
                    if ( compile_active )
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
                goto st215;
tr353:

                {
                    if ( compile_active )
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
                goto st215;
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

                        add_opcode( Z80_PUSH( REG_HL ) + P_IY );
                    };
                }
                goto st215;
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

                        add_opcode( Z80_PUSH( REG_AF ) );
                    };
                }
                goto st215;
tr356:

                {
                    if ( compile_active )
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
                goto st215;
tr365:

                {
                    if ( compile_active )
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
                goto st215;
tr366:

                {
                    if ( compile_active )
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
                goto st215;
tr367:

                {
                    if ( compile_active )
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
                goto st215;
tr368:

                {
                    if ( compile_active )
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
                goto st215;
tr369:

                {
                    if ( compile_active )
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
                goto st215;
tr370:

                {
                    if ( compile_active )
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
                goto st215;
tr371:

                {
                    if ( compile_active )
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
                goto st215;
tr372:

                {
                    if ( compile_active )
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
                goto st215;
tr373:

                {
                    if ( compile_active )
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
                goto st215;
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

                        add_opcode( Z80_RETN );
                    };
                }
                goto st215;
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

                        add_opcode( Z80_RLA );
                    };
                }
                goto st215;
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

                        add_opcode( Z80_RLCA );
                    };
                }
                goto st215;
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

                        add_opcode_emul( Z80_RLD, "rcmx_rld" );
                    }
                }
                goto st215;
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

                        add_opcode( Z80_RRA );
                    };
                }
                goto st215;
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

                        add_opcode( Z80_RRCA );
                    };
                }
                goto st215;
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

                        add_opcode_emul( Z80_RRD, "rcmx_rrd" );
                    }
                }
                goto st215;
tr383:

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
                goto st215;
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

                        add_opcode( Z80_SCF );
                    };
                }
                goto st215;
st215:

                if ( ++p == pe )
                    goto _test_eof215;

            case 215:

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
                    goto tr48;

                case 87:
                    goto st3;

                case 88:
                    goto st38;

                case 89:
                    goto st39;

                case 90:
                    goto st78;

                case 91:
                    goto st79;

                case 92:
                    goto st80;

                case 93:
                    goto st81;

                case 94:
                    goto st82;

                case 95:
                    goto st83;

                case 96:
                    goto st84;

                case 97:
                    goto st85;

                case 98:
                    goto st88;

                case 99:
                    goto st89;

                case 100:
                    goto st102;

                case 101:
                    goto st103;

                case 102:
                    goto st104;

                case 103:
                    goto st107;

                case 104:
                    goto st108;

                case 105:
                    goto st109;

                case 106:
                    goto st110;

                case 107:
                    goto st111;

                case 108:
                    goto st151;

                case 109:
                    goto st170;

                case 110:
                    goto st171;

                case 111:
                    goto st172;

                case 112:
                    goto st173;

                case 113:
                    goto st174;

                case 114:
                    goto st175;

                case 115:
                    goto st176;

                case 116:
                    goto st177;

                case 117:
                    goto st178;

                case 118:
                    goto st179;

                case 119:
                    goto st180;

                case 120:
                    goto st187;

                case 121:
                    goto st194;

                case 122:
                    goto st203;

                case 123:
                    goto st204;

                case 124:
                    goto st205;

                case 125:
                    goto st206;

                case 126:
                    goto st207;

                case 127:
                    goto st208;

                case 128:
                    goto st209;

                case 129:
                    goto st210;

                case 130:
                    goto st211;

                case 131:
                    goto st214;
                }

                goto st0;
st3:

                if ( ++p == pe )
                    goto _test_eof3;

            case 3:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr49;

                case 5:
                    goto tr49;

                case 8:
                    goto tr49;

                case 18:
                    goto tr50;

                case 21:
                    goto tr50;

                case 23:
                    goto tr50;

                case 36:
                    goto tr50;

                case 44:
                    goto tr50;

                case 45:
                    goto st6;

                case 46:
                    goto st10;

                case 47:
                    goto st14;

                case 48:
                    goto st18;

                case 49:
                    goto st22;

                case 50:
                    goto st26;

                case 51:
                    goto st30;

                case 52:
                    goto st34;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr50;

                goto st0;
tr49:

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
                    goto tr59;

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
tr50:

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
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st7;

                goto st0;
st7:

                if ( ++p == pe )
                    goto _test_eof7;

            case 7:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr63;

                case 5:
                    goto tr63;

                case 8:
                    goto tr63;

                case 18:
                    goto tr64;

                case 21:
                    goto tr64;

                case 23:
                    goto tr64;

                case 36:
                    goto tr64;

                case 44:
                    goto tr64;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr64;

                goto st0;
tr63:

                {
                    expr_start = p;
                }
                goto st8;
st8:

                if ( ++p == pe )
                    goto _test_eof8;

            case 8:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr65;

                case 19:
                    goto st8;

                case 23:
                    goto st9;

                case 37:
                    goto st8;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st9;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st9;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st9;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st9;
                }
                else
                    goto st9;

                goto st0;
tr64:

                {
                    expr_start = p;
                }
                goto st9;
st9:

                if ( ++p == pe )
                    goto _test_eof9;

            case 9:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st8;

                case 5:
                    goto st8;

                case 8:
                    goto st8;

                case 13:
                    goto st9;

                case 18:
                    goto st9;

                case 21:
                    goto st9;

                case 23:
                    goto st9;

                case 36:
                    goto st9;

                case 44:
                    goto st9;
                }

                goto st0;
st10:

                if ( ++p == pe )
                    goto _test_eof10;

            case 10:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st11;

                goto st0;
st11:

                if ( ++p == pe )
                    goto _test_eof11;

            case 11:
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
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr70;

                goto st0;
tr69:

                {
                    expr_start = p;
                }
                goto st12;
st12:

                if ( ++p == pe )
                    goto _test_eof12;

            case 12:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr71;

                case 19:
                    goto st12;

                case 23:
                    goto st13;

                case 37:
                    goto st12;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st13;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st13;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st13;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st13;
                }
                else
                    goto st13;

                goto st0;
tr70:

                {
                    expr_start = p;
                }
                goto st13;
st13:

                if ( ++p == pe )
                    goto _test_eof13;

            case 13:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st12;

                case 5:
                    goto st12;

                case 8:
                    goto st12;

                case 13:
                    goto st13;

                case 18:
                    goto st13;

                case 21:
                    goto st13;

                case 23:
                    goto st13;

                case 36:
                    goto st13;

                case 44:
                    goto st13;
                }

                goto st0;
st14:

                if ( ++p == pe )
                    goto _test_eof14;

            case 14:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st15;

                goto st0;
st15:

                if ( ++p == pe )
                    goto _test_eof15;

            case 15:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr75;

                case 5:
                    goto tr75;

                case 8:
                    goto tr75;

                case 18:
                    goto tr76;

                case 21:
                    goto tr76;

                case 23:
                    goto tr76;

                case 36:
                    goto tr76;

                case 44:
                    goto tr76;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr76;

                goto st0;
tr75:

                {
                    expr_start = p;
                }
                goto st16;
st16:

                if ( ++p == pe )
                    goto _test_eof16;

            case 16:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr77;

                case 19:
                    goto st16;

                case 23:
                    goto st17;

                case 37:
                    goto st16;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st17;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st17;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st17;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st17;
                }
                else
                    goto st17;

                goto st0;
tr76:

                {
                    expr_start = p;
                }
                goto st17;
st17:

                if ( ++p == pe )
                    goto _test_eof17;

            case 17:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st16;

                case 5:
                    goto st16;

                case 8:
                    goto st16;

                case 13:
                    goto st17;

                case 18:
                    goto st17;

                case 21:
                    goto st17;

                case 23:
                    goto st17;

                case 36:
                    goto st17;

                case 44:
                    goto st17;
                }

                goto st0;
st18:

                if ( ++p == pe )
                    goto _test_eof18;

            case 18:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st19;

                goto st0;
st19:

                if ( ++p == pe )
                    goto _test_eof19;

            case 19:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr81;

                case 5:
                    goto tr81;

                case 8:
                    goto tr81;

                case 18:
                    goto tr82;

                case 21:
                    goto tr82;

                case 23:
                    goto tr82;

                case 36:
                    goto tr82;

                case 44:
                    goto tr82;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr82;

                goto st0;
tr81:

                {
                    expr_start = p;
                }
                goto st20;
st20:

                if ( ++p == pe )
                    goto _test_eof20;

            case 20:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr83;

                case 19:
                    goto st20;

                case 23:
                    goto st21;

                case 37:
                    goto st20;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st21;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st21;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st21;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st21;
                }
                else
                    goto st21;

                goto st0;
tr82:

                {
                    expr_start = p;
                }
                goto st21;
st21:

                if ( ++p == pe )
                    goto _test_eof21;

            case 21:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st20;

                case 5:
                    goto st20;

                case 8:
                    goto st20;

                case 13:
                    goto st21;

                case 18:
                    goto st21;

                case 21:
                    goto st21;

                case 23:
                    goto st21;

                case 36:
                    goto st21;

                case 44:
                    goto st21;
                }

                goto st0;
st22:

                if ( ++p == pe )
                    goto _test_eof22;

            case 22:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st23;

                goto st0;
st23:

                if ( ++p == pe )
                    goto _test_eof23;

            case 23:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr87;

                case 5:
                    goto tr87;

                case 8:
                    goto tr87;

                case 18:
                    goto tr88;

                case 21:
                    goto tr88;

                case 23:
                    goto tr88;

                case 36:
                    goto tr88;

                case 44:
                    goto tr88;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr88;

                goto st0;
tr87:

                {
                    expr_start = p;
                }
                goto st24;
st24:

                if ( ++p == pe )
                    goto _test_eof24;

            case 24:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr89;

                case 19:
                    goto st24;

                case 23:
                    goto st25;

                case 37:
                    goto st24;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st25;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st25;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st25;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st25;
                }
                else
                    goto st25;

                goto st0;
tr88:

                {
                    expr_start = p;
                }
                goto st25;
st25:

                if ( ++p == pe )
                    goto _test_eof25;

            case 25:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st24;

                case 5:
                    goto st24;

                case 8:
                    goto st24;

                case 13:
                    goto st25;

                case 18:
                    goto st25;

                case 21:
                    goto st25;

                case 23:
                    goto st25;

                case 36:
                    goto st25;

                case 44:
                    goto st25;
                }

                goto st0;
st26:

                if ( ++p == pe )
                    goto _test_eof26;

            case 26:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st27;

                goto st0;
st27:

                if ( ++p == pe )
                    goto _test_eof27;

            case 27:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr93;

                case 5:
                    goto tr93;

                case 8:
                    goto tr93;

                case 18:
                    goto tr94;

                case 21:
                    goto tr94;

                case 23:
                    goto tr94;

                case 36:
                    goto tr94;

                case 44:
                    goto tr94;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr94;

                goto st0;
tr93:

                {
                    expr_start = p;
                }
                goto st28;
st28:

                if ( ++p == pe )
                    goto _test_eof28;

            case 28:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr95;

                case 19:
                    goto st28;

                case 23:
                    goto st29;

                case 37:
                    goto st28;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st29;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st29;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st29;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st29;
                }
                else
                    goto st29;

                goto st0;
tr94:

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
                case 3:
                    goto st28;

                case 5:
                    goto st28;

                case 8:
                    goto st28;

                case 13:
                    goto st29;

                case 18:
                    goto st29;

                case 21:
                    goto st29;

                case 23:
                    goto st29;

                case 36:
                    goto st29;

                case 44:
                    goto st29;
                }

                goto st0;
st30:

                if ( ++p == pe )
                    goto _test_eof30;

            case 30:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st31;

                goto st0;
st31:

                if ( ++p == pe )
                    goto _test_eof31;

            case 31:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr99;

                case 5:
                    goto tr99;

                case 8:
                    goto tr99;

                case 18:
                    goto tr100;

                case 21:
                    goto tr100;

                case 23:
                    goto tr100;

                case 36:
                    goto tr100;

                case 44:
                    goto tr100;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr100;

                goto st0;
tr99:

                {
                    expr_start = p;
                }
                goto st32;
st32:

                if ( ++p == pe )
                    goto _test_eof32;

            case 32:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr101;

                case 19:
                    goto st32;

                case 23:
                    goto st33;

                case 37:
                    goto st32;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st33;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st33;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st33;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st33;
                }
                else
                    goto st33;

                goto st0;
tr100:

                {
                    expr_start = p;
                }
                goto st33;
st33:

                if ( ++p == pe )
                    goto _test_eof33;

            case 33:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st32;

                case 5:
                    goto st32;

                case 8:
                    goto st32;

                case 13:
                    goto st33;

                case 18:
                    goto st33;

                case 21:
                    goto st33;

                case 23:
                    goto st33;

                case 36:
                    goto st33;

                case 44:
                    goto st33;
                }

                goto st0;
st34:

                if ( ++p == pe )
                    goto _test_eof34;

            case 34:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st35;

                goto st0;
st35:

                if ( ++p == pe )
                    goto _test_eof35;

            case 35:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr105;

                case 5:
                    goto tr105;

                case 8:
                    goto tr105;

                case 18:
                    goto tr106;

                case 21:
                    goto tr106;

                case 23:
                    goto tr106;

                case 36:
                    goto tr106;

                case 44:
                    goto tr106;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr106;

                goto st0;
tr105:

                {
                    expr_start = p;
                }
                goto st36;
st36:

                if ( ++p == pe )
                    goto _test_eof36;

            case 36:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr107;

                case 19:
                    goto st36;

                case 23:
                    goto st37;

                case 37:
                    goto st36;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st37;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st37;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st37;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st37;
                }
                else
                    goto st37;

                goto st0;
tr106:

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
                    goto st36;

                case 5:
                    goto st36;

                case 8:
                    goto st36;

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
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr110;

                goto st0;
st39:

                if ( ++p == pe )
                    goto _test_eof39;

            case 39:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr111;

                case 5:
                    goto tr111;

                case 8:
                    goto tr111;

                case 18:
                    goto tr112;

                case 21:
                    goto tr112;

                case 23:
                    goto tr112;

                case 36:
                    goto tr112;

                case 44:
                    goto tr112;

                case 48:
                    goto st42;

                case 53:
                    goto st43;

                case 54:
                    goto st44;

                case 55:
                    goto st45;

                case 56:
                    goto st46;

                case 57:
                    goto st47;

                case 58:
                    goto st48;

                case 59:
                    goto st49;

                case 60:
                    goto st50;

                case 61:
                    goto st51;

                case 62:
                    goto st52;

                case 79:
                    goto st55;

                case 80:
                    goto st56;

                case 81:
                    goto st68;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr112;

                goto st0;
tr111:

                {
                    expr_start = p;
                }
                goto st40;
st40:

                if ( ++p == pe )
                    goto _test_eof40;

            case 40:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr127;

                case 19:
                    goto st40;

                case 23:
                    goto st41;

                case 37:
                    goto st40;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st41;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st41;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st41;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st41;
                }
                else
                    goto st41;

                goto st0;
tr112:

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
                    goto st40;

                case 5:
                    goto st40;

                case 8:
                    goto st40;

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
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr130;

                goto st0;
st43:

                if ( ++p == pe )
                    goto _test_eof43;

            case 43:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr131;

                goto st0;
st44:

                if ( ++p == pe )
                    goto _test_eof44;

            case 44:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr132;

                goto st0;
st45:

                if ( ++p == pe )
                    goto _test_eof45;

            case 45:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr133;

                goto st0;
st46:

                if ( ++p == pe )
                    goto _test_eof46;

            case 46:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr134;

                goto st0;
st47:

                if ( ++p == pe )
                    goto _test_eof47;

            case 47:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr135;

                goto st0;
st48:

                if ( ++p == pe )
                    goto _test_eof48;

            case 48:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr136;

                goto st0;
st49:

                if ( ++p == pe )
                    goto _test_eof49;

            case 49:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr137;

                goto st0;
st50:

                if ( ++p == pe )
                    goto _test_eof50;

            case 50:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr138;

                goto st0;
st51:

                if ( ++p == pe )
                    goto _test_eof51;

            case 51:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr139;

                goto st0;
st52:

                if ( ++p == pe )
                    goto _test_eof52;

            case 52:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr140;

                case 22:
                    goto st53;
                }

                goto st0;
st53:

                if ( ++p == pe )
                    goto _test_eof53;

            case 53:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr111;

                case 5:
                    goto tr111;

                case 8:
                    goto tr111;

                case 18:
                    goto tr112;

                case 21:
                    goto tr112;

                case 23:
                    goto tr112;

                case 36:
                    goto tr112;

                case 44:
                    goto tr112;

                case 48:
                    goto st42;

                case 53:
                    goto st43;

                case 54:
                    goto st44;

                case 55:
                    goto st45;

                case 56:
                    goto st46;

                case 57:
                    goto st47;

                case 58:
                    goto st48;

                case 59:
                    goto st49;

                case 60:
                    goto st50;

                case 61:
                    goto st51;

                case 62:
                    goto st54;

                case 79:
                    goto st55;

                case 80:
                    goto st56;

                case 81:
                    goto st68;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr112;

                goto st0;
st54:

                if ( ++p == pe )
                    goto _test_eof54;

            case 54:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr140;

                goto st0;
st55:

                if ( ++p == pe )
                    goto _test_eof55;

            case 55:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr143;

                goto st0;
st56:

                if ( ++p == pe )
                    goto _test_eof56;

            case 56:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st57;

                case 21:
                    goto st58;

                case 23:
                    goto st64;
                }

                goto st0;
st57:

                if ( ++p == pe )
                    goto _test_eof57;

            case 57:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr147;

                goto st0;
st58:

                if ( ++p == pe )
                    goto _test_eof58;

            case 58:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr148;

                case 5:
                    goto tr148;

                case 8:
                    goto tr148;

                case 18:
                    goto tr149;

                case 21:
                    goto tr149;

                case 23:
                    goto tr149;

                case 36:
                    goto tr149;

                case 44:
                    goto tr149;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr149;

                goto st0;
tr148:

                {
                    expr_start = p;
                }
                goto st59;
st59:

                if ( ++p == pe )
                    goto _test_eof59;

            case 59:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr151;

                case 23:
                    goto st60;

                case 37:
                    goto st59;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st60;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st60;
                }
                else
                    goto st60;

                goto st0;
st60:

                if ( ++p == pe )
                    goto _test_eof60;

            case 60:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st61;

                case 5:
                    goto st61;

                case 8:
                    goto st61;

                case 13:
                    goto st60;

                case 18:
                    goto st60;

                case 21:
                    goto st60;

                case 23:
                    goto st60;

                case 36:
                    goto st60;

                case 44:
                    goto st60;
                }

                goto st0;
st61:

                if ( ++p == pe )
                    goto _test_eof61;

            case 61:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st61;

                case 23:
                    goto st60;

                case 37:
                    goto st61;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st60;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st60;
                }
                else
                    goto st60;

                goto st0;
tr151:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st62;
st62:

                if ( ++p == pe )
                    goto _test_eof62;

            case 62:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr154;

                case 19:
                    goto tr151;

                case 23:
                    goto st60;

                case 37:
                    goto st59;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st60;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st60;
                }
                else
                    goto st60;

                goto st0;
tr149:

                {
                    expr_start = p;
                }
                goto st63;
st63:

                if ( ++p == pe )
                    goto _test_eof63;

            case 63:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st59;

                case 5:
                    goto st59;

                case 8:
                    goto st59;

                case 13:
                    goto st63;

                case 18:
                    goto st63;

                case 21:
                    goto st63;

                case 23:
                    goto st63;

                case 36:
                    goto st63;

                case 44:
                    goto st63;
                }

                goto st0;
st64:

                if ( ++p == pe )
                    goto _test_eof64;

            case 64:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr156;

                case 5:
                    goto tr156;

                case 8:
                    goto tr156;

                case 18:
                    goto tr157;

                case 21:
                    goto tr157;

                case 23:
                    goto tr157;

                case 36:
                    goto tr157;

                case 44:
                    goto tr157;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr157;

                goto st0;
tr156:

                {
                    expr_start = p;
                }
                goto st65;
st65:

                if ( ++p == pe )
                    goto _test_eof65;

            case 65:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr158;

                case 23:
                    goto st60;

                case 37:
                    goto st65;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st60;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st60;
                }
                else
                    goto st60;

                goto st0;
tr158:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st66;
st66:

                if ( ++p == pe )
                    goto _test_eof66;

            case 66:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr160;

                case 19:
                    goto tr158;

                case 23:
                    goto st60;

                case 37:
                    goto st65;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st60;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st60;
                }
                else
                    goto st60;

                goto st0;
tr157:

                {
                    expr_start = p;
                }
                goto st67;
st67:

                if ( ++p == pe )
                    goto _test_eof67;

            case 67:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st65;

                case 5:
                    goto st65;

                case 8:
                    goto st65;

                case 13:
                    goto st67;

                case 18:
                    goto st67;

                case 21:
                    goto st67;

                case 23:
                    goto st67;

                case 36:
                    goto st67;

                case 44:
                    goto st67;
                }

                goto st0;
st68:

                if ( ++p == pe )
                    goto _test_eof68;

            case 68:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto st69;

                case 21:
                    goto st70;

                case 23:
                    goto st74;
                }

                goto st0;
st69:

                if ( ++p == pe )
                    goto _test_eof69;

            case 69:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr165;

                goto st0;
st70:

                if ( ++p == pe )
                    goto _test_eof70;

            case 70:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr166;

                case 5:
                    goto tr166;

                case 8:
                    goto tr166;

                case 18:
                    goto tr167;

                case 21:
                    goto tr167;

                case 23:
                    goto tr167;

                case 36:
                    goto tr167;

                case 44:
                    goto tr167;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr167;

                goto st0;
tr166:

                {
                    expr_start = p;
                }
                goto st71;
st71:

                if ( ++p == pe )
                    goto _test_eof71;

            case 71:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr168;

                case 23:
                    goto st60;

                case 37:
                    goto st71;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st60;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st60;
                }
                else
                    goto st60;

                goto st0;
tr168:

                {
                    push_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st72;
st72:

                if ( ++p == pe )
                    goto _test_eof72;

            case 72:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr170;

                case 19:
                    goto tr168;

                case 23:
                    goto st60;

                case 37:
                    goto st71;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st60;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st60;
                }
                else
                    goto st60;

                goto st0;
tr167:

                {
                    expr_start = p;
                }
                goto st73;
st73:

                if ( ++p == pe )
                    goto _test_eof73;

            case 73:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st71;

                case 5:
                    goto st71;

                case 8:
                    goto st71;

                case 13:
                    goto st73;

                case 18:
                    goto st73;

                case 21:
                    goto st73;

                case 23:
                    goto st73;

                case 36:
                    goto st73;

                case 44:
                    goto st73;
                }

                goto st0;
st74:

                if ( ++p == pe )
                    goto _test_eof74;

            case 74:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr172;

                case 5:
                    goto tr172;

                case 8:
                    goto tr172;

                case 18:
                    goto tr173;

                case 21:
                    goto tr173;

                case 23:
                    goto tr173;

                case 36:
                    goto tr173;

                case 44:
                    goto tr173;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr173;

                goto st0;
tr172:

                {
                    expr_start = p;
                }
                goto st75;
st75:

                if ( ++p == pe )
                    goto _test_eof75;

            case 75:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 19:
                    goto tr174;

                case 23:
                    goto st60;

                case 37:
                    goto st75;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st60;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st60;
                }
                else
                    goto st60;

                goto st0;
tr174:

                {
                    push_neg_expr( expr_start->ts, ( p - 1 )->te );
                }
                goto st76;
st76:

                if ( ++p == pe )
                    goto _test_eof76;

            case 76:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr176;

                case 19:
                    goto tr174;

                case 23:
                    goto st60;

                case 37:
                    goto st75;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st60;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st60;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st60;
                }
                else
                    goto st60;

                goto st0;
tr173:

                {
                    expr_start = p;
                }
                goto st77;
st77:

                if ( ++p == pe )
                    goto _test_eof77;

            case 77:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st75;

                case 5:
                    goto st75;

                case 8:
                    goto st75;

                case 13:
                    goto st77;

                case 18:
                    goto st77;

                case 21:
                    goto st77;

                case 23:
                    goto st77;

                case 36:
                    goto st77;

                case 44:
                    goto st77;
                }

                goto st0;
st78:

                if ( ++p == pe )
                    goto _test_eof78;

            case 78:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr178;

                goto st0;
st79:

                if ( ++p == pe )
                    goto _test_eof79;

            case 79:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr179;

                goto st0;
st80:

                if ( ++p == pe )
                    goto _test_eof80;

            case 80:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr180;

                goto st0;
st81:

                if ( ++p == pe )
                    goto _test_eof81;

            case 81:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr181;

                goto st0;
st82:

                if ( ++p == pe )
                    goto _test_eof82;

            case 82:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr182;

                goto st0;
st83:

                if ( ++p == pe )
                    goto _test_eof83;

            case 83:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr183;

                goto st0;
st84:

                if ( ++p == pe )
                    goto _test_eof84;

            case 84:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr184;

                goto st0;
st85:

                if ( ++p == pe )
                    goto _test_eof85;

            case 85:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr185;

                case 5:
                    goto tr185;

                case 8:
                    goto tr185;

                case 18:
                    goto tr186;

                case 21:
                    goto tr186;

                case 23:
                    goto tr186;

                case 36:
                    goto tr186;

                case 44:
                    goto tr186;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr186;

                goto st0;
tr185:

                {
                    expr_start = p;
                }
                goto st86;
st86:

                if ( ++p == pe )
                    goto _test_eof86;

            case 86:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr187;

                case 19:
                    goto st86;

                case 23:
                    goto st87;

                case 37:
                    goto st86;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st87;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st87;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st87;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st87;
                }
                else
                    goto st87;

                goto st0;
tr186:

                {
                    expr_start = p;
                }
                goto st87;
st87:

                if ( ++p == pe )
                    goto _test_eof87;

            case 87:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st86;

                case 5:
                    goto st86;

                case 8:
                    goto st86;

                case 13:
                    goto st87;

                case 18:
                    goto st87;

                case 21:
                    goto st87;

                case 23:
                    goto st87;

                case 36:
                    goto st87;

                case 44:
                    goto st87;
                }

                goto st0;
st88:

                if ( ++p == pe )
                    goto _test_eof88;

            case 88:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr190;

                goto st0;
st89:

                if ( ++p == pe )
                    goto _test_eof89;

            case 89:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 70:
                    goto st90;

                case 74:
                    goto st93;

                case 82:
                    goto st97;
                }

                goto st0;
st90:

                if ( ++p == pe )
                    goto _test_eof90;

            case 90:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st91;

                goto st0;
st91:

                if ( ++p == pe )
                    goto _test_eof91;

            case 91:
                if ( ( ( ( int ) p->tok ) ) == 71 )
                    goto st92;

                goto st0;
st92:

                if ( ++p == pe )
                    goto _test_eof92;

            case 92:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr196;

                goto st0;
st93:

                if ( ++p == pe )
                    goto _test_eof93;

            case 93:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st94;

                goto st0;
st94:

                if ( ++p == pe )
                    goto _test_eof94;

            case 94:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 74:
                    goto st95;

                case 76:
                    goto st96;
                }

                goto st0;
st95:

                if ( ++p == pe )
                    goto _test_eof95;

            case 95:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr200;

                goto st0;
st96:

                if ( ++p == pe )
                    goto _test_eof96;

            case 96:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr201;

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
                case 71:
                    goto st99;

                case 72:
                    goto st100;

                case 73:
                    goto st101;
                }

                goto st0;
st99:

                if ( ++p == pe )
                    goto _test_eof99;

            case 99:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr206;

                goto st0;
st100:

                if ( ++p == pe )
                    goto _test_eof100;

            case 100:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr207;

                goto st0;
st101:

                if ( ++p == pe )
                    goto _test_eof101;

            case 101:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr208;

                goto st0;
st102:

                if ( ++p == pe )
                    goto _test_eof102;

            case 102:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr209;

                goto st0;
st103:

                if ( ++p == pe )
                    goto _test_eof103;

            case 103:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr210;

                goto st0;
st104:

                if ( ++p == pe )
                    goto _test_eof104;

            case 104:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr211;

                case 5:
                    goto tr211;

                case 8:
                    goto tr211;

                case 18:
                    goto tr212;

                case 21:
                    goto tr212;

                case 23:
                    goto tr212;

                case 36:
                    goto tr212;

                case 44:
                    goto tr212;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr212;

                goto st0;
tr211:

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
                case 12:
                    goto tr213;

                case 19:
                    goto st105;

                case 23:
                    goto st106;

                case 37:
                    goto st105;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st106;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st106;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st106;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st106;
                }
                else
                    goto st106;

                goto st0;
tr212:

                {
                    expr_start = p;
                }
                goto st106;
st106:

                if ( ++p == pe )
                    goto _test_eof106;

            case 106:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st105;

                case 5:
                    goto st105;

                case 8:
                    goto st105;

                case 13:
                    goto st106;

                case 18:
                    goto st106;

                case 21:
                    goto st106;

                case 23:
                    goto st106;

                case 36:
                    goto st106;

                case 44:
                    goto st106;
                }

                goto st0;
st107:

                if ( ++p == pe )
                    goto _test_eof107;

            case 107:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr216;

                goto st0;
st108:

                if ( ++p == pe )
                    goto _test_eof108;

            case 108:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr217;

                goto st0;
st109:

                if ( ++p == pe )
                    goto _test_eof109;

            case 109:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr218;

                goto st0;
st110:

                if ( ++p == pe )
                    goto _test_eof110;

            case 110:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr219;

                goto st0;
st111:

                if ( ++p == pe )
                    goto _test_eof111;

            case 111:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr220;

                case 5:
                    goto tr220;

                case 8:
                    goto tr220;

                case 18:
                    goto tr221;

                case 21:
                    goto tr221;

                case 23:
                    goto tr221;

                case 36:
                    goto tr221;

                case 44:
                    goto tr221;

                case 45:
                    goto st114;

                case 46:
                    goto st118;

                case 47:
                    goto st122;

                case 48:
                    goto st126;

                case 49:
                    goto st130;

                case 50:
                    goto st134;

                case 51:
                    goto st138;

                case 52:
                    goto st142;

                case 79:
                    goto st146;

                case 80:
                    goto st147;

                case 81:
                    goto st149;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr221;

                goto st0;
tr220:

                {
                    expr_start = p;
                }
                goto st112;
st112:

                if ( ++p == pe )
                    goto _test_eof112;

            case 112:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr233;

                case 19:
                    goto st112;

                case 23:
                    goto st113;

                case 37:
                    goto st112;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st113;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st113;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st113;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st113;
                }
                else
                    goto st113;

                goto st0;
tr221:

                {
                    expr_start = p;
                }
                goto st113;
st113:

                if ( ++p == pe )
                    goto _test_eof113;

            case 113:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st112;

                case 5:
                    goto st112;

                case 8:
                    goto st112;

                case 13:
                    goto st113;

                case 18:
                    goto st113;

                case 21:
                    goto st113;

                case 23:
                    goto st113;

                case 36:
                    goto st113;

                case 44:
                    goto st113;
                }

                goto st0;
st114:

                if ( ++p == pe )
                    goto _test_eof114;

            case 114:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st115;

                goto st0;
st115:

                if ( ++p == pe )
                    goto _test_eof115;

            case 115:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr237;

                case 5:
                    goto tr237;

                case 8:
                    goto tr237;

                case 18:
                    goto tr238;

                case 21:
                    goto tr238;

                case 23:
                    goto tr238;

                case 36:
                    goto tr238;

                case 44:
                    goto tr238;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr238;

                goto st0;
tr237:

                {
                    expr_start = p;
                }
                goto st116;
st116:

                if ( ++p == pe )
                    goto _test_eof116;

            case 116:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr239;

                case 19:
                    goto st116;

                case 23:
                    goto st117;

                case 37:
                    goto st116;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st117;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st117;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st117;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st117;
                }
                else
                    goto st117;

                goto st0;
tr238:

                {
                    expr_start = p;
                }
                goto st117;
st117:

                if ( ++p == pe )
                    goto _test_eof117;

            case 117:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st116;

                case 5:
                    goto st116;

                case 8:
                    goto st116;

                case 13:
                    goto st117;

                case 18:
                    goto st117;

                case 21:
                    goto st117;

                case 23:
                    goto st117;

                case 36:
                    goto st117;

                case 44:
                    goto st117;
                }

                goto st0;
st118:

                if ( ++p == pe )
                    goto _test_eof118;

            case 118:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st119;

                goto st0;
st119:

                if ( ++p == pe )
                    goto _test_eof119;

            case 119:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr243;

                case 5:
                    goto tr243;

                case 8:
                    goto tr243;

                case 18:
                    goto tr244;

                case 21:
                    goto tr244;

                case 23:
                    goto tr244;

                case 36:
                    goto tr244;

                case 44:
                    goto tr244;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr244;

                goto st0;
tr243:

                {
                    expr_start = p;
                }
                goto st120;
st120:

                if ( ++p == pe )
                    goto _test_eof120;

            case 120:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr245;

                case 19:
                    goto st120;

                case 23:
                    goto st121;

                case 37:
                    goto st120;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st121;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st121;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st121;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st121;
                }
                else
                    goto st121;

                goto st0;
tr244:

                {
                    expr_start = p;
                }
                goto st121;
st121:

                if ( ++p == pe )
                    goto _test_eof121;

            case 121:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st120;

                case 5:
                    goto st120;

                case 8:
                    goto st120;

                case 13:
                    goto st121;

                case 18:
                    goto st121;

                case 21:
                    goto st121;

                case 23:
                    goto st121;

                case 36:
                    goto st121;

                case 44:
                    goto st121;
                }

                goto st0;
st122:

                if ( ++p == pe )
                    goto _test_eof122;

            case 122:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st123;

                goto st0;
st123:

                if ( ++p == pe )
                    goto _test_eof123;

            case 123:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr249;

                case 5:
                    goto tr249;

                case 8:
                    goto tr249;

                case 18:
                    goto tr250;

                case 21:
                    goto tr250;

                case 23:
                    goto tr250;

                case 36:
                    goto tr250;

                case 44:
                    goto tr250;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr250;

                goto st0;
tr249:

                {
                    expr_start = p;
                }
                goto st124;
st124:

                if ( ++p == pe )
                    goto _test_eof124;

            case 124:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr251;

                case 19:
                    goto st124;

                case 23:
                    goto st125;

                case 37:
                    goto st124;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st125;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st125;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st125;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st125;
                }
                else
                    goto st125;

                goto st0;
tr250:

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
                    goto st124;

                case 5:
                    goto st124;

                case 8:
                    goto st124;

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
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st127;

                goto st0;
st127:

                if ( ++p == pe )
                    goto _test_eof127;

            case 127:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr255;

                case 5:
                    goto tr255;

                case 8:
                    goto tr255;

                case 18:
                    goto tr256;

                case 21:
                    goto tr256;

                case 23:
                    goto tr256;

                case 36:
                    goto tr256;

                case 44:
                    goto tr256;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr256;

                goto st0;
tr255:

                {
                    expr_start = p;
                }
                goto st128;
st128:

                if ( ++p == pe )
                    goto _test_eof128;

            case 128:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr257;

                case 19:
                    goto st128;

                case 23:
                    goto st129;

                case 37:
                    goto st128;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st129;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st129;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st129;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st129;
                }
                else
                    goto st129;

                goto st0;
tr256:

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
                    goto st128;

                case 5:
                    goto st128;

                case 8:
                    goto st128;

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
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st131;

                goto st0;
st131:

                if ( ++p == pe )
                    goto _test_eof131;

            case 131:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr261;

                case 5:
                    goto tr261;

                case 8:
                    goto tr261;

                case 18:
                    goto tr262;

                case 21:
                    goto tr262;

                case 23:
                    goto tr262;

                case 36:
                    goto tr262;

                case 44:
                    goto tr262;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr262;

                goto st0;
tr261:

                {
                    expr_start = p;
                }
                goto st132;
st132:

                if ( ++p == pe )
                    goto _test_eof132;

            case 132:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr263;

                case 19:
                    goto st132;

                case 23:
                    goto st133;

                case 37:
                    goto st132;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st133;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st133;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st133;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st133;
                }
                else
                    goto st133;

                goto st0;
tr262:

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
                case 3:
                    goto st132;

                case 5:
                    goto st132;

                case 8:
                    goto st132;

                case 13:
                    goto st133;

                case 18:
                    goto st133;

                case 21:
                    goto st133;

                case 23:
                    goto st133;

                case 36:
                    goto st133;

                case 44:
                    goto st133;
                }

                goto st0;
st134:

                if ( ++p == pe )
                    goto _test_eof134;

            case 134:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st135;

                goto st0;
st135:

                if ( ++p == pe )
                    goto _test_eof135;

            case 135:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr267;

                case 5:
                    goto tr267;

                case 8:
                    goto tr267;

                case 18:
                    goto tr268;

                case 21:
                    goto tr268;

                case 23:
                    goto tr268;

                case 36:
                    goto tr268;

                case 44:
                    goto tr268;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr268;

                goto st0;
tr267:

                {
                    expr_start = p;
                }
                goto st136;
st136:

                if ( ++p == pe )
                    goto _test_eof136;

            case 136:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr269;

                case 19:
                    goto st136;

                case 23:
                    goto st137;

                case 37:
                    goto st136;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st137;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st137;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st137;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st137;
                }
                else
                    goto st137;

                goto st0;
tr268:

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
                case 3:
                    goto st136;

                case 5:
                    goto st136;

                case 8:
                    goto st136;

                case 13:
                    goto st137;

                case 18:
                    goto st137;

                case 21:
                    goto st137;

                case 23:
                    goto st137;

                case 36:
                    goto st137;

                case 44:
                    goto st137;
                }

                goto st0;
st138:

                if ( ++p == pe )
                    goto _test_eof138;

            case 138:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st139;

                goto st0;
st139:

                if ( ++p == pe )
                    goto _test_eof139;

            case 139:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr273;

                case 5:
                    goto tr273;

                case 8:
                    goto tr273;

                case 18:
                    goto tr274;

                case 21:
                    goto tr274;

                case 23:
                    goto tr274;

                case 36:
                    goto tr274;

                case 44:
                    goto tr274;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr274;

                goto st0;
tr273:

                {
                    expr_start = p;
                }
                goto st140;
st140:

                if ( ++p == pe )
                    goto _test_eof140;

            case 140:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr275;

                case 19:
                    goto st140;

                case 23:
                    goto st141;

                case 37:
                    goto st140;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st141;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st141;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st141;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st141;
                }
                else
                    goto st141;

                goto st0;
tr274:

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
                case 3:
                    goto st140;

                case 5:
                    goto st140;

                case 8:
                    goto st140;

                case 13:
                    goto st141;

                case 18:
                    goto st141;

                case 21:
                    goto st141;

                case 23:
                    goto st141;

                case 36:
                    goto st141;

                case 44:
                    goto st141;
                }

                goto st0;
st142:

                if ( ++p == pe )
                    goto _test_eof142;

            case 142:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st143;

                goto st0;
st143:

                if ( ++p == pe )
                    goto _test_eof143;

            case 143:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr279;

                case 5:
                    goto tr279;

                case 8:
                    goto tr279;

                case 18:
                    goto tr280;

                case 21:
                    goto tr280;

                case 23:
                    goto tr280;

                case 36:
                    goto tr280;

                case 44:
                    goto tr280;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr280;

                goto st0;
tr279:

                {
                    expr_start = p;
                }
                goto st144;
st144:

                if ( ++p == pe )
                    goto _test_eof144;

            case 144:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr281;

                case 19:
                    goto st144;

                case 23:
                    goto st145;

                case 37:
                    goto st144;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st145;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st145;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st145;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st145;
                }
                else
                    goto st145;

                goto st0;
tr280:

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
                case 3:
                    goto st144;

                case 5:
                    goto st144;

                case 8:
                    goto st144;

                case 13:
                    goto st145;

                case 18:
                    goto st145;

                case 21:
                    goto st145;

                case 23:
                    goto st145;

                case 36:
                    goto st145;

                case 44:
                    goto st145;
                }

                goto st0;
st146:

                if ( ++p == pe )
                    goto _test_eof146;

            case 146:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr284;

                goto st0;
st147:

                if ( ++p == pe )
                    goto _test_eof147;

            case 147:
                if ( ( ( ( int ) p->tok ) ) == 19 )
                    goto st148;

                goto st0;
st148:

                if ( ++p == pe )
                    goto _test_eof148;

            case 148:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr286;

                goto st0;
st149:

                if ( ++p == pe )
                    goto _test_eof149;

            case 149:
                if ( ( ( ( int ) p->tok ) ) == 19 )
                    goto st150;

                goto st0;
st150:

                if ( ++p == pe )
                    goto _test_eof150;

            case 150:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr288;

                goto st0;
st151:

                if ( ++p == pe )
                    goto _test_eof151;

            case 151:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr289;

                case 5:
                    goto tr289;

                case 8:
                    goto tr289;

                case 18:
                    goto tr290;

                case 21:
                    goto tr290;

                case 23:
                    goto tr290;

                case 36:
                    goto tr290;

                case 44:
                    goto tr290;

                case 45:
                    goto st154;

                case 46:
                    goto st158;

                case 47:
                    goto st162;

                case 48:
                    goto st166;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr290;

                goto st0;
tr289:

                {
                    expr_start = p;
                }
                goto st152;
st152:

                if ( ++p == pe )
                    goto _test_eof152;

            case 152:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr295;

                case 19:
                    goto st152;

                case 23:
                    goto st153;

                case 37:
                    goto st152;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st153;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st153;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st153;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st153;
                }
                else
                    goto st153;

                goto st0;
tr290:

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
                case 3:
                    goto st152;

                case 5:
                    goto st152;

                case 8:
                    goto st152;

                case 13:
                    goto st153;

                case 18:
                    goto st153;

                case 21:
                    goto st153;

                case 23:
                    goto st153;

                case 36:
                    goto st153;

                case 44:
                    goto st153;
                }

                goto st0;
st154:

                if ( ++p == pe )
                    goto _test_eof154;

            case 154:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st155;

                goto st0;
st155:

                if ( ++p == pe )
                    goto _test_eof155;

            case 155:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr299;

                case 5:
                    goto tr299;

                case 8:
                    goto tr299;

                case 18:
                    goto tr300;

                case 21:
                    goto tr300;

                case 23:
                    goto tr300;

                case 36:
                    goto tr300;

                case 44:
                    goto tr300;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr300;

                goto st0;
tr299:

                {
                    expr_start = p;
                }
                goto st156;
st156:

                if ( ++p == pe )
                    goto _test_eof156;

            case 156:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr301;

                case 19:
                    goto st156;

                case 23:
                    goto st157;

                case 37:
                    goto st156;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st157;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st157;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st157;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st157;
                }
                else
                    goto st157;

                goto st0;
tr300:

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
                    goto st156;

                case 5:
                    goto st156;

                case 8:
                    goto st156;

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
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st159;

                goto st0;
st159:

                if ( ++p == pe )
                    goto _test_eof159;

            case 159:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr305;

                case 5:
                    goto tr305;

                case 8:
                    goto tr305;

                case 18:
                    goto tr306;

                case 21:
                    goto tr306;

                case 23:
                    goto tr306;

                case 36:
                    goto tr306;

                case 44:
                    goto tr306;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr306;

                goto st0;
tr305:

                {
                    expr_start = p;
                }
                goto st160;
st160:

                if ( ++p == pe )
                    goto _test_eof160;

            case 160:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr307;

                case 19:
                    goto st160;

                case 23:
                    goto st161;

                case 37:
                    goto st160;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st161;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st161;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st161;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st161;
                }
                else
                    goto st161;

                goto st0;
tr306:

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
                    goto st160;

                case 5:
                    goto st160;

                case 8:
                    goto st160;

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
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st163;

                goto st0;
st163:

                if ( ++p == pe )
                    goto _test_eof163;

            case 163:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto tr311;

                case 5:
                    goto tr311;

                case 8:
                    goto tr311;

                case 18:
                    goto tr312;

                case 21:
                    goto tr312;

                case 23:
                    goto tr312;

                case 36:
                    goto tr312;

                case 44:
                    goto tr312;
                }

                if ( 13 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 14 )
                    goto tr312;

                goto st0;
tr311:

                {
                    expr_start = p;
                }
                goto st164;
st164:

                if ( ++p == pe )
                    goto _test_eof164;

            case 164:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr313;

                case 19:
                    goto st164;

                case 23:
                    goto st165;

                case 37:
                    goto st164;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st165;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st165;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st165;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st165;
                }
                else
                    goto st165;

                goto st0;
tr312:

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
                case 3:
                    goto st164;

                case 5:
                    goto st164;

                case 8:
                    goto st164;

                case 13:
                    goto st165;

                case 18:
                    goto st165;

                case 21:
                    goto st165;

                case 23:
                    goto st165;

                case 36:
                    goto st165;

                case 44:
                    goto st165;
                }

                goto st0;
st166:

                if ( ++p == pe )
                    goto _test_eof166;

            case 166:
                if ( ( ( ( int ) p->tok ) ) == 22 )
                    goto st167;

                goto st0;
st167:

                if ( ++p == pe )
                    goto _test_eof167;

            case 167:
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
                goto st168;
st168:

                if ( ++p == pe )
                    goto _test_eof168;

            case 168:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr319;

                case 19:
                    goto st168;

                case 23:
                    goto st169;

                case 37:
                    goto st168;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st169;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st169;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st169;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st169;
                }
                else
                    goto st169;

                goto st0;
tr318:

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
                case 3:
                    goto st168;

                case 5:
                    goto st168;

                case 8:
                    goto st168;

                case 13:
                    goto st169;

                case 18:
                    goto st169;

                case 21:
                    goto st169;

                case 23:
                    goto st169;

                case 36:
                    goto st169;

                case 44:
                    goto st169;
                }

                goto st0;
st170:

                if ( ++p == pe )
                    goto _test_eof170;

            case 170:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr322;

                goto st0;
st171:

                if ( ++p == pe )
                    goto _test_eof171;

            case 171:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr323;

                goto st0;
st172:

                if ( ++p == pe )
                    goto _test_eof172;

            case 172:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr324;

                goto st0;
st173:

                if ( ++p == pe )
                    goto _test_eof173;

            case 173:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr325;

                goto st0;
st174:

                if ( ++p == pe )
                    goto _test_eof174;

            case 174:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr326;

                goto st0;
st175:

                if ( ++p == pe )
                    goto _test_eof175;

            case 175:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr327;

                goto st0;
st176:

                if ( ++p == pe )
                    goto _test_eof176;

            case 176:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr328;

                goto st0;
st177:

                if ( ++p == pe )
                    goto _test_eof177;

            case 177:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr329;

                goto st0;
st178:

                if ( ++p == pe )
                    goto _test_eof178;

            case 178:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr330;

                goto st0;
st179:

                if ( ++p == pe )
                    goto _test_eof179;

            case 179:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr331;

                goto st0;
st180:

                if ( ++p == pe )
                    goto _test_eof180;

            case 180:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st181;

                case 70:
                    goto st182;

                case 71:
                    goto st183;

                case 72:
                    goto st184;

                case 73:
                    goto st185;

                case 74:
                    goto st186;
                }

                goto st0;
st181:

                if ( ++p == pe )
                    goto _test_eof181;

            case 181:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr338;

                goto st0;
st182:

                if ( ++p == pe )
                    goto _test_eof182;

            case 182:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr339;

                goto st0;
st183:

                if ( ++p == pe )
                    goto _test_eof183;

            case 183:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr340;

                goto st0;
st184:

                if ( ++p == pe )
                    goto _test_eof184;

            case 184:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr341;

                goto st0;
st185:

                if ( ++p == pe )
                    goto _test_eof185;

            case 185:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr342;

                goto st0;
st186:

                if ( ++p == pe )
                    goto _test_eof186;

            case 186:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr343;

                goto st0;
st187:

                if ( ++p == pe )
                    goto _test_eof187;

            case 187:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 69:
                    goto st188;

                case 70:
                    goto st189;

                case 71:
                    goto st190;

                case 72:
                    goto st191;

                case 73:
                    goto st192;

                case 74:
                    goto st193;
                }

                goto st0;
st188:

                if ( ++p == pe )
                    goto _test_eof188;

            case 188:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr350;

                goto st0;
st189:

                if ( ++p == pe )
                    goto _test_eof189;

            case 189:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr351;

                goto st0;
st190:

                if ( ++p == pe )
                    goto _test_eof190;

            case 190:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr352;

                goto st0;
st191:

                if ( ++p == pe )
                    goto _test_eof191;

            case 191:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr353;

                goto st0;
st192:

                if ( ++p == pe )
                    goto _test_eof192;

            case 192:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr354;

                goto st0;
st193:

                if ( ++p == pe )
                    goto _test_eof193;

            case 193:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr355;

                goto st0;
st194:

                if ( ++p == pe )
                    goto _test_eof194;

            case 194:
                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr356;

                case 45:
                    goto st195;

                case 46:
                    goto st196;

                case 47:
                    goto st197;

                case 48:
                    goto st198;

                case 49:
                    goto st199;

                case 50:
                    goto st200;

                case 51:
                    goto st201;

                case 52:
                    goto st202;
                }

                goto st0;
st195:

                if ( ++p == pe )
                    goto _test_eof195;

            case 195:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr365;

                goto st0;
st196:

                if ( ++p == pe )
                    goto _test_eof196;

            case 196:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr366;

                goto st0;
st197:

                if ( ++p == pe )
                    goto _test_eof197;

            case 197:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr367;

                goto st0;
st198:

                if ( ++p == pe )
                    goto _test_eof198;

            case 198:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr368;

                goto st0;
st199:

                if ( ++p == pe )
                    goto _test_eof199;

            case 199:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr369;

                goto st0;
st200:

                if ( ++p == pe )
                    goto _test_eof200;

            case 200:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr370;

                goto st0;
st201:

                if ( ++p == pe )
                    goto _test_eof201;

            case 201:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr371;

                goto st0;
st202:

                if ( ++p == pe )
                    goto _test_eof202;

            case 202:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr372;

                goto st0;
st203:

                if ( ++p == pe )
                    goto _test_eof203;

            case 203:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr373;

                goto st0;
st204:

                if ( ++p == pe )
                    goto _test_eof204;

            case 204:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr374;

                goto st0;
st205:

                if ( ++p == pe )
                    goto _test_eof205;

            case 205:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr375;

                goto st0;
st206:

                if ( ++p == pe )
                    goto _test_eof206;

            case 206:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr376;

                goto st0;
st207:

                if ( ++p == pe )
                    goto _test_eof207;

            case 207:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr377;

                goto st0;
st208:

                if ( ++p == pe )
                    goto _test_eof208;

            case 208:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr378;

                goto st0;
st209:

                if ( ++p == pe )
                    goto _test_eof209;

            case 209:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr379;

                goto st0;
st210:

                if ( ++p == pe )
                    goto _test_eof210;

            case 210:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr380;

                goto st0;
st211:

                if ( ++p == pe )
                    goto _test_eof211;

            case 211:
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
                goto st212;
st212:

                if ( ++p == pe )
                    goto _test_eof212;

            case 212:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 12:
                    goto tr383;

                case 19:
                    goto st212;

                case 23:
                    goto st213;

                case 37:
                    goto st212;
                }

                if ( ( ( ( int ) p->tok ) ) < 25 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 17 )
                    {
                        if ( 20 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 21 )
                            goto st213;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 15 )
                        goto st213;
                }
                else if ( ( ( ( int ) p->tok ) ) > 35 )
                {
                    if ( ( ( ( int ) p->tok ) ) > 39 )
                    {
                        if ( 41 <= ( ( ( int ) p->tok ) ) && ( ( ( int ) p->tok ) ) <= 42 )
                            goto st213;
                    }
                    else if ( ( ( ( int ) p->tok ) ) >= 38 )
                        goto st213;
                }
                else
                    goto st213;

                goto st0;
tr382:

                {
                    expr_start = p;
                }
                goto st213;
st213:

                if ( ++p == pe )
                    goto _test_eof213;

            case 213:

                switch ( ( ( ( int ) p->tok ) ) )
                {
                case 3:
                    goto st212;

                case 5:
                    goto st212;

                case 8:
                    goto st212;

                case 13:
                    goto st213;

                case 18:
                    goto st213;

                case 21:
                    goto st213;

                case 23:
                    goto st213;

                case 36:
                    goto st213;

                case 44:
                    goto st213;
                }

                goto st0;
st214:

                if ( ++p == pe )
                    goto _test_eof214;

            case 214:
                if ( ( ( ( int ) p->tok ) ) == 12 )
                    goto tr386;

                goto st0;
            }

_test_eof215:
            cs = 215;
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

                215

           )
            return TRUE;
    }

    return FALSE;
}

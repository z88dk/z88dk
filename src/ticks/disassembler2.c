
#include <stdio.h>
#include "ticks.h"




static char *rp2_table[] = { "bc", "de", "hl", "af"};

static char *cc_table[] = { "nz", "z", "c", "nc", "po", "pe", "p", "m"};

static char *alu_table[] = { "add", "adc", "sub", "sbc", "and", "xor", "or", "cp"};


static char *assorted_mainpage_opcodes[] = { "rlca", "rrca", "rla", "rra", "daa", "cpl", "scf", "ccf" };



typedef struct {
    int       index;
    int       pc;
    int       len;
    int       skip;
    uint8_t   prefix;
    uint8_t   displacement;
    uint8_t   opcode;
    uint8_t   instr_bytes[6];
} dcontext;


#define READ_BYTE(state,val) do { \
    val = get_memory(state->pc++); \
    state->instr_bytes[state->len++] = val; \
} while (0)

#define BUF_PRINTF(fmt, ...) do { \
    offs += snprintf(buf + offs, buflen - offs, fmt, ## __VA_ARGS__); \
} while(0)

static char *handle_rot(dcontext *state,  uint8_t z)
{
    char *undoc_rot_table[] = { "rlc", "rrc", "rl", "rr", "sla", "sra", "sll", "srl" };
    char *rot_table[] = { "rlc", "rrc", "rl", "rr", "sla", "sra", NULL, "srl" };
    char *instr = rot_table[z];

    if ( !cansll() ) {
        char *isntr = undoc_rot_table[z];
    }
    if ( instr == NULL ) {
        return "nop";        
    } 
    return instr;
}

static char *handle_rel8(dcontext *state, char *buf, size_t buflen)
{
    size_t offs = 0;
    int8_t displacement;

    READ_BYTE(state, displacement);
    
    BUF_PRINTF("$%04x", state->pc + displacement);
    
    return buf;
}

static char *handle_addr16(dcontext *state, char *buf, size_t buflen)
{
    size_t offs = 0;
    uint8_t lsb;
    uint8_t msb;
    
    READ_BYTE(state, lsb);
    READ_BYTE(state, msb);
    
    BUF_PRINTF("$%02x%02x", msb, lsb);

    return buf;
}

static char *handle_immed8(dcontext *state, char *buf, size_t buflen)
{
    size_t offs = 0;
    uint8_t lsb;
    
    READ_BYTE(state, lsb);
    BUF_PRINTF("$%02x", lsb);
    
    return buf;
}

static char *handle_immed16(dcontext *state, char *buf, size_t buflen)
{
    size_t offs = 0;
    uint8_t lsb;
    uint8_t msb;
    
    READ_BYTE(state, lsb);
    READ_BYTE(state, msb);
    
    BUF_PRINTF("$%02x%02x", msb, lsb);
    
    return buf;
}

static char *handle_hl(dcontext *state)
{
    char *table[] = { "hl", "ix", "iy"};
    return table[state->index];
}

static char *handle_register8(dcontext *state, uint8_t y, char *buf, size_t buflen)
{
    static char *table[3][8] = { 
        { "b", "c", "d", "e", "h", "l", "(hl)", "a" },
        { "b", "c", "d", "e", "ixh", "ixl", "(ix", "a" },
        { "b", "c", "d", "e", "iyh", "ixl", "(iy", "a" }
    };
    size_t offs = 0;

    /* Turn of ixl/h handling for Rabbit and Z180 */
    if ( !canixh() ) {
        state->index = 0;
     }
    if ( y == 6 && state->index ) {
        int8_t displacement = state->displacement;

        if ( state->prefix != 0xcb )
            READ_BYTE(state, displacement);
        BUF_PRINTF("%s%s$%02x)", table[state->index][y],
                                    displacement < 0 ? "-" : "+", displacement < 0 ? -displacement : displacement);
        return buf;
    } 
    BUF_PRINTF("%s", table[state->index][y]);
    return buf;
}

static char *handle_displacement(dcontext *state, char *buf, size_t buflen)
{
    int8_t dis;
    size_t offs = 0;

    READ_BYTE(state, dis);
    BUF_PRINTF("%s$%02x",  dis < 0 ? "-" : "+", dis < 0 ? -dis : dis);
    return buf;
}

static char *handle_register16(dcontext *state, uint8_t p, int index)
{
    static char *table[3][4] = {
        { "bc", "de", "hl", "sp" },
        { "bc", "de", "ix", "sp" },
        { "bc", "de", "iy", "sp" },
    };
    
    return table[index][p];
}

static char *handle_register16_2(dcontext *state, uint8_t p, int index)
{
    static char *table[3][4] = {
        { "bc", "de", "hl", "af" },
        { "bc", "de", "ix", "af" },
        { "bc", "de", "iy", "af" },
    };
    
    
    return table[index][p];
}

static char *handle_block_instruction(dcontext *state, uint8_t z, uint8_t y)
{
    static char *table[4][4] = { 
        { "ldi", "cpi", "ini", "outi"},
        { "ldd", "cpd", "ind", "outd"},
        { "ldir", "cpir", "inir", "otir"},
        { "lddr", "cpdr", "indr", "otdr"}
    };

    return table[y-4][z];

}

static char *handle_ed_assorted_instructions(dcontext *state, uint8_t y)
{
    static char *table[] = { "ld\ti,a", "ld\tr,a", "ld\ta,i", "ld\ta,r", "rrd", "rld", "nop", "nop"};
    static char *r2k_table[] = { "ld\teir,a", "ld\tiir,a", "ld\ta,eir", "ld\ta,iir", "ld\txpc,a", "nop", "ld\ta,xpc", "nop"};
    static char *r3k_table[] = { "ld\teir,a", "ld\tiir,a", "ld\ta,eir", "ld\ta,iir", "ld\txpc,a", "setusr", "ld\ta,xpc", "rdmode"};
    
    return c_cpu & CPU_R2K ? r2k_table[y] : c_cpu & CPU_R3K ? r3k_table[y] : table[y];
}

static char *handle_im_instructions(dcontext *state, uint8_t y)
{
    char *table[] = { "im\t0", "im\t0/1", "im\t1", "im\t2", "im\t0", "im\t0/1", "im\t1", "im\t2"};
    char *r2k_table[] = { "ipset\t0", "ipset\t2", "ipset\t1", "ipset\t3", "nop", "nop", "push\tip", "pop\tip"};
    char *r3k_table[] = { "ipset\t0", "ipset\t2", "ipset\t1", "ipset\t3", "push\tsu", "pop\tsu", "push\tip", "pop\tip"};
    
    return c_cpu & CPU_R2K ? r2k_table[y] : c_cpu & CPU_R3K ? r3k_table[y] : table[y];
}   


int disassemble2(int pc, char *buf, size_t buflen)
{
    dcontext    s_state = {0};
    dcontext   *state = &s_state;
    int         i;
    uint8_t     b;
    const char  *label;
    size_t       offs = 0;
    int          start_pc = pc;
    char         opbuf1[256];
    char         opbuf2[256];

    buf[0] = 0;
    state->pc = pc;
    
    label = find_symbol(pc, SYM_ADDRESS);
    if (label ) {
        offs += snprintf(buf + offs, buflen - offs, "%s:",label);
    }

    if ( offs < 20 ) {
        offs = snprintf(buf, buflen, "%-20s", buf);
    }
    
    do {
        READ_BYTE(state, b);

        // Decoding the main page
        // x = the opcode's 1st octal digit (i.e. bits 7-6)
        // y = the opcode's 2nd octal digit (i.e. bits 5-3)
        // z = the opcode's 3rd octal digit (i.e. bits 2-0)
        uint8_t x = b >> 6;
        uint8_t y = ( b & 0x38) >> 3;
        uint8_t z = b & 0x07;
        uint8_t p = (y & 0x06) >> 1;
        uint8_t q = y & 0x01;

        switch ( x ) {
            case 0:
                switch ( z ) {
                    case 0:
                        if ( y == 0 ) BUF_PRINTF("nop");
                        else if ( y == 1 ) BUF_PRINTF("ex\taf,af\'");
                        else if ( y == 2 ) BUF_PRINTF("djnz\t%s", handle_rel8(state, opbuf1, sizeof(opbuf1)));
                        else if ( y == 3 ) BUF_PRINTF("jr\t%s", handle_rel8(state, opbuf1, sizeof(opbuf1)));
                        else BUF_PRINTF("jr\t%s,%s", cc_table[y-4], handle_rel8(state, opbuf1,  sizeof(opbuf1)));
                        break;
                    case 1:
                        if ( q == 0 ) BUF_PRINTF("ld\t%s,%s", handle_register16(state, p,state->index), handle_immed16(state, opbuf1, sizeof(opbuf1)));
                        else BUF_PRINTF("add\t%s,%s", handle_hl(state), handle_register16(state, p, state->index));
                        break;
                    case 2:
                        if ( q == 0 ) {
                            if ( p == 0 ) BUF_PRINTF("ld\t(bc),a");
                            else if ( p == 1 ) BUF_PRINTF("ld\t(de),a");
                            else if ( p == 2 ) BUF_PRINTF("ld\t(%s),%s",handle_addr16(state, opbuf1, sizeof(opbuf1)), handle_hl(state));
                            else if ( p == 3 ) BUF_PRINTF("ld\t(%s),a",handle_addr16(state, opbuf1, sizeof(opbuf1)));
                        } else if ( q == 1 ) {
                            if ( p == 0 ) BUF_PRINTF("ld\ta,(bc)");
                            else if ( p == 1 ) BUF_PRINTF("ld\ta,(de)");
                            else if ( p == 2 ) BUF_PRINTF("ld\t%s,(%s)", handle_hl(state), handle_addr16(state, opbuf1, sizeof(opbuf1)));
                            else if ( p == 3 ) BUF_PRINTF("ld\ta,(%s)", handle_addr16(state, opbuf1, sizeof(opbuf1)));
                        } 
                        break;
                    case 3:
                        if ( q == 0 ) BUF_PRINTF("inc\t%s", handle_register16(state, p, state->index));
                        else BUF_PRINTF("dec\t%s", handle_register16(state, p, state->index));
                        break;
                    case 4:
                        BUF_PRINTF("inc\t%s", handle_register8(state, y, opbuf1, sizeof(opbuf1)));
                        break;
                    case 5:
                        BUF_PRINTF("dec\t%s", handle_register8(state, y,opbuf1,sizeof(opbuf1)));
                        break;
                    case 6:
                        BUF_PRINTF("ld\t%s,%s", handle_register8(state, y,opbuf1,sizeof(opbuf1)), handle_immed8(state, opbuf2, sizeof(opbuf2)));
                        break;
                    case 7:
                        if ( israbbit() && y == 4 ) BUF_PRINTF("add\tsp,%s", handle_displacement(state, opbuf1, sizeof(opbuf1)));
                        else BUF_PRINTF("%s", assorted_mainpage_opcodes[y]);
                        break;
                }
                break;
            case 1: /* x = 1 */
                if ( z == 6 && y == 6 ) {
                    if ( israbbit() ) BUF_PRINTF("altd");
                    else BUF_PRINTF("halt");
                } else if ( israbbit() && z == 4 && y == 7 ) {
                    BUF_PRINTF("ld\thl,%s", handle_register16(state,2, state->index));
                } else if ( israbbit() && z == 5 && y == 7 ) {
                    BUF_PRINTF("ld\t%s,hl", handle_register16(state,2, state->index)); 
                } else if ( israbbit() && z == 4 && y == 4 && state->index ) {
                    BUF_PRINTF("ldp\t(%s),hl",  handle_register16(state,2, state->index)); 
                } else if ( israbbit() && z == 5 && y == 4 && state->index ) {
                    BUF_PRINTF("ldp\t(%s),hl",  handle_addr16(state,opbuf1, sizeof(opbuf1)));
                } else if ( israbbit() && z == 4 && y == 5 && state->index ) {
                    BUF_PRINTF("ldp\thl,(%s)", handle_register16(state,2, state->index)); 
                } else if ( israbbit() && z == 5 && y == 5 && state->index ) {
                    BUF_PRINTF("ldp\t%s,(%s)", handle_register16(state,2, state->index),  handle_addr16(state,opbuf1, sizeof(opbuf1)));
                } else {
                    handle_register8(state, y, opbuf1, sizeof(opbuf1));
                    handle_register8(state, z, opbuf2, sizeof(opbuf2));
                    if ( y == 6) {
                        state->index = 0;
                        handle_register8(state, z, opbuf2, sizeof(opbuf2));
                    } else if ( z == 6 ) {
                        state->index = 0;
                        handle_register8(state, y, opbuf1, sizeof(opbuf1));  
                    }
                    BUF_PRINTF("ld\t%s,%s", opbuf1, opbuf2);
                }
                break;
            case 2: /* x = 2 */
                BUF_PRINTF("%s\t%s", alu_table[y], handle_register8(state, z, opbuf1, sizeof(opbuf1)));
                break;
            case 3: /* x = 3 */
                if ( z == 0 ) {
                    BUF_PRINTF("ret\t%s",cc_table[y]);
                } else if ( z == 1 ) {
                    if  ( q == 0 ) BUF_PRINTF("pop\t%s",handle_register16_2(state,p, state->index));
                    else if ( q == 1 ) {
                        if ( p == 0 ) BUF_PRINTF("ret");
                        else if ( p == 1 ) BUF_PRINTF("exx");
                        else if ( p == 2 ) BUF_PRINTF("jp\t(%s)",handle_register16(state, 2, state->index)); 
                        else if ( p == 3 ) BUF_PRINTF("ld\tsp,%s", handle_register16(state, 2, state->index)); 
                    }
                } else if ( z == 2 ) { 
                    BUF_PRINTF("jp\t%s,%s", cc_table[y], handle_addr16(state, opbuf1, sizeof(opbuf1)));
                } else if  ( z == 3 ) {
                    if ( y == 0 ) BUF_PRINTF("jp\t%s",  handle_addr16(state, opbuf1, sizeof(opbuf1)));
                    else if ( y == 1 ) {
                        READ_BYTE(state, b);
                        uint8_t x = b >> 6;
                        uint8_t y = ( b & 0x38) >> 3;
                        uint8_t z = b & 0x07;

                        state->prefix = 0xcb;
                        if ( state->index ) {
                            READ_BYTE(state, state->displacement);
                        }
                        if ( x == 0 ) {
                            char *instr = handle_rot(state, y);
                            if ( instr ) BUF_PRINTF("%s\t%s", instr, handle_register8(state, z, opbuf1, sizeof(opbuf1)));
                            else BUF_PRINTF("nop");
                        } else if ( x == 1 ) {
                            BUF_PRINTF("bit\t%d,%s", z, handle_register8(state, z, opbuf1, sizeof(opbuf1)));                 // TODO: Undocumented
                        } else if ( x == 2 ) {
                            BUF_PRINTF("res\t%d,%s", z, handle_register8(state, z, opbuf1, sizeof(opbuf1)));                 // TODO: Undocumented
                        } else if ( x == 3 ) {
                            BUF_PRINTF("set\t%d,%s", z, handle_register8(state, z, opbuf1, sizeof(opbuf1)));                 // TODO: Undocumented
                        }
                        state->prefix = 0;
                    } else if ( y == 2 ) {
                        if ( israbbit() ) BUF_PRINTF("ioi");  
                        else BUF_PRINTF("out\t(%s),a",handle_immed8(state, opbuf1, sizeof(opbuf1)));
                    } else if ( y == 3 ) {
                        if ( israbbit() ) BUF_PRINTF("ioe");
                        else BUF_PRINTF("in\ta,(%s)",handle_immed8(state, opbuf1, sizeof(opbuf1)));
                    } else if ( y == 4 ) {
                        if ( israbbit() && state->index == 0 ) BUF_PRINTF("ex\tde',hl");
                        else BUF_PRINTF("ex\t(sp),%s",  handle_register16(state, 2, state->index)); 
                    } else if ( y == 5 ) BUF_PRINTF("ex\tde,hl");
                    else if ( y == 6 ) { if (israbbit()) BUF_PRINTF("rl\tde"); else BUF_PRINTF("di"); }
                    else if ( y == 7 ) { if (israbbit()) BUF_PRINTF("rr\tde"); else BUF_PRINTF("ei"); }
                } else if ( z == 4 ) { 
                    if ( israbbit() ) {
                        if ( y == 0 ) BUF_PRINTF("ld\t%s,(sp+%s)",handle_register16(state, 2, state->index), handle_immed8(state, opbuf1, sizeof(opbuf1)));
                        else if ( y == 1 ) BUF_PRINTF("bool\t%s",handle_register16(state, 2, state->index));
                        else if ( y == 2 ) BUF_PRINTF("ld\t(sp+%s),%s",handle_immed8(state, opbuf1, sizeof(opbuf1)),handle_register16(state, 2, state->index));
                        else if ( y == 3 ) BUF_PRINTF("and\t%s,de", handle_register16(state,2, state->index));
                        else if ( y == 4 ) BUF_PRINTF("ld\thl,(%s%s)", handle_register16(state,2, state->index == 0 ? 1 : state->index == 1 ? 0 : 2), handle_displacement(state, opbuf1, sizeof(opbuf1)));
                        else if ( y == 5 ) BUF_PRINTF("or\t%s,de", handle_register16(state,2, state->index));
                        else if ( y == 6 ) BUF_PRINTF("ld\t(%s%s),hl",handle_register16(state,2, state->index == 0 ? 1 : state->index == 1 ? 0 : 2), handle_displacement(state, opbuf1, sizeof(opbuf1)));
                        else if ( y == 7 ) BUF_PRINTF("rr\t%s", handle_register16(state,2, state->index));
                    } else BUF_PRINTF("call\t%s,%s", cc_table[y], handle_addr16(state, opbuf1, sizeof(opbuf1)));
                } else if ( z == 5 ) {
                    if ( q == 0 ) BUF_PRINTF("push\t%s",handle_register16_2(state,p, state->index));
                    else if ( q == 1 ) {
                        if ( p == 0 ) BUF_PRINTF("call\t%s", handle_addr16(state, opbuf1, sizeof(opbuf1)));
                        else if ( p == 1 ) { state->index = 1; continue; }
                        else if ( p == 2 ) { // ED page
                            READ_BYTE(state, b);
                            uint8_t x = b >> 6;
                            uint8_t y = ( b & 0x38) >> 3;
                            uint8_t z = b & 0x07;
                            uint8_t p = (y & 0x06) >> 1;
                            uint8_t q = y & 0x01;
                            state->index = 0;
                            if ( x == 1 ) {
                                // 01 101 100
                                switch ( z ) {
                                    case 0:
                                        if ( y != 6 ) BUF_PRINTF("in\t%s,(c)", handle_register8(state, y, opbuf1, sizeof(opbuf1)));
                                        else BUF_PRINTF("in\t(c)");
                                        break;
                                    case 1:
                                        if ( israbbit() ) {
                                            if ( q == 0 ) BUF_PRINTF("ld\t%s',de",handle_register16(state, p, state->index));
                                            else BUF_PRINTF("ld\t%s',bc",handle_register16(state, p, state->index));
                                        } else {
                                            if ( y != 6 ) BUF_PRINTF("out\t(c),%s", handle_register8(state, y, opbuf1, sizeof(opbuf1)));
                                            else BUF_PRINTF("out\t(c),0");
                                        }
                                        break;                     
                                    case 2:
                                        if ( q == 0 ) BUF_PRINTF("sbc\thl,%s", handle_register16(state, p, state->index));
                                        else BUF_PRINTF("adc\thl,%s", handle_register16(state, p, state->index));
                                        break;
                                    case 3:
                                        if ( q == 0 ) BUF_PRINTF("ld\t(%s),%s", handle_addr16(state, opbuf1, sizeof(opbuf1)), handle_register16(state, p, state->index));
                                        else BUF_PRINTF("ld\t%s,(%s)", handle_register16(state, p, state->index), handle_addr16(state, opbuf1, sizeof(opbuf1)));
                                        break;
                                    case 4:
                                        if ( israbbit() ) {
                                            if ( y == 0 ) BUF_PRINTF("neg");
                                            else if ( y == 2 ) BUF_PRINTF("ex\t(sp),hl");
                                            else if ( y == 4 ) BUF_PRINTF("ldp\t(hl),hl");
                                            else if ( y == 5 ) BUF_PRINTF("ldp\thl,(hl)");
                                            else BUF_PRINTF("nop");
                                        } else {
                                            BUF_PRINTF("neg");
                                        }
                                        break;
                                    case 5:
                                        if ( israbbit() && y == 0 ) BUF_PRINTF("lret");
                                        if ( y == 1 ) BUF_PRINTF("reti");
                                        else if ( israbbit() && y == 3 ) BUF_PRINTF("ipres");
                                        else if ( israbbit() && y == 4 ) BUF_PRINTF("ldp\t(%s),hl",handle_addr16(state, opbuf1, sizeof(opbuf1)));
                                        else if ( israbbit() && y == 5 ) BUF_PRINTF("ldp\thl,(%s)",handle_addr16(state, opbuf1, sizeof(opbuf1)));
                                        else if ( israbbit() && y == 6 ) BUF_PRINTF("%s", c_cpu == CPU_R3K ? "syscall" : "nop");
                                        else if ( israbbit() && y == 7 ) BUF_PRINTF("%s", c_cpu == CPU_R3K ? "sures" : "nop");
                                        else if ( !israbbit() ) BUF_PRINTF("retn"); 
                                        break;
                                    case 6:
                                        BUF_PRINTF("%s",handle_im_instructions(state,y));
                                        break;
                                    case 7:
                                        BUF_PRINTF("%s", handle_ed_assorted_instructions(state,y));
                                        break;
                                }
                            } else if ( x == 2 ) {
                                // LDISR = 98 = 10 011 000
                                if ( z <= 3 && y >= 4 ) {
                                    BUF_PRINTF("%s", handle_block_instruction(state, z, y));
                                } else if ( israbbit3k() && z == 0 ) {
                                    if ( y == 2 ) BUF_PRINTF("ldisr");
                                    else if ( y == 3 ) BUF_PRINTF("lddsr");
                                } else {
                                    BUF_PRINTF("nop");
                                }
                                break;
                            } else if ( x == 3 ) {
                                if ( z == 0 && israbbit3k() ) {
                                    if ( y == 0 ) BUF_PRINTF("uma");
                                    else if ( y == 1 ) BUF_PRINTF("ums");
                                    else if ( y == 2 ) BUF_PRINTF("lsidr");
                                    else if ( y == 3 ) BUF_PRINTF("lsddr");
                                    else if ( y == 6 ) BUF_PRINTF("lsir");
                                    else if ( y == 7 ) BUF_PRINTF("lsdr");
                                    
                                    else BUF_PRINTF("nop");
                                } else BUF_PRINTF("nop");
                            }
                        } else if ( p == 3 ) { state->index = 2; continue; }
                    }
                } else if ( z == 6 ) {
                    BUF_PRINTF("%s\t%s", alu_table[y], handle_immed8(state, opbuf1, sizeof(opbuf1)));                    
                } else if ( z == 7 ) {
                    if ( israbbit() && y == 0 ) { handle_immed16(state, opbuf1, sizeof(opbuf1)); handle_immed8(state, opbuf2, sizeof(opbuf2)); BUF_PRINTF("ljp\t%s,%s",opbuf2, opbuf1); }
                    else if ( israbbit() && y == 1 ) { handle_immed16(state, opbuf1, sizeof(opbuf1)); handle_immed8(state, opbuf2, sizeof(opbuf2)); BUF_PRINTF("lcall\t%s,%s",opbuf2, opbuf1); }
                    else if ( israbbit() && y == 7 ) BUF_PRINTF("mul");
                    else BUF_PRINTF("rst\t$%02x", y * 8);
                }
                break;
        }
        break;
    } while (1);

    offs += snprintf(buf + offs, buflen - offs, "\t\t;[%04x] ", start_pc);
    for ( i = state->skip; i < state->len; i++ ) {
        offs += snprintf(buf + offs, buflen - offs,"%s%02x", i ? " " : "", state->instr_bytes[i]);
    }

    return state->len;
}




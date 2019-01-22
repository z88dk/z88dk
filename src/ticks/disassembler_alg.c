
#include <stdio.h>
#include "ticks.h"




static char *rp2_table[] = { "bc", "de", "hl", "af"};
static char *cc_table[] = { "nz", "z", "nc", "c", "po", "pe", "p", "m"};
static char *alu_table[] = { "add", "adc", "sub", "sbc", "and", "xor", "or", "cp"};
static char *assorted_mainpage_opcodes[] = { "rlca", "rrca", "rla", "rra", "daa", "cpl", "scf", "ccf" };


typedef struct {
    int       index;
    unsigned short     pc;
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
    char *rot_table[] = { "rlc", "rrc", "rl", "rr", "sla", "sra", NULL, "srl" };
    char *instr = rot_table[z];

    if ( z == 6 ) {
        if ( cansll() ) {
            instr = "sll";
        } else if ( isr800() ) {
            instr = "test";
        } else if ( isgbz80() ) {
            instr = "swap";
        }
    } 

    return instr;
}

static char *handle_rel8(dcontext *state, char *buf, size_t buflen)
{
    const char   *label;
    size_t  offs = 0;
    int8_t  displacement;

    READ_BYTE(state, displacement);

    if ( (label = find_symbol(state->pc + displacement, SYM_ADDRESS)) != NULL ) {
        BUF_PRINTF("%s",label);
    } else {
        BUF_PRINTF("$%04x", (unsigned short)(state->pc + displacement));
    }
    
    
    return buf;
}

static char *handle_addr16(dcontext *state, char *buf, size_t buflen)
{
    size_t   offs = 0;
    const char    *label;
    uint8_t  lsb;
    uint8_t  msb;
    
    READ_BYTE(state, lsb);
    READ_BYTE(state, msb);

    if ( (label = find_symbol(lsb + msb * 256, SYM_ADDRESS)) != NULL ) {
        BUF_PRINTF("%s",label);
    } else {
        BUF_PRINTF("$%02x%02x", msb, lsb);
    }
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

static char *handle_immed16_be(dcontext *state, char *buf, size_t buflen)
{
    size_t offs = 0;
    uint8_t lsb;
    uint8_t msb;
    
    READ_BYTE(state, msb);
    READ_BYTE(state, lsb);
    
    BUF_PRINTF("$%02x%02x", msb, lsb);
    
    return buf;
}


static char *handle_hl(int index)
{
    char *table[] = { "hl", "ix", "iy"};
    return table[index];
}


static char *handle_register8(dcontext *state, uint8_t y, char *buf, size_t buflen)
{
    static char *table[3][8] = { 
        { "b", "c", "d", "e", "h", "l", "(hl)", "a" },
        { "b", "c", "d", "e", "ixh", "ixl", "(ix", "a" },
        { "b", "c", "d", "e", "iyh", "ixl", "(iy", "a" }
    };
    size_t offs = 0;
    int index = state->index;

    /* Turn of ixl/h handling for Rabbit and Z180 */
    if ( !canixh() && y != 6 ) {
        index = 0;
    }
    if ( y == 6 && index ) {
        int8_t displacement = state->displacement;

        if ( state->prefix != 0xcb )
            READ_BYTE(state, displacement);
            BUF_PRINTF("%s%s$%02x)", table[index][y],
                                    displacement < 0 ? "-" : "+", displacement < 0 ? -displacement : displacement);
        return buf;
    } 
    BUF_PRINTF("%s", table[index][y]);
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
    static char *table[4][5] = { 
        { "ldi", "cpi", "ini", "outi", "outi2"},
        { "ldd", "cpd", "ind", "outd", "outd2", },
        { "ldir", "cpir", "inir", "otir", "otir2"},
        { "lddr", "cpdr", "indr", "otdr", "otdr2"}
    };

    if ( israbbit() && z != 0 ) return "nop";

    return table[y-4][z];

}

static char *handle_ed_assorted_instructions(dcontext *state, uint8_t y)
{
    static char *table[] =      { "ld      i,a",   "ld      r,a",   "ld      a,i",   "ld      a,r",   "rrd",           "rld",    "ld      i,i",           "ld      r,r"};
    static char *z180_table[] = { "ld      i,a",   "ld      r,a",   "ld      a,i",   "ld      a,r",   "rrd",           "rld",    "nop",           "nop"};
    static char *r2k_table[] =  { "ld      eir,a", "ld      iir,a", "ld      a,eir", "ld      a,iir", "ld      xpc,a", "nop",    "ld      a,xpc", "nop"};
    static char *r3k_table[] =  { "ld      eir,a", "ld      iir,a", "ld      a,eir", "ld      a,iir", "ld      xpc,a", "setusr", "ld      a,xpc", "rdmode"};
    
    return c_cpu & CPU_R2K ? r2k_table[y] : c_cpu & CPU_R3K ? r3k_table[y] : c_cpu & (CPU_Z180|CPU_EZ80) ? z180_table[y] : table[y];
}

static char *handle_im_instructions(dcontext *state, uint8_t y)
{
    char *table[] =      { "im      0", "im      0/1", "im      1", "im      2", "im      0",  "im      0/1", "im      1",  "im      2"};
    char *z180_table[] = { "im      0", "nop     ",    "im      1", "im      2", "nop     ",   "nop     ",    "slp     ",   "nop     "};
    char *r2k_table[] =  { "ipset   0", "ipset   2",   "ipset   1", "ipset   3", "nop     ",   "nop     ",    "push    ip", "pop     ip"};
    char *r3k_table[] =  { "ipset   0", "ipset   2",   "ipset   1", "ipset   3", "push    su", "pop     su",  "push    ip", "pop     ip"};
    char *ez80table[] =  { "im      0", "nop     ",    "im      1", "im      2", "im      0",  "ld      a,mb","slp     ",   "rsmix   "};
    
    return c_cpu & CPU_R2K ? r2k_table[y] : c_cpu & CPU_R3K ? r3k_table[y] : c_cpu & CPU_Z180 ? z180_table[y] : isez80() ? ez80table[y] : table[y];
}   


int disassemble2(int pc, char *bufstart, size_t buflen)
{
    dcontext    s_state = {0};
    dcontext   *state = &s_state;
    int         i;
    uint8_t     b;
    char        *buf;
    const char  *label;
    size_t       offs = 0;
    int          start_pc = pc;
    char         dolf = 0; 
    char         opbuf1[256];
    char         opbuf2[256];

    state->pc = pc;
    
    label = find_symbol(pc, SYM_ADDRESS);
    if (label ) {
        offs += snprintf(bufstart + offs, buflen - offs, "%s:\n",label);
    }
    buf = bufstart + offs;
    buflen -= offs;

    offs = snprintf(buf, buflen, "%-20s", "");

    
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
                        else if ( y == 1 ) {
                            if ( canaltreg() ) BUF_PRINTF("%-8saf,af\'","ex");
                            else if (isgbz80() ) BUF_PRINTF("%-8s(%s),sp","ld",handle_addr16(state, opbuf1,sizeof(opbuf1)));
                            else BUF_PRINTF("nop");
                        } else if ( y == 2 ) {
                            if ( isgbz80() )  BUF_PRINTF("%-8s","stop");
                            else if ( is8080() ) BUF_PRINTF("nop");                            
                            else BUF_PRINTF("%-8s%s","djnz", handle_rel8(state, opbuf1, sizeof(opbuf1)));                  
                        } else if ( y == 3 ) {
                            if ( !is8080() ) BUF_PRINTF("%-8s%s", "jr",handle_rel8(state, opbuf1, sizeof(opbuf1)));
                            else BUF_PRINTF("nop");
                        } else if ( !is8080() ) BUF_PRINTF("%-8s%s,%s", "jr", cc_table[y-4], handle_rel8(state, opbuf1,  sizeof(opbuf1)));  
                        else BUF_PRINTF("nop");
                        break;
                    case 1:
                        if ( q == 0 ) BUF_PRINTF("%-8s%s,%s","ld", handle_register16(state, p,state->index), handle_immed16(state, opbuf1, sizeof(opbuf1)));
                        else BUF_PRINTF("%-8s%s,%s", "add", handle_hl(state->index), handle_register16(state, p, state->index));
                        break;
                    case 2:
                        if ( q == 0 ) {
                            if ( p == 0 ) BUF_PRINTF("%-8s(bc),a","ld");
                            else if ( p == 1 ) BUF_PRINTF("%-8s(de),a","ld");
                            else if ( p == 2 && !isgbz80()) BUF_PRINTF("%-8s(%s),%s","ld", handle_addr16(state, opbuf1, sizeof(opbuf1)), handle_hl(state->index));
                            else if ( p == 2 && isgbz80() ) BUF_PRINTF("%-8s(hl+),a","ld");
                            else if ( p == 3 && !isgbz80() ) BUF_PRINTF("%-8s(%s),a","ld", handle_addr16(state, opbuf1, sizeof(opbuf1)));
                            else if ( p == 3 && isgbz80() ) BUF_PRINTF("%-8s(hl-),a","ld");                            
                        } else if ( q == 1 ) {
                            if ( p == 0 ) BUF_PRINTF("%-8sa,(bc)","ld");
                            else if ( p == 1 ) BUF_PRINTF("%-8sa,(de)","ld");
                            else if ( p == 2 && !isgbz80() ) BUF_PRINTF("%-8s%s,(%s)", "ld", handle_hl(state->index), handle_addr16(state, opbuf1, sizeof(opbuf1)));
                            else if ( p == 2 && isgbz80() ) BUF_PRINTF("%-8sa,(hl+)", "ld");
                            else if ( p == 3 && !isgbz80() ) BUF_PRINTF("%-8sa,(%s)", "ld", handle_addr16(state, opbuf1, sizeof(opbuf1)));
                            else if ( p == 3 && isgbz80() ) BUF_PRINTF("%-8sa,(hl-)", "ld");                            
                        } 
                        break;
                    case 3:
                        if ( q == 0 ) BUF_PRINTF("%-8s%s", "inc", handle_register16(state, p, state->index));
                        else BUF_PRINTF("%-8s%s", "dec", handle_register16(state, p, state->index));
                        break;
                    case 4:
                        BUF_PRINTF("%-8s%s", "inc", handle_register8(state, y, opbuf1, sizeof(opbuf1)));
                        break;
                    case 5:
                        BUF_PRINTF("%-8s%s", "dec", handle_register8(state, y,opbuf1,sizeof(opbuf1)));
                        break;
                    case 6:
                        BUF_PRINTF("%-8s%s,%s", "ld", handle_register8(state, y,opbuf1,sizeof(opbuf1)), handle_immed8(state, opbuf2, sizeof(opbuf2)));
                        break;
                    case 7:
                        if ( israbbit() && y == 4 ) BUF_PRINTF("%-8ssp,%s", "add",handle_displacement(state, opbuf1, sizeof(opbuf1)));
                        else if ( isez80() && state->index != 0  ) {
                            if ( q == 0 && y < 6 ) BUF_PRINTF("%-8s%s,%s", "ld", handle_register16(state,p,0), handle_register8(state, 6, opbuf1, sizeof(opbuf1)));
                            else if ( q == 1 && y < 6 ) BUF_PRINTF("%-8s%s,%s", "ld",handle_register8(state, 6, opbuf1, sizeof(opbuf1)), handle_register16(state,p,0));
                            else if ( y == 6 ) BUF_PRINTF("%-8s%s,%s", "ld",handle_hl(state->index == 1 ? 2 : 1), handle_register8(state, 6, opbuf1, sizeof(opbuf1)));
                            else if ( y == 7 ) BUF_PRINTF("%-8s%s,%s", "ld", handle_register8(state, 6, opbuf1, sizeof(opbuf1)), handle_hl(state->index == 1 ? 2 : 1));
                        } else BUF_PRINTF("%-8s", assorted_mainpage_opcodes[y]);
                        break;
                }
                break;
            case 1: /* x = 1 */
                if ( z == 6 && y == 6 ) {
                    if ( israbbit() ) BUF_PRINTF("%-8s","altd");
                    else BUF_PRINTF("%-8s","halt");
                } else if ( israbbit() && z == 4 && y == 7 && state->index ) {
                    BUF_PRINTF("%-8shl,%s", "ld", handle_register16(state,2, state->index));
                } else if ( israbbit() && z == 5 && y == 7 && state->index ) {
                    BUF_PRINTF("%-8s%s,hl", "ld", handle_register16(state,2, state->index)); 
                } else if ( israbbit() && z == 4 && y == 4 && state->index ) {
                    BUF_PRINTF("%-8s(%s),hl", "ldp", handle_register16(state,2, state->index)); 
                } else if ( israbbit() && z == 5 && y == 4 && state->index ) {
                    BUF_PRINTF("%-8s(%s),hl", "ldp", handle_addr16(state,opbuf1, sizeof(opbuf1)));
                } else if ( israbbit() && z == 4 && y == 5 && state->index ) {
                    BUF_PRINTF("%-8shl,(%s)", "ldp", handle_register16(state,2, state->index)); 
                } else if ( israbbit() && z == 5 && y == 5 && state->index ) {
                    BUF_PRINTF("%-8s%s,(%s)", "ldp", handle_register16(state,2, state->index),  handle_addr16(state,opbuf1, sizeof(opbuf1)));
                } else if ( israbbit3k() && z == 3 && y == 3 && state->index == 0) {
                    BUF_PRINTF("%-8s","idet");
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
                    BUF_PRINTF("%-8s%s,%s", "ld", opbuf1, opbuf2);
                }
                break;
            case 2: /* x = 2 */
                BUF_PRINTF("%-8s%s", alu_table[y], handle_register8(state, z, opbuf1, sizeof(opbuf1)));
                break;
            case 3: /* x = 3 */
                if ( z == 0 ) {
                    if ( !isgbz80() || y < 4 ) BUF_PRINTF("%-8s%s","ret", cc_table[y]);
                    else {
                        // gbz80 codes
                        if ( y == 4 ) BUF_PRINTF("%-8s($ff00+%s),a","ld", handle_immed8(state, opbuf1, sizeof(opbuf2)));
                        else if ( y == 5 ) BUF_PRINTF("%-8ssp,%s","add", handle_immed8(state, opbuf1, sizeof(opbuf2)));
                        else if ( y == 6 ) BUF_PRINTF("%-8sa,($ff00+%s)","ld", handle_immed8(state, opbuf1, sizeof(opbuf2)));
                        else if ( y == 7 ) BUF_PRINTF("%-8shl,sp+%s","ld", handle_immed8(state, opbuf1, sizeof(opbuf2)));
                    }
                } else if ( z == 1 ) {
                    if  ( q == 0 ) BUF_PRINTF("%-8s%s","pop", handle_register16_2(state,p, state->index));
                    else if ( q == 1 ) {
                        if ( p == 0 ) { BUF_PRINTF("ret"); dolf=1; }
                        else if ( p == 1 && !isgbz80() ) BUF_PRINTF("exx");
                        else if ( p == 1 && isgbz80() ) BUF_PRINTF("reti");
                        else if ( p == 2 ) BUF_PRINTF("%-8s(%s)","jp",handle_register16(state, 2, state->index)); 
                        else if ( p == 3 ) BUF_PRINTF("%-8ssp,%s", "ld", handle_register16(state, 2, state->index)); 
                    }
                } else if ( z == 2 ) { 
                    if ( !isgbz80() || y < 4 ) BUF_PRINTF("%-8s%s,%s", "jp",cc_table[y], handle_addr16(state, opbuf1, sizeof(opbuf1)));
                    else {
                        if ( y == 4 ) BUF_PRINTF("%-8s($ff00+c),a","ld");
                        else if ( y == 5 ) BUF_PRINTF("%-8s(%s),a","ld",handle_addr16(state,opbuf1,sizeof(opbuf1)));
                        else if ( y == 6 )  BUF_PRINTF("%-8sa,($ff00+c)","ld");
                        else if ( y == 7 ) BUF_PRINTF("%-8sa,(%s)","ld",handle_addr16(state,opbuf1,sizeof(opbuf1)));                        
                    }
                } else if  ( z == 3 ) {
                    if ( y == 0 ) BUF_PRINTF("%-8s%s", "jp", handle_addr16(state, opbuf1, sizeof(opbuf1)));
                    else if ( y == 1 ) {
                        state->prefix = 0xcb;
                        if ( state->index ) {
                            READ_BYTE(state, state->displacement);
                        }
                        READ_BYTE(state, b);
                        uint8_t x = b >> 6;
                        uint8_t y = ( b & 0x38) >> 3;
                        uint8_t z = b & 0x07;

                        if ( x == 0 ) {
                            char *instr = handle_rot(state, y);
                            if ( state->index && z != 6 && instr ) {
                                handle_register8(state, z, opbuf1, sizeof(opbuf1));
                                handle_register8(state, 6, opbuf2, sizeof(opbuf2));
                                if ( cancbundoc() ) BUF_PRINTF("%-8s%s,%s %s","ld", opbuf1, instr, opbuf2);
                                else BUF_PRINTF("nop");
                            } else if ( instr ) BUF_PRINTF("%-8s%s", instr, handle_register8(state, z, opbuf1, sizeof(opbuf1)));
                            else BUF_PRINTF("nop");
                        } else if ( x == 1 ) {
                            if ( cancbundoc() && state->index ) {
                                z = 6;
                            }
                            if ( !cancbundoc() && state->index && z != 6 ) BUF_PRINTF("nop");
                            else BUF_PRINTF("%-8s%d,%s", "bit", y, handle_register8(state, z, opbuf1, sizeof(opbuf1)));                 // TODO: Undocumented
                        } else if ( x == 2 ) {
                            if ( state->index && z != 6 ) {
                                handle_register8(state, z, opbuf1, sizeof(opbuf1));
                                handle_register8(state, 6, opbuf2, sizeof(opbuf2));
                                if ( cancbundoc() ) BUF_PRINTF("%-8s%s,%s %d,%s","ld", opbuf1, "res",y, opbuf2);
                                else BUF_PRINTF("nop");
                            } else BUF_PRINTF("%-8s%d,%s", "res", y, handle_register8(state, z, opbuf1, sizeof(opbuf1)));                 // TODO: Undocumented
                        } else if ( x == 3 ) {
                            if ( cancbundoc() && state->index && z != 6 ) {
                                handle_register8(state, z, opbuf1, sizeof(opbuf1));
                                handle_register8(state, 6, opbuf2, sizeof(opbuf2));
                                if ( cancbundoc() ) BUF_PRINTF("%-8s%s,%s %d,%s","ld", opbuf1, "set",y, opbuf2);
                                else BUF_PRINTF("nop");
                            } else BUF_PRINTF("%-8s%d,%s", "set", y, handle_register8(state, z, opbuf1, sizeof(opbuf1)));                 // TODO: Undocumented
                        }
                        state->prefix = 0;
                    } else if ( y == 2 ) {
                        if ( israbbit() ) BUF_PRINTF("%-8s", "ioi");  
                        else if ( !isgbz80() ) BUF_PRINTF("%-8s(%s),a","out", handle_immed8(state, opbuf1, sizeof(opbuf1)));
                        else BUF_PRINTF("nop");
                    } else if ( y == 3 ) {
                        if ( israbbit() ) BUF_PRINTF("%-8s", "ioe");
                        else if ( !isgbz80() ) BUF_PRINTF("%-8sa,(%s)","in", handle_immed8(state, opbuf1, sizeof(opbuf1)));
                        else BUF_PRINTF("nop");
                    } else if ( y == 4 ) {
                        if ( israbbit() && state->index == 0 ) BUF_PRINTF("%-8sde',hl","ex");
                        else if ( !isgbz80() ) BUF_PRINTF("%-8s(sp),%s",  "ex", handle_register16(state, 2, state->index)); 
                        else BUF_PRINTF("nop");
                    } else if ( y == 5 ) {
                        if ( !isgbz80() ) BUF_PRINTF("%-8s%s,%s","ex","de","hl");
                        else BUF_PRINTF("nop");
                    } else if ( y == 6 ) { if (israbbit()) BUF_PRINTF("%-8s%s","rl","de"); else BUF_PRINTF("%-8s", "di"); }
                    else if ( y == 7 ) { if (israbbit()) BUF_PRINTF("%-8s%s","rr","de"); else BUF_PRINTF("%-8s", "ei"); }
                } else if ( z == 4 ) { 
                    if ( israbbit() ) {
                        if ( y == 0 ) BUF_PRINTF("%-8s%s,(sp+%s)","ld",handle_register16(state, 2, state->index), handle_immed8(state, opbuf1, sizeof(opbuf1)));
                        else if ( y == 1 ) BUF_PRINTF("%-8s%s","bool",handle_register16(state, 2, state->index));
                        else if ( y == 2 ) BUF_PRINTF("%-8s(sp+%s),%s","ld",handle_immed8(state, opbuf1, sizeof(opbuf1)),handle_register16(state, 2, state->index));
                        else if ( y == 3 ) BUF_PRINTF("%-8s%s,de", "and",handle_register16(state,2, state->index));
                        else if ( y == 4 ) BUF_PRINTF("%-8shl,(%s%s)","ld", handle_register16(state,2, state->index == 0 ? 1 : state->index == 1 ? 0 : 2), handle_displacement(state, opbuf1, sizeof(opbuf1)));
                        else if ( y == 5 ) BUF_PRINTF("%-8s%s,de", "or",handle_register16(state,2, state->index));
                        else if ( y == 6 ) BUF_PRINTF("%-8s(%s%s),hl","ld",handle_register16(state,2, state->index == 0 ? 1 : state->index == 1 ? 0 : 2), handle_displacement(state, opbuf1, sizeof(opbuf1)));
                        else if ( y == 7 ) BUF_PRINTF("%-8s%s", "rr",handle_register16(state,2, state->index));
                    } else if ( isgbz80() && y >= 4 ) BUF_PRINTF("nop");
                    else BUF_PRINTF("%-8s%s,%s", "call",cc_table[y], handle_addr16(state, opbuf1, sizeof(opbuf1)));
                } else if ( z == 5 ) {
                    if ( q == 0 ) BUF_PRINTF("%-8s%s","push",handle_register16_2(state,p, state->index));
                    else if ( q == 1 ) {
                        if ( p == 0 ) BUF_PRINTF("%-8s%s", "call", handle_addr16(state, opbuf1, sizeof(opbuf1)));
                        else if ( p == 1 && canindex() ) { state->index = 1; continue; }
                        else if ( p == 2 && canindex() ) { // ED page
                            READ_BYTE(state, b);
                            uint8_t x = b >> 6;
                            uint8_t y = ( b & 0x38) >> 3;
                            uint8_t z = b & 0x07;
                            uint8_t p = (y & 0x06) >> 1;
                            uint8_t q = y & 0x01;
                            state->index = 0;
                            if ( x == 0 ) {
                                if ( isz180() || isez80() ) {
                                    if ( z == 4 ) BUF_PRINTF("%-8s%s","tst",handle_register8(state,y, opbuf1, sizeof(opbuf1)));
                                    else if ( z == 0 ) BUF_PRINTF("%-8s%s,(%s)","in0",y == 6 ? "f" : handle_register8(state,y, opbuf1, sizeof(opbuf1)), handle_immed8(state, opbuf2, sizeof(opbuf2)));
                                    else if ( z == 1 ) BUF_PRINTF("%-8s(%s),%s","out0",handle_immed8(state, opbuf2, sizeof(opbuf2)),handle_register8(state,y, opbuf1, sizeof(opbuf1)));
                                    else if ( (z == 2 || z == 3) && isez80() ) BUF_PRINTF("%-8s%s,%s%s", "lea", y == 6 ? handle_hl(z-1) : handle_register16(state, p, 0), handle_hl(z-1), handle_displacement(state, opbuf1, sizeof(opbuf1)));
                                    else if ( z == 7 && isez80() ) {
                                        if ( q == 1 ) BUF_PRINTF("%-8s(hl),%s", "ld", p == 3 ? handle_hl(1) : handle_register16(state, p, 0));
                                        else BUF_PRINTF("%-8s%s,(hl)", "ld", p == 3 ? handle_hl(1) : handle_register16(state, p, 0));
                                    } else if ( z == 6 && isez80()) {
                                        if ( q == 1 ) BUF_PRINTF("%-8s(hl),iy","ld");
                                        else BUF_PRINTF("%-8siy,(hl)","ld");
                                    }
                                    else BUF_PRINTF("nop");
                                } else if ( c_cpu & CPU_Z80_ZXN ) {
                                    if ( b == 0x23 ) BUF_PRINTF("swapnib");
                                    else if ( b == 0x24 ) BUF_PRINTF("mirror  a");
                                    else if ( b == 0x27 ) BUF_PRINTF("test    %s",handle_immed8(state, opbuf1, sizeof(opbuf1)));                                    
                                    else if ( b == 0x28 ) BUF_PRINTF("bsla    de,b");
                                    else if ( b == 0x29 ) BUF_PRINTF("bsra    de,b");
                                    else if ( b == 0x2a ) BUF_PRINTF("bsrl    de,b");
                                    else if ( b == 0x2b ) BUF_PRINTF("bsrf    de,b");
                                    else if ( b == 0x2c ) BUF_PRINTF("brlc    de,b");
                                    else if ( b == 0x30 ) BUF_PRINTF("mul     d,e");
                                    else if ( b == 0x31 ) BUF_PRINTF("add     hl,a");
                                    else if ( b == 0x32 ) BUF_PRINTF("add     de,a");
                                    else if ( b == 0x33 ) BUF_PRINTF("add     bc,a");
                                    else if ( b == 0x34 ) BUF_PRINTF("add     hl,%s",handle_immed16(state, opbuf1, sizeof(opbuf1)));
                                    else if ( b == 0x35 ) BUF_PRINTF("add     de,%s",handle_immed16(state, opbuf1, sizeof(opbuf1)));
                                    else if ( b == 0x36 ) BUF_PRINTF("add     bc,%s",handle_immed16(state, opbuf1, sizeof(opbuf1)));
                                    else BUF_PRINTF("nop");                              
                                } else BUF_PRINTF("nop");
                            } else if ( x == 1 ) {
                                // 01 101 100                                
                                switch ( z ) {
                                    case 0:
                                        if ( y != 6 ) BUF_PRINTF("%-8s%s,(%s)", "in",handle_register8(state, y, opbuf1, sizeof(opbuf1)), isez80() ? "bc" : "c");
                                        else BUF_PRINTF("%-8s(c)","in");
                                        break;
                                    case 1:
                                        if ( israbbit() ) {
                                            if ( q == 0 ) BUF_PRINTF("%-8s%s',de","ld",handle_register16(state, p, state->index));
                                            else BUF_PRINTF("%-8s%s',bc","ld",handle_register16(state, p, state->index));
                                        } else {
                                            if ( y != 6 ) BUF_PRINTF("%-8s(%s),%s", "out", !isez80() ? "c" : "bc", handle_register8(state, y, opbuf1, sizeof(opbuf1)));
                                            else BUF_PRINTF("%-8s(c),0","out");
                                        }
                                        break;                     
                                    case 2:
                                        if ( q == 0 ) BUF_PRINTF("%-8shl,%s", "sbc", handle_register16(state, p, state->index));
                                        else BUF_PRINTF("%-8shl,%s", "adc", handle_register16(state, p, state->index));
                                        break;
                                    case 3:
                                        if ( q == 0 ) BUF_PRINTF("%-8s(%s),%s", "ld", handle_addr16(state, opbuf1, sizeof(opbuf1)), handle_register16(state, p, state->index));
                                        else BUF_PRINTF("%-8s%s,(%s)", "ld", handle_register16(state, p, state->index), handle_addr16(state, opbuf1, sizeof(opbuf1)));
                                        break;
                                    case 4:
                                        if ( israbbit() ) {
                                            if ( y == 0 ) BUF_PRINTF("%-8s","neg");
                                            else if ( y == 2 ) BUF_PRINTF("%-8s(sp),hl","ex");
                                            else if ( y == 4 ) BUF_PRINTF("%-8s(hl),hl","ldp");
                                            else if ( y == 5 ) BUF_PRINTF("%-8shl,(hl)","ldp");
                                            else BUF_PRINTF("nop");
                                        } else if ( isz180() || isez80() ) {
                                            if ( y == 0 )  BUF_PRINTF("%-8s","neg");
                                            else if ( y == 6 ) BUF_PRINTF("%-8s%s",isz180() ? "tstio" : "tsr", handle_immed8(state, opbuf1, sizeof(opbuf1)));
                                            else if ( y == 4 ) BUF_PRINTF("%-8s%s","tst", handle_immed8(state, opbuf1, sizeof(opbuf1)));
                                            else if ( y == 2 && isez80()) BUF_PRINTF("%-8six,iy%s","lea",handle_displacement(state, opbuf1, sizeof(opbuf1)));
                                            else if ( (y % 2 )&& p >= 0 && p <= 3 ) BUF_PRINTF("%-8s%s","mlt", handle_register16(state,p,0));
                                            else BUF_PRINTF("nop");
                                        } else {
                                            BUF_PRINTF("neg");
                                        }
                                        break;
                                    case 5:
                                        if ( israbbit() && y == 0 ) BUF_PRINTF("lret");
                                        if ( y == 1 ) BUF_PRINTF("reti");
                                        else if ( israbbit() && y == 3 ) BUF_PRINTF("ipres");
                                        else if ( israbbit() && y == 4 ) BUF_PRINTF("%-8s(%s),hl","ldp", handle_addr16(state, opbuf1, sizeof(opbuf1)));
                                        else if ( israbbit() && y == 5 ) BUF_PRINTF("%-8shl,(%s)","ldp", handle_addr16(state, opbuf1, sizeof(opbuf1)));
                                        else if ( israbbit() && y == 6 ) BUF_PRINTF("%-8s", c_cpu == CPU_R3K ? "syscall" : "nop");
                                        else if ( israbbit() && y == 7 ) BUF_PRINTF("%-8s", c_cpu == CPU_R3K ? "sures" : "nop");
                                        else if ( (isz180() || isez80()) && y == 0 ) BUF_PRINTF("retn");
                                        else if ( isez80() && y == 2 ) BUF_PRINTF("%-8siy,ix%s","lea",handle_displacement(state, opbuf1, sizeof(opbuf1)));                                        
                                        else if ( isez80() && y == 4 ) BUF_PRINTF("%-8six%s","pea",handle_displacement(state, opbuf1, sizeof(opbuf1)));                                        
                                        else if ( isez80() && y == 5 ) BUF_PRINTF("%-8smb,a","ld");                                        
                                        else if ( isez80() && y == 7 ) BUF_PRINTF("stmix");                                        
                                        else if ( (isz180() || isez80()) && y != 0 ) BUF_PRINTF("nop");
                                        else if ( !israbbit() ) BUF_PRINTF("retn"); 
                                        break;
                                    case 6:
                                        if ( isez80() && y == 4 ) BUF_PRINTF("%-8siy%s","pea",handle_displacement(state, opbuf1, sizeof(opbuf1)));                                        
                                        else BUF_PRINTF("%s",handle_im_instructions(state,y));
                                        break;
                                    case 7:
                                        BUF_PRINTF("%s", handle_ed_assorted_instructions(state,y));
                                        break;
                                }
                            } else if ( x == 2 ) {
                                // LDISR = 98 = 10 011 000
                                if ( isez80() && y < 4 && z >=2 && z <= 4 ) {
                                    static char *instrs[4][3] = {
                                        { "inim", "otim", "ini2" },
                                        { "indm", "otdm", "ind2" },
                                        { "inimr", "otimr", "ini2r" },
                                        { "indmr", "otdmr", "ind2r" }
                                    };
                                    BUF_PRINTF("%-8s",instrs[y][z-2]);
                                } else if ( ((isez80() && z <= 4) || z <= 3) && y >= 4 ) {
                                    BUF_PRINTF("%s", handle_block_instruction(state, z, y));
                                } else if ( israbbit3k() && z == 0 ) {
                                    if ( y == 2 ) BUF_PRINTF("ldisr");
                                    else if ( y == 3 ) BUF_PRINTF("lddsr");
                                } else if ( isz180() && z == 3 && y < 4 ) {
                                    char *instr[] = { "otim", "otdm", "otimr", "otdmr"};
                                    BUF_PRINTF("%s", instr[y]);
                                } else if ( c_cpu & CPU_Z80_ZXN ) {
                                    if ( b == 0x8a ) BUF_PRINTF("push    %s", handle_immed16_be(state, opbuf1, sizeof(opbuf1)));
                                    else if ( b == 0x90 ) BUF_PRINTF("outinb  ");
                                    else if ( b == 0x91 ) BUF_PRINTF("nextreg %s,%s",handle_immed8(state, opbuf1, sizeof(opbuf1)), handle_immed8(state, opbuf2, sizeof(opbuf2)));
                                    else if ( b == 0x92 ) BUF_PRINTF("nextreg %s,a",handle_immed8(state, opbuf1, sizeof(opbuf1)));
                                    else if ( b == 0x93 ) BUF_PRINTF("pixeldn");
                                    else if ( b == 0x94 ) BUF_PRINTF("pixelad");
                                    else if ( b == 0x95 ) BUF_PRINTF("setae");
                                    else if ( b == 0x98 ) BUF_PRINTF("jp      (c)");
                                    else if ( b == 0x98 ) BUF_PRINTF("setae");
                                    else if ( b == 0xa4 ) BUF_PRINTF("ldix");
                                    else if ( b == 0xa5 ) BUF_PRINTF("ldws");
                                    else if ( b == 0xac ) BUF_PRINTF("lddx");
                                    else if ( b == 0xb4 ) BUF_PRINTF("ldirx");
                                    else if ( b == 0xb7 ) BUF_PRINTF("ldpirx");
                                    else if ( b == 0xbc ) BUF_PRINTF("lddrx");
                                    else BUF_PRINTF("nop");
                                } else {
                                    BUF_PRINTF("nop");
                                }
                                break;
                            } else if ( x == 3 ) {
                                if ( z == 0 && israbbit3k() ) {
                                    char *r3k_instrs[] = { "uma", "umsa", "lsidr", "lsddr", "nop", "nop", "lsir", "lsdr"};
                                    BUF_PRINTF("%s",r3k_instrs[y]);
                                } else if ( z == 1 && y != 6 && isr800() ) {
                                    BUF_PRINTF("%-8sa,%s","mulub", handle_register8(state, y, opbuf1, sizeof(opbuf1)));
                                } else if ( z == 3 && isr800() ) {
                                    BUF_PRINTF("%-8shl,%s","muluw", handle_register16(state, p, state->index));                                    
                                } else if ( b == 0xfe ) BUF_PRINTF("trap");
                                else BUF_PRINTF("nop");
                            }
                        } else if ( p == 3 && canindex()  ) { state->index = 2; continue; }
                        else BUF_PRINTF("nop");                            
                    }
                } else if ( z == 6 ) {
                    BUF_PRINTF("%-8s%s", alu_table[y], handle_immed8(state, opbuf1, sizeof(opbuf1)));                    
                } else if ( z == 7 ) {
                    if ( israbbit() && y == 0 ) { handle_immed16(state, opbuf1, sizeof(opbuf1)); handle_immed8(state, opbuf2, sizeof(opbuf2)); BUF_PRINTF("%-8s%s,%s","ljp", opbuf2, opbuf1); }
                    else if ( israbbit() && y == 1 ) { handle_immed16(state, opbuf1, sizeof(opbuf1)); handle_immed8(state, opbuf2, sizeof(opbuf2)); BUF_PRINTF("%-8s%s,%s","lcall", opbuf2, opbuf1); }
                    else if ( israbbit() && y == 6 ) BUF_PRINTF("mul");
                    else BUF_PRINTF("%-8s$%02x", "rst", y * 8);
                }
                break;
        }
        break;
    } while (1);

    while ( offs < 60 ) {
        buf[offs++] = ' ';
        buf[offs] = 0;
    }
    offs += snprintf(buf + offs, buflen - offs, ";[%04x] ", start_pc);
    for ( i = state->skip; i < state->len; i++ ) {
        offs += snprintf(buf + offs, buflen - offs,"%s%02x", i ? " " : "", state->instr_bytes[i]);
    }
    if ( dolf ) {
        offs += snprintf(buf + offs, buflen - offs,"\n");
    }

    return state->len;
}

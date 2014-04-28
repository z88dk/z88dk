/*
 *	Z80 - Assembler
 *	Copyright (C) 1987-2014 by Udo Munk
 *
 *	History:
 *	17-SEP-1987 Development under Digital Research CP/M 2.2
 *	28-JUN-1988 Switched to Unix System V.3
 *	21-OCT-2006 changed to ANSI C for modern POSIX OS's
 *	03-FEB-2007 more ANSI C conformance and reduced compiler warnings
 *	18-MAR-2007 use default output file extension dependend on format
 *	04-OCT-2008 fixed comment bug, ';' string argument now working
 */

/*
 *	opcode tables
 */

#include <stdio.h>
#include "z80a.h"

extern int op_1b(), op_2b(), op_pupo(), op_ex(), op_ld();
extern int op_call(), op_ret(), op_jp(), op_jr(), op_djnz(), op_rst();
extern int op_add(), op_adc(), op_sub(), op_sbc(), op_cp();
extern int op_inc(), op_dec(), op_or(), op_xor(), op_and();
extern int op_rl(), op_rr(), op_sla(), op_sra(), op_srl(), op_rlc(), op_rrc();
extern int op_out(), op_in(), op_im();
extern int op_set(), op_res(), op_bit();
extern int op_org(), op_dl(), op_equ();
extern int op_ds(), op_db(), op_dw(), op_dm();
extern int op_misc();
extern int op_cond();
extern int op_glob();

/*
 *	opcode table:
 *	includes entries for all opcodes and pseudo ops other than END
 *	must be sorted in ascending order!
 */
struct opc opctab[] = {
	{ "ADC",	op_adc,		0,	0	},
	{ "ADD",	op_add,		0,	0	},
	{ "AND",	op_and,		0,	0	},
	{ "BIT",	op_bit,		0,	0	},
	{ "CALL",	op_call,	0,	0	},
	{ "CCF",	op_1b,		0x3f,	0	},
	{ "CP",		op_cp,		0,	0	},
	{ "CPD",	op_2b,		0xed,	0xa9	},
	{ "CPDR",	op_2b,		0xed,	0xb9	},
	{ "CPI",	op_2b,		0xed,	0xa1	},
	{ "CPIR",	op_2b,		0xed,	0xb1	},
	{ "CPL",	op_1b,		0x2f,	0	},
	{ "DAA",	op_1b,		0x27,	0	},
	{ "DEC",	op_dec,		0,	0	},
	{ "DEFB",	op_db,		0,	0	},
	{ "DEFL",	op_dl,		0,	0	},
	{ "DEFM",	op_dm,		0,	0	},
	{ "DEFS",	op_ds,		0,	0	},
	{ "DEFW",	op_dw,		0,	0	},
	{ "DI",		op_1b,		0xf3,	0	},
	{ "DJNZ",	op_djnz,	0,	0	},
	{ "EI",		op_1b,		0xfb,	0	},
	{ "EJECT",	op_misc,	1,	0	},
	{ "ELSE",	op_cond,	98,	0	},
	{ "ENDIF",	op_cond,	99,	0	},
	{ "EQU",	op_equ,		0,	0	},
	{ "EX",		op_ex,		0,	0	},
	{ "EXTRN",	op_glob,	1,	0	},
	{ "EXX",	op_1b,		0xd9,	0	},
	{ "HALT",	op_1b,		0x76,	0	},
	{ "IFDEF",	op_cond,	1,	0	},
	{ "IFEQ",	op_cond,	3,	0	},
	{ "IFNDEF",	op_cond,	2,	0	},
	{ "IFNEQ",	op_cond,	4,	0	},
	{ "IM",		op_im,		0,	0	},
	{ "IN",		op_in,		0,	0	},
	{ "INC",	op_inc,		0,	0	},
	{ "INCLUDE",	op_misc,	6,	0	},
	{ "IND",	op_2b,		0xed,	0xaa	},
	{ "INDR",	op_2b,		0xed,	0xba	},
	{ "INI",	op_2b,		0xed,	0xa2	},
	{ "INIR",	op_2b,		0xed,	0xb2	},
	{ "JP",		op_jp,		0,	0	},
	{ "JR",		op_jr,		0,	0	},
	{ "LD",		op_ld,		0,	0	},
	{ "LDD",	op_2b,		0xed,	0xa8	},
	{ "LDDR",	op_2b,		0xed,	0xb8	},
	{ "LDI",	op_2b,		0xed,	0xa0	},
	{ "LDIR",	op_2b,		0xed,	0xb0	},
	{ "LIST",	op_misc,	2,	0	},
	{ "NEG",	op_2b,		0xed,	0x44	},
	{ "NOLIST",	op_misc,	3,	0	},
	{ "NOP",	op_1b,		0,	0	},
	{ "OR",		op_or,		0,	0	},
	{ "ORG",	op_org,		0,	0	},
	{ "OTDR",	op_2b,		0xed,	0xbb	},
	{ "OTIR",	op_2b,		0xed,	0xb3	},
	{ "OUT",	op_out,		0,	0	},
	{ "OUTD",	op_2b,		0xed,	0xab	},
	{ "OUTI",	op_2b,		0xed,	0xa3	},
	{ "PAGE",	op_misc,	4,	0	},
	{ "POP",	op_pupo,	1,	0	},
	{ "PRINT",	op_misc,	5,	0	},
	{ "PUBLIC",	op_glob,	2,	0	},
	{ "PUSH",	op_pupo,	2,	0	},
	{ "RES",	op_res,		0,	0	},
	{ "RET",	op_ret,		0,	0	},
	{ "RETI",	op_2b,		0xed,	0x4d	},
	{ "RETN",	op_2b,		0xed,	0x45	},
	{ "RL",		op_rl,		0,	0	},
	{ "RLA",	op_1b,		0x17,	0	},
	{ "RLC",	op_rlc,		0,	0	},
	{ "RLCA",	op_1b,		0x07,	0	},
	{ "RLD",	op_2b,		0xed,	0x6f	},
	{ "RR",		op_rr,		0,	0	},
	{ "RRA",	op_1b,		0x1f,	0	},
	{ "RRC",	op_rrc,		0,	0	},
	{ "RRCA",	op_1b,		0x0f,	0	},
	{ "RRD",	op_2b,		0xed,	0x67	},
	{ "RST",	op_rst,		0,	0	},
	{ "SBC",	op_sbc,		0,	0	},
	{ "SCF",	op_1b,		0x37,	0	},
	{ "SET",	op_set,		0,	0	},
	{ "SLA",	op_sla,		0,	0	},
	{ "SRA",	op_sra,		0,	0	},
	{ "SRL",	op_srl,		0,	0	},
	{ "SUB",	op_sub,		0,	0	},
	{ "TITLE",	op_misc,	7,	0	},
	{ "XOR",	op_xor,		0,	0	}
};

/*
 *	compute no. of table entries for search_op()
 */
int no_opcodes = sizeof(opctab) / sizeof(struct opc);

/*
 *	table with reserverd operand words: registers and flags
 *	must be sorted in ascending order!
 */
struct ope opetab[] = {
	{ "(BC)",	REGIBC },
	{ "(DE)",	REGIDE },
	{ "(HL)",	REGIHL },
	{ "(IX)",	REGIIX },
	{ "(IY)",	REGIIY },
	{ "(SP)",	REGISP },
	{ "A",		REGA   },
	{ "AF",		REGAF  },
	{ "B",		REGB   },
	{ "BC",		REGBC  },
	{ "C",		REGC   },
	{ "D",		REGD   },
	{ "DE",		REGDE  },
	{ "E",		REGE   },
	{ "H",		REGH   },
	{ "HL",		REGHL  },
	{ "I",		REGI   },
	{ "IX",		REGIX  },
	{ "IY",		REGIY  },
	{ "L",		REGL   },
	{ "M",		FLGM   },
	{ "NC",		FLGNC  },
	{ "NZ",		FLGNZ  },
	{ "P",		FLGP   },
	{ "PE",		FLGPE  },
	{ "PO",		FLGPO  },
	{ "R",		REGR   },
	{ "SP",		REGSP  },
	{ "Z",		FLGZ   }
};

/*
 *	compute no. of table entries
 */
int no_operands = sizeof(opetab) / sizeof(struct ope);

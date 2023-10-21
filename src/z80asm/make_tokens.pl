#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2023
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

use 5.020;
use warnings;
use autodie;

my @tokens = (
	'END',						# = 0; end of file reached
	'NIL',						# Returned for rubbish
	
	# Semantic tokens
	'NAME', 'LABEL', 'NUMBER', 'STRING', 'TERN_COND',	# cond ? true : false

	# Tokens
	'NEWLINE', 'LOG_NOT', 'CONST_EXPR', 'MOD', 'BIN_AND', 'LOG_AND',
	'LPAREN', 'RPAREN', 'MULTIPLY', 'PLUS', 'COMMA', 'MINUS', 'DOT',
	'DIVIDE', 'COLON', 'LESS', 'LEFT_SHIFT', 'LESS_EQ', 'NOT_EQ', 'EQUAL',
	'GREATER', 'RIGHT_SHIFT', 'GREATER_EQ', 'QUESTION', 'LSQUARE', 'RSQUARE',
	'BIN_XOR', 'POWER', 'LCURLY', 'BIN_OR', 'LOG_OR', 'RCURLY', 'BIN_NOT',
	
	# Assembly keywords
	'ASMPC', 
	
	# Flags
	'CALL_NZ', 'CALL_Z', 'CALL_NC', 'CALL_C', 'CALL_PO', 'CALL_PE', 'CALL_P', 'CALL_M', 
	'CALL_LZ', 'CALL_LO', 'CALL_NV', 'CALL_V', 'CALL_NK', 'CALL_K', 'CALL_NX5', 'CALL_X5',
	'CALL_NE', 'CALL_EQ', 
	'CALL_LTU', 'CALL_LEU', 'CALL_GTU', 'CALL_GEU', 
	'CALL_LT',  'CALL_LE',  'CALL_GT',  'CALL_GE', 

	'CALL_SIS_NZ', 'CALL_SIS_Z', 'CALL_SIS_NC', 'CALL_SIS_C', 'CALL_SIS_PO', 'CALL_SIS_PE', 'CALL_SIS_P', 'CALL_SIS_M', 
	'CALL_SIS_LZ', 'CALL_SIS_LO', 'CALL_SIS_NV', 'CALL_SIS_V', 'CALL_SIS_NK', 'CALL_SIS_K', 'CALL_SIS_NX5', 'CALL_SIS_X5',
	'CALL_SIS_NE', 'CALL_SIS_EQ', 
	'CALL_SIS_LTU', 'CALL_SIS_LEU', 'CALL_SIS_GTU', 'CALL_SIS_GEU', 
	'CALL_SIS_LT',  'CALL_SIS_LE',  'CALL_SIS_GT',  'CALL_SIS_GE', 

	'CALL_SIL_NZ', 'CALL_SIL_Z', 'CALL_SIL_NC', 'CALL_SIL_C', 'CALL_SIL_PO', 'CALL_SIL_PE', 'CALL_SIL_P', 'CALL_SIL_M', 
	'CALL_SIL_LZ', 'CALL_SIL_LO', 'CALL_SIL_NV', 'CALL_SIL_V', 'CALL_SIL_NK', 'CALL_SIL_K', 'CALL_SIL_NX5', 'CALL_SIL_X5',
	'CALL_SIL_NE', 'CALL_SIL_EQ', 
	'CALL_SIL_LTU', 'CALL_SIL_LEU', 'CALL_SIL_GTU', 'CALL_SIL_GEU', 
	'CALL_SIL_LT',  'CALL_SIL_LE',  'CALL_SIL_GT',  'CALL_SIL_GE', 

	'CALL_LIS_NZ', 'CALL_LIS_Z', 'CALL_LIS_NC', 'CALL_LIS_C', 'CALL_LIS_PO', 'CALL_LIS_PE', 'CALL_LIS_P', 'CALL_LIS_M', 
	'CALL_LIS_LZ', 'CALL_LIS_LO', 'CALL_LIS_NV', 'CALL_LIS_V', 'CALL_LIS_NK', 'CALL_LIS_K', 'CALL_LIS_NX5', 'CALL_LIS_X5',
	'CALL_LIS_NE', 'CALL_LIS_EQ', 
	'CALL_LIS_LTU', 'CALL_LIS_LEU', 'CALL_LIS_GTU', 'CALL_LIS_GEU', 
	'CALL_LIS_LT',  'CALL_LIS_LE',  'CALL_LIS_GT',  'CALL_LIS_GE', 

	'CALL_LIL_NZ', 'CALL_LIL_Z', 'CALL_LIL_NC', 'CALL_LIL_C', 'CALL_LIL_PO', 'CALL_LIL_PE', 'CALL_LIL_P', 'CALL_LIL_M', 
	'CALL_LIL_LZ', 'CALL_LIL_LO', 'CALL_LIL_NV', 'CALL_LIL_V', 'CALL_LIL_NK', 'CALL_LIL_K', 'CALL_LIL_NX5', 'CALL_LIL_X5',
	'CALL_LIL_NE', 'CALL_LIL_EQ', 
	'CALL_LIL_LTU', 'CALL_LIL_LEU', 'CALL_LIL_GTU', 'CALL_LIL_GEU', 
	'CALL_LIL_LT',  'CALL_LIL_LE',  'CALL_LIL_GT',  'CALL_LIL_GE', 

	'CALL_IS_NZ', 'CALL_IS_Z', 'CALL_IS_NC', 'CALL_IS_C', 'CALL_IS_PO', 'CALL_IS_PE', 'CALL_IS_P', 'CALL_IS_M', 
	'CALL_IS_LZ', 'CALL_IS_LO', 'CALL_IS_NV', 'CALL_IS_V', 'CALL_IS_NK', 'CALL_IS_K', 'CALL_IS_NX5', 'CALL_IS_X5',
	'CALL_IS_NE', 'CALL_IS_EQ', 
	'CALL_IS_LTU', 'CALL_IS_LEU', 'CALL_IS_GTU', 'CALL_IS_GEU', 
	'CALL_IS_LT',  'CALL_IS_LE',  'CALL_IS_GT',  'CALL_IS_GE', 

	'CALL_IL_NZ', 'CALL_IL_Z', 'CALL_IL_NC', 'CALL_IL_C', 'CALL_IL_PO', 'CALL_IL_PE', 'CALL_IL_P', 'CALL_IL_M', 
	'CALL_IL_LZ', 'CALL_IL_LO', 'CALL_IL_NV', 'CALL_IL_V', 'CALL_IL_NK', 'CALL_IL_K', 'CALL_IL_NX5', 'CALL_IL_X5',
	'CALL_IL_NE', 'CALL_IL_EQ', 
	'CALL_IL_LTU', 'CALL_IL_LEU', 'CALL_IL_GTU', 'CALL_IL_GEU', 
	'CALL_IL_LT',  'CALL_IL_LE',  'CALL_IL_GT',  'CALL_IL_GE', 

	'CALL3_NZ', 'CALL3_Z', 'CALL3_NC', 'CALL3_C', 'CALL3_PO', 'CALL3_PE', 'CALL3_P', 'CALL3_M', 
	'JR_NZ', 'JR_Z', 'JR_NC', 'JR_C', 'JR_PO', 'JR_PE', 'JR_P', 'JR_M', 
	'JR_LZ', 'JR_LO', 'JR_NV', 'JR_V', 'JR_NK', 'JR_K', 'JR_NX5', 'JR_X5',
	'JR_NE', 'JR_EQ', 
	'JR_LTU', 'JR_LEU', 'JR_GTU', 'JR_GEU', 
	'JR_LT',  'JR_LE',  'JR_GT',  'JR_GE', 

	'JRE_NZ', 'JRE_Z', 'JRE_NC', 'JRE_C', 'JRE_PO', 'JRE_PE', 'JRE_P', 'JRE_M', 
	'JRE_LZ', 'JRE_LO', 'JRE_NV', 'JRE_V', 'JRE_NK', 'JRE_K', 'JRE_NX5', 'JRE_X5',
	'JRE_NE', 'JRE_EQ', 
	'JRE_LTU', 'JRE_LEU', 'JRE_GTU', 'JRE_GEU', 
	'JRE_LT',  'JRE_LE',  'JRE_GT',  'JRE_GE', 

	'JP_NZ', 'JP_Z', 'JP_NC', 'JP_C', 'JP_PO', 'JP_PE', 'JP_P', 'JP_M', 
	'JP_LZ', 'JP_LO', 'JP_NV', 'JP_V', 'JP_NK', 'JP_K', 'JP_NX5', 'JP_X5',
	'JP_NE', 'JP_EQ', 
	'JP_LTU', 'JP_LEU', 'JP_GTU', 'JP_GEU', 
	'JP_LT',  'JP_LE',  'JP_GT',  'JP_GE', 

	'JP_SIS_NZ', 'JP_SIS_Z', 'JP_SIS_NC', 'JP_SIS_C', 'JP_SIS_PO', 'JP_SIS_PE', 'JP_SIS_P', 'JP_SIS_M', 
	'JP_SIS_LZ', 'JP_SIS_LO', 'JP_SIS_NV', 'JP_SIS_V', 'JP_SIS_NK', 'JP_SIS_K', 'JP_SIS_NX5', 'JP_SIS_X5',
	'JP_SIS_NE', 'JP_SIS_EQ', 
	'JP_SIS_LTU', 'JP_SIS_LEU', 'JP_SIS_GTU', 'JP_SIS_GEU', 
	'JP_SIS_LT',  'JP_SIS_LE',  'JP_SIS_GT',  'JP_SIS_GE', 

	'JP_LIL_NZ', 'JP_LIL_Z', 'JP_LIL_NC', 'JP_LIL_C', 'JP_LIL_PO', 'JP_LIL_PE', 'JP_LIL_P', 'JP_LIL_M', 
	'JP_LIL_LZ', 'JP_LIL_LO', 'JP_LIL_NV', 'JP_LIL_V', 'JP_LIL_NK', 'JP_LIL_K', 'JP_LIL_NX5', 'JP_LIL_X5',
	'JP_LIL_NE', 'JP_LIL_EQ', 
	'JP_LIL_LTU', 'JP_LIL_LEU', 'JP_LIL_GTU', 'JP_LIL_GEU', 
	'JP_LIL_LT',  'JP_LIL_LE',  'JP_LIL_GT',  'JP_LIL_GE', 

	'JP3_NZ', 'JP3_Z', 'JP3_NC', 'JP3_C', 'JP3_PO', 'JP3_PE', 'JP3_P', 'JP3_M', 
	'JP3_LZ', 'JP3_LO', 'JP3_NV', 'JP3_V', 'JP3_NK', 'JP3_K', 'JP3_NX5', 'JP3_X5',
	'JP3_NE', 'JP3_EQ', 
	'JP3_LTU', 'JP3_LEU', 'JP3_GTU', 'JP3_GEU', 
	'JP3_LT',  'JP3_LE',  'JP3_GT',  'JP3_GE', 

	'JMP_NZ', 'JMP_Z', 'JMP_NC', 'JMP_C', 'JMP_PO', 'JMP_PE', 'JMP_P', 'JMP_M', 
	'JMP_LZ', 'JMP_LO', 'JMP_NV', 'JMP_V', 'JMP_NK', 'JMP_K', 'JMP_NX5', 'JMP_X5',
	'JMP_NE', 'JMP_EQ', 
	'JMP_LTU', 'JMP_LEU', 'JMP_GTU', 'JMP_GEU', 
	'JMP_LT',  'JMP_LE',  'JMP_GT',  'JMP_GE', 

	'JMP_SIS_NZ', 'JMP_SIS_Z', 'JMP_SIS_NC', 'JMP_SIS_C', 'JMP_SIS_PO', 'JMP_SIS_PE', 'JMP_SIS_P', 'JMP_SIS_M', 
	'JMP_SIS_LZ', 'JMP_SIS_LO', 'JMP_SIS_NV', 'JMP_SIS_V', 'JMP_SIS_NK', 'JMP_SIS_K', 'JMP_SIS_NX5', 'JMP_SIS_X5',
	'JMP_SIS_NE', 'JMP_SIS_EQ', 
	'JMP_SIS_LTU', 'JMP_SIS_LEU', 'JMP_SIS_GTU', 'JMP_SIS_GEU', 
	'JMP_SIS_LT',  'JMP_SIS_LE',  'JMP_SIS_GT',  'JMP_SIS_GE', 

	'JMP_LIL_NZ', 'JMP_LIL_Z', 'JMP_LIL_NC', 'JMP_LIL_C', 'JMP_LIL_PO', 'JMP_LIL_PE', 'JMP_LIL_P', 'JMP_LIL_M', 
	'JMP_LIL_LZ', 'JMP_LIL_LO', 'JMP_LIL_NV', 'JMP_LIL_V', 'JMP_LIL_NK', 'JMP_LIL_K', 'JMP_LIL_NX5', 'JMP_LIL_X5',
	'JMP_LIL_NE', 'JMP_LIL_EQ', 
	'JMP_LIL_LTU', 'JMP_LIL_LEU', 'JMP_LIL_GTU', 'JMP_LIL_GEU', 
	'JMP_LIL_LT',  'JMP_LIL_LE',  'JMP_LIL_GT',  'JMP_LIL_GE', 

	'RET_NZ', 'RET_Z', 'RET_NC', 'RET_C', 'RET_PO', 'RET_PE', 'RET_P', 'RET_M', 
	'RET_LZ', 'RET_LO', 'RET_NV', 'RET_V', 'RET_NK', 'RET_K', 'RET_NX5', 'RET_X5',
	'RET_NE', 'RET_EQ', 
	'RET_LTU', 'RET_LEU', 'RET_GTU', 'RET_GEU', 
	'RET_LT',  'RET_LE',  'RET_GT',  'RET_GE', 

	'RET_L_NZ', 'RET_L_Z', 'RET_L_NC', 'RET_L_C', 'RET_L_PO', 'RET_L_PE', 'RET_L_P', 'RET_L_M', 
	'RET_L_LZ', 'RET_L_LO', 'RET_L_NV', 'RET_L_V', 'RET_L_NK', 'RET_L_K', 'RET_L_NX5', 'RET_L_X5',
	'RET_L_NE', 'RET_L_EQ', 
	'RET_L_LTU', 'RET_L_LEU', 'RET_L_GTU', 'RET_L_GEU', 
	'RET_L_LT',  'RET_L_LE',  'RET_L_GT',  'RET_L_GE', 

	'RET_LIS_NZ', 'RET_LIS_Z', 'RET_LIS_NC', 'RET_LIS_C', 'RET_LIS_PO', 'RET_LIS_PE', 'RET_LIS_P', 'RET_LIS_M', 
	'RET_LIS_LZ', 'RET_LIS_LO', 'RET_LIS_NV', 'RET_LIS_V', 'RET_LIS_NK', 'RET_LIS_K', 'RET_LIS_NX5', 'RET_LIS_X5',
	'RET_LIS_NE', 'RET_LIS_EQ', 
	'RET_LIS_LTU', 'RET_LIS_LEU', 'RET_LIS_GTU', 'RET_LIS_GEU', 
	'RET_LIS_LT',  'RET_LIS_LE',  'RET_LIS_GT',  'RET_LIS_GE', 

	'RET_LIL_NZ', 'RET_LIL_Z', 'RET_LIL_NC', 'RET_LIL_C', 'RET_LIL_PO', 'RET_LIL_PE', 'RET_LIL_P', 'RET_LIL_M', 
	'RET_LIL_LZ', 'RET_LIL_LO', 'RET_LIL_NV', 'RET_LIL_V', 'RET_LIL_NK', 'RET_LIL_K', 'RET_LIL_NX5', 'RET_LIL_X5',
	'RET_LIL_NE', 'RET_LIL_EQ', 
	'RET_LIL_LTU', 'RET_LIL_LEU', 'RET_LIL_GTU', 'RET_LIL_GEU', 
	'RET_LIL_LT',  'RET_LIL_LE',  'RET_LIL_GT',  'RET_LIL_GE', 

	'RST_V',

	'FLAG_NZ', 'FLAG_Z', 'FLAG_NC', 'FLAG_C', 'FLAG_PO', 'FLAG_PE', 'FLAG_P', 'FLAG_M',
	'FLAG_LZ', 'FLAG_LO', 'FLAG_NV', 'FLAG_V', 'FLAG_X5', 'FLAG_NX5', 'FLAG_K', 'FLAG_NK',
	'FLAG_NE', 'FLAG_EQ',
	'FLAG_LTU', 'FLAG_LEU', 'FLAG_GTU', 'FLAG_GEU',
	'FLAG_LT', 'FLAG_LE', 'FLAG_GT', 'FLAG_GE',

	# Indirect 8-bit register
	'IND_C', 'IND_HTR',
	'IND_A', 'IND_XP', 'IND_YP', 'IND_PP', 'IND_ZP',
	
	# Indirect 16-bit register
	'IND_BC', 'IND_DE', 'IND_HL', 'IND_SP', 'IND_IX', 'IND_IY', 'IND_HLI', 'IND_HLD',
	'IND_PW', 'IND_PX', 'IND_PY', 'IND_PZ', 
	
	# 8-bit registers
	'B', 'C', 'D', 'E', 'H', 'L', 'A', 'F', 'I', 'R', 'M',
	'IIR', 'EIR', 'XPC', 'IXH', 'IYH', 'IXL', 'IYL', 'HTR', 'LXPC',
	'XP', 'YP', 'PP', 'ZP', 
	
	# 16-bit registers
	'BC', 'DE', 'HL', 'JK', 'IX', 'IY', 'AF', 'SP', 'PSW',

	# 24-bit registers
	'XBC', 'XDE', 'XHL', 'XSP', 'XIX', 'XIY', 
	'YBC', 'YDE', 'YHL', 'YSP', 'YIX', 'YIY', 
	'ABC', 'ADE', 'AHL', 'ASP', 'AIX', 'AIY', 
	'PBC', 'PDE', 'PHL', 'PSP', 'PIX', 'PIY', 
	'ZBC', 'ZDE', 'ZHL', 'ZSP', 'ZIX', 'ZIY', 
	
	# Indirect 24-bit registers
	'IND_XBC', 'IND_XDE', 'IND_XHL', 'IND_XSP', 'IND_XIX', 'IND_XIY', 
	'IND_YBC', 'IND_YDE', 'IND_YHL', 'IND_YSP', 'IND_YIX', 'IND_YIY', 
	'IND_ABC', 'IND_ADE', 'IND_AHL', 'IND_ASP', 'IND_AIX', 'IND_AIY', 
	'IND_PBC', 'IND_PDE', 'IND_PHL', 'IND_PSP', 'IND_PIX', 'IND_PIY', 
	'IND_ZBC', 'IND_ZDE', 'IND_ZHL', 'IND_ZSP', 'IND_ZIX', 'IND_ZIY', 
	
	# 32-bit registers
	'BCDE', 'DEHL', 'JKHL', 'PW', 'PX', 'PY', 'PZ',
	
	# alternate registers
	'B1', 'C1', 'D1', 'E1', 'H1', 'L1', 'A1', 'F1', 'BC1', 'DE1', 'JK1', 'HL1', 'AF1',
	'BCDE1', 'JKHL1', 'PW1', 'PX1', 'PY1', 'PZ1',

	# EZ80 specific keywords
	'ADL', 'S', 'IS', 'IL', 'SIS', 'LIL', 'LIS', 'SIL', 'MB',
	'LEA', 'PEA', 'RSMIX', 'STMIX',
	'INI2', 'INI2R', 'IND2', 'IND2R', 'INIM', 'INIMR', 'INDM', 'INDMR', 'INIRX', 'INDRX',
	'OTD2R', 'OTDRX', 'OTI2R', 'OTIRX', 'OUTD2', 'OUTI2',

	# Assembly directives
	'ALIGN', 'ASSERT', 'ASSUME', 
	'BYTE', 'C_LINE', 'DB', 'DC', 'DDB', 'DEFB', 'DEFC', 
	'DEFDB', 'DEFGROUP', 'DEFINE', 'DEFM', 'DEFP', 'DEFQ', 'DEFS', 'DEFVARS', 
	'DEFW', 'DEPHASE', 'DM', 'DP', 'DQ', 'DS', 'DW', 'DWORD', 'EQU', 'EXTERN', 
	'GLOBAL', 'LIB', 'LINE', 'LSTOFF', 'LSTON', 'MODULE', 'ORG', 'PHASE', 'PTR', 
	'PUBLIC', 'SECTION', 'UNDEFINE', 'WORD', 'XDEF', 'XLIB', 'XREF',

	# DEFGROUP storage specifiers
	'DS_B', 'DS_W', 'DS_P', 'DS_Q',

	# Z80 opcode specifiers
	'ADC', 'ADD', 'AND', 'BIT', 'CALL', 'CCF', 'CCF1', 'CP', 'CPD', 'CPDR', 
	'CPI', 'CPIR', 'CPL', 'DAA', 'DEC', 'DI', 'DJNZ', 'EI', 'EX', 'EXX', 'HALT', 
	'IM', 'IN', 'INC', 'IND', 'INDR', 'INI', 'INIR', 'JP', 'JR', 'LD', 'LDH', 
	'LDHL', 'LDD', 'LDDR', 'LDI', 'LDIR', 'NEG', 'NOP', 'OR', 'OTDR', 'OTIR', 
	'OUT', 'OUTD', 'OUTI', 'POP', 'PUSH', 'RES', 'RET', 'RETI', 'RETN', 'RL', 
	'RLA', 'RLA1', 'RLC', 'RLCA', 'RLCA1', 'RLD', 'RR', 'RRA', 'RRA1', 'RRC', 
	'RRCA', 'RRCA1', 'RRD', 'RST', 'SBC', 'SCF', 'SCF1', 'SET', 'SLA', 'SLL', 
	'SLS', 'SLI', 'SRA', 'SRL', 'STOP', 'SUB', 'XOR',

	# Z80-ZXN specific opcodes
	'SWAPNIB', 'SWAP', 'OUTINB', 'LDIX', 'LDIRX', 'LDDX', 'LDDRX', 'LDIRSCALE',
	'LDPIRX', 'LDWS', 'FILL', 'FILLDE', 'MIRROR', 'NEXTREG', 'PIXELDN', 'PIXELAD',
	'SETAE', 'TEST', 'MMU', 'MMU0', 'MMU1', 'MMU2', 'MMU3', 'MMU4', 'MMU5', 
	'MMU6', 'MMU7', 'CU_WAIT', 'CU_MOVE', 'CU_STOP', 'CU_NOP', 'DMA_WR0', 
	'DMA_WR1', 'DMA_WR2', 'DMA_WR3', 'DMA_WR4', 'DMA_WR5', 'DMA_WR6', 'DMA_CMD',
	'BSLA', 'BSRA', 'BSRL', 'BSRF', 'BRLC', 'LDRX', 'LIRX', 'LPRX', 'MIRR', 
	'NREG', 'OTIB', 'PXAD', 'PXDN', 'STAE', 

	# Z180 specific opcodes
	'SLP', 'MLT', 'IN0', 'OUT0', 'OTIM', 'OTIMR', 'OTDM', 'OTDMR', 'TST', 'TSTIO',

	# EZ80 specific opcodes
	
	# Rabbit specific opcodes
	'ALTD', 'BOOL', 'IOE', 'IOI', 'IPRES', 'IPSET', 'IDET', 'LDDSR', 'LDISR', 
	'LDP', 'LSDR', 'LSIR', 'LSDDR', 'LSIDR', 'MUL', 'IP', 'SU', 'RDMODE', 
	'SETUSR', 'SURES', 'SYSCALL', 'UMA', 'UMS', 'CBM', 'CLR', 'CONVC', 'CONVD',
	'COPY', 'COPYR', 'DWJNZ', 'EXP', 'FLAG', 'FSYSCALL', 'IBOX', 'JRE', 'LDF',
	'LDL', 'MULU', 'RLB', 'RRB', 'SBOX', 'SETSYSP', 'SETUSRP', 'SYSRET', 'SRET',

	# Z88DK specific opcodes
	'CALL_OZ', 'CALL_PKG', 'FPP', 'INVOKE',

	# Intel 8080/8085 specific opcodes
	'MOV', 'MVI', 'LXI', 'LDA', 'STA', 'LHLD', 'SHLD', 'LDAX', 'STAX', 'XCHG', 
	'ADI', 'ACI', 'SUI', 'SBB', 'SBI', 'INR', 'DCR', 'INX', 'DCX', 'DAD', 'ANA',
	'ANI', 'ORA', 'ORI', 'XRA', 'XRI', 'CMP', 'RAL', 'RAR', 'CMA', 'CMC', 'STC',
	'JMP', 'JNC', 'JC', 'JNZ', 'JZ', 'JPO', 'JPE', 'JNV', 'JV', 'JLO', 'JLZ', 
	'JM', 'JX5', 'JNK', 'JNX5', 'J_NC', 'J_C', 'J_NZ', 'J_Z', 'J_PO', 'J_PE',
	'J_NV', 'J_V', 'J_LO', 'J_LZ', 'J_P', 'J_M', 'J_K', 'J_X5', 'J_NK', 'J_NX5',
	'CNC', 'CC', 'CNZ', 'CZ', 'CPO', 'CPE', 'CNV', 'CV', 'CLO', 'CLZ', 'CM', 
	'C_NC', 'C_C', 'C_NZ', 'C_Z', 'C_PO', 'C_PE', 'C_NV', 'C_V', 'C_LO', 'C_LZ',
	'C_P', 'C_M', 'RNC', 'RC', 'RNZ', 'RZ', 'RPO', 'RPE', 'RNV', 'RV', 'RLO', 
	'RLZ', 'RP', 'RM', 'R_NC', 'R_C', 'R_NZ', 'R_Z', 'R_PO', 'R_PE', 'R_NV', 'R_V',
	'R_LO', 'R_LZ', 'R_P', 'R_M', 'PCHL', 'XTHL', 'SPHL', 'HLT', 'RIM', 'SIM', 
	'DSUB', 'ARHL', 'RRHL', 'RDEL', 'RLDE', 'LDHI', 'LDSI', 'RSTV', 'OVRST8', 
	'SHLX', 'SHLDE', 'LHLX', 'LHLDE',
	'CEQ', 'C_EQ', 'CNE', 'C_NE',  
	'JEQ', 'J_EQ', 'JNE', 'J_NE',  
	'REQ', 'R_EQ', 'RNE', 'R_NE',  
	'C_LTU', 'CLTU', 'C_LEU', 'CLEU', 'C_GTU', 'CGTU', 'C_GEU', 'CGEU',
	'J_LTU', 'JLTU', 'J_LEU', 'JLEU', 'J_GTU', 'JGTU', 'J_GEU', 'JGEU',
	'R_LTU', 'RLTU', 'R_LEU', 'RLEU', 'R_GTU', 'RGTU', 'R_GEU', 'RGEU',
	'C_LT',  'CLT',  'C_LE',  'CLE',  'C_GT',  'CGT',  'C_GE',  'CGE', 
	'J_LT',  'JLT',  'J_LE',  'JLE',  'J_GT',  'JGT',  'J_GE',  'JGE', 
	'R_LT',  'RLT',  'R_LE',  'RLE',  'R_GT',  'RGT',  'R_GE',  'RGE', 
		
	# R800 specific opcodes
	'MULUB', 'MULUW',
	
	# KC160 specific opcodes
	'TRA', 'MULS', 'DIV', 'DIVS', 'JP3', 'CALL3', 'RET3', 'RETN3',
	'CPD_X', 'CPDR_X', 'CPI_X', 'CPIR_X', 
	'IND_X', 'INDR_X', 'INI_X', 'INIR_X', 
	'OTDR_X', 'OTIR_X', 'OUTD_X', 'OUTI_X',	
	'LDD_XY', 'LDDR_XY', 'LDI_XY', 'LDIR_XY',

);

# output tokens.h
print <<END;
/* generated by $0 - do not edit */
#pragma once
END

for my $i (0..$#tokens) {
	say sprintf("%-23s %d", "#define _TK_$tokens[$i]", $i);
}

print <<END;

#ifndef NO_TOKEN_ENUM
typedef enum tokid_t {
END

for my $i (0..$#tokens) {
	say sprintf("    %-19s = %d,", "TK_$tokens[$i]", $i);
}

print <<END;
} tokid_t;
#endif
END

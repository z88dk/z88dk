/*
 *   ROM Basic analyzer, by Stefano Bodrato, APR 2016
 *
 *   This tool looks for known 'fingerprints' in the code and tries to identify
 *   function entry points and to provide a cross-reference for further ROM analysis.
 *
 *   It works with either Sinclair or Microsoft ROMs, giving hints to set-up a brand new
 *   target port or to just extend it with an alternative shortcuts (i.e. in the FP package).
 *
 *   $Id: basck.c,v 1.3 2016-04-28 15:11:00 stefano Exp $
 */

unsigned char *img;
int	len, pos;
int jptab;
int l;

#include <stdio.h>
/* stdlib.h MUST be included to really open files as binary */
#include <stdlib.h>
#include <malloc.h>

#define SKIP -1
#define CATCH -2
#define ADDR -3
#define CATCH_CALL -4
#define SKIP_CALL -5

#define ZX80     1
#define ZX81     2
#define LAMBDA   3
#define SPECTRUM 4
#define TS2068   5


/* CPU detection */
int ldir_skel[]={11, 33, CATCH, CATCH, 17, SKIP, SKIP, 1, SKIP, SKIP, 0xED, 0xB0};
int ldir_skel2[]={11, 17, CATCH, CATCH, 33, SKIP, SKIP, 1, SKIP, SKIP, 0xED, 0xB0};


/* Sinclair BASIC detection */
int makeroom_skel[]={7, 0x2A, CATCH, CATCH, 0xEB,0xEd, 0xB8, 0xC9};
int sinclair_skel[]={8, CATCH, 'i', 'n', 'c', 'l', 'a', 'i', 'r'};
int amstrad_skel[]={7, CATCH, 'm', 's', 't', 'r', 'a' ,'d'};

/* Sinclair BASIC code inspection */
int stk_st_skel[]={11, CATCH_CALL, SKIP, SKIP, SKIP, SKIP, 0x28, SKIP, 0xED, 0xB0, 0xC1, 0xE1};
int intfp_skel[]={15, 0x21, SKIP, SKIP, 0x22, SKIP, SKIP, CATCH_CALL,  0xCD, SKIP, SKIP, 0x38, SKIP, 0x21, 0xf0, 0xd8};
int intfp_skel2[]={13, 0x21, SKIP, SKIP, 0x22, SKIP, SKIP, CATCH_CALL,  0xCD, SKIP, SKIP, 0x21, 0xf0, 0xd8};
int fpbc_skel[]={15, 0x21, SKIP, SKIP, 0x22, SKIP, SKIP, 0xCD, SKIP, SKIP, CATCH_CALL, 0x38, SKIP, 0x21, 0xf0, 0xd8};
int fpbc_skel2[]={13, 0x21, SKIP, SKIP, 0x22, SKIP, SKIP, 0xCD, SKIP, SKIP, CATCH_CALL, 0x21, 0xf0, 0xd8};
int prog_skel[]={14, CATCH, CATCH, 0x5D, 0x54, 0xCD, SKIP, SKIP, 0xD0, 0xC5, 0xCD, SKIP, SKIP, 0xC1, 0xEB};
int prog_skel2[]={14, CATCH, CATCH, 0x54, 0x5D, 0xC1, 0xCD, SKIP, SKIP, 0xD0, 0xC5, 0xCD, SKIP, SKIP, 0xEB};
int next_one_skel[]={12, SKIP, SKIP, 0x5D, 0x54, 0xCD, SKIP, SKIP, 0xD0, 0xC5, CATCH_CALL, 0xC1, 0xEB};
int next_one_skel2[]={12, SKIP, SKIP, 0x54, 0x5D, 0xC1, 0xCD, SKIP, SKIP, 0xD0, 0xC5, CATCH_CALL, 0xEB};
int vars_skel[]={10, 0x2A, CATCH, CATCH, 0x36, 0x80, 0x23, 0x22, SKIP, SKIP, 0x2A};
int eline_skel[]={10, 0x2A, SKIP, SKIP, 0x36, 0x80, 0x23, 0x22, CATCH, CATCH, 0x2A};
int vars_skel2[]={10, 0x22, CATCH, CATCH, 0x36, 0x80, 0x23, 0x22, SKIP, SKIP, 0x36};
int eline_skel2[]={10, 0x22, SKIP, SKIP, 0x36, 0x80, 0x23, 0x22, CATCH, CATCH, 0x36};
int stk_pntr_skel[]={12, 0xED, 0xB0, 0x2A, CATCH, CATCH, 0x11, 0xFB, 0xFF, 0xE5, 0x19, 0xD1, 0xC9};
int test5fp_skel[]={8, CATCH_CALL, 0XD9, 0xE5, 0xD9, 0xE3, 0xC5, 0x7E, 0xE6};
int test5fp_skel2[]={9, 0x62, 0x6B, CATCH_CALL, 0XD9, 0xD5, 0xD9, 0xE3, 0xC5, 0x7E};
int stkftch_skel[]={10, 0x0F, 0xF5, CATCH_CALL, 0xD5, 0xC5, 0xCD, SKIP, SKIP, 0xE1, 0x7C};
int stkftch_skel2[]={13, CATCH_CALL, 0x78, 0xB1, 0x28, SKIP, 0x1A, 0xC3, SKIP, SKIP, 0xCD, SKIP, SKIP, 0xC3};
int stkbc_skel[]={11, 0xCD, SKIP, SKIP, 0x28, SKIP, 0xED, 0x4B, SKIP, SKIP, CATCH_CALL, 0xEF};
int seed_skel[]={13, 0xCD, SKIP, SKIP, 0x28, SKIP, 0xED, 0x4B, CATCH, CATCH, 0xCD, SKIP, SKIP, 0xEF};
int rnd_skel[]={13, 0xCD, SKIP, SKIP, 0x28, SKIP, 0xED, 0x4B, SKIP, SKIP, 0xCD, SKIP, SKIP, ADDR};
int restack_skel[]={11, CATCH_CALL, 0xEB, 0x7E, 0xA7, 0xC0, 0xD5, 0xCD, SKIP, SKIP, 0xAF, 0x23};
int stkstr_skel[]={8, 0xF7, CATCH_CALL, 0xC1, 0xE1, 0x78, 0xB1, 0x28, SKIP};
int stka_skel[]={15, 0xCD, SKIP, SKIP, 0x78, 0xB1, 0x28, SKIP, 0x1A, 0xC3, CATCH, CATCH, 0xCD, SKIP, SKIP, 0xC3};
int decfp_skel[]={11, 0xCD, SKIP, SKIP, 0x20, SKIP, CATCH_CALL, SKIP, 1, 0, 6, 0xCD};


/* Sinclair BASIC token extraction */
int tklambda_skel[]={12, 0xB7, 0xF2, SKIP, SKIP, 0xE6, 0x3F, 0x21, CATCH, CATCH, 0xFE, 0x49, 0x30};
int tkzx81_skel[]={12, 0xE5, 0x21, CATCH, CATCH, 0xCB, 0x7F, 0x28, SKIP, 0xE6, 0x3F, 0xFE, 0x43};
int tkspectrum_skel[]={13, 0x11, CATCH, CATCH, 0xF5, 0xCD, SKIP, SKIP, 0x38, SKIP, 0x3E, 0x20, 0xFD, 0xCB};
int tk2068_skel[]={15, 0x11, CATCH, CATCH, 0xFE,0x5B, 0x38, SKIP, 0xD6, 0x1F, 0xF5, 0xCD, SKIP, SKIP, 0x38, SKIP};
int tkzx128_skel[]={15, 0xD8, 0x06, 0xF9, 0x11, SKIP, SKIP , 0x21, CATCH, CATCH, 0xCD, SKIP, SKIP, 0xD0, 0xFE, 0xFF};

/* Sinclair BASIC error messages */
int zxerr_skel[]={16, 0xFE, 0x0A, 0x38, 2, 0xC6, 7, 0xCD, SKIP, SKIP, 0X3E, 0x20, SKIP, 0x78, 0x11,  CATCH, CATCH};
int zxfpmod_skel[]={10, 0x1A, 0xA7, 0x20, SKIP, 0xD9, 0x23, 0xD9, 0xC9, 0xEF, ADDR};
int zxfpmod_skel2[]={11, 0xD9, 0x23, 0xD9, 0xC9, 0xF1, 0xD9, 0xE3, 0xD9, 0xC9, 0xEF, ADDR};



/* ZX Spectrum Shadow ROM detection (ATM only Disciple and IF1 are known) */
int zxshadow_end[]={26, ADDR, 33, 0x38, 0x00, 0x22, 0x8D, 0x5C, 0x22, 0x8F, 0x5C, 0xFD, 0x75, 0x0E, 0xFD, 0x74, 0x57, 0x3E, 7, 0xD3, 254, SKIP_CALL, SKIP, SKIP, 0xC3, CATCH, CATCH };




/* Microsoft BASIC detection */
int restore_skel[]={14, 0xEB, 0x2A, CATCH, CATCH, 0x28, 0x0E, 0xEB, SKIP_CALL, 0xE5, SKIP_CALL, 0x60, 0x69, 0xD1, 0xD2};
int microsoft_skel[]={9, CATCH, 'i', 'c', 'r', 'o', 's', 'o', 'f', 't'};
int bastxt_skel[]={8, 0x2A, CATCH, CATCH, 0x44, 0x4D, 0x7E, 0x23, 0xB6, 0x2B, 0xC8, 0x23, 0x23, 0x7E, 0x23, 0x66};

int microsoft_extended_skel[]={11, ADDR, 0xFE, '%', 0xC8, 0x14, 0xFE, '$', 0xC8, 0x14, 0xFE, '!'};
int microsoft_defdbl_skel[]={7, ADDR, 'D', 'E', 'F', 'D', 'B', 'L'};
int microsoft_defdbl_skel2[]={7, ADDR, 'D'+0x80, 'E', 'F', 'D', 'B', 'L'};
int microsoft_defdbl_skel3[]={6, ADDR, 'E', 'F', 'D', 'B', 'L'+0x80};


/* Microsoft BASIC code inspection */
int ulerr_skel[]={9, SKIP_CALL, 0xE5, SKIP_CALL, 0x60, 0x69, 0xD1, 0xD2, CATCH, CATCH};
int prognd_skel[]={8, 0xEB, 0x2A, CATCH, CATCH, 0x1A, 0x02, 0x03, 0x13};
int errtab_skel[]={11, ADDR, 0x1E, 2, 1, 0x1E, SKIP, 1, 0x1E, SKIP, 1, 0x1E}; 

int cmpnum_skel[]={7, 1, 0x74, 0x94, 17, SKIP, SKIP, CATCH_CALL}; 
int fpint_skel[]={7, 0x7E, CATCH_CALL, 0x36, 0x98, 0x7B, 0xF5, 0x79}; 
int flgrel_skel[]={11, ADDR, 6, 0x88, 17, 0, 0, 33, SKIP, SKIP, 0x4F, 0x70};
int fpreg_skel[]={10, 0x21, SKIP, SKIP, 0x7E, 0xFE, 0x98, 0x3A, CATCH, CATCH, 0xD0}; 
int fpexp_skel[]={10, 0x21, CATCH, CATCH, 0x7E, 0xFE, 0x98, 0x3A, SKIP, SKIP, 0xD0}; 
int bcdefp_skel[]={11, ADDR, 0x21, SKIP, SKIP, 0x5E, 0x23, 0x56, 0x23, 0x4E, 0x23, 0x46};
int loadfp_skel[]={8, ADDR, 0x5E, 0x23, 0x56, 0x23, 0x4E, 0x23, 0x46, 0xC9};
int fpbcde_skel[]={8, ADDR, SKIP_CALL, 0xEB, 0x22, SKIP, SKIP, 0x60, 0x69, 0x22, SKIP, SKIP, 0xEB};
int fpreg_skel2[]={7, SKIP_CALL, 0xEB, 0x22, CATCH, CATCH, 0x60, 0x69, 0x22, SKIP, SKIP, 0xEB};
int stakfp_skel[]={10, ADDR, 0xEB, 0x2A, SKIP, SKIP, 0xE3, 0xE5, 0x2A, SKIP, SKIP, 0xE3, 0xEB, 0xC9};
int tstsgn_skel[]={12, ADDR, 0x3A,  SKIP, SKIP, 0xB7, 0xC8, 0x3A,  SKIP, SKIP, 0xFE, 0x2F, 0x17};
int tstsgn_skel2[]={13, ADDR, 0x3A,  SKIP, SKIP, 0xB7, 0xC8, 0x3A,  SKIP, SKIP, 0x18, 1, 0x2F, 0x17};
int tstsgn_skel3[]={10, ADDR, 0x3A,  SKIP, SKIP, 0xB7, 0xC8, 0x3A,  SKIP, SKIP, 0xC3};
int fpexp_skel2[]={12, 0x3A,  CATCH, CATCH, 0xB7, 0xC8, 0x3A,  SKIP, SKIP, 0x18, 1, 0x2F, 0x17};

/* nxtopr_skel2 checked in OPNPAR first */
int nxtopr_skel2[]={8, 0x16,  0x7D, SKIP_CALL, 0x2A,  CATCH, CATCH, 0xE5, 0xCD};

/* chkstk_skel checked in OPNPAR first */
int chkstk_skel2[]={10, ADDR, 0xE5, 0x2A,  SKIP, SKIP, 6, 0, 9, 9, 0x3E};
int arrend_skel[]={9, 0xE5, 0x2A,  CATCH, CATCH, 6, 0, 9, 9, 0x3E};

int fpadd_skel[]={12, ADDR, 0x3A,  SKIP, SKIP, 0xB7, 0xC8, 0x3A,  SKIP, SKIP, 0x18, 1, 0x2F};

int last_fpreg_skel[]={11, 0x3A,  CATCH, CATCH, 0xB7, 0xC8, 0x3A,  SKIP, SKIP, 0x18, 1, 0x2F};

int getvar_skel[]={4, SKIP_CALL, ',', CATCH_CALL, 0xE3};
int getvar_skel2[]={6, CATCH_CALL, 0xE3, 0xD5, 0x7E, 0xFE, ','};
/* chksyn_skel checked in OPNPAR first */
int chksyn_skel2[]={4, CATCH_CALL, ',', SKIP_CALL, 0xE3};
int chksyn_skel3[]={4, CATCH_CALL, ',', SKIP_CALL, 0x28};

int getchr_skel[]={7, CATCH_CALL, 0xD0, 0xE5, 0xF5, 0x21, 0x98, 0x19};

int getk_skel[]={12, CATCH_CALL, 0x2A, SKIP, SKIP, 0xC5, SKIP_CALL, 0xC1, 0xC0, 0x2A, SKIP, SKIP, 0x85};
int rinput_skel[]={9, 0x3E, '?', SKIP_CALL, 0x3E, ' ', SKIP_CALL, 0xC3, CATCH, CATCH};
int rinput_skel2[]={7, 0x3E, '?', SKIP_CALL, 0x3E, ' ', SKIP_CALL, CATCH_CALL};
int rinput_skel3[]={7, 0x3E, '?', SKIP, 0x3E, ' ', SKIP, CATCH_CALL};
int rinput_skel4[]={14, 0x3E, '?', SKIP_CALL, 0x3E, ' ', SKIP_CALL, 0x18, SKIP, SKIP, SKIP, 0xC3, SKIP, SKIP, ADDR};

int halfpi_skel[]={11, 0x21, CATCH, CATCH, SKIP_CALL, SKIP_CALL, 1, 0x49, 0x83, 0x11, 0xDB, 0x0F};
int addphl_skel[]={11, 0x21, SKIP, SKIP, CATCH_CALL, SKIP_CALL, 0X01, 0x49, 0x83, 0x11, 0xDB, 0x0F};
int cos_skel[]={11, ADDR, SKIP, SKIP, SKIP_CALL, SKIP_CALL, 0X01, 0x49, 0x83, 0x11, 0xDB, 0x0F};
int sin_skel[]={13, 0x21, SKIP, SKIP, SKIP_CALL, ADDR, SKIP, SKIP, 0X01, 0x49, 0x83, 0x11, 0xDB, 0x0F};

int cos_skel3[]={20, ADDR, SKIP, SKIP, SKIP_CALL, 0x21, SKIP, SKIP, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, SKIP_CALL, 0xF5, 0xFA};
int sin_skel3[]={22, 0x21, SKIP, SKIP, SKIP_CALL, 0x21, SKIP, SKIP, ADDR, SKIP, SKIP, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, SKIP_CALL, 0xF5, 0xFA};
int halfpi_skel2[]={20, 0x21, CATCH, CATCH, SKIP_CALL, 0x21, SKIP, SKIP, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, SKIP_CALL, 0xF5, 0xFA};
int addphl_skel2[]={20, 0x21, SKIP, SKIP, CATCH_CALL, 0x21, SKIP, SKIP, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, SKIP_CALL, 0xF5, 0xFA};

int atn_skel[]={13, ADDR, SKIP_CALL, 0xFC, SKIP, SKIP, 0xFC, SKIP, SKIP, 0X3A, SKIP, SKIP, 0xFE, 0x81};
int negaft_skel[]={12, SKIP_CALL, 0xFC, CATCH, CATCH, 0xFC, SKIP, SKIP, 0X3A, SKIP, SKIP, 0xFE, 0x81};
int invsgn_skel[]={12, SKIP_CALL, 0xFC, SKIP, SKIP, 0xFC, CATCH, CATCH, 0X3A, SKIP, SKIP, 0xFE, 0x81};
int invsgn_skel2[]={8, 0x16,  0x7D, SKIP_CALL, 0x2A,  SKIP, SKIP, 0xE5, CATCH_CALL};

int exp_skel[]={9, ADDR, SKIP_CALL, 1, 0x38, 0x81, 17, 0X3B, 0xAA, SKIP_CALL};
int fpmult_skel[]={7, 1, 0x38, 0x81, 17, 0X3B, 0xAA, CATCH_CALL};

int abs_skel[]={10, ADDR, SKIP_CALL, 0xF0, 33, SKIP, SKIP, 0x7E, 0xEE, 0x80, 0x77};
int abs_skel2[]={10, ADDR, SKIP, 0xF0, 33, SKIP, SKIP, 0x7E, 0xEE, 0x80, 0x77};
int abs_skel3[]={14, ADDR, SKIP_CALL, 0xF0, SKIP, 0xFA, SKIP, SKIP, 0xCA, SKIP, SKIP, 33, SKIP, SKIP, 0x7E};

int last_fpreg_skel2[]={13, SKIP_CALL, 0xF0, SKIP, 0xFA, SKIP, SKIP, 0xCA, SKIP, SKIP, 33, CATCH, CATCH, 0x7E};
int dblabs_skel[]={13, SKIP_CALL, 0xF0, SKIP, 0xFA, CATCH, CATCH, 0xCA, SKIP, SKIP, 33, SKIP, SKIP, 0x7E};

int dblabs_skel2[]={10, ADDR, 0x2A, SKIP, SKIP, SKIP_CALL, 0x7C, 0xEE, 0x80, 0xB5, 0xC0};
int dblfpreg_skel[]={9, 0x2A, CATCH, CATCH, SKIP_CALL, 0x7C, 0xEE, 0x80, 0xB5, 0xC0};

int dbl_tstsgn_skel[]={13, CATCH_CALL, 0xF0, SKIP, 0xFA, SKIP, SKIP  ,0xCA, SKIP, SKIP, 33, SKIP, SKIP, 0x7E};
int dbl_tstsgn_skel2[]={9, CATCH_CALL, 0xF0, 33, SKIP, SKIP, 0x7E, 0xEE, 0x80, 0x77};

int log_skel[]={13, ADDR, SKIP_CALL, 0xB7, 0xEA, SKIP, SKIP, 33, SKIP, SKIP, 0x7E, 1, 0x35, 0x80};
int log_skel2[]={10, ADDR, SKIP_CALL, 0xB7, 0xEA, SKIP, SKIP, SKIP_CALL, 1, 0x31, 0x80};
int log_skel3[]={10, ADDR, SKIP, 0xB7, 0xEA, SKIP, SKIP, SKIP_CALL, 1, 0x31, 0x80};
int log_skel4[]={13, ADDR, SKIP, 0xB7, 0xEA, SKIP, SKIP, 33, SKIP, SKIP, 0x7E, 1, 0x35, 0x80};
int fcerr_skel[]={12, SKIP_CALL, 0xB7, 0xEA, CATCH, CATCH, 33, SKIP, SKIP, 0x7E, 1, 0x35, 0x80};

int fpadd_skel2[]={13, CATCH_CALL, 0xC1, 0xD1, 0x04, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 33, SKIP, SKIP, 0xCD};
int fpadd_skel3[]={12, ADDR, 0xB7, 0xC8, 0x3A,  SKIP, SKIP, 0xB7, 0xCA,  SKIP, SKIP, 0x90, 0x30};
int dvbcde_skel[]={13, SKIP_CALL, 0xC1, 0xD1, 0x04, CATCH_CALL, 33, SKIP, SKIP, SKIP_CALL, 33, SKIP, SKIP, 0xCD};
int unity_skel[]={13, SKIP_CALL, 0xC1, 0xD1, 0x04, SKIP_CALL, 33, CATCH, CATCH, SKIP_CALL, 33, SKIP, SKIP, 0xCD};
int subphl_skel[]={13, SKIP_CALL, 0xC1, 0xD1, 0x04, SKIP_CALL, 33, SKIP, SKIP, CATCH_CALL, 33, SKIP, SKIP, 0xCD};
int logtab_skel[]={13, SKIP_CALL, 0xC1, 0xD1, 0x04, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 33, CATCH, CATCH, 0xCD};
int sumser_skel[]={13, SKIP_CALL, 0xC1, 0xD1, 0x04, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 33, SKIP, SKIP, CATCH_CALL};

int tan_skel[]={10, ADDR, SKIP_CALL, SKIP_CALL, 0xC1, 0xE1, SKIP_CALL, 0xEB, SKIP_CALL, SKIP_CALL, 0xC3};
int sin_skel2[]={9, SKIP_CALL, CATCH_CALL, 0xC1, 0xE1, SKIP_CALL, 0xEB, SKIP_CALL, SKIP_CALL, 0xC3};
int cos_skel2[]={9, SKIP_CALL, SKIP_CALL, 0xC1, 0xE1, SKIP_CALL, 0xEB, SKIP_CALL, CATCH_CALL, 0xC3};
int div_skel[]={11, SKIP_CALL, SKIP_CALL, 0xC1, 0xE1, SKIP_CALL, 0xEB, SKIP_CALL, SKIP_CALL, 0xC3, CATCH, CATCH};

int sqr_skel[]={10, ADDR, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int sqr_skel2[]={13, ADDR, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 0x18, 3, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int sqr_skel3[]={13, ADDR, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 0xc3, SKIP, SKIP, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int power_skel[]={11, SKIP_CALL, 33, SKIP, SKIP, 0xCD, SKIP, ADDR, 0xC1, 0xD1, SKIP_CALL, 0x78};
int power_skel2[]={12, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 0x18, ADDR, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int power_skel3[]={12, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 0xc3, SKIP, ADDR, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int half_skel[]={9, SKIP_CALL, 33, CATCH, CATCH, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int half_skel2[]={12, SKIP_CALL, 33, CATCH, CATCH, SKIP_CALL, 0x18, 3, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int half_skel3[]={12, SKIP_CALL, 33, CATCH, CATCH, SKIP_CALL, 0xc3, SKIP, SKIP, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};


int fpthl_skel[]={10, ADDR, 17, SKIP, SKIP, 6, 4, 0x1A, 0x77, 0x13, 0x23};
int dcbde_skel[]={8, ADDR, 0x1B, 0x7A, 0xA3, 0x3C, 0xC0, 0x0B, 0xC9};
int dblint_skel[]={9, ADDR, SKIP, 0xF8, 0x30, SKIP, 0x28, SKIP, SKIP_CALL, 33, SKIP, SKIP, 0x7E, 0xFE, 0x98}; 
int dblint_skel2[]={16, ADDR, SKIP_CALL, 0xF8, 0xD2, SKIP, SKIP, 0xCA, SKIP, SKIP, SKIP_CALL, 33, SKIP, SKIP, 0x7E, 0xFE, 0x98}; 

int fix_skel[]={10, ADDR, SKIP_CALL, 0xF8, SKIP_CALL, 0xF2, SKIP, SKIP, SKIP_CALL, SKIP_CALL, 0xC3};

int dblsub_skel[]={14, ADDR, 33, SKIP, SKIP, 0x7E, 0xEE, 0x80, 0x77, 33, SKIP, SKIP, 0x7E, 0xB7, 0xC8};
int dblsub_skel2[]={15, ADDR, 33, SKIP, SKIP, SKIP_CALL, 33, SKIP, SKIP, 0x7E, 0xB7, 0xC8, 0x47, 0x2B, 0x4E, 17};

int dbllast_fpreg_skel[]={13, 33, CATCH, CATCH, 0x7E, 0xEE, 0x80, 0x77, 33, SKIP, SKIP, 0x7E, 0xB7, 0xC8};

int dbladd_skel[]={13, 33, SKIP, SKIP, 0x7E, 0xEE, 0x80, ADDR,  33, SKIP, SKIP, 0x7E, 0xB7, 0xC8};
int dblmul_skel[]={9, ADDR, SKIP_CALL, 0xC8, SKIP_CALL, SKIP_CALL, 0x71, 0x13, 6, 7};
int dbldiv_skel[]={13, ADDR, 0x3A, SKIP, SKIP, 0xB7, 0xCA, SKIP, SKIP, SKIP_CALL, 0x34, 0x34, SKIP_CALL, 33};

int int_skel[]={11, ADDR, 33, SKIP, SKIP, 0x7E, 0xFE, 0x98, 0x3A, SKIP, SKIP, 0xD0};
int mldebc_skel[]={9, ADDR, 33, 0, 0, 0x78, 0xB1, 0xC8, 0x3E, 0x10};

int intmul_skel[]={17, ADDR, 0x7C, 0xB5, 0xCA, SKIP, SKIP, 0xE5, 0xD5, SKIP_CALL, 0xC5, 0x44, 0x4D, 33, 0, 0, 0x3E, 0x10};

int asctfp_skel[]={10, ADDR, 0xFE, '-', 0xF5, 0xCA, SKIP, SKIP, 0xFE, '+', 0xCA};
int asctfp_skel2[]={9, ADDR, 0xFE, '-', 0xF5, 0x28, SKIP, 0xFE, '+', 0x28};

int dblasctfp_skel[]={11, ADDR, SKIP_CALL, SKIP_CALL, 0xF6, 0xAF, 0xEB, 1, 255, 0, 0x60, 0x68};



int prnthl_skel[]={10, ADDR, 0xEB, 0xAF, 6, 0x98, SKIP_CALL, 33, SKIP, SKIP, 0xE5};
int prnthl_skel2[]={10, 0xE5, 33, SKIP, SKIP, SKIP_CALL, ADDR, 0xEB, 0xAF, 6, 0x98};
int prnthl_skel3[]={10, 0xE5, 33, SKIP, SKIP, SKIP_CALL, 17, SKIP, SKIP, ADDR, 0xEB, 0xAF, 6, 0x98};

int prs_skel[]={14, 0xE5, 33, SKIP, SKIP, CATCH_CALL, 0xE1, 17, SKIP, SKIP, 0xD5, 0xEB, 0xAF, 6, 0x98};
int prs_skel3[]={11, 0xE5, 33, SKIP, SKIP, CATCH_CALL, 0xE1, 17, 0xEB, 0xAF, 6, 0x98};

int str_skel[]={15, ADDR, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, 1, SKIP, SKIP,  0xC5, 0x7E, 0x23, 0x23, 0xE5, SKIP_CALL, 0xE1, 0x4E};
int str_skel2[]={14, ADDR, SKIP_CALL, SKIP_CALL, SKIP_CALL, 1, SKIP, SKIP,  0xC5, 0x7E, 0x23, 0xE5, SKIP_CALL, 0xE1, 0x4E};

int tstopl_skel[]={15, ADDR, 17, SKIP, SKIP, 0x2A, SKIP, SKIP, 0x22, SKIP, SKIP, 0x3E, 1, 0x32, SKIP_CALL, SKIP_CALL};
int tstopl_skel2[]={14, ADDR, 17, SKIP, SKIP, 0x3E, 0xD5, 0x2A, SKIP, SKIP, 0x22, SKIP, SKIP, 0x3E, 3};
int tmstpt_skel[]={14, 17, SKIP, SKIP, 0x2A, CATCH, CATCH, 0x22, SKIP, SKIP, 0x3E, 1, 0x32, SKIP_CALL, SKIP_CALL};
int tmstpt_skel2[]={13, 17, SKIP, SKIP, 0x3E, 0xD5, 0x2A, CATCH, CATCH, 0x22, SKIP, SKIP, 0x3E, 3};
int tmpstr_skel[]={14, 17, CATCH, CATCH, 0x2A, SKIP, SKIP, 0x22, SKIP, SKIP, 0x3E, 1, 0x32, SKIP_CALL, SKIP_CALL};
int tmpstr_skel2[]={13, 17, CATCH, CATCH, 0x3E, 0xD5, 0x2A, SKIP, SKIP, 0x22, SKIP, SKIP, 0x3E, 3};

int fpreg_skel3[]={14, 17, SKIP, SKIP, 0x2A, SKIP, SKIP, 0x22, CATCH, CATCH, 0x3E, 1, 0x32, SKIP_CALL, SKIP_CALL};
int fpreg_skel4[]={13, 17, SKIP, SKIP, 0x3E, 0xD5, 0x2A, SKIP, SKIP, 0x22, CATCH, CATCH, 0x3E, 3};



int savstr_skel[]={17, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0xCD, SKIP, ADDR, 1, SKIP, SKIP,  0xC5, 0x7E, 0x23, 0x23, 0xE5, SKIP_CALL, 0xE1, 0x4E};
int savstr_skel2[]={15, SKIP_CALL, SKIP_CALL, 0xCD, SKIP, ADDR, 1, SKIP, SKIP,  0xC5, 0x7E, 0x23, 0xE5, SKIP_CALL, 0xE1, 0x4E};

int testr_skel[]={15, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, 1, SKIP, SKIP,  0xC5, 0x7E, 0x23, 0x23, 0xE5, CATCH_CALL, 0xE1, 0x4E};
int testr_skel2[]={13, SKIP_CALL, SKIP_CALL, SKIP_CALL, 1, SKIP, SKIP,  0xC5, 0x7E, 0x23, 0xE5, CATCH_CALL, 0xE1, 0x4E};

int topool_skel[]={15, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, 1, CATCH, CATCH,  0xC5, 0x7E, 0x23, 0x23, 0xE5, SKIP_CALL, 0xE1, 0x4E};
int topool_skel2[]={14, ADDR, SKIP_CALL, SKIP_CALL, SKIP_CALL, 1, CATCH, CATCH,  0xC5, 0x7E, 0x23, 0xE5, SKIP_CALL, 0xE1, 0x4E};

int opnpar_skel[]={12, ADDR, SKIP_CALL, '(', 0x2B, 0x16, 0, 0xD5, 0x0E, 1, SKIP_CALL, SKIP_CALL, 0x22};
int eval_skel[]={11, SKIP_CALL, ADDR, 0x2B, 0x16, 0, 0xD5, 0x0E, 1, SKIP_CALL, SKIP_CALL, 0x22};
int chksyn_skel[]={11, CATCH_CALL, '(', 0x2B, 0x16, 0, 0xD5, 0x0E, 1, SKIP_CALL, SKIP_CALL, 0x22};
int chkstk_skel[]={11, SKIP_CALL, '(', 0x2B, 0x16, 0, 0xD5, 0x0E, 1, CATCH_CALL, SKIP_CALL, 0x22};
int oprnd_skel[]={11, SKIP_CALL, '(', 0x2B, 0x16, 0, 0xD5, 0x0E, 1, SKIP_CALL, CATCH_CALL, 0x22};
int nxtopr_skel[]={13, SKIP_CALL, '(', 0x2B, 0x16, 0, 0xD5, 0x0E, 1, SKIP_CALL, SKIP_CALL, 0x22, CATCH, CATCH};

int curpos_skel[]={15, 0x3A, CATCH, CATCH, 0x86, 0x3D, 0xB8, 0xD4, SKIP, SKIP, SKIP_CALL, 0xAF, 0xC4, SKIP, SKIP, 0xE1};
int curpos_skel2[]={11, 0x3A, CATCH, CATCH, 0x86, 0xB8, 0xD4, SKIP, SKIP, SKIP_CALL, 0x3E, 0x20};

int outc_skel[]={15, 0x3A, SKIP, SKIP, 0x86, 0x3D, 0xB8, 0xD4, CATCH, CATCH, SKIP_CALL, 0xAF, 0xC4, SKIP, SKIP, 0xE1};
int prs_skel2[]={15, 0x3A, SKIP, SKIP, 0x86, 0x3D, 0xB8, 0xD4, SKIP, SKIP, CATCH_CALL, 0xAF, 0xC4, SKIP, SKIP, 0xE1};
int outc_skel2[]={12, 0x3A, SKIP, SKIP, 0x86, 0xB8, 0xD4, SKIP, SKIP, SKIP_CALL, 0x3E, 0x20, CATCH_CALL};

int prnums_skel[]={12, ADDR, 0x23, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0x1C, 0x1D, 0xC8, 0x0A, SKIP_CALL, 0xFE, 13};
int prnums_skel2[]={12, ADDR, 0x23, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0x14, 0x15, 0xC8, 0x0A, SKIP_CALL, 0xFE, 13};

int outc_skel3[]={11, 0x23, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0x1C, 0x1D, 0xC8, 0x0A, CATCH_CALL, 0xFE, 13};
int outc_skel4[]={11, 0x23, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0x14, 0x15, 0xC8, 0x0A, CATCH_CALL, 0xFE, 13};
int outc_skel5[]={6 ,0x3E, '?', CATCH_CALL, 0x3E, ' ', 0xCD};

int numasc_skel[]={15, SKIP_CALL, CATCH_CALL, SKIP_CALL, SKIP_CALL, 1, SKIP, SKIP,  0xC5, 0x7E, 0x23, 0x23, 0xE5, SKIP_CALL, 0xE1, 0x4E};

int atoh_skel[]={12, ADDR, 0x2B, 17, 0, 0, SKIP_CALL, 0xD0, 0xE5, 0xF5, 33, 0x98, 0x19};



int crtst_skel[]={10, ADDR,  0x2B, 6, 0x22, 0x50, 0xE5, 0x0E ,0xFF, 0x23, 0x7E};
int getstr_skel[]={12, ADDR,  SKIP_CALL, 0x2A, SKIP, SKIP, 0xEB, SKIP_CALL, 0xEB, 0xC0, 0xD5, 0x50, 0x59};
int tststr_skel[]={10, CATCH_CALL, 0x2A, SKIP, SKIP, 0xEB, SKIP_CALL, 0xEB, 0xC0, 0xD5};

int datsnr_skel[]={15, ADDR, 0x2A, SKIP, SKIP, 0x22, SKIP, SKIP, 0x1E, 2, 1, 0x1E, SKIP, 1, 0x1E, SKIP};



/* Microsoft BASIC token extraction */
int tkmsbasic_skel[]={12, 17, CATCH, CATCH, 0x1A, 0x13, 0xB7, 0xF2, SKIP, SKIP, 0x0D, 0x20, 0xF7};
int tkmsbasic_skel2[]={15, 33, CATCH, CATCH, 0x7E, 0xB7, 0x23, 0xF2, SKIP, SKIP, 0x1D, 0xC2, SKIP, SKIP, 0xA6, 0x7F};
int tkmsbasic_skel3[]={12, 0xD5, 17, CATCH, CATCH, 0xC5, 1, SKIP, SKIP, 0xC5, 0x06, SKIP, 0x7E};

/* odd MSX/Spectravideo tokens*/
int tkmsbasic_msx_skel[]={12, SKIP_CALL, 33, CATCH, CATCH, 0x47, 0x0e, 0x40, 0x0C, 0x23, 0x54, 0x5D, 0x7E};



int tkmsbasic_code_skel[]={12, 0xD5, 17, SKIP, SKIP, 0xC5, 1, SKIP, SKIP, 0xC5, 0x06, CATCH, 0x7E};
int jptab_msbasic_skel[]={10, 0x07, 0x4F, 6, 0, 0xEB, 33, CATCH, CATCH, 9, 0x4E};
int fnctab_msbasic_skel[]={10, 0xD5, 1, CATCH, CATCH, 9, 0x4E, 0x23, 0x66, 0x69, 0xE9};
int fnctab_msbasic_skel2[]={9,       1, CATCH, CATCH, 9, 0x4E, 0x23, 0x66, 0x69, 0xE9};



int pc6001_60_page[]={12, 33, CATCH, CATCH, 17, 0 ,0xFA, 1, SKIP, SKIP, 0xED, 0xB0, 17};
//int pc6001_page[]={11, 33, CATCH, CATCH, 17, 0 ,0xFA, 1, SKIP, SKIP, 0xED, 0xB0};



int cpdehl_skel[]={7, ADDR, 0x7C, 0x92, 0xC0, 0x7D, 0x93, 0xC9};
int cpdehl_loc_skel[]={9, 0xEB, 0x2A, SKIP, SKIP, 0x1A, 0x02, 0x03, 0x13, CATCH_CALL};
int cpdehl_loc_skel2[]={7, 0xD0, 0xE5, 0xF5, 0x21, 0x98, 0x19, CATCH_CALL};

int buffer_loc_skel[]={9,  0x21, CATCH, CATCH, 0x12, 0x13, 0x12, 0x13, 0x12, 0xC9,};
int buffer_loc_skel2[]={10,  0x21, CATCH, CATCH, 0xAF, 0x12, 0x13, 0x12, 0x13, 0x12, 0xC9,};





int find_in_skel (int *skel, int p) {
	int i, j, retval;
	
	retval = -2;
	i = p;
	
	for (j=1; j<=l; j++) {
		if (skel[j] == CATCH) {
			retval = img[j+i];
			if(skel[j+1] == CATCH) {
				retval += 256 * img[i+j+1];
				j++;}
		} else {
			if (skel[j] != SKIP)
				if (skel[j] == ADDR)
					retval=j+i;
				else
					if ((skel[j] == CATCH_CALL) || (skel[j] == SKIP_CALL))
						switch (img[j+i]) {
							case 0xC7:		/* RST 0 */
							case 0xCF:		/* RST 8 */
							case 0xD7:		/* RST 10 */
							case 0xDF:		/* RST 18 */
							case 0xE7:		/* RST 20 */
							case 0xEF:		/* RST 28 */
							case 0xF7:		/* RST 30 */
							case 0xFF:		/* RST 38 */
								if (skel[j] == CATCH_CALL)
									retval = img[j+i] & 0x38;
								break;
							case 0xCD:
								i++;
								if (skel[j] == CATCH_CALL)
									retval = img[i+j] + 256 * img[i+j+1];
								i++;
								break;
							default:
								return (-1);
								break;
					}
					else if (img[j+i] != skel[j]) return (-1);
		}
	}
	return (retval);
}
	
int find_skel (int *skel) {
	int i,retval;
	
	l=skel[0];
	for (i=0; i<(len-l);i++) {
		retval=find_in_skel (skel, i);
		if (retval >= 0)
			return (retval);
	}
	return (-1);
}


int zx81char(c) {
	int a;
	switch (c) {
		case 11:
			a='"';
			break;
		case 13:
			a='$';
			break;
		case 15:
			a='?';
			break;
		case 18:
			a='>';
			break;
		case 19:
			a='<';
			break;
		case 20:
			a='=';
			break;
		case 23:
			a='*';
			break;
		case 27:
			a='.';
			break;
		default:
			a=c+27;
			break;
	}
	return (a);
}

int main(int argc, char *argv[])
{
	FILE	*fpin;
	int	c, chr;
	int	i;
	int res;
	int brand;
	int new_tk_found;



	if ( (fpin=fopen(argv[1],"rb") ) == NULL ) {
		printf("Can't open input file\n");
		exit(1);
	}


/*
 *	Now we try to determine the size of the file
 *	to be converted
 */
	if	(fseek(fpin,0,SEEK_END)) {
		printf("Couldn't determine size of file\n");
		fclose(fpin);
		exit(1);
	}

	len=ftell(fpin);

	fseek(fpin,0L,SEEK_SET);

	/* We add 64K to prevent overflows in the token decoding tricks */
	img=malloc(len*sizeof(unsigned char)+65536);


/* We load the binary file */

	for (i=0; i<len;i++) {
		img[i]=getc(fpin);
	}

	printf("\nFile size: %d\n",i);

	res=find_skel(ldir_skel);
	if (res<0) 
		res=find_skel(ldir_skel2);
	if (res>0)
		printf("\nSpecific Z80 CPU code detected\n\n");

	
	
	/***********************************/
	/* Microsoft BASIC related section */
	/***********************************/
	res=find_skel(restore_skel);
	if (res<0)
		res=find_skel(bastxt_skel);
	if (res<0) {
		res=find_skel(errtab_skel);
		if (res>0) res =0xFFFF;
	}
	if (res>0) {
		printf("\nMicrosoft 8080/Z80 BASIC found\n");
		
		brand=find_skel(microsoft_extended_skel);
		if (brand>0)
			printf("  Extended syntax detected\n");
			else printf("  Earlier version\n");

		brand=find_skel(microsoft_defdbl_skel);
		if (brand<0)
			brand=find_skel(microsoft_defdbl_skel2);
		if (brand<0)
			brand=find_skel(microsoft_defdbl_skel3);
		if (brand>0)
			printf("  Double precision maths detected\n");

		brand=find_skel(microsoft_skel);
		if (brand>0)
			printf("  Microsoft signature found\n");
			else printf("  Microsoft signature not found\n");

		
		printf("\n");


		/* We refer to a common ROM subroutine to determine the correct code position */
		
		printf("\nBASTXT = $%04X  ; BASIC program start ptr\n",res);

		printf("\n");

		pos=find_skel(cpdehl_skel)+1;
		if (pos>0)
			printf("CPDEHL = $%04X  ; compare DE and HL",pos);
		
		res=find_skel(cpdehl_loc_skel);
		if (res<0)
			res=find_skel(cpdehl_loc_skel2);
		if (res>0) {
			pos=res-pos;
			if (pos>0)
				printf("\n    (Detected position for ORG:  $%04X)",pos);
			else pos=0;
		} else pos=0;

		
		
		printf("\n\n");

		
		res=find_skel(buffer_loc_skel);
		if (res<0)
			res=find_skel(buffer_loc_skel2);
		if (res>0)
			printf("BUFFER = $%04X  ; Start of input buffer\n",res+pos+1);

		res=find_skel(tmstpt_skel);
		if (res<0)
		res=find_skel(tmstpt_skel2);
		if (res>0)
			printf("TMSTPT = $%04X  ; Temporary string pool pointer\n",res);
		
		res=find_skel(tmpstr_skel);
		if (res<0)
		res=find_skel(tmpstr_skel2);
		if (res>0)
			printf("TMPSTR = $%04X  ; Temporary string\n",res);
		
		res=find_skel(nxtopr_skel);
		if (res<0)
			res=find_skel(nxtopr_skel2);
		if (res>0)
			printf("NXTOPR = $%04X  ; Address ptr to next operator\n",res);

		res=find_skel(curpos_skel);
		if (res<0)
			res=find_skel(curpos_skel2);
		if (res>0)
			printf("CURPOS = $%04X  ; Character position on line (cursor position)\n",res);


		res=find_skel(prognd_skel);
		if (res>0)
			printf("PROGND = $%04X  ; BASIC program end ptr\n",res);

		res=find_skel(arrend_skel);
		if (res>0)
			printf("ARREND = $%04X  ; End of arrays (lowest free mem)\n",res);

		res=find_skel(halfpi_skel);
		if (res<0)
			res=find_skel(halfpi_skel2);
		if (res>0)
			printf("HALFPI = $%04X  ; Half PI constant ptr\n",res);
		
		res=find_skel(unity_skel);
		if (res>0)
			printf("UNITY  = $%04X  ; Constant ptr for number 1 in FP\n",res);
		
		res=find_skel(half_skel);
		if (res<0)
			res=find_skel(half_skel2);
		if (res<0)
			res=find_skel(half_skel3);
		if (res>0)
			printf("HALF   = $%04X  ; Constant ptr for number 0.5 in FP\n",res);
		
		res=find_skel(logtab_skel);
		if (res>0)
			printf("LOGTAB = $%04X  ; Table used by LOG\n",res);
		
		printf("\n");

		res=find_skel(fpreg_skel);
		if (res<0)
			res=find_skel(fpreg_skel2);
		if (res<0)
			res=find_skel(fpreg_skel3);
		if (res<0)
			res=find_skel(fpreg_skel4);
		if (res>0)
			printf("FPREG  = $%04X  ; Floating Point Register\n",res);

		res=find_skel(last_fpreg_skel);
		if (res<0)
			res=find_skel(last_fpreg_skel2);
		if (res>0)
			printf("LAST_FPREG  = $%04X  ; Last byte in Single Precision FP Register (+sign bit)\n",res);
		
		res=find_skel(fpexp_skel);
		if (res<0)
			res=find_skel(fpexp_skel2);
		if (res>0)
			printf("FPEXP  = $%04X  ; Floating Point Exponent\n",res);


		res=find_skel(dblfpreg_skel);
		if (res>0)
			printf("DBL_FPREG  = $%04X  ; Double Precision Floating Point Register\n",res);

		res=find_skel(dbllast_fpreg_skel);
		if (res>0)
			printf("DBL_LAST_FPREG  = $%04X  ; Last byte in Double Precision FP register (+sign bit)\n",res);
		
		
		printf("\n");

		res=find_skel(getvar_skel);
		if (res<0)
			res=find_skel(getvar_skel2);
		if (res>0)
			printf("GETVAR = $%04X  ; Get variable address to DE\n",res);

		res=find_skel(chkstk_skel);
		if (res>0)
			printf("CHKSTK = $%04X  ; Check for C levels of stack\n",res);
		else {
			res=find_skel(chkstk_skel2);
			if (res>0)
				printf("CHKSTK = $%04X  ; Check for C levels of stack\n",res+pos+1);
		}

		res=find_skel(oprnd_skel);
		if (res>0)
			printf("OPRND  = $%04X  ; Get next expression value\n",res);

		res=find_skel(chksyn_skel);
		if (res<0)
			res=find_skel(chksyn_skel2);
		if (res<0)
			res=find_skel(chksyn_skel3);
		if (res>0)
			printf("CHKSYN = $%04X  ; A byte follows to be compared\n",res);
		
		printf("\n");
			
		res=find_skel(tstsgn_skel);
		if (res<0)
			res=find_skel(tstsgn_skel2);
		if (res<0)
			res=find_skel(tstsgn_skel3);
		if (res>0)
			printf("TSTSGN = $%04X  ; Test sign of FPREG\n",res+pos+1);

		
		res=find_skel(dbl_tstsgn_skel);
		if (res<0)
			res=find_skel(dbl_tstsgn_skel2);
		if (res>0)
			printf("_TSTSGN = $%04X  ; Test sign in number\n",res);


		res=find_skel(invsgn_skel);
		if (res<0)
			res=find_skel(invsgn_skel2);
		if (res>0)
			printf("INVSGN = $%04X  ; Invert number sign\n",res);

		res=find_skel(stakfp_skel);
		if (res>0) {
			printf("STAKFP = $%04X  ; Put FP value on stack\n",res+pos+1);
		}
		
		res=find_skel(negaft_skel);
		if (res>0)
			printf("NEGAFT = $%04X  ; Negate number\n",res);

		res=find_skel(log_skel);
		if (res<0)
			res=find_skel(log_skel2);
		if (res<0)
			res=find_skel(log_skel3);
		if (res<0)
			res=find_skel(log_skel4);
		if (res>0)
			printf("LOG    = $%04X  ; \n",res+pos+1);

		res=find_skel(sqr_skel);
		if (res<0)
			res=find_skel(sqr_skel2);
		if (res<0)
			res=find_skel(sqr_skel3);
		if (res>0)
			printf("SQR    = $%04X  ; \n",res+pos+1);
		
		res=find_skel(power_skel);
		if (res<0)
			res=find_skel(power_skel2);
		if (res<0)
			res=find_skel(power_skel3);
		if (res>0)
			printf("POWER  = $%04X  ; \n",res+pos+1);

		res=find_skel(exp_skel);
		if (res>0)
			printf("EXP    = $%04X  ; \n",res+pos+1);

		res=find_skel(cos_skel);
		if (res<0)
			res=find_skel(cos_skel2);
		if (res<0)
			res=find_skel(cos_skel3);
		if (res>0)
			printf("COS    = $%04X  ; \n",res+pos);
		
		res=find_skel(sin_skel);
		if (res<0)
			res=find_skel(sin_skel2);
		if (res<0)
			res=find_skel(sin_skel3);
		if (res>0)
			printf("SIN    = $%04X  ; \n",res+pos);

		res=find_skel(tan_skel);
		if (res>0)
			printf("TAN    = $%04X  ; \n",res+pos+1);

		res=find_skel(atn_skel);
		if (res>0)
			printf("ATN    = $%04X  ; \n",res+pos+1);

		res=find_skel(abs_skel);
		if (res<0)
			res=find_skel(abs_skel2);
		if (res<0)
			res=find_skel(abs_skel3);
		if (res>0)
			printf("ABS    = $%04X  ; \n",res+pos+1);
		
		res=find_skel(dblabs_skel);
		if (res<0)
			res=find_skel(dblabs_skel2);
		if (res>0)
			printf("DBL_ABS    = $%04X  ; \n",res+pos+1);
		
		res=find_skel(fpadd_skel);
		if (res>0) {
			printf("SUBCDE = $%04X  ; Subtract BCDE from FP reg\n",res+pos+1-3);
			printf("FPADD  = $%04X  ; Add BCDE to FP reg\n",res+pos+1);
		}
		else {
			res=find_skel(fpadd_skel2);
			if (res<0)
				res=find_skel(fpadd_skel3);
			if (res>0) {
				printf("SUBCDE = $%04X  ; Subtract BCDE from FP reg\n",res-3);
				printf("FPADD  = $%04X  ; Add BCDE to FP reg\n",res);
			}
		}
		
		res=find_skel(fpthl_skel);
		if (res>0)
			printf("FPTHL  = $%04X  ; Copy number in FPREG to HL ptr\n",res+pos+1);

		res=find_skel(fpbcde_skel);
		if (res>0) {
			printf("PHLTFP = $%04X  ; Number at HL to BCDE\n",res+pos+1);
			printf("FPBCDE = $%04X  ; Move BCDE to FPREG\n",res+pos+4);
		}
		
		res=find_skel(addphl_skel);
		if (res<0)
			res=find_skel(addphl_skel2);
		if (res>0)
			printf("ADDPHL = $%04X  ; ADD number at HL to BCDE\n",res);
		
		res=find_skel(subphl_skel);
		if (res>0)
			printf("SUBPHL = $%04X  ; SUBTRACT number at HL from BCDE\n",res);
		

		res=find_skel(fpmult_skel);
		if (res>0)
			printf("FPMULT = $%04X  ; Multiply BCDE to FP reg\n",res);

		res=find_skel(div_skel);
		if (res>0) {
			printf("DIV    = $%04X  ; Divide FP by number on stack\n",res);
			res +=2;
		}
		if (res <0)
			res=find_skel(dvbcde_skel);
		if (res>0)
			printf("DVBCDE = $%04X  ; Divide FP by BCDE\n",res);

		res=find_skel(dcbde_skel);
		if (res>0)
			printf("DCBCDE = $%04X  ; Dec FP value in BCDE\n",res+pos+1);
		



		res=find_skel(bcdefp_skel);
		if (res>0) {
			printf("BCDEFP = $%04X  ; Load FP reg to BCDE\n",res+pos+1);
		}

		res=find_skel(loadfp_skel);
		if (res>0)
			printf("LOADFP = $%04X  ; Load FP value pointed by HL to BCDE\n",res+pos+1);
		
		res=find_skel(cmpnum_skel);
		if (res>0)
			printf("CMPNUM = $%04X  ; Compare FP reg to BCDE\n",res);

		res=find_skel(fpint_skel);
		if (res>0)
			printf("FPINT  = $%04X  ; Floating Point to Integer\n",res);

		res=find_skel(flgrel_skel);
		if (res>0)
			printf("FLGREL = $%04X  ; CY and A to FP, & normalise\n",res+pos+1);

		res=find_skel(sumser_skel);
		if (res>0)
			printf("SUMSER = $%04X  ; Evaluate sum of series\n",res);
		
		res=find_skel(int_skel);
		if (res>0)
			printf("INT    = $%04X  ; \n",res+pos+1);
		
		res=find_skel(dblint_skel);
		if (res<0)
			res=find_skel(dblint_skel2);
		if (res>0)
			printf("DBL_INT    = $%04X  ; \n",res+pos+1);
		
		res=find_skel(dblsub_skel);
		if (res>0)
			printf("DBL_SUB    = $%04X  ; Double precision SUB (formerly SUBCDE)\n",res+pos+1);
		
		res=find_skel(dbladd_skel);
		if (res>0)
			printf("DBL_ADD    = $%04X  ; Double precision ADD (formerly FPADD)\n",res+pos+1);
		
		res=find_skel(dblsub_skel2);
		if (res>0) {
			printf("DBL_SUB    = $%04X  ; Double precision SUB (formerly SUBCDE)\n",res+pos+1);
			printf("DBL_ADD    = $%04X  ; Double precision ADD (formerly FPADD)\n",res+pos+7);
		}

		res=find_skel(dblmul_skel);
		if (res>0)
			printf("DBL_MUL    = $%04X  ; Double precision MULTIPLY\n",res+pos+1);
		
		res=find_skel(dbldiv_skel);
		if (res>0)
			printf("DBL_DIV    = $%04X  ; Double precision DIVIDE\n",res+pos+1);
		
		res=find_skel(fix_skel);
		if (res>0)
			printf("FIX    = $%04X  ; Double Precision to Integer conversion\n",res+pos+1);
		
		res=find_skel(intmul_skel);
		if (res>0)
			printf("INT_MUL    = $%04X  ; Integer MULTIPLY\n",res+pos+1);
		
		res=find_skel(mldebc_skel);
		if (res>0)
			printf("MLDEBC = $%04X  ; Multiply DE by BC\n",res+pos+1);

		res=find_skel(asctfp_skel);
		if (res<0)
			res=find_skel(asctfp_skel2);
		if (res>0)
			printf("ASCTFP = $%04X  ; ASCII to FP number\n",res+pos+1);

		res=find_skel(dblasctfp_skel);
		if (res>0) {
			printf("ASCTFP = $%04X  ; ASCII to FP number (New version)\n",res+pos+8);
			printf("DBL_ASCTFP = $%04X  ; ASCII to Double precision FP number\n",res+pos+1);
		}

		
		res=find_skel(prnthl_skel);
		if (res<0)
			res=find_skel(prnthl_skel2);
		if (res<0)
			res=find_skel(prnthl_skel3);
		if (res>0)
			printf("PRNTHL = $%04X  ; Print number in HL\n",res+pos+1);
		
		res=find_skel(prs_skel);
		if (res<0)
			res=find_skel(prs_skel2);
		if (res<0)
			res=find_skel(prs_skel3);
		if (res>0) {
			printf("PRNUMS = $%04X  ; Print number string\n",res-1);
			printf("PRS    = $%04X  ; Create string entry and print it\n",res);
			printf("PRS1   = $%04X  ; Print string at HL\n",res+3);
		} else {
			res=find_skel(prnums_skel);
			if (res<0)
				res=find_skel(prnums_skel2);
			if (res>0) {
				printf("PRNUMS = $%04X  ; Print number string\n",res+pos+1);
				printf("PRS    = $%04X  ; Create string entry and print it\n",res+pos+2);
				printf("PRS1   = $%04X  ; Print string at HL\n",res+pos+5);
			}
		}

		res=find_skel(str_skel);
		if (res<0)
			res=find_skel(str_skel2);
		if (res>0)
			printf("STR    = $%04X  ; STR BASIC function entry\n",res+pos+1);

		res=find_skel(savstr_skel);
		if (res<0)
			res=find_skel(savstr_skel2);
		if (res>0)
			printf("SAVSTR = $%04X  ; Save string in string area\n",res+pos+1);

		res=find_skel(testr_skel);
		if (res<0)
			res=find_skel(testr_skel2);
		if (res>0)
			printf("TESTR  = $%04X  ; Test if enough room for string\n",res);

		res=find_skel(topool_skel);
		if (res<0)
			res=find_skel(topool_skel2);
		if (res>0)
			printf("TOPOOL = $%04X  ; Save in string pool\n",res);

		res=find_skel(tstopl_skel);
		if (res<0)
			res=find_skel(tstopl_skel2);
		if (res>0)
			printf("TSTOPL = $%04X  ; Temporary string to pool\n",res+pos+1);

		res=find_skel(opnpar_skel);
		if (res>0)
			printf("OPNPAR = $%04X  ; Chk Syntax make sure '(' follows\n",res+pos+1);

		res=find_skel(eval_skel);
		if (res>0)
			printf("EVAL   = $%04X  ; Evaluate expression\n",res+pos+1);

		res=find_skel(crtst_skel);
		if (res>0)
			printf("CRTST  = $%04X  ; Create String\n",res+pos+1);
		
		res=find_skel(getstr_skel);
		if (res>0) {
			printf("GETSTR = $%04X  ; Get string pointed by FPREG 'Type Error' if it is not\n",res+pos+1);
			printf("GSTRCU = $%04X  ; Get string pointed by FPREG\n",res+pos+1+3);
			printf("GSTRHL = $%04X  ; Get string pointed by HL\n",res+pos+1+6);
			printf("GSTRDE = $%04X  ; Get string pointed by DE\n",res+pos+1+7);
		}
		
		res=find_skel(tststr_skel);
		if (res>0)
			printf("TSTSTR = $%04X  ; Test a string, 'Type Error' if it is not\n",res);
		
		res=find_skel(numasc_skel);
		if (res>0)
			printf("NUMASC = $%04X  ; Number to ASCII conversion\n",res);
		
		res=find_skel(atoh_skel);
		if (res>0)
			printf("ATOH   = $%04X  ; ASCII to Integer, result in DE\n",res+pos+1);
		
		
		
		printf("\n");


		
		res=find_skel(getchr_skel);
		if (res>0)
			printf("GETCHR = $%04X  ; GETNEXT char from program listing\n",res);
		
		
		res=find_skel(getk_skel);
		if (res>0)
			printf("GETK   = $%04X  ; Get key in 'A'\n",res);
		
		res=find_skel(rinput_skel);
		if (res<0)
			res=find_skel(rinput_skel2);
		if (res<0)
			res=find_skel(rinput_skel3);
		if (res>0)
			printf("RINPUT = $%04X  ; Line input\n",res);
		else {
			res=find_skel(rinput_skel4);
			if (res>0)
				printf("RINPUT = $%04X  ; Line input\n",res+pos);
		}

		res=find_skel(outc_skel);
		if (res<0)
			res=find_skel(outc_skel2);
		if (res<0)
			res=find_skel(outc_skel3);
		if (res<0)
			res=find_skel(outc_skel4);
		if (res<0)
			res=find_skel(outc_skel5);
		if (res>0)
			printf("OUTC   = $%04X  ; Output char in 'A' to console\n",res);


		/* MS BASIC errors */
		
		printf("\n");
		
		res=find_skel(datsnr_skel);
		if (res>0) {
			printf("DATSNR = $%04X  ; 'SN err' entry for Input STMT\n",res+pos+1);
			printf("SNERR  = $%04X  ; entry for '?SN ERROR'\n",res+pos+1+6);
		}
		res=find_skel(fcerr_skel);
		if (res>0)
			printf("FCERR  = $%04X  ; entry for '?FC ERROR'\n",res);
		
		res=find_skel(ulerr_skel);
		if (res>0)
			printf("ULERR  = $%04X  ; entry for '?UL ERROR'\n",res);

		printf("\n\n");

		/* MS BASIC commands */
		jptab=find_skel(jptab_msbasic_skel);
		if (jptab>0) {
			printf("\nJP table for statements = $%04X\n",jptab);
			res=find_skel(pc6001_60_page);
			if (res>0)
				jptab=0x134+0x61;
		}

		res=find_skel(tkmsbasic_msx_skel);
		if (res>0)
			printf("\nTOKEN table position = $%04X\n",res);

		res=find_skel(tkmsbasic_skel)-1;
		if (res<0)
			res=find_skel(tkmsbasic_skel2);
		if (res<0)
			res=find_skel(tkmsbasic_skel3);
		if (res>0) {
			res=res+1-pos;
			printf("\n\n\nTOKEN table position = $%04X\n",res+pos);
			new_tk_found=0;
			printf("\n-- STATEMENTS --\n");
			printf("\n\t ---  ");
			chr=find_skel(tkmsbasic_code_skel)+1;;
			for (i=res; img[i]!=128; i++) {
				if ((c == 'W') && (img[i-2] == 'E') && ((img[i-3] == 'N') || (img[i-3] == ('N'+0x80)))) {
					new_tk_found=1;
					printf("\n\n-- OPERATORS & extras --\n");
				}
				if ((c == '<') && ((img[i-2] != '=') || (img[i-2] != ('='+0x80)))) {
					jptab=find_skel(fnctab_msbasic_skel);
					if (jptab<0)
						jptab=find_skel(fnctab_msbasic_skel2);
					if (jptab>0) {
						printf("\n\nJP table for functions = $%04X\n",jptab);
						res=find_skel(pc6001_60_page);
						if (res>0)
							jptab=0x134+0xB7;
					}
					new_tk_found=0;
					printf("\n-- FUNCTIONS --\n");
				}
				c=img[i];
				if (c>=128) {
					c-=128; 
					if ((jptab>0) && !(new_tk_found)) {
						printf("\n$%04X - [%d] ", img[jptab-pos]+256*img[jptab-pos+1], chr);
						jptab+=2;
					} else
						printf("\n\t %d  ",chr);
					chr++;
				}
				printf("%c",c);
			}		
		}
	}


   	/**************************/
	/* Sinclair BASIC section */
	/**************************/
	
	res=find_skel(makeroom_skel);
	
	if (res>0) {
		printf("\nSinclair BASIC found\n");
		brand=find_skel(sinclair_skel);
		if (brand>0)
			printf("  Sinclair signature found\n");
		else {
			brand=find_skel(amstrad_skel);
			if (brand>0)
				printf("  Amstrad signature found\n");
		}
		
		brand=0;
		printf("\n\tSTKEND system variable = %d  ; ",res);
			switch (res) {
				case 16400:
					printf ("ZX80 System Variables mode\n");
					brand=ZX80;
					break;
				case 16412:
					printf ("ZX81 System Variables mode\n");
					brand=ZX81;
					break;
				case 23653:
					res=find_skel(tk2068_skel);
					if (res < 0) {
						printf ("ZX Spectrum System Variables mode\n");
						brand=SPECTRUM;
					} else {
						printf ("TS2068 System Variables mode\n");
						brand=TS2068;
					}
					break;
				default:
					printf ("Unknown System Variables mode\n");
					break;
			}
		res=find_skel(prog_skel);
		if (res<0)
			res=find_skel(prog_skel2);
		if (res>0)
			printf("\n\tPROG    = $%04X  ; BASIC program start",res);
			switch (res) {
				case 0x4396:
					printf (" - LAMBDA style addressing");
					brand=LAMBDA;
					break;
				case 0x407d:
					printf (" - ZX81 style addressing");
					brand=ZX81;
					break;
				case 23653:
					printf (" ptr - ZX Spectrum style addressing");
					brand=SPECTRUM;
					break;
				default:
					break;
			}

		res=find_skel(vars_skel);
		if (res<0)
			res=find_skel(vars_skel2);
		if (res>0)
			printf("\n\tVARS    = $%04X  ; BASIC variables ptr",res);

		res=find_skel(eline_skel);
		if (res<0)
			res=find_skel(eline_skel2);
		if (res>0)
			printf("\n\tE-LINE  = $%04X  ; Ptr to line being edited",res);

		res=find_skel(seed_skel);
		if (res>0)
			printf("\n\tSEED    = $%04X  ; 'SEED' for RND function",res);
		
		printf("\n");

		res=find_skel(next_one_skel);
		if (res<0)
			res=find_skel(next_one_skel2);
		if (res>0)
			printf("\n\tNEXT-ONE  = $%04X  ; Find next variable or program line",res);
		
		res=find_skel(restack_skel);
		if (res>0)
			printf("\n\tZXFP_DO_RESTACK   = $%04X  ; Not on ZX81",res+1);
	
		printf("\n");

		res=find_skel(stk_pntr_skel);
		if (res>0)
			printf("\n\tZXFP_STK_PTR   = $%04X\n",res);

		res=find_skel(stk_st_skel);
		if (res>0)
			printf("\n\tZXFP_STK_STORE = $%04X",res);

		res=find_skel(test5fp_skel);
		if (res<0) 
			res=find_skel(test5fp_skel2);
		if (res>0)
			printf("\n\tZXFP_TEST_5_FP = $%04X",res);
		
		res=find_skel(stkstr_skel);
		if (res>0)
			printf("\n\tZXFP_STK_STR   = $%04X",res);
		
		res=find_skel(stkftch_skel);
		if (res<0)
				res=find_skel(stkftch_skel2);
		if (res>0)
			printf("\n\tZXFP_STK_FETCH = $%04X",res);

		res=find_skel(stka_skel);
		if (res>0)
			printf("\n\tZXFP_STACK_A   = $%04X",res);
		
		res=find_skel(stkbc_skel);
		if (res>0)
			printf("\n\tZXFP_STACK_BC  = $%04X",res);

		res=find_skel(fpbc_skel);
		if (res<0)
			res=find_skel(fpbc_skel2);
		if (res>0)
			printf("\n\tZXFP_FP_TO_BC  = $%04X",res);

		res=find_skel(intfp_skel);
		if (res<0)
			res=find_skel(intfp_skel2);
		if (res>0)
			printf("\n\tZXFP_INT_TO_FP = $%04X",res);

		res=find_skel(decfp_skel);
		if (res>0)
			printf("\n\tZXFP_DEC_TO_FP = $%04X",res);


		printf("\n");
		
		res=find_skel(zxfpmod_skel);
		if (res<0)
			res=find_skel(zxfpmod_skel2);
		if (res>0) {
			if (img[res-1] & 0xC7 == 0xC7)
				printf("\n\tZXFP_BEGIN_CALC  = $%02X\n",img[res-1] & 0x38);
			if (img[res+12]==img[res+33]) {
				printf("\n\tZXFP_END_CALC   = $%02X",img[res+12]);
				printf("\n\tZXFP_DELETE     = $%02X",img[res+1]);
				printf("\n\tZXFP_DUPLICATE  = $%02X",img[res+2]);
				printf("\n\tZXFP_SUBTRACT   = $%02X",img[res+11]);
				printf("\n\tZXFP_DIVISION   = $%02X",img[res+4]);
				printf("\n\tZXFP_MULTIPLY   = $%02X",img[res+9]);
				printf("\n\tZXFP_EXCHANGE   = $%02X",img[res+7]);
				printf("\n\tZXFP_INT        = $%02X",img[res+5]);
				printf("\n\tZXFP_ST_MEM_0   = $%02X",img[res]);
				printf("\n\tZXFP_GET_MEM_0  = $%02X",img[res+3]);
				printf("\n\tZXFP_LESS_0     = $%02X",img[res+16]);
				printf("\n\tZXFP_JUMP_TRUE  = $%02X",img[res+17]);
				printf("\n\tZXFP_TRUNCATE   = $%02X",img[res+19]);
				printf("\n\tZXFP_NOT        = $%02X",img[res+28]);
				printf("\n\tZXFP_STK_ONE    = $%02X",img[res+31]);
			}
			if (img[res+12]==img[res+87]) {
				printf("\n\tZXFP_ADDITION   = $%02X",img[res+49]);
				printf("\n\tZXFP_STK_DATA   = $%02X",img[res+36]);
				printf("\n\tZXFP_ST_MEM_3   = $%02X",img[res+46]);
				printf("\n\tZXFP_GET_MEM_3  = $%02X",img[res+86]);
				printf("\n\tZXFP_SERIES_08  = $%02X",img[res+52]);
				printf("\n");				
				printf("\n\tZXFP_FP_TO_A  = $%04X",img[res+89]+256*img[res+90]);
			}

		}
		
		res=find_skel(rnd_skel);
		if (res>0) {
			printf("\n");
			printf("\n\tZXFP_STK_ONE    = $%02X",img[res+1]);
			printf("\n\tZXFP_STK_DATA   = $%02X",img[res+3]);
			printf("\n\tZXFP_N_MOD_M    = $%02X",img[res+13]);
			if (img[res+18]==img[res+42]) {
				printf("\n\tZXFP_STK_PI_D_2 = $%02X",img[res+13]);
			}
		}

		/* Sinclair BASIC Commands */
	
		switch (brand) {
			
			case LAMBDA:
				res=find_skel(tklambda_skel);
				if (res>0) {
					printf("\n\n\nTOKEN table position = $%04X\n",res);
					printf("\n\t--- ");
					chr=192;
					for (i=res; (img[i]!=0xCD)!=0; i++) {
						c=img[i] & 0xBF;
						if (chr==256)  chr=64;
						if (c>=128) { c-=128; printf("%c \n\t%d ",zx81char(c), chr++); }
						else printf("%c",zx81char(c));
					}
				}
				break;

			case ZX81:
				res=find_skel(tkzx81_skel);
				if (res>0) {
					printf("\n\n\nTOKEN table position = $%04X\n",res);
					printf("\n\t--- ");
					chr=192;
					for (i=res; (img[i]!=0x23)!=0; i++) {
						c=img[i] & 0xBF;;
						if (chr==256) chr=64;
						if (c>=128) { c-=128; printf("%c \n\t%d ",zx81char(c), chr++); }
						else printf("%c",zx81char(c));
					}
				}
				break;
				
			case TS2068:
				res=find_skel(tk2068_skel);
				if (res>0) {
					printf("\n\n\nTOKEN table position = $%04X\n",res);
					printf("\n\t--- ");
					chr=165;
					for (i=res; (chr<263)!=0; i++) {
						c=img[i];
						if (c>=128) {
							c-=128;
							if (chr<=255)
								printf("%c \n\t%d ",c, chr++);
							else {
								printf("%c \n\t    ",c);
								chr++;
							}
						}
						else printf("%c",c);
					}
				}

			default:
				res=find_skel(tkspectrum_skel);
				if (res>0) {
					printf("\n\n\nTOKEN table position = $%04X\n",res);
					printf("\n\t--- ");
					chr=165;
					if (len>16384) res+=16384;
					if (len>32768) res+=32768;
					for (i=res; (chr<=256)!=0; i++) {
						c=img[i];
						if (c>=128) { c-=128; printf("%c \n\t%d ",c, chr++); }
						else printf("%c",c);
					}
					res=find_skel(tkzx128_skel);
					
					printf("\n\t    ");
					
					if (res>0) {
						for (i=res; (img[i]>2); i++) {
							c=img[i];
							if (c>=128) { c-=128; printf("%c\n\t    ",c); }
							else printf("%c",c);
						}
					}			
				}
				break;
		}

	}

	
	res=find_skel(zxshadow_end);
	
	if (res>0) {
		printf("\nShadow memory for ZX Spectrum ROM found\n");
		
		printf("\n\tZX_SHADOW_END  =  $%04X    ; Return to the BASIC interpreter\n",res);
		
	}

	printf("\n\n");

	fclose(fpin);
}


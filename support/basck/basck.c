/*
 *   ROM Basic analyzer, by Stefano Bodrato, APR 2016
 *
 *   This tool looks for known 'fingerprints' in the code and tries to identify
 *   function entry points and to provide a cross-reference for further ROM analysis.
 *
 *   It works with either Sinclair or Microsoft ROMs, giving hints to set-up a brand new
 *   target port or to just extend it with an alternative shortcuts (i.e. in the FP package).
 *
 *   $Id: basck.c,v 1.19 2017-01-09 09:35:42 stefano Exp $
 */

unsigned char  *img;
long  len, pos, pos2;
long  jptab;
int  l;
char token[1000];
int address;

/* For the SKOOL mode, refer to:  http://pythonhosted.org/skoolkit */
/* usage example in skool mode:
		basck -ctl p2000.bin > p2000.ctl
		---> we look into the created file and see:  "(Detected position for ORG:  4096)"
		python sna2skool.py p2000.bin -o 4096 -h > p2000.skool    <--  it will pick the "ctl" file automatically, use '.bin' extension for the original binary file
		python skool2asm.py -H -c p2000.skool > p2000.asm
		
		
  Getting the most from the SkoolKit automations:
  (always use '.bin' extension for the original binary file)
   
	python sna2skool.py p2000.bin -g p2000.ct -o 4096 -h > /dev/null   <- prepare a control file automatically (use basck to check the position for ORG)
	basck -ctl p2000.bin > p2000.ctl                                        <- get extra infos from the basck tools
	cat p2000.ct >> p2000.ctl                                          <- merge it all
	python sna2skool.py p2000.bin -o 4096 -h > p2000.skool             <- do the final run
	python skool2asm.py -H -c p2000.skool > p2000.asm
	

  If you wish you may add more detail using the already existing z88dk DEF files, e.g.:
	awk {'print "@ " $4 " label="$2'} /z88dk/lib/msxbios.def >> msx.ctl
	awk -F "[=;]" {'print "D " $2 $3'}  /z88dk/lib/msxbios.def >> msx.ctl
  
*/


int SKOOLMODE = -1;


#include <stdio.h>
#include <string.h>
/* stdlib.h MUST be included to really open files as binary */
#include <stdlib.h>
#include <malloc.h>

#define SKIP -1
#define CATCH -2
#define ADDR -3
#define CATCH_CALL -4
#define SKIP_CALL -5
#define SKIP_JP_RET -6

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
int restore_bastxt_skel[]={14, 0xEB, 0x2A, CATCH, CATCH, 0x28, 0x0E, 0xEB, SKIP_CALL, 0xE5, SKIP_CALL, 0x60, 0x69, 0xD1, 0xD2};
int microsoft_skel[]={9, CATCH, 'i', 'c', 'r', 'o', 's', 'o', 'f', 't'};
int bastxt_skel[]={8, 0x2A, CATCH, CATCH, 0x44, 0x4D, 0x7E, 0x23, 0xB6, 0x2B, 0xC8, 0x23, 0x23, 0x7E, 0x23, 0x66};
int bastxt_skel2[]={11, SKIP_JP_RET, 0xC0, 0x2A, CATCH, CATCH, 0xAF, 0x77, 0x23, 0x77, 0x23, 0x22 };

int microsoft_extended_skel[]={11, ADDR, 0xFE, '%', 0xC8, 0x14, 0xFE, '$', 0xC8, 0x14, 0xFE, '!'};
int microsoft_defdbl_skel[]={7, ADDR, 'D', 'E', 'F', 'D', 'B', 'L'};
int microsoft_defdbl_skel2[]={7, ADDR, 'D'+0x80, 'E', 'F', 'D', 'B', 'L'};
int microsoft_defdbl_skel3[]={6, ADDR, 'E', 'F', 'D', 'B', 'L'+0x80};


/* Microsoft BASIC code inspection */
int ulerr_skel[]={9, SKIP_CALL, 0xE5, SKIP_CALL, 0x60, 0x69, 0xD1, 0xD2, CATCH, CATCH};
int prognd_skel[]={8, 0xEB, 0x2A, CATCH, CATCH, 0x1A, 0x02, 0x03, 0x13};
int prognd_skel2[]={13, SKIP_JP_RET, 0xC0, 0x2A, SKIP, SKIP, 0xAF, 0x77, 0x23, 0x77, 0x23, 0x22, CATCH, CATCH };
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

int mlsp10_skel[]={11, ADDR, SKIP_CALL, 0x78, 0xB7, 0xC8, 0xC6, 2, 0xDA,  SKIP, SKIP, 0x47};
int mlsp10_skel2[]={10, ADDR, SKIP_CALL, 0x78, 0xB7, 0xC8, 0xC6, 2, 0x38, SKIP, 0x47};


/* nxtopr_skel2 checked in OPNPAR first */
int nxtopr_skel2[]={8, 0x16,  0x7D, SKIP_CALL, 0x2A,  CATCH, CATCH, 0xE5, 0xCD};

/* chkstk_skel checked in OPNPAR first */
int chkstk_skel2[]={10, ADDR, 0xE5, 0x2A,  SKIP, SKIP, 6, 0, 9, 9, 0x3E};
int arrend_skel3[]={9, 0xE5, 0x2A,  CATCH, CATCH, 6, 0, 9, 9, 0x3E};

int arrend_skel[]={13, 0x22, CATCH, CATCH, 0x60, 0x69, 0x22, SKIP, SKIP, 6, 6, 0x2B, 0x36, 0};
int varend_skel[]={13, 0x22, SKIP, SKIP, 0x60, 0x69, 0x22, CATCH, CATCH, 6, 6, 0x2B, 0x36, 0};
int arrend_skel2[]={13, 0xE1, 0x22, CATCH, CATCH, 0x60, 0x69, 0x22, SKIP, SKIP, 0x2B, 0x36, 0, SKIP_CALL};
int varend_skel2[]={13, 0xE1, 0x22, SKIP, SKIP, 0x60, 0x69, 0x22, CATCH, CATCH, 0x2B, 0x36, 0, SKIP_CALL};

int fpadd_skel[]={14, 0xCD, SKIP, ADDR, 0x3A,  SKIP, SKIP, 0xB7, 0xC8, 0x3A,  SKIP, SKIP, 0x18, 1, 0x2F};
int fpadd_skel2[]={14, 0xCD, SKIP, ADDR, 0x78, 0xB7, 0xC8, 0x3A,  SKIP, SKIP, 0xB7, 0xCA, SKIP, SKIP, 0x90};

int last_fpreg_skel[]={11, 0x3A,  CATCH, CATCH, 0xB7, 0xC8, 0x3A,  SKIP, SKIP, 0x18, 1, 0x2F};


int getvar_skel[]={4, SKIP_CALL, ',', CATCH_CALL, 0xE3};
int getvar_skel2[]={6, CATCH_CALL, 0xE3, 0xD5, 0x7E, 0xFE, ','};
/* chksyn_skel checked in OPNPAR first */
int chksyn_skel2[]={4, CATCH_CALL, ',', SKIP_CALL, 0xE3};
int chksyn_skel3[]={4, CATCH_CALL, ',', SKIP_CALL, 0x28};

int lfrgnm_skel[]={10, 0x3E, '(', 0x18, ADDR, 0x3E, ')', 0x18, 0x0a, 0x3E, 0x88};
int lfrgnm_skel2[]={9, ADDR, 0xEB, SKIP_CALL, ')', 0xC1, 0xD1, 0xC5, 0x43, 0xC9};

int midnum_skel[]={8, 0xEB, SKIP_CALL, ')', ADDR, 0xD1, 0xC5, 0x43, 0xC9};

int getchr_skel3[]={12, ADDR, 0x23, 0x7E, 0xFE, ':', 0xD0, 0xFE, ' ', 0xCA, SKIP, SKIP, 0xFE};
int getchr_skel4[]={11, ADDR, 0x23, 0x7E, 0xFE, ':', 0xD0, 0xFE, ' ', 0x28, SKIP, 0xFE};
int getchr_skel5[]={10, ADDR, 0x23, 0x7E, 0xFE, ' ', 0x28, SKIP, 0xFE, ':', 0xD0};

int getchr_skel[]={12,  CATCH_CALL, SKIP_CALL, SKIP_CALL, 0x7A, 0xB7, 0xC2, SKIP, SKIP, 0x2B, SKIP_CALL, 0x7B, 0xC9};
int getchr_skel2[]={11, CATCH_CALL, SKIP_CALL, SKIP_CALL, 0x7A, 0xB7, 0xC4, SKIP, SKIP, SKIP_CALL, 0x7B, 0xC9};

/* 'EVAL' in later BASIC versions */
int getnum_skel[]={11,             CATCH_CALL, SKIP_CALL, 0x7A, 0xB7, 0xC2, SKIP, SKIP, 0x2B, SKIP_CALL, 0x7B, 0xC9};
int getnum_skel2[]={10,            CATCH_CALL, SKIP_CALL, 0x7A, 0xB7, 0xC4, SKIP, SKIP, SKIP_CALL, 0x7B, 0xC9};
int getnum_skel3[]={9,  SKIP_CALL, CATCH_CALL, SKIP_CALL, 0xC2, SKIP, SKIP, 0x2B, SKIP_CALL, 0x7B, 0xC9};

int eval3_ex_skel[]={13, ADDR, 0x2A, SKIP, SKIP, 0xC1, 0x7E, 0x22, SKIP, SKIP, 0xFE, SKIP, 0xD8, 0xFE};
int eval3_body_skel[]={14, ADDR, 0x3A, SKIP, SKIP, 0xFE, 3, 0x7B, 0xCA, SKIP, SKIP, 0xFE, SKIP, 0xD0, 33};

int depint_skel[]={11,              SKIP_CALL, CATCH_CALL, 0x7A, 0xB7, 0xC2, SKIP, SKIP, 0x2B, SKIP_CALL, 0x7B, 0xC9};
int depint_skel2[]={10,             SKIP_CALL, CATCH_CALL, 0x7A, 0xB7, 0xC4, SKIP, SKIP, SKIP_CALL, 0x7B, 0xC9};
int depint_skel3[]={9,  SKIP_CALL,  SKIP_CALL, CATCH_CALL, 0xC2, SKIP, SKIP, 0x2B, SKIP_CALL, 0x7B, 0xC9};

int getk_skel[]={12, CATCH_CALL, 0x2A, SKIP, SKIP, 0xC5, SKIP_CALL, 0xC1, 0xC0, 0x2A, SKIP, SKIP, 0x85};
int rinput_skel[]={9, 0x3E, '?', SKIP_CALL, 0x3E, ' ', SKIP_CALL, 0xC3, CATCH, CATCH};
int rinput_skel2[]={7, 0x3E, '?', SKIP_CALL, 0x3E, ' ', SKIP_CALL, CATCH_CALL};
int rinput_skel3[]={7, 0x3E, '?', SKIP, 0x3E, ' ', SKIP, CATCH_CALL};
int rinput_skel4[]={14, 0x3E, '?', SKIP_CALL, 0x3E, ' ', SKIP_CALL, 0x18, SKIP, SKIP, SKIP, 0xC3, SKIP, SKIP, ADDR};

/* High precision BASIC constants present only in the latest versions*/
int log10eval_skel[]={9, ADDR, 0x40,0x43,0x42,0x94,0x48,0x19,0x03,0x24};
int halfval_skel[]={11, ADDR, 0x40,0x50,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
int unityval_skel[]={9, ADDR, 0x41,0x10,0x00,0x00,0x00,0x00,0x00,0x00};
int quarterval_skel[]={9, ADDR, 0x40,0x25,0x00,0x00,0x00,0x00,0x00,0x00};
int tenhalfval_skel[]={9, ADDR, 0x41,0x31,0x62,0x27,0x76,0x60,0x16,0x84};
int twoln10val_skel[]={9, ADDR, 0x40,0x86,0x85,0x88,0x96,0x38,0x06,0x50};
int ln10val_skel[]={9, ADDR, 0x41,0x23,0x02,0x58,0x50,0x92,0x99,0x40};
int tan15val_skel[]={9, ADDR, 0x40,0x26,0x79,0x49,0x19,0x24,0x31,0x12};
int sqr3val_skel[]={9, ADDR, 0x41,0x17,0x32,0x05,0x08,0x07,0x56,0x89};
int sixthpival_skel[]={9, ADDR, 0x40,0x52,0x35,0x98,0x77,0x55,0x98,0x30};
int halfpival_skel[]={9, ADDR, 0x41, 0x15, 0x70, 0x79, 0x63, 0x26, 0x79, 0x49};
int epsilonval_skel[]={9, ADDR, 0x40, 0x15, 0x91, 0x54, 0x94, 0x30, 0x91, 0x90};
int logtabval_skel[]={10, ADDR, 4,0xc0,0x71,0x43,0x33,0x82,0x15,0x32,0x26};
int sintabval_skel[]={10, ADDR, 8,0xC0,0x69,0x21,0x56,0x92,0x29,0x18,0x09};
int atntabval_skel[]={10, ADDR, 8,0xBF,0x52,0x08,0x69,0x39,0x04,0x00,0x00};


int halfpi_skel[]={11, 0x21, CATCH, CATCH, SKIP_CALL, SKIP_CALL, 1, 0x49, 0x83, SKIP, 0xDB, 0x0F};
int addphl_skel[]={11, 0x21, SKIP, SKIP, CATCH_CALL, SKIP_CALL, 0X01, 0x49, 0x83, SKIP, 0xDB, 0x0F};
int cos_skel[]={11, ADDR, SKIP, SKIP, SKIP_CALL, SKIP_CALL, 0X01, 0x49, 0x83, SKIP, 0xDB, 0x0F};
int sin_skel[]={13, 0x21, SKIP, SKIP, SKIP_CALL, ADDR, SKIP, SKIP, 0X01, 0x49, 0x83, SKIP, 0xDB, 0x0F};

int cos_skel3[]={20, ADDR, SKIP, SKIP, SKIP_CALL, 0x21, SKIP, SKIP, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, SKIP_CALL, 0xF5, 0xFA};
int sin_skel3[]={22, 0x21, SKIP, SKIP, SKIP_CALL, 0x21, SKIP, SKIP, ADDR, SKIP, SKIP, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, SKIP_CALL, 0xF5, 0xFA};

int halfpi_skel3[]={13, 0x21, CATCH, CATCH, SKIP_CALL, 0x3A, SKIP, SKIP, 0xE6, 0x7F, 0x32, SKIP, SKIP, 33};
int addphl_skel3[]={12, SKIP, SKIP, CATCH_CALL, 0x3A, SKIP, SKIP, 0xE6, 0x7F, 0x32, SKIP, SKIP, 33};
int cos_skel4[]={13, ADDR, SKIP, SKIP, SKIP_CALL, 0x3A, SKIP, SKIP, 0xE6, 0x7F, 0x32, SKIP, SKIP, 33};
int sin_skel4[]={20, 0x21, SKIP, SKIP, SKIP_CALL, 0x3A, SKIP, SKIP, 0xE6, 0x7F, 0x32, SKIP, SKIP, 33, SKIP, SKIP, SKIP_CALL, SKIP_CALL, 0x18, SKIP, ADDR};

int halfpi_skel2[]={20, 0x21, CATCH, CATCH, SKIP_CALL, 0x21, SKIP, SKIP, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, SKIP_CALL, 0xF5, 0xFA};
int addphl_skel2[]={20, 0x21, SKIP, SKIP, CATCH_CALL, 0x21, SKIP, SKIP, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, SKIP_CALL, 0xF5, 0xFA};

int atn_skel[]={13, ADDR, SKIP_CALL, 0xFC, SKIP, SKIP, 0xFC, SKIP, SKIP, 0X3A, SKIP, SKIP, 0xFE, 0x81};
int negaft_skel[]={12, SKIP_CALL, 0xFC, CATCH, CATCH, 0xFC, SKIP, SKIP, 0X3A, SKIP, SKIP, 0xFE, 0x81};
int invsgn_skel[]={12, SKIP_CALL, 0xFC, SKIP, SKIP, 0xFC, CATCH, CATCH, 0X3A, SKIP, SKIP, 0xFE, 0x81};
int invsgn_skel2[]={8, 0x16,  0x7D, SKIP_CALL, 0x2A,  SKIP, SKIP, 0xE5, CATCH_CALL};
int atn_skel2[]={15, ADDR, 0x3A, SKIP, SKIP, 0xB7, 0xC8, 0xFC, SKIP, SKIP, 0xFE, 0x41, 0xDA, SKIP, SKIP, SKIP_CALL};
int negaft_skel2[]={14, 0x3A, SKIP, SKIP, 0xB7, 0xC8, 0xFC, CATCH, CATCH, 0xFE, 0x41, 0xDA, SKIP, SKIP, SKIP_CALL};

int dbldiv_skel[]={16, 0xB7, 0xC8, 0xFC, SKIP, SKIP, 0xFE, 0x41, 0xDA, SKIP, SKIP, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, CATCH_CALL};

int exp_skel[]={9, ADDR, SKIP_CALL, 1, 0x38, 0x81, 17, 0X3B, 0xAA, SKIP_CALL};
int fpmult_skel[]={7, 1, 0x38, 0x81, 17, 0X3B, 0xAA, CATCH_CALL};

int abs_skel[]={10, ADDR, SKIP_CALL, 0xF0, 33, SKIP, SKIP, 0x7E, 0xEE, 0x80, 0x77};
int abs_skel2[]={10, ADDR, SKIP, 0xF0, 33, SKIP, SKIP, 0x7E, 0xEE, 0x80, 0x77};
int abs_skel3[]={14, ADDR, SKIP_CALL, 0xF0, SKIP, 0xFA, SKIP, SKIP, 0xCA, SKIP, SKIP, 33, SKIP, SKIP, 0x7E};

int tstsgn_loc_skel[]={9, CATCH_CALL, 0xF0, 33, SKIP, SKIP, 0x7E, 0xEE, 0x80, 0x77};
int tstsgn_loc_skel2[]={13, CATCH_CALL, 0xF0, SKIP, 0xFA, SKIP, SKIP, 0xCA, SKIP, SKIP, 33, SKIP, SKIP, 0x7E};

int ms_rnd_skel[]={11, ADDR, SKIP_CALL, 0xFA, SKIP, SKIP, 33, SKIP, SKIP, SKIP_CALL, 0xC8, 1};
int ms_rnd_skel2[]={16, ADDR, SKIP_CALL, 33, SKIP, SKIP, 0xFA, SKIP, SKIP, 33, SKIP, SKIP, SKIP_CALL, 33, SKIP, SKIP, 0xC8};

int ms_rnd_seed[]={15, SKIP_CALL, 33, CATCH, CATCH, 0xFA, SKIP, SKIP, 33, SKIP, SKIP, SKIP_CALL, 33, SKIP, SKIP, 0xC8};
int ms_lstrnd[]={15, SKIP_CALL, 33, SKIP, SKIP, 0xFA, SKIP, SKIP, 33, CATCH, CATCH, SKIP_CALL, 33, SKIP, SKIP, 0xC8};
int ms_lstrnd2[]={10, SKIP_CALL, 0xFA, SKIP, SKIP, 33, CATCH, CATCH, SKIP_CALL, 0xC8, 1};

int last_fpreg_skel2[]={13, SKIP_CALL, 0xF0, SKIP, 0xFA, SKIP, SKIP, 0xCA, SKIP, SKIP, 33, CATCH, CATCH, 0x7E};
int dblabs_skel[]={13, SKIP_CALL, 0xF0, SKIP, 0xFA, CATCH, CATCH, 0xCA, SKIP, SKIP, 33, SKIP, SKIP, 0x7E};

int dblabs_skel2[]={10, ADDR, 0x2A, SKIP, SKIP, SKIP_CALL, 0x7C, 0xEE, 0x80, 0xB5, 0xC0};
int dblfpreg_skel[]={9, 0x2A, CATCH, CATCH, SKIP_CALL, 0x7C, 0xEE, 0x80, 0xB5, 0xC0};
int dbl_tstsgn_skel3[]={6, CATCH_CALL, 0x6F, 0x17, 0x9F, 0x67, 0xC3};
 
int dbl_tstsgn_skel[]={13, CATCH_CALL, 0xF0, SKIP, 0xFA, SKIP, SKIP  ,0xCA, SKIP, SKIP, 33, SKIP, SKIP, 0x7E};
int dbl_tstsgn_skel2[]={9, CATCH_CALL, 0xF0, 33, SKIP, SKIP, 0x7E, 0xEE, 0x80, 0x77};

int test_type_skel[]={9, CATCH_CALL, 0xCA, SKIP, SKIP, 0xF2, SKIP, SKIP, 0x2A, SKIP, SKIP, 0x7C, 0xB5, 0xC8 ,0x7C, 0x18};

int log_skel[]={13, ADDR, SKIP_CALL, 0xB7, 0xEA, SKIP, SKIP, 33, SKIP, SKIP, 0x7E, 1, SKIP, 0x80};
int log_skel2[]={10, ADDR, SKIP_CALL, 0xB7, 0xEA, SKIP, SKIP, SKIP_CALL, 1, SKIP, 0x80};
int log_skel3[]={13, ADDR, SKIP_CALL, 0xB7, 0xEC, SKIP, SKIP, 33, SKIP, SKIP, 0x7E, 1, SKIP, 0x80};
int log_skel4[]={10, ADDR, SKIP, 0xB7, 0xEA, SKIP, SKIP, SKIP_CALL, 1, SKIP, 0x80};
int log_skel5[]={13, ADDR, SKIP, 0xB7, 0xEA, SKIP, SKIP, 33, SKIP, SKIP, 0x7E, 1, SKIP, 0x80};
int log_skel6[]={14, ADDR, SKIP_CALL, 0xFA, SKIP, SKIP, 0xCA, SKIP, SKIP, 33, SKIP, SKIP, 0x7E, 0xF5, 0x36};
int fcerr_skel[]={12, SKIP_CALL, 0xB7, 0xEA, CATCH, CATCH, 33, SKIP, SKIP, 0x7E, 1, SKIP, 0x80};
int fcerr_skel2[]={12, SKIP_CALL, 0xB7, 0xEA, CATCH, CATCH, 33, SKIP, SKIP, 0x7E, 1, SKIP, 0x80};
int fcerr_skel3[]={12, SKIP_CALL, 0xB7, 0xEC, CATCH, CATCH, 33, SKIP, SKIP, 0x7E, 1, SKIP, 0x80};
int fcerr_skel4[]={13, SKIP_CALL, 0xFA, CATCH, CATCH, 0xCA, SKIP, SKIP, 33, SKIP, SKIP, 0x7E, 0xF5, 0x36};



int fpadd_skel3[]={13, CATCH_CALL, 0xC1, 0xD1, 0x04, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 33, SKIP, SKIP, 0xCD};
int fpadd_skel4[]={12, ADDR, 0xB7, 0xC8, 0x3A,  SKIP, SKIP, 0xB7, 0xCA,  SKIP, SKIP, 0x90, 0x30};
int dvbcde_skel[]={13, SKIP_CALL, 0xC1, 0xD1, 0x04, CATCH_CALL, 33, SKIP, SKIP, SKIP_CALL, 33, SKIP, SKIP, 0xCD};
int unity_skel[]={13, SKIP_CALL, 0xC1, 0xD1, 0x04, SKIP_CALL, 33, CATCH, CATCH, SKIP_CALL, 33, SKIP, SKIP, 0xCD};
int subphl_skel[]={13, SKIP_CALL, 0xC1, 0xD1, 0x04, SKIP_CALL, 33, SKIP, SKIP, CATCH_CALL, 33, SKIP, SKIP, 0xCD};
int logtab_skel[]={13, SKIP_CALL, 0xC1, 0xD1, 0x04, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 33, CATCH, CATCH, 0xCD};
int sumser_skel[]={13, SKIP_CALL, 0xC1, 0xD1, 0x04, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 33, SKIP, SKIP, CATCH_CALL};

int dvbcde_org_skel[]={13, ADDR, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 1, 0x38, 0x81, 17, SKIP, SKIP, SKIP_CALL, 33};


int tan_skel[]={10, ADDR, SKIP_CALL, SKIP_CALL, 0xC1, 0xE1, SKIP_CALL, 0xEB, SKIP_CALL, SKIP_CALL, 0xC3};
int tan_skel2[]={11, ADDR, SKIP_CALL, SKIP_CALL, 0xC1, 0xD1, 0xEB, SKIP_CALL, 0xEB, SKIP_CALL, SKIP_CALL, 0xC3};
int tan_skel3[]={12, ADDR, SKIP_CALL, SKIP_CALL, 0xC1, 0xDD, 0xE1, 0xD1, SKIP_CALL, 0xEB, SKIP_CALL, SKIP_CALL, 0xC3};

/* Removed to avoid false positive results */
//int sin_skel2[]={9, SKIP_CALL, CATCH_CALL, 0xC1, 0xE1, SKIP_CALL, 0xEB, SKIP_CALL, SKIP_CALL, 0xC3};
//int cos_skel2[]={9, SKIP_CALL, SKIP_CALL, 0xC1, 0xE1, SKIP_CALL, 0xEB, SKIP_CALL, CATCH_CALL, 0xC3};
int div_skel[]={11, SKIP_CALL, SKIP_CALL, 0xC1, 0xE1, SKIP_CALL, 0xEB, SKIP_CALL, SKIP_CALL, 0xC3, CATCH, CATCH};
int div_skel2[]={17, 1, 0x20, 0x84, 0xDD, 0x21, 0, 0, 17, 0, 0, 0xCD, SKIP, ADDR, 0xC1, 0xDD, 0xE1, 0xD1};

int fpbcde_skel2[]={10, SKIP_CALL, SKIP_CALL, 0xC1, 0xD1, 0xEB, SKIP_CALL, 0xEB, CATCH_CALL, SKIP_CALL, 0xC3};
int fpbcde_skel3[]={12, SKIP_CALL, 1, 0x20, 0x84, 0xDD, 0x21, 0, 0, 17, 0, 0, CATCH_CALL};
int fpbcde_skel4[]={11, SKIP_CALL, SKIP_CALL, 0xC1, 0xDD, 0xE1, 0xD1, SKIP_CALL, 0xEB, CATCH_CALL, SKIP_CALL, 0xC3};

int phltfp_skel[]={9, SKIP_CALL, 33, SKIP, SKIP, CATCH_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int phltfp_skel2[]={12, SKIP_CALL, 33, SKIP, SKIP, CATCH_CALL, 0x18, 3, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int phltfp_skel3[]={13, SKIP_CALL, 33, SKIP, SKIP, CATCH_CALL, 0xC3, SKIP, SKIP, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int phltfp_skel4[]={11, SKIP_CALL, 33, SKIP, SKIP, CATCH_CALL, 0xC1, 0xD1, SKIP_CALL, 0x28, SKIP, 0x78};
int phltfp_skel5[]={15, SKIP_CALL, 33, SKIP, SKIP, 0xFA, SKIP, SKIP, 33, SKIP, SKIP, CATCH_CALL, 33, SKIP, SKIP, 0xC8};
int phltfp_skel6[]={10, SKIP_CALL, 0xFA, SKIP, SKIP, 33, SKIP, SKIP, CATCH_CALL, 0xC8, 1};

int div10_skel[]={17, ADDR, SKIP_CALL, 1, SKIP, SKIP, 17, SKIP, SKIP, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0xCA, SKIP, SKIP, 0x2E, 0xFF};
int div10_skel2[]={17, ADDR, SKIP_CALL, 1, SKIP, SKIP, 17, SKIP, SKIP, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0xCC, SKIP, SKIP, 0x2E, 0xFF};
int div10_skel3[]={14, ADDR, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0xCA, SKIP, SKIP, 0x2E, 0xFF};
int div10_skel4[]={14, ADDR, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0xCC, SKIP, SKIP, 0x2E, 0xFF};
int div10_skel5[]={13, ADDR, SKIP_CALL, 1, 0x20, 0x84, 0xDD, 0x21, 0, 0, 17, 0, 0, SKIP_CALL};

int sqr_skel[]={10, ADDR, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int sqr_skel2[]={13, ADDR, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 0x18, 3, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int sqr_skel3[]={14, ADDR, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 0xC3, SKIP, SKIP, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int sqr_skel4[]={12, ADDR, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x28, SKIP, 0x78};
int sqr_skel5[]={12, ADDR, SKIP_CALL, 0xC8, 0xFA, SKIP, SKIP, SKIP_CALL, 0x3A, SKIP, SKIP, 0xB7, 0x1F};

int power_skel[]={11, SKIP_CALL, 33, SKIP, SKIP, 0xCD, SKIP, ADDR, 0xC1, 0xD1, SKIP_CALL, 0x78};
int power_skel2[]={12, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 0x18, ADDR, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int power_skel3[]={13, SKIP_CALL, 33, SKIP, SKIP, SKIP_CALL, 0xC3, SKIP, ADDR, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int power_skel4[]={13, SKIP_CALL, 33, SKIP, SKIP, 0xCD, SKIP, ADDR, 0xC1, 0xD1, SKIP_CALL, 0x28, SKIP, 0x78};
int half_skel[]={9, SKIP_CALL, 33, CATCH, CATCH, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int half_skel2[]={12, SKIP_CALL, 33, CATCH, CATCH, SKIP_CALL, 0x18, 3, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int half_skel3[]={13, SKIP_CALL, 33, CATCH, CATCH, SKIP_CALL, 0xc3, SKIP, SKIP, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x78};
int half_skel4[]={11, SKIP_CALL, 33, CATCH, CATCH, SKIP_CALL, 0xC1, 0xD1, SKIP_CALL, 0x28, SKIP, 0x78};

int bnorm_skel[]={12, ADDR, 0x68, 0x63, 0xAF, 0x47, 0x79, 0xB7, 0xC2, SKIP, SKIP, 0x4A, 0x54};
int bnorm_skel2[]={11, ADDR, 0x68, 0x63, 0xAF, 0x47, 0x79, 0xB7, 0x28, SKIP, 0x4A, 0x54};
int plucde_skel[]={11, ADDR, 0x7E, 0x83, 0x5F, 0x23, 0x7E, 0x8A, 0x57, 0x23, 0x7E, 0x89};
int compl_skel[]={12, ADDR, 33, SKIP, SKIP, 0x7E, 0x2F, 0x77, 0xAF, 0x6F, 0x90, 0x47, 0x7D};

int sgnres_skel[]={11, 33, CATCH, CATCH, 0x7E, 0x2F, 0x77, 0xAF, 0x6F, 0x90, 0x47, 0x7D};
int shrite_skel[]={13, 6, 0, 0xD6, 8, 0xDA, CATCH, CATCH, 0x43, 0x5A, 0x51, 0x0E, 0, 0xC3};
int shrite_skel2[]={9, ADDR, 0xC6, 9, 0x6F, 0xAF, 0x2D, 0xC8, 0x79, 0x1F};
int scale_skel[]={11, ADDR, 6, 0, 0xD6, 8, 0x38, SKIP, 0x43, 0x5A, 0x51, 0x0E, 0, 0xC3};
int scale_skel2[]={14, ADDR, 6, 0, 0xD6, 8, 0xDA, CATCH, CATCH, 0x43, 0x5A, 0x51, 0x0E, 0, 0xC3};
/*
SHRITE: ADD     A,8+1           ; Adjust count
        LD      L,A             ; Save bits to shift
SHRLP:  XOR     A               ; Flag for all done
        DEC     L               ; All shifting done?
        RET     Z               ; Yes - Return
        LD      A,C             ; Get MSB
SHRT1:  RRA                     ; Shift it right

*/
int fpthl_skel[]={10, ADDR, 17, SKIP, SKIP, 6, 4, 0x1A, 0x77, 0x13, 0x23};

/* connected to 'ASCTFP' */
int fpthl_skel2[]={9, SKIP_JP_RET, SKIP_CALL, SKIP_CALL, 0xE3, CATCH_CALL, 0xE1, 0xDD, 0xE1, SKIP_CALL};
int fpthl_skel3[]={12, SKIP_JP_RET, SKIP_CALL, SKIP_CALL, 0xE3, CATCH_CALL, 0xE1, 0x25, SKIP_CALL, 0xCA, SKIP, SKIP, 0xE3};

int for_skel[]={10, ADDR, 62, 0x64, 0x32, SKIP, SKIP, SKIP_CALL, 0xE3, SKIP_CALL, 0xD1};
int for_skel2[]={10, ADDR, 62, 0x64, 0x32, SKIP, SKIP, SKIP_CALL, 0xE3, 0xD1, 0xC2};
int for_skel3[]={12, ADDR, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0xED, 0x53, SKIP, SKIP, 0xE3, SKIP_CALL, 0xD1, 0x20};
int for_skel4[]={10, ADDR, 62, 0x64, 0x32, SKIP, SKIP, SKIP_CALL, 0xC1, 0xE5, SKIP_CALL};

int fdtlp_skel[]={10, ADDR, SKIP_CALL, 0xB7, 0xC2, SKIP, SKIP, 0x23, 0x7E, 0x23, 0xB6, 0x5E};
int fdtlp_skel2[]={9, ADDR, SKIP_CALL, 0xB7, 0x20, SKIP, 0x23, 0x7E, 0x23, 0xB6, 0x5E};
int fdtlp_skel3[]={9, ADDR, SKIP_CALL, 0xB7, 0xC2, SKIP, SKIP, 0x23, SKIP_CALL, 0x79, 0xB0};

int data_skel[]={9, CATCH_CALL, 0xB7, 0xC2, SKIP, SKIP, 0x23, 0x7E, 0x23, 0xB6, 0x5E};
int data_skel2[]={8, CATCH_CALL, 0xB7, 0x20, SKIP, 0x23, 0x7E, 0x23, 0xB6, 0x5E};
int data_skel3[]={9, CATCH_CALL, 0xB7, 0xC2, SKIP, SKIP, 0x23, SKIP_CALL, 0x79, 0xB0};

int restore_skel[]={14, ADDR, 0xEB, 0x2A, SKIP, SKIP, 0x28, 0x0E, 0xEB, SKIP_CALL, 0xE5, SKIP_CALL, 0x60, 0x69, 0xD1, 0xD2};

int dcbde_skel[]={8, ADDR, 0x1B, 0x7A, 0xA3, 0x3C, 0xC0, 0x0B, 0xC9};
int dblint_skel[]={9, ADDR, SKIP, 0xF8, 0x30, SKIP, 0x28, SKIP, SKIP_CALL, 33, SKIP, SKIP, 0x7E, 0xFE, 0x98}; 
int dblint_skel2[]={16, ADDR, SKIP_CALL, 0xF8, 0xD2, SKIP, SKIP, 0xCA, SKIP, SKIP, SKIP_CALL, 33, SKIP, SKIP, 0x7E, 0xFE, 0x98}; 

int fix_skel[]={10, ADDR, SKIP_CALL, 0xF8, SKIP_CALL, 0xF2, SKIP, SKIP, SKIP_CALL, SKIP_CALL, 0xC3};

int dblsub_skel[]={14, ADDR, 33, SKIP, SKIP, 0x7E, 0xEE, 0x80, 0x77, 33, SKIP, SKIP, 0x7E, 0xB7, 0xC8};
int dblsub_skel2[]={15, ADDR, 33, SKIP, SKIP, SKIP_CALL, 33, SKIP, SKIP, 0x7E, 0xB7, 0xC8, 0x47, 0x2B, 0x4E, 17};

int dbllast_fpreg_skel[]={13, 33, CATCH, CATCH, 0x7E, 0xEE, 0x80, 0x77, 33, SKIP, SKIP, 0x7E, 0xB7, 0xC8};

int dbladd_skel[]={13, 33, SKIP, SKIP, 0x7E, 0xEE, 0x80, ADDR,  33, SKIP, SKIP, 0x7E, 0xB7, 0xC8};
int dblmul_skel[]={9, ADDR, SKIP_CALL, 0xC8, SKIP_CALL, SKIP_CALL, 0x71, 0x13, 6, 7};
int dbldiv_skel2[]={13, ADDR, 0x3A, SKIP, SKIP, 0xB7, 0xCA, SKIP, SKIP, SKIP_CALL, 0x34, 0x34, SKIP_CALL, 33};

int int_skel[]={11, ADDR, 33, SKIP, SKIP, 0x7E, 0xFE, 0x98, 0x3A, SKIP, SKIP, 0xD0};

int mldebc_skel[]={10, 0xC1, 3, 0x71, 0xF5, 0x23, 0x70, 0x23, CATCH_CALL, 0xF1, 0x3D};
int mldebc_skel2[]={10, 0xC1, 3, 0x71, 0x23, 0x70, 0x23, 0xF5, CATCH_CALL, 0xF1, 0x3D};

int mldebc_skel3[]={9, ADDR, 33, 0, 0, 0x78, 0xB1, 0xC8, 0x3E, 0x10};

int intmul_skel[]={17, ADDR, 0x7C, 0xB5, 0xCA, SKIP, SKIP, 0xE5, 0xD5, SKIP_CALL, 0xC5, 0x44, 0x4D, 33, 0, 0, 0x3E, 0x10};

int asctfp_skel[]={10, ADDR, 0xFE, '-', 0xF5, 0xCA, SKIP, SKIP, 0xFE, '+', 0xCA};
int asctfp_skel2[]={9, ADDR, 0xFE, '-', 0xF5, 0x28, SKIP, 0xFE, '+', 0x28};

int hextfp_skel[]={12, ADDR, 17, 0, 0, SKIP_CALL, SKIP_CALL, 1, SKIP, SKIP, 0xFE, 0x42, 0x28};

int hex_asctfp_skel[]={15, ADDR, 0xFE, '&', 0xCA, SKIP, SKIP, 0xFE, '-', 0xF5, 0xCA, SKIP, SKIP, 0xFE, '+', 0xCA};
int hex_asctfp_skel2[]={14, ADDR, 0xFE, '&', 0xCA, SKIP, SKIP, 0xFE, '-', 0xF5, 0x28,       SKIP, 0xFE, '+', 0x28};

int dblasctfp_skel[]={11, ADDR, SKIP_CALL, SKIP_CALL, 0xF6, 0xAF, 0xEB, 1, 255, 0, 0x60, 0x68};
int dblasctfp_skel2[]={11, ADDR, 0xEB, 1, 0xFF, 0, 0x60, 0x68,  SKIP_CALL, 0xEB, 0x7E, 0xFE};

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
int tmpstr_skel3[]={13, SKIP_CALL, 33, CATCH, CATCH, 0xE5, 0x77, 0x23, 0x23, 0x73, 0x23, 0x72, 0xE1, 0xC9};

int fpreg_skel3[]={14, 17, SKIP, SKIP, 0x2A, SKIP, SKIP, 0x22, CATCH, CATCH, 0x3E, 1, 0x32, SKIP_CALL, SKIP_CALL};
int fpreg_skel4[]={13, 17, SKIP, SKIP, 0x3E, 0xD5, 0x2A, SKIP, SKIP, 0x22, CATCH, CATCH, 0x3E, 3};



int savstr_skel[]={17, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0xCD, SKIP, ADDR, 1, SKIP, SKIP,  0xC5, 0x7E, 0x23, 0x23, 0xE5, SKIP_CALL, 0xE1, 0x4E};
int savstr_skel2[]={15, SKIP_CALL, SKIP_CALL, 0xCD, SKIP, ADDR, 1, SKIP, SKIP,  0xC5, 0x7E, 0x23, 0xE5, SKIP_CALL, 0xE1, 0x4E};

int testr_skel[]={15, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, 1, SKIP, SKIP,  0xC5, 0x7E, 0x23, 0x23, 0xE5, CATCH_CALL, 0xE1, 0x4E};
int testr_skel2[]={13, SKIP_CALL, SKIP_CALL, SKIP_CALL, 1, SKIP, SKIP,  0xC5, 0x7E, 0x23, 0xE5, CATCH_CALL, 0xE1, 0x4E};
int testr_skel3[]={13, CATCH_CALL, 33, SKIP, SKIP, 0xE5, 0x77, 0x23, 0x23, 0x73, 0x23, 0x72, 0xE1, 0xC9};

int mktmst_skel[]={14, ADDR, SKIP_CALL, 33, SKIP, SKIP, 0xE5, 0x77, 0x23, 0x23, 0x73, 0x23, 0x72, 0xE1, 0xC9};
int mktmst_skel2[]={9, 0x3E, 1 , CATCH_CALL, SKIP_CALL, 0x2A, SKIP, SKIP, 0x73, 0xC1};
int makint_skel[]={9, 0x3E, 1 , SKIP_CALL, CATCH_CALL, 0x2A, SKIP, SKIP, 0x73, 0xC1};
int tstopl_skel3[]={12, 0x3E, 1, SKIP_CALL, SKIP_CALL, 0x2A, SKIP, SKIP, 0x73, 0xC1, 0xC3, CATCH, CATCH};
int tstopl_skel4[]={12, 0x3E, 1, SKIP_CALL, SKIP_CALL, 0x2A, SKIP, SKIP, 0x73, 0xC1, 0xE1, 0xC3, CATCH, CATCH};

int chr_skel[]={10, ADDR, 0x3E, 1 , SKIP_CALL, SKIP_CALL, 0x2A, SKIP, SKIP, 0x73, 0xC1};
int new_skel[]={13, 0xC3, SKIP, ADDR, 0xC0, 0x2A, SKIP, SKIP, 0xAF, 0x77, 0x23, 0x77, 0x23, 0x22 };
int new_skel2[]={12, 0x18, ADDR, 0xC0, 0x2A, SKIP, SKIP, 0xAF, 0x77, 0x23, 0x77, 0x23, 0x22 };
int new_skel3[]={14, ADDR, 0xC0, 0x2A, SKIP, SKIP, SKIP_CALL, 0x32, SKIP, SKIP, 0x77, 0x23, 0x77, 0x23, 0x22 };

int concat_skel[]={13, ADDR, 0xC5, 0xE5, 0x2A, SKIP, SKIP, 0xE3, SKIP_CALL, 0xE3, SKIP_CALL, 0x7E, 0xE5, 0x2A};

int oprnd_skel[]={12, 0xC5, 0xE5, 0x2A, SKIP, SKIP, 0xE3, CATCH_CALL, 0xE3, SKIP_CALL, 0x7E, 0xE5, 0x2A};
int tststr_skel[]={12, 0xC5, 0xE5, 0x2A, SKIP, SKIP, 0xE3, SKIP_CALL, 0xE3, CATCH_CALL, 0x7E, 0xE5, 0x2A};

int mktmst2_skel[]={13, CATCH_CALL, 0xD1, SKIP_CALL, 0xE3, SKIP_CALL, 0xE5, 0x2A, SKIP, SKIP, 0xEB, SKIP_CALL, SKIP_CALL, 33};
int sstsa_skel[]={13, SKIP_CALL, 0xD1, SKIP_CALL, 0xE3, SKIP_CALL, 0xE5, 0x2A, SKIP, SKIP, 0xEB, CATCH_CALL, SKIP_CALL, 33};
int tostra_skel[]={9, 0x46, 0x6F, ADDR, 0x2D, 0xC8, 0x0A, 0x12, 0x03, 0x13};

int topool_skel[]={15, SKIP_CALL, SKIP_CALL, SKIP_CALL, SKIP_CALL, 1, CATCH, CATCH,  0xC5, 0x7E, 0x23, 0x23, 0xE5, SKIP_CALL, 0xE1, 0x4E};
int topool_skel2[]={14, ADDR, SKIP_CALL, SKIP_CALL, SKIP_CALL, 1, CATCH, CATCH,  0xC5, 0x7E, 0x23, 0xE5, SKIP_CALL, 0xE1, 0x4E};

int opnpar_skel[]={12, ADDR, SKIP_CALL, '(', 0x2B, 0x16, 0, 0xD5, 0x0E, 1, SKIP_CALL, SKIP_CALL, 0x22};

int stkths_skel[]={15, ADDR, 0xC5, 1, SKIP, SKIP, 0xC5, 0x43, 0x4A, SKIP_CALL, 0x58, 0x51, 0x4E, 0x23, 0x46, 0x23};

int eval_skel[]={13, ADDR, 0x2B, 0x16, 0, 0xD5, 0x0E, 1, SKIP_CALL, SKIP_CALL, 0x22, SKIP, SKIP, 0x2A};
int eval_skel2[]={14, ADDR, 0x2B, 0x16, 0, 0xD5, 0x0E, 1, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0x22, SKIP, SKIP, 0x2A};
int eval_skel3[]={18, ADDR, 0x2B, 0x16, 0, 0xD5, 0x0E, 1, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0xAF, 0x32, SKIP, SKIP, 0x22, SKIP, SKIP, 0x2A};

int chksyn_skel[]={11, CATCH_CALL, '(', 0x2B, 0x16, 0, 0xD5, 0x0E, 1, SKIP_CALL, SKIP_CALL, 0x22};
int chkstk_skel[]={11, SKIP_CALL, '(', 0x2B, 0x16, 0, 0xD5, 0x0E, 1, CATCH_CALL, SKIP_CALL, 0x22};
int oprnd_skel2[]={11, SKIP_CALL, '(', 0x2B, 0x16, 0, 0xD5, 0x0E, 1, SKIP_CALL, CATCH_CALL, 0x22};
int nxtopr_skel[]={13, SKIP_CALL, '(', 0x2B, 0x16, 0, 0xD5, 0x0E, 1, SKIP_CALL, SKIP_CALL, 0x22, CATCH, CATCH};

int curpos_skel[]={15, 0x3A, CATCH, CATCH, 0x86, 0x3D, 0xB8, 0xD4, SKIP, SKIP, SKIP_CALL, 0xAF, 0xC4, SKIP, SKIP, 0xE1};
int curpos_skel2[]={11, 0x3A, CATCH, CATCH, 0x86, 0xB8, 0xD4, SKIP, SKIP, SKIP_CALL, 0x3E, 0x20};

int getint_skel[]={13, CATCH_CALL, 0x32, SKIP, SKIP, 0x32, SKIP, SKIP, SKIP_CALL, ',', 0xC3, SKIP, SKIP, SKIP_CALL};
int getint_skel2[]={12, CATCH_CALL, 0x32, SKIP, SKIP, 0x32, SKIP, SKIP, SKIP_CALL, ',', 0x18, SKIP, SKIP_CALL};
int getint_skel3[]={12, CATCH_CALL, 0x32, SKIP, SKIP, 0x32, SKIP, SKIP, SKIP_CALL, ',', 0x2B, 0x23, SKIP_CALL};
int getint_skel4[]={14, SKIP_CALL, ADDR, SKIP, SKIP, SKIP_CALL, 0x7A, 0xB7, 0xC2, SKIP, SKIP, 0x2B, SKIP_CALL, 0x7B, 0xC9};
int getint_skel5[]={13, SKIP_CALL, ADDR, SKIP, SKIP, SKIP_CALL, 0x7A, 0xB7, 0xC4, SKIP, SKIP, SKIP_CALL, 0x7B, 0xC9};
int getint_skel6[]={12, SKIP_CALL, ADDR, SKIP, SKIP, SKIP_CALL, 0xC2, SKIP, SKIP,  0x2B, SKIP_CALL, 0x7B, 0xC9};

int fndnum_skel[]={13, ADDR, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0x7A, 0xB7, 0xC2, SKIP, SKIP, 0x2B, SKIP_CALL, 0x7B, 0xC9};
int fndnum_skel2[]={12, ADDR, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0x7A, 0xB7, 0xC4, SKIP, SKIP, SKIP_CALL, 0x7B, 0xC9};
int fndnum_skel3[]={11, ADDR, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0xC2, SKIP, SKIP,  0x2B, SKIP_CALL, 0x7B, 0xC9};

int makint_skel2[]={14, SKIP_CALL, SKIP_CALL, ADDR, SKIP, SKIP, 0x7A, 0xB7, 0xC2, SKIP, SKIP, 0x2B, SKIP_CALL, 0x7B, 0xC9};
int makint_skel3[]={13, SKIP_CALL, SKIP_CALL, ADDR, SKIP, SKIP, 0x7A, 0xB7, 0xC4, SKIP, SKIP, SKIP_CALL, 0x7B, 0xC9};
int makint_skel4[]={12, SKIP_CALL, SKIP_CALL, ADDR, SKIP, SKIP, 0xC2, SKIP, SKIP,  0x2B, SKIP_CALL, 0x7B, 0xC9};

int getword_skel[]={8, CATCH_CALL, 0xD5, SKIP_CALL, ',', SKIP_CALL, 0xD1, 0x12, 0xc9};

/*
__POKE:
  CALL L542F   ; GETWORD <--
  PUSH DE
  RST SYNCHR        ; Check syntax: next byte holds the byte to be found
  INC L
  CALL GETINT
  POP DE
  LD (DE),A
  RET
  */

int inport_skel[]={13, SKIP_CALL, 0x32, CATCH, CATCH, 0x32, SKIP, SKIP, SKIP_CALL, ',', 0xC3, SKIP, SKIP, SKIP_CALL};
int otport_skel[]={13, SKIP_CALL, 0x32, SKIP, SKIP, 0x32, CATCH, CATCH, SKIP_CALL, ',', 0xC3, SKIP, SKIP, SKIP_CALL};
int inport_skel2[]={12, SKIP_CALL, 0x32, CATCH, CATCH, 0x32, SKIP, SKIP, SKIP_CALL, ',', 0x18, SKIP, SKIP_CALL};
int otport_skel2[]={12, SKIP_CALL, 0x32, SKIP, SKIP, 0x32, CATCH, CATCH, SKIP_CALL, ',', 0x18, SKIP, SKIP_CALL};
int inport_skel3[]={12, SKIP_CALL, 0x32, CATCH, CATCH, 0x32, SKIP, SKIP, SKIP_CALL, ',', 0x2B, 0x23, SKIP_CALL};
int otport_skel3[]={12, SKIP_CALL, 0x32, SKIP, SKIP, 0x32, CATCH, CATCH, SKIP_CALL, ',', 0x2B, 0x23, SKIP_CALL};


int outc_skel[]={15, 0x3A, SKIP, SKIP, 0x86, 0x3D, 0xB8, 0xD4, CATCH, CATCH, SKIP_CALL, 0xAF, 0xC4, SKIP, SKIP, 0xE1};
int prs_skel2[]={15, 0x3A, SKIP, SKIP, 0x86, 0x3D, 0xB8, 0xD4, SKIP, SKIP, CATCH_CALL, 0xAF, 0xC4, SKIP, SKIP, 0xE1};
int outc_skel2[]={12, 0x3A, SKIP, SKIP, 0x86, 0xB8, 0xD4, SKIP, SKIP, SKIP_CALL, 0x3E, 0x20, CATCH_CALL};

int prnums_skel[]={12, ADDR, 0x23, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0x1C, 0x1D, 0xC8, 0x0A, SKIP_CALL, 0xFE, 13};
int prnums_skel2[]={12, ADDR, 0x23, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0x14, 0x15, 0xC8, 0x0A, SKIP_CALL, 0xFE, 13};

int outc_skel3[]={11, 0x23, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0x1C, 0x1D, 0xC8, 0x0A, CATCH_CALL, 0xFE, 13};
int outc_skel4[]={11, 0x23, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0x14, 0x15, 0xC8, 0x0A, CATCH_CALL, 0xFE, 13};
int outc_skel5[]={6 ,0x3E, '?', CATCH_CALL, 0x3E, ' ', 0xCD};
int outc_skel6[]={11 ,0x4F, 0xF1, 0xB7, 0x28, SKIP, 0x79, 0xFE, ' ', 0xD4, CATCH, CATCH};

int numasc_skel[]={15, SKIP_CALL, CATCH_CALL, SKIP_CALL, SKIP_CALL, 1, SKIP, SKIP,  0xC5, 0x7E, 0x23, 0x23, 0xE5, SKIP_CALL, 0xE1, 0x4E};

int fpsint_skel[]={12, ADDR, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0xFA, SKIP, SKIP, 0x3A, SKIP, SKIP, 0xFE, 0x91};
int fpsint_skel2[]={12, ADDR, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0xFC, SKIP, SKIP, 0x3A, SKIP, SKIP, 0xFE, 0x91};

int ex_fpsint_skel[]={11, ADDR, SKIP_CALL, SKIP_CALL, 0xE5, SKIP_CALL, 0xEB, 0xE1, 0x7A, 0xB7, 0xC9};
int ex_fpsint_skel2[]={14, 0xF2, SKIP, SKIP, SKIP_CALL, 0xE3, 17, 1, 0, 0x7E, 0xFE, SKIP, 0xCC, CATCH, CATCH};
int ex_posint_skel[]={10, 0x7E, 0xFE, SKIP, 0xC0, SKIP_CALL, 0x18, SKIP, SKIP_CALL, CATCH_CALL, 0xF0};


int abpass_skel[]={11, ADDR, 0x50, 0x1E, 0, 33, SKIP, SKIP, 0x73, 6, 0x90, 0xC3};
int abpass_skel2[]={8, 0x47, ADDR, 0x50, 0x1E, 0, 6, 0x90, 0xC3};

int hlpass_skel[]={8, ADDR, 0x7C, 0x55, 0x1E, 0, 6, 0x90, 0xC3};


int atoh_skel[]={12, ADDR, 0x2B, 17, 0, 0, SKIP_CALL, 0xD0, 0xE5, 0xF5, 33, 0x98, 0x19};
int atoh_skel2[]={10, ADDR, 0x2B, 0xC5, SKIP_CALL, 0xC1, 0xD0, SKIP_CALL, 17, 0, 0};

int crtst_skel[]={10, ADDR,  0x2B, 6, 0x22, 0x50, 0xE5, 0x0E ,0xFF, 0x23, 0x7E};
int getstr_skel[]={12, ADDR,  SKIP_CALL, 0x2A, SKIP, SKIP, 0xEB, SKIP_CALL, 0xEB, 0xC0, 0xD5, 0x50, 0x59};
int tststr_skel2[]={10, CATCH_CALL, 0x2A, SKIP, SKIP, 0xEB, SKIP_CALL, 0xEB, 0xC0, 0xD5};

int baktmp_skel[]={12, ADDR,  0x2A, SKIP, SKIP, 0x2B, 0x46, 0x2B, 0x4E, 0x2B, 0x2B, SKIP_CALL, 0xC0};
int baktmp_skel2[]={13, ADDR,  0x2A, SKIP, SKIP, 0x2B, 0x46, 0x2B, 0x4E, 0x2B, 0x2B, 0x7C, 0x92, 0xC0};
int tmstpt_skel3[]={11, 0x2A, CATCH, CATCH, 0x2B, 0x46, 0x2B, 0x4E, 0x2B, 0x2B, SKIP_CALL, 0xC0};
int tmstpt_skel4[]={12, 0x2A, CATCH, CATCH, 0x2B, 0x46, 0x2B, 0x4E, 0x2B, 0x2B, 0x7C, 0x92, 0xC0};

int datsnr_skel[]={15, ADDR, 0x2A, SKIP, SKIP, 0x22, SKIP, SKIP, 0x1E, 2, 1, 0x1E, SKIP, 1, 0x1E, SKIP};

int ucase_skel[]={9, ADDR, 0x7E, 0xFE, 0x61, 0xD8, 0xFE, 0x7B, 0xD0, 0xE6, 0x5F, 0xC9};


/* Later Extended BASIC versions (MSX BASIC, Otrona Attache', Triumph Adler.. */

int ttypos_skel[] ={10, 0x3A, CATCH, CATCH, 0x6F, 0xAF, 0x67, 0xC3, SKIP, SKIP, 0xCD};
int ttypos_skel2[]={11, 0x3A, CATCH, CATCH, 0x3C, 0x6F, 0xAF, 0x67, 0xC3, SKIP, SKIP, 0xCD};
int lpos_skel[] ={12, 0x3A, CATCH, CATCH, 0x18, 0x03, 0x3A, SKIP, SKIP, 0x6F, 0xAF, 0x67, 0xC3};
int lpos_skel2[]={12, 0x3A, CATCH, CATCH, 0x18, 0x03, 0x3A, SKIP, SKIP, 0x3C, 0x6F, 0xAF, 0x67};

int unsigned_a_skel[] ={10, 0x3A, SKIP, SKIP, ADDR, 0xAF, 0x67, 0xC3, SKIP, SKIP, 0xCD};
int unsigned_a_skel2[]={11, 0x3A, SKIP, SKIP, 0x3C, ADDR, 0xAF, 0x67, 0xC3, SKIP, SKIP, 0xCD};
int int_hl_skel[] ={10, 0x3A, SKIP, SKIP, 0x6F, 0xAF, 0x67, 0xC3, CATCH, CATCH, 0xCD};
int int_hl_skel2[]={11, 0x3A, SKIP, SKIP, 0x3C, 0x6F, 0xAF, 0x67, 0xC3, CATCH, CATCH, 0xCD};
int int_a_skel[]={8, 0x77, 0xC9, SKIP_CALL, ADDR, 0x17, 0x9F, 0x67, 0xC3};
int faccu_skel[]={9, 33, CATCH, CATCH, 0x7E, 0xEE, 0x80, 0x77, 0xC9, 0xCD};

int chrgtb2_skel[]={15, 0x07, 0x4F, 6, 0, 0xEB, 33, SKIP, SKIP, 9, 0x4E, 0x23, 0x46, 0xC5, 0xEB, ADDR};
int chrckb2_skel[]={13, ADDR, 0x7E, 0xFE, ':', 0xD0, 0xFE, ' ', 0x28, SKIP, 0x30, SKIP, 0xB7, 0xC8};

int newstmt_skel[]={14, 0xFE, 0x0E, 0x28, SKIP, 0xFE, 0x0D, 0xC2, SKIP, SKIP, SKIP_CALL, 1, CATCH, CATCH, 0x18};
int goto_skel[]={15, 0xFE, 0x0E, 0x28, SKIP, 0xFE, 0x0D, 0xC2, SKIP, SKIP, SKIP_CALL, 1, SKIP, SKIP, 0x18, ADDR};
  
int dim_skel[]={12, ADDR, ',', 1, SKIP, SKIP, 0xC5, 0xF6, 0xAF, 0x32, SKIP, SKIP, 0x4E};
  
int sbscpt_skel[]={13, ADDR, 0x2A, SKIP, SKIP, 0xE3, 0x57, 0xD5, 0xC5, SKIP_CALL, 0xC1, 0xF1, 0xEB, 0xE3};

  
/* Microsoft BASIC token extraction */
int tkmsbasic_skel[]={12, 17, CATCH, CATCH, 0x1A, 0x13, 0xB7, 0xF2, SKIP, SKIP, 0x0D, 0x20, 0xF7};
int tkmsbasic_skel2[]={15, 33, CATCH, CATCH, 0x7E, 0xB7, 0x23, 0xF2, SKIP, SKIP, 0x1D, 0xC2, SKIP, SKIP, 0xA6, 0x7F};
int tkmsbasic_skel3[]={12, 0xD5, 17, CATCH, CATCH, 0xC5, 1, SKIP, SKIP, 0xC5, 0x06, SKIP, 0x7E};
int tkmsbasic_skel4[]={12, 0xC5, 33, CATCH, CATCH, 1, SKIP, SKIP, 0x1E, 0x41, 0x56, 0xED, 0xA1};

/* Last resort attempt, we look for the text ! */
int tkmsbasic_old_skel[]={8, ADDR, 'E', 'N', 0xC4, 'F', 'O', 0xd2, 'N'};

/* Odd extended BASIC (i.e. MSX) tokens*/
int tkmsbasic_ex_skel[]={11, 33, CATCH, CATCH, 0x47, 0x0e, 0x40, 0x0C, 0x23, 0x54, 0x5D, 0x7E};
int tkrange_ex_skel[]={14, 0xD6, 129, 0xDA, SKIP, SKIP, 0xFE, CATCH, 0xD2, SKIP, SKIP, 7, 0x4F, 6, 0};
int tok_ex_skel[]={12, 0x3C, 0xCA, SKIP, SKIP, 0x3D, 0xFE, ADDR, 0x28, SKIP, 0xFE, SKIP, 0xCA};
int lnum_tokens_skel[]={11, 17, CATCH, CATCH, 0x4F, 0x1A, 0xB7, 0x28, SKIP, 0x13, 0xB9, 0x20};
int equal_tk_skel[]={8, 0xF1, 0xC6, 3, 0x18, SKIP, SKIP_CALL, SKIP_CALL, CATCH};
int using_tokens_skel[]={18, 0xFE, ADDR, 0xCA, SKIP, SKIP, 0xFE, SKIP, 0xCA, SKIP, SKIP, 0xFE, SKIP, 0xCA, SKIP, SKIP, 0xE5, 0xFE, ','};
int lnum_range_skel[]={9, 0x73, 0x23, 0x72, 0x18, ADDR, 17, 0, 0, 0xD5};

int ex_warm_skel[]={17, ADDR, 0xF9, 33, SKIP, SKIP, 0x22, SKIP, SKIP, SKIP_CALL, SKIP_CALL, 0xAF, 0x67, 0x6F, 0x22, SKIP, SKIP, 0x32};
int ex_warm_skel2[]={18, ADDR, 0xF9, 33, SKIP, SKIP, 0x22, SKIP, SKIP, SKIP_CALL, SKIP_CALL, SKIP_CALL, 0xAF, 0x67, 0x6F, 0x22, SKIP, SKIP, 0x32};
int ex_end1_skel[]={14, ADDR, 0x22, SKIP, SKIP, 33, SKIP, SKIP, 0x22, SKIP, SKIP, 33, 0xF6, 0xFF, 0xC1};

int tkmsbasic_code_skel[]={12, 0xD5, 17, SKIP, SKIP, 0xC5, 1, SKIP, SKIP, 0xC5, 0x06, CATCH, 0x7E};
int jptab_msbasic_skel[]={10, 0x07, 0x4F, 6, 0, 0xEB, 33, CATCH, CATCH, 9, 0x4E};
//int jptab_msbasic_skel[]={13, 0x07, 0x4F, 6, 0, 0xEB, 33, CATCH, CATCH, 0x09, 0x4E, 0x23, 0x46, 0xC5};
int jptab_msbasic_skel3[]={11, 17, CATCH, CATCH, 0xD4, SKIP,SKIP, 7, 0x4f, 6, 0, 0xEB};
int jptab_msbasic_skel2[]={12, 17, CATCH, CATCH, 0x07, 0x4F, 6, 0, 0xEB, 0x09, 0x4E, 0x23, 0x46};

int else_token_skel[]={13, 0x32, SKIP, SKIP,0xF1, 0xC1, 0xD1, 0xFE, CATCH, 0xF5, 0xCC, SKIP, SKIP, 0xF1};

int fnctab_msbasic_skel[]={10, 0xD5, 1, CATCH, CATCH, 9, 0x4E, 0x23, 0x66, 0x69, 0xE9};
int fnctab_msbasic_skel2[]={9,       1, CATCH, CATCH, 9, 0x4E, 0x23, 0x66, 0x69, 0xE9};
int fnctab_msbasic_skel3[]={14, 0xE5, 33, SKIP, SKIP, 0xE5, 33, CATCH, CATCH, 9, 0x4E, 0x23, 0x66, 0x69, 0xE9};

int pc6001_60_page[]={12, 33, CATCH, CATCH, 17, 0 ,0xFA, 1, SKIP, SKIP, 0xED, 0xB0, 17};
//int pc6001_page[]={11, 33, CATCH, CATCH, 17, 0 ,0xFA, 1, SKIP, SKIP, 0xED, 0xB0};



int cpdehl_skel[]={7, ADDR, 0x7C, 0x92, 0xC0, 0x7D, 0x93, 0xC9};
int cpdehl_loc_skel[]={9, 0xEB, 0x2A, SKIP, SKIP, 0x1A, 0x02, 0x03, 0x13, CATCH_CALL};
int cpdehl_loc_skel2[]={7, 0xD0, 0xE5, 0xF5, 0x21, 0x98, 0x19, CATCH_CALL};

int buffer_loc_skel[]={9,  0x21, CATCH, CATCH, 0x12, 0x13, 0x12, 0x13, 0x12, 0xC9,};
int buffer_loc_skel2[]={10,  0x21, CATCH, CATCH, 0xAF, 0x12, 0x13, 0x12, 0x13, 0x12, 0xC9,};


/* byte to signed offset conversion */
long signed_byte(long byt)
{
	if (byt <128)
		return (byt);
	return (-256+byt);
}


/* DATA label declaration */
int dlbl(char *label, long position, char *comment) {
if (SKOOLMODE) {
	printf("@ $%04x label=%s\n", position, label);
	printf("D $%04x %s\n", position, comment);
} else
	printf("%s \t= $%04X   ; %s\n", label, position, comment);
}


/* CODE label declaration */
int clbl(char *label, long position, char *comment) {
if (SKOOLMODE) {
	printf("@ $%04x label=%s\n", position, label);
	printf("c $%04x %s\n", position, comment);
} else
	printf("%s \t= $%04X   ; %s\n", label, position, comment);
}

void clear_token () {
	//sprintf (token,"");
    token[0]  = '\0';
    token[1]  = '\0';

}

void append_c(char c) {
	int sl;
	sl=strlen(token);
	switch (c) {
		case '(':
			token[sl] = '_';
			token[sl+1] = '\0';
			break;
		/*
		case '$':
			token[sl] = '_';
			token[sl+1] = 'S';
			token[sl+2] = '\0';
			break;
			*/
		default:
			token[sl] = c;
			token[sl+1] = '\0';
			break;
	}
}

/* This is the core engine of the tool.. peep into the code, identify a known fingerprint, 
   and extract its position, a value, or a referred address */

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
					} else if (skel[j] == SKIP_JP_RET)
						switch (img[j+i]) {
							case 0xC9:		/* RET */
								break;
							case 0xC3:		/* JP nn */
								i++;
								i++;
								break;
							case 0x18:		/* JR n */
								i++;
								break;
					} else if (img[j+i] != skel[j]) return (-1);
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


int zx81char(int c) {
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
	long res, res2, res3;
	int token_range;
	int brand;
	int new_tk_found;


	if (argc !=3) {
		printf("USAGE:\n");
		printf("basck <-ctl|-map> basic.bin\n");
		exit(1);
	}

	if (!strcmp(argv[1], "-ctl"))
		SKOOLMODE=1;
	
	if (!strcmp(argv[1], "-map"))
		SKOOLMODE=0;
	
	if ( (fpin=fopen(argv[2],"rb") ) == NULL ) {
		printf("Can't open input file\n");
		exit(1);
	}

	if (SKOOLMODE<0) {
		printf("Invalid parameter.  Usage:\n");
		printf("basck <-ctl|-map> basic.bin\n");
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

	printf("\n# File size: %d\n",i);

	res=find_skel(ldir_skel);
	if (res<0) 
		res=find_skel(ldir_skel2);
	if (res>0)
		printf("\n# Specific Z80 CPU code detected\n\n");

	
	
	/***********************************/
	/* Microsoft BASIC related section */
	/***********************************/
	res=find_skel(restore_bastxt_skel);
	if (res<0)
		res=find_skel(bastxt_skel);
	if (res<0)
		res=find_skel(bastxt_skel2);
	if (res<0) {
		res=find_skel(errtab_skel);
		if (res>0) res =0xFFFF;
	}

	if (res>0) {
		printf("\n# Microsoft 8080/Z80 BASIC found\n");
		
		brand=find_skel(tkmsbasic_ex_skel);
		if (brand<0)
			printf("#  Extended BASIC detected\n");
			else {
				brand=find_skel(microsoft_extended_skel);
				if (brand>0)
					printf("#  Extended syntax detected (classic version)\n");
					else printf("#  Earlier version\n");
			}

		brand=find_skel(microsoft_defdbl_skel);
		if (brand<0)
			brand=find_skel(microsoft_defdbl_skel2);
		if (brand<0)
			brand=find_skel(microsoft_defdbl_skel3);
		if (brand>0)
			printf("#  Double precision maths detected\n");

		brand=find_skel(microsoft_skel);
		if (brand>0)
			printf("#  Microsoft signature found\n");
			else printf("#  Microsoft signature not found\n");

		
		printf("\n");


		/* We refer to a common ROM subroutine to determine the correct code position */
		
		
		printf("\n");
		dlbl("BASTXT", res, "BASIC program start ptr (aka TXTTAB)");

		printf("\n");

		pos=find_skel(cpdehl_skel);
		if (pos>0) {
			printf ("\n#    CPDEHL (compare DE and HL), code found at $%04X", pos);
			/* Canon X-07 hack */
			if (pos==0x3E44) {
				pos=0xB000;
				printf("\n#    (Canon X-07 hack.. shifting to position $%04X,  *work in progress*)",pos);
			}
			else {
				res=find_skel(cpdehl_loc_skel);
				if (res<0)
					res=find_skel(cpdehl_loc_skel2);
				if (res>0) {
					pos=res-pos-1;
					if (pos>=0) {
						if (pos==8434) {
							printf("\n#    ...patching MS SoftCard HR GBASIC, gap size: $%04X",pos-256);
							pos=256;
						}
						printf("\n#    (Detected position for ORG:  %d)",pos);
					}
					else pos=0;
				} else pos=0;
			}
		}
 
		res=find_skel(tstsgn_skel);
		if (res<0)
			res=find_skel(tstsgn_skel2);
		if (res<0)
			res=find_skel(tstsgn_skel3);
		pos2=find_skel(tstsgn_loc_skel);
		if (pos2<0)
			pos2=find_skel(tstsgn_loc_skel);
		if ((res>0) && (pos2>0)) {
			pos=pos2-res-1;
			printf("\n#    (Detected position basing on TSTSGN:  %d)",pos);
			//pos=-pos;
		}
		
		res=find_skel(dvbcde_skel);
		pos2=find_skel(dvbcde_org_skel);
		if ((res>0) && (pos2>0)) {
			pos=pos2-res+1;
			if (pos <0)
				pos=res-pos2+1;   // probably wrong
			printf("\n#    (Detected position basing on DVBCDE:  %d)",pos);
		}
		
		if (pos==-1) pos=0;


		printf("\n\n");


		res=find_skel(inport_skel);
		if (res<0)
			res=find_skel(inport_skel2);
		if (res<0)
			res=find_skel(inport_skel3);
		if (res>0)
			dlbl("INPORT", res, "Current port for 'INP' function");

		res=find_skel(otport_skel);
		if (res<0)
			res=find_skel(otport_skel2);
		if (res<0)
			res=find_skel(otport_skel3);
		if (res>0)
			dlbl("OTPORT", res, "Current port for 'OUT' statement");

		res=find_skel(ms_rnd_seed);
		if (res>0)
			dlbl("SEED", res+2, "Seed for RND numbers");

		res=find_skel(ms_lstrnd);
		if (res<0)
			res=find_skel(ms_lstrnd2);
		if (res>0)
			dlbl("LSTRND2", res+2, "Last RND number");

		res=find_skel(buffer_loc_skel);
		if (res<0)
			res=find_skel(buffer_loc_skel2);
		if (res>0)
			dlbl("BUFFER", res, "Start of input buffer");

		res=find_skel(tmstpt_skel);
		if (res<0)
			res=find_skel(tmstpt_skel2);
		if (res<0)
			res=find_skel(tmstpt_skel3);
		if (res<0)
			res=find_skel(tmstpt_skel4);
		if (res>0)
			dlbl("TMSTPT", res, "Temporary string pool pointer");
		
		res=find_skel(tmpstr_skel);
		if (res<0)
			res=find_skel(tmpstr_skel2);
		if (res<0)
			res=find_skel(tmpstr_skel3);
		if (res>0)
			dlbl("TMPSTR", res, "Temporary string");
		
		res=find_skel(nxtopr_skel);
		if (res<0)
			res=find_skel(nxtopr_skel2);
		if (res>0)
			dlbl("NXTOPR", res, "Address ptr to next operator");

		res=find_skel(curpos_skel);
		if (res<0)
			res=find_skel(curpos_skel2);
		if (res<0)
			res=find_skel(ttypos_skel);     /* Extended Basic versions..*/
		if (res<0)
			res=find_skel(ttypos_skel2);
		if (res>0)
			dlbl("CURPOS", res, "Character position on line (TTYPOS on Ext. Basic)");
		
		res=find_skel(lpos_skel);       /* Extended Basic versions..*/
		if (res<0)
			res=find_skel(lpos_skel2);
		if (res>0)
			dlbl("LPTPOS", res, "Character position on printer");
		
		res=find_skel(prognd_skel);
		if (res<0)
			res=find_skel(prognd_skel2);
		if (res>0)
			dlbl("PROGND", res, "BASIC program end ptr (aka VARTAB)");

		res=find_skel(varend_skel);
		if (res<0)
			res=find_skel(varend_skel2);
		if (res>0)
			dlbl("VAREND", res, "End of variables");

		res=find_skel(arrend_skel);
		if (res<0)
			res=find_skel(arrend_skel2);
		if (res<0)
			res=find_skel(arrend_skel3);
		if (res>0)
			dlbl("ARREND", res, "End of arrays (lowest free mem)");

		res=find_skel(sgnres_skel);
		if (res>0)
			dlbl("SGNRES", res, "Sign of result");

		res=find_skel(ex_warm_skel);
		if (res>0) {
			dlbl("TEMPST", img[res+3] + 256*img[res+4], "(word), temporary descriptors");
			dlbl("TEMPPT", img[res+6] + 256*img[res+7], "(word), start of free area of temporary descriptor");
			//
			dlbl("PRMLEN", img[res+18] + 256*img[res+19], "(word), number of bytes of obj table");
			dlbl("NOFUNS", img[res+21] + 256*img[res+22], "(byte), 0 if no function active");
			dlbl("PRMLN2", img[res+24] + 256*img[res+25], "(word), size of parameter block");
			dlbl("FUNACT", img[res+27] + 256*img[res+28], "(word), active functions counter");
			dlbl("PRMSTK", img[res+30] + 256*img[res+31], "(word), previous block definition on stack");
			dlbl("SUBFLG", img[res+33] + 256*img[res+34], "(byte), flag for USR fn. array");
			dlbl("TEMP", img[res+38] + 256*img[res+39], "(word) temp. reservation for st.code");
		}
		
		res=find_skel(ex_warm_skel2);
		if (res>0) {
			dlbl("TEMPST", img[res+3] + 256*img[res+4], "(word), temporary descriptors");
			dlbl("TEMPPT", img[res+6] + 256*img[res+7], "(word), start of free area of temporary descriptor");
			//
			dlbl("PRMLEN", img[res+21] + 256*img[res+22], "(word), number of bytes of obj table");
			dlbl("NOFUNS", img[res+24] + 256*img[res+25], "(byte), 0 if no function active");
			dlbl("PRMLN2", img[res+27] + 256*img[res+28], "(word), size of parameter block");
			dlbl("FUNACT", img[res+30] + 256*img[res+31], "(word), active functions counter");
			dlbl("PRMSTK", img[res+33] + 256*img[res+34], "(word), previous block definition on stack");
			dlbl("SUBFLG", img[res+36] + 256*img[res+37], "(byte), flag for USR fn. array");
			dlbl("TEMP", img[res+41] + 256*img[res+42], "(word) temp. reservation for st.code");
		}

		res=find_skel(sbscpt_skel);
		if (res>0) {
			dlbl("DIMFLG", img[res+2] + 256*img[res+3], "(word), aka LCRFLG (Locate/Create and Type");
		}

		res=find_skel(eval3_body_skel);
		if (res>0) {
			dlbl("VALTYP", img[res+2] + 256*img[res+3], "(word) type indicator");
			dlbl("PRITAB", img[res+14] + 256*img[res+15], "Arithmetic precedence table");
		}
		
		res=find_skel(eval3_ex_skel);
		if (res>0) {
			dlbl("TEMP2", img[res+2] + 256*img[res+3], "(word) temp. storage used by EVAL");
			dlbl("TEMP3", img[res+7] + 256*img[res+8], "(word) used for garbage collection or by USR function");
		}

		res=find_skel(ex_end1_skel);
		if (res>0) {
			dlbl("SAVTXT", img[res+2] + 256*img[res+3], "(word), prg pointer for resume");
			dlbl("TEMPST", img[res+5] + 256*img[res+6], "(word), temporary descriptors");
			dlbl("TEMPPT", img[res+8] + 256*img[res+9], "(word), start of free area of temporary descriptor");
			//
			dlbl("CURLIN", img[res+15] + 256*img[res+16], "(word), line number being interpreted");
			//
			dlbl("OLDLIN", img[res+25] + 256*img[res+26], "(word), old line number set up ^C ...");
			dlbl("SAVTXT", img[res+28] + 256*img[res+29], "(word), prg pointer for resume");
			dlbl("OLDTXT", img[res+31] + 256*img[res+32], "(word), prg pointer for CONT");
		}

		
		printf("\n");

		
		res=find_skel(log10eval_skel);
		if (res>0)
			clbl("FP_LOG10E", res+pos+1, "Constant ptr for LOG(e)");

		res=find_skel(halfpival_skel);
		if (res>0)
			clbl("FP_HALFPI", res+pos+1, "Half PI constant ptr");
		else {
			res=find_skel(halfpi_skel);
			if (res<0)
				res=find_skel(halfpi_skel2);
			if (res<0)
				res=find_skel(halfpi_skel3);
			if (res>0)
				dlbl("HALFPI", res, "Half PI constant ptr");
		}

		res=find_skel(halfval_skel);
		if (res>0) {
			clbl("FP_HALF", res+pos+1, "Constant ptr for 0.5 in FP");
			clbl("FP_ZERO", res+pos+3, "Constant ptr for 'zero' in FP");
		} else {
			res=find_skel(half_skel);
			if (res<0)
				res=find_skel(half_skel2);
			if (res<0)
				res=find_skel(half_skel3);
			if (res<0)
				res=find_skel(half_skel4);
			if (res>0)
				dlbl("HALF", res, "Constant ptr for 0.5 in FP");
		}
		
		res=find_skel(unityval_skel);
		if (res>0) {
			clbl("FP_UNITY", res+pos+1, "Constant ptr for 1 in FP");
		} else {
			res=find_skel(unity_skel);
			if (res>0)
				dlbl("UNITY", res, "Constant ptr for number 1 in FP");
		}

		res=find_skel(quarterval_skel);
		if (res>0)
			clbl("FP_QUARTER", res+pos+1, "Constant ptr for 0.25 in FP");

		res=find_skel(tenhalfval_skel);
		if (res>0)
			clbl("FP_10EXHALF", res+pos+1, "Constant ptr for 10^(1/2) in FP");

		res=find_skel(twoln10val_skel);
		if (res>0)
			clbl("FP_TWODLN10", res+pos+1, "Constant ptr for 2/LN(10) in FP");

		res=find_skel(ln10val_skel);
		if (res>0)
			clbl("FP_LN10", res+pos+1, "Constant ptr for LN(10) in FP");

		res=find_skel(tan15val_skel);
		if (res>0)
			clbl("FP_TAN15", res+pos+1, "Constant ptr for TAN(15) in FP");

		res=find_skel(sqr3val_skel);
		if (res>0)
			clbl("FP_SQR3", res+pos+1, "Constant ptr for SQR(3) in FP");

		res=find_skel(sixthpival_skel);
		if (res>0)
			clbl("FP_SIXTHPI", res+pos+1, "Constant ptr for PI/6 in FP");

		res=find_skel(epsilonval_skel);
		if (res>0) {
			clbl("FP_EPSILON", res+pos+1, "Epsilon constant ptr");
			if (img[res+9]==4)
				clbl("FP_EXPTAB1", res+pos+9, "Ptr to first exponent table");
			if (img[res+42]==3)
				clbl("FP_EXPTAB2", res+pos+42, "Ptr to second exponent table");
		}

		res=find_skel(logtab_skel);
		if (res>0)
			dlbl("LOGTAB", res, "Table used by LOG");
		else {
			res=find_skel(logtabval_skel);
			if (res>0)
				clbl("FP_LOGTAB", res+pos+1, "First table used by LOG");
			if (img[res+34]==5)
				clbl("FP_LOGTAB2", res+pos+34, "Second table used by LOG");
		}
		
		res=find_skel(sintabval_skel);
		if (res>0)
			clbl("FP_SINTAB", res+pos+1, "Table used by SIN/COS/TAN");
		
		res=find_skel(atntabval_skel);
		if (res>0)
			clbl("FP_ATNTAB", res+pos+1, "Table used by ATN/TAN");
		
		printf("\n");

		res=find_skel(fpreg_skel);
		if (res<0)
			res=find_skel(fpreg_skel2);
		if (res<0)
			res=find_skel(fpreg_skel3);
		if (res<0)
			res=find_skel(fpreg_skel4);
		if (res>0)
			dlbl("FPREG", res, "Floating Point Register (FACCU, FACLOW on Ext. BASIC)");
			
		res=find_skel(last_fpreg_skel);
		if (res<0)
			res=find_skel(last_fpreg_skel2);
		if (res>0)
			dlbl("LAST_FPREG", res, "Last byte in Single Precision FP Register (+sign bit)");
		
		res=find_skel(fpexp_skel);
		if (res<0)
			res=find_skel(fpexp_skel2);
		if (res>0)
			dlbl("FPEXP", res, "Floating Point Exponent");

		res=find_skel(dblfpreg_skel);
		if (res>0)
			dlbl("DBL_FPREG", res, "Double Precision Floating Point Register (aka FACLOW)");

		res=find_skel(dbllast_fpreg_skel);
		if (res>0)
			dlbl("DBL_LAST_FPREG", res, "Last byte in Double Precision FP register (+sign bit)");
		
		
		printf("\n");

		res=find_skel(cpdehl_skel);
		if (res>0)
			clbl("CPDEHL", res+pos+1, "compare DE and HL (aka DCOMPR)");
		
		res=find_skel(fndnum_skel);
		if (res<0)
			res=find_skel(fndnum_skel2);
		if (res<0)
			res=find_skel(fndnum_skel3);
		if (res>0)
			clbl("FNDNUM", res+pos+1, "Load 'A' with the next number in BASIC program");

		res=find_skel(getint_skel);
		if (res<0)
			res=find_skel(getint_skel2);
		if (res<0)
			res=find_skel(getint_skel3);
		if (res<0)
			res=find_skel(getint_skel4);
		if (res<0)
			res=find_skel(getint_skel5);
		if (res<0)
			res=find_skel(getint_skel6);
		if (res>0)
			clbl("GETINT", res, "Get a number to 'A'");

		res=find_skel(getword_skel);
		if (res>0)
			clbl("GETWORD", res, "Get a number to DE (0..65535)");

		res=find_skel(depint_skel);
		if (res<0)
			res=find_skel(depint_skel2);
		if (res<0)
			res=find_skel(depint_skel3);
		if (res>0)
			clbl("DEPINT", res, "Get integer variable to DE, error if negative");

		res=find_skel(fpsint_skel);
		if (res<0)
			res=find_skel(fpsint_skel2);
		if (res>0) {
			clbl("FPSINT", res+pos+1, "Get subscript (0-32767)");
			clbl("POSINT", res+pos+4, "Get integer 0 to 32767");
			clbl("DEINT", res+pos+13, "Get integer variable (-32768 to 32767) to DE");
		}
		
		res=find_skel(ex_fpsint_skel);
		if (res>0) {
			clbl("FPSINT", res+pos+1, "Get subscript");
		} else {
			res=find_skel(ex_fpsint_skel2);
			if (res>0)
				clbl("FPSINT", res, "Get subscript");
		}

		res=find_skel(sbscpt_skel);
		if (res>0) {
			clbl("SBSCPT", res+pos, "Sort out subscript");
			clbl("SCPTLP", res+pos+6, "SBSCPT loop");
		}
		
		res=find_skel(ex_posint_skel);
		if (res>0)
			clbl("POSINT", res, "Get positive integer");		

		res=find_skel(getvar_skel);
		if (res<0)
			res=find_skel(getvar_skel2);
		if (res>0)
			clbl("GETVAR", res, "Get variable address to DE");

		res=find_skel(dim_skel);
		if (res>0)
			clbl("DIM", res+pos+2, "DIM command");

		res=find_skel(chkstk_skel);
		if (res>0)
			clbl("CHKSTK", res, "Check for C levels of stack");
		else {
			res=find_skel(chkstk_skel2);
			if (res>0)
				clbl("CHKSTK", res+pos+1, "Check for C levels of stack");
		}

		res=find_skel(oprnd_skel);
		if (res<0)
			res=find_skel(oprnd_skel2);
		if (res>0)
			clbl("OPRND", res, "Get next expression value");

		res=find_skel(chksyn_skel);
		if (res<0)
			res=find_skel(chksyn_skel2);
		if (res<0)
			res=find_skel(chksyn_skel3);
		if (res>0)
			clbl("SYNCHR", res, "Check syntax, 1 byte follows to be compared");

		res=find_skel(lfrgnm_skel);
		if (res<0)
			res=find_skel(lfrgnm_skel2);
		if (res>0)
			clbl("LFRGNM", res+pos+1, "number in program listing and check for ending ')'");

		res=find_skel(abpass_skel);
		if (res<0)
			res=find_skel(abpass_skel2);
		if (res>0)
			clbl("ABPASS", res+pos+2, "Get back from function passing an INT value in A+B registers");
		
		res=find_skel(hlpass_skel);
		if (res>0)
			clbl("HLPASS", res+pos+1, "Get back from function passing an INT value HL");

		res=find_skel(midnum_skel);
		if (res>0)
			clbl("MIDNUM", res+pos, "Get number in program listing");

		res=find_skel(int_a_skel);
		if (res>0)
			clbl("INT_RESULT_A", res+pos, "Get back from function, result in A (signed)");
		
		res=find_skel(int_hl_skel);
		if (res<0)
			res=find_skel(int_hl_skel2);
		if (res>0)
			clbl("INT_RESULT_HL", res, "Get back from function, result in HL");

		res=find_skel(unsigned_a_skel);
		if (res<0)
			res=find_skel(unsigned_a_skel2);
		if (res>0)
			clbl("UNSIGNED_RES_A", res+pos, "Get back from function, result in A");

		printf("\n");

		res=find_skel(test_type_skel);
		if (res>0)
			clbl("GETYPR", res, "Test number FAC type (Precision mode, etc..)");
		
		res=find_skel(tstsgn_skel);
		if (res<0)
			res=find_skel(tstsgn_skel2);
		if (res<0)
			res=find_skel(tstsgn_skel3);
		if (res>0)
			clbl("TSTSGN", res+pos+1, "Test sign of FPREG");

		res=find_skel(dbl_tstsgn_skel);
		if (res<0)
			res=find_skel(dbl_tstsgn_skel2);
		if (res<0)
			res=find_skel(dbl_tstsgn_skel3);
		if (res>0)
			clbl("_TSTSGN", res, "Test sign in number");


		res=find_skel(invsgn_skel);
		if (res<0)
			res=find_skel(invsgn_skel2);
		if (res>0)
			clbl("INVSGN", res, "Invert number sign");

		res=find_skel(stakfp_skel);
		if (res>0) {
			clbl("STAKFP", res+pos+1, "Put FP value on stack");
		}
		
		res=find_skel(negaft_skel);
		if (res<0)
			res=find_skel(negaft_skel2);
		if (res>0)
			clbl("NEGAFT", res, "Negate number");

		res=find_skel(log_skel);
		if (res<0)
			res=find_skel(log_skel2);
		if (res<0)
			res=find_skel(log_skel3);
		if (res<0)
			res=find_skel(log_skel4);
		if (res<0)
			res=find_skel(log_skel5);
		if (res<0)
			res=find_skel(log_skel6);
		if (res>0)
			clbl("LOG", res+pos+1, "LOG");

		res=find_skel(sqr_skel);
		if (res<0)
			res=find_skel(sqr_skel2);
		if (res<0)
			res=find_skel(sqr_skel3);
		if (res<0)
			res=find_skel(sqr_skel4);
		if (res<0)
			res=find_skel(sqr_skel5);
		if (res>0)
			clbl("SQR", res+pos+1, "SQR");
		
		res=find_skel(power_skel);
		if (res<0)
			res=find_skel(power_skel2);
		if (res<0)
			res=find_skel(power_skel3);
		if (res<0)
			res=find_skel(power_skel4);
		if (res>0)
			clbl("POWER", res+pos+1, "POWER");

		res=find_skel(exp_skel);
		if (res>0)
			clbl("EXP",res+pos+1, "EXP");

		res=find_skel(cos_skel);
		if (res<0)
			res=find_skel(cos_skel3);
		if (res<0)
			res=find_skel(cos_skel4);
		if (res>0)
			clbl("COS", res+pos, "COS");
		
		res=find_skel(sin_skel);
		if (res<0)
			res=find_skel(sin_skel3);
		if (res<0)
			res=find_skel(sin_skel4);
		if (res>0)
			clbl("SIN", res+pos, "SIN");

		res=find_skel(tan_skel);
		if (res<0)
			res=find_skel(tan_skel2);
		if (res<0)
			res=find_skel(tan_skel3);
		if (res>0)
			clbl("TAN", res+pos+1, "TAN");

		res=find_skel(atn_skel);
		if (res<0)
			res=find_skel(atn_skel2);
		if (res>0)
			clbl("ATN", res+pos+1, "ATN");

		res=find_skel(abs_skel);
		if (res<0)
			res=find_skel(abs_skel2);
		if (res<0)
			res=find_skel(abs_skel3);
		if (res>0)
			clbl("ABS", res+pos+1, "ATN");
		
		res=find_skel(dblabs_skel);
		if (res>0)
			clbl("DBL_ABS", res, "ABS (double precision BASIC variant)");
		else {
			res=find_skel(dblabs_skel2);
			if (res>0)
				clbl("DBL_ABS", res+pos+1, "ABS (double precision BASIC variant)");
		}
		
		res=find_skel(ms_rnd_skel);
		if (res<0)
			res=find_skel(ms_rnd_skel2);
		if (res>0)
			clbl("RND", res+pos+1, "RND");
		
		res=find_skel(fpadd_skel);
		if (res<0)
			res=find_skel(fpadd_skel2);
		if (res>0) {
			clbl("SUBCDE",res+pos+1-3, "Subtract BCDE from FP reg");
			clbl("FPADD", res+pos+1, "Add BCDE to FP reg");
		}
		else {
			res=find_skel(fpadd_skel3);
			if (res<0)
				res=find_skel(fpadd_skel4);
			if (res>0) {
				clbl("SUBCDE",res-3, "Subtract BCDE from FP reg");
				clbl("FPADD", res, "Add BCDE to FP reg");
			}
		}
		
		res=find_skel(bnorm_skel);
		if (res<0)
			res=find_skel(bnorm_skel2);
		if (res>0)
			clbl("BNORM", res+pos+1, "Normalise number");

		res=find_skel(scale_skel);
		if (res<0)
			res=find_skel(scale_skel2);
		if (res>0)
			clbl("SCALE", res+pos+1, "Scale number in BCDE for A exponent (bits)");

		res=find_skel(plucde_skel);
		if (res>0)
			clbl("PLUCDE", res+pos+1, "Add number pointed by HL to CDE");

		res=find_skel(compl_skel);
		if (res>0)
			clbl("COMPL", res+pos+1, "Convert a negative number to positive");
		
		res=find_skel(fpthl_skel);
		if (res>0)
			clbl("FPTHL", res+pos+1, "Copy number in FPREG to HL ptr");
		else {
			res=find_skel(fpthl_skel2);
			if (res<0)
				res=find_skel(fpthl_skel3);
			if (res>0)
			clbl("FPTHL", res, "Copy number in FPREG to HL ptr");
		}
		
		res=find_skel(fpbcde_skel);
		if (res>0) {
			clbl("PHLTFP", res+pos+1, "Number at HL to BCDE");
			clbl("FPBCDE", res+pos+4, "Move BCDE to FPREG");
		} else {
			res=find_skel(fpbcde_skel2);
			if (res<0)
				res=find_skel(fpbcde_skel3);
			if (res<0)
				res=find_skel(fpbcde_skel4);
			if (res>0)
				clbl("FPBCDE", res, "Move BCDE to FPREG");
			res=find_skel(phltfp_skel);
			if (res<0)
				res=find_skel(phltfp_skel2);
			if (res<0)
				res=find_skel(phltfp_skel3);
			if (res<0)
				res=find_skel(phltfp_skel4);
			if (res<0)
				res=find_skel(phltfp_skel5);
			if (res<0)
				res=find_skel(phltfp_skel6);
			if (res>0)
				clbl("PHLTFP", res, "Number at HL to BCDE");
		}
		
		
		res=find_skel(addphl_skel);
		if (res<0)
			res=find_skel(addphl_skel2);
		if (res<0)
			res=find_skel(addphl_skel3);
		if (res>0)
			clbl("ADDPHL", res, "ADD number at HL to BCDE");
		
		res=find_skel(subphl_skel);
		if (res>0)
			clbl("SUBPHL", res, "SUBTRACT number at HL from BCDE");
		
		res=find_skel(mlsp10_skel);
		if (res<0)
			res=find_skel(mlsp10_skel2);
		if (res>0)
			clbl("MLSP10", res+pos+1, "Multiply number in FPREG by 10");

		res=find_skel(fpmult_skel);
		if (res>0)
			clbl("FPMULT", res, "Multiply BCDE to FP reg");

		res=find_skel(div10_skel);
		if (res<0)
			res=find_skel(div10_skel2);
		if (res<0)
			res=find_skel(div10_skel3);
		if (res<0)
			res=find_skel(div10_skel4);
		if (res<0)
			res=find_skel(div10_skel5);
		if (res>0)
			clbl("DIV10", res+pos+1, "Divide FP by 10");

		res=find_skel(div_skel);
		if (res>0)
			clbl("DIV", res, "Divide FP by number on stack");
		else {
			res=find_skel(div_skel2);
			if (res>0)
				clbl("DIV", res+pos+1, "Divide FP by number on stack");
		}

		res=find_skel(dvbcde_org_skel);
		if (res>0)
			clbl("DVBCDE", res+pos+1, "Divide FP by BCDE");
		else {
			res=find_skel(dvbcde_skel);
			if (res>0)
				clbl("DVBCDE", res, "Divide FP by BCDE");
		}

		res=find_skel(dcbde_skel);
		if (res>0)
			clbl("DCBCDE", res+pos+1, "Decrement FP value in BCDE");

		res=find_skel(bcdefp_skel);
		if (res>0) {
			clbl("BCDEFP", res+pos+1, "Load FP reg to BCDE");
		}
		
		res=find_skel(loadfp_skel);
		if (res>0)
			clbl("LOADFP", res+pos+1, "Load FP value pointed by HL to BCDE");
		
		res=find_skel(shrite_skel);
		if (res>0)
			clbl("SHRITE", res, "Shift right number in BCDE");
		else {
			res=find_skel(shrite_skel2);
			if (res>0)
				clbl("SHRITE", res+pos+1, "Shift right number in BCDE");
		}

		res=find_skel(cmpnum_skel);
		if (res>0)
			clbl("CMPNUM", res, "Compare FP reg to BCDE");

		res=find_skel(fpint_skel);
		if (res>0)
			clbl("FPINT", res, "Floating Point to Integer");

		res=find_skel(flgrel_skel);
		if (res>0)
			clbl("FLGREL", res+pos+1, "CY and A to FP, & normalise");

		res=find_skel(sumser_skel);
		if (res>0)
			clbl("SUMSER", res, "Evaluate sum of series");
		
		res=find_skel(int_skel);
		if (res>0)
			clbl("INT", res+pos+1, "INT");
		
		res=find_skel(dblint_skel);
		if (res<0)
			res=find_skel(dblint_skel2);
		if (res>0)
			clbl("DBL_INT", res+pos+1, "INT (double precision BASIC variant)");
		
		res=find_skel(dblsub_skel);
		if (res>0)
			clbl("DBL_SUB", res+pos+1, "Double precision SUB (formerly SUBCDE)");
		
		res=find_skel(dbladd_skel);
		if (res>0)
			clbl("DBL_ADD", res+pos+1, "Double precision ADD (formerly FPADD)");
		
		res=find_skel(dblsub_skel2);
		if (res>0) {
			clbl("DBL_SUB", res+pos+1, "Double precision SUB (formerly SUBCDE)");
			clbl("DBL_ADD", res+pos+7, "Double precision ADD (formerly FPADD)");
		}

		res=find_skel(dblmul_skel);
		if (res>0)
			clbl("DBL_MUL", res+pos+1, "Double precision MULTIPLY");
		
		res=find_skel(dbldiv_skel);
		if (res>0)
			clbl("DBL_DIV", res, "Double precision DIVIDE");
		else {
			res=find_skel(dbldiv_skel2);
			if (res>0)
				clbl("DBL_DIV", res+pos+1, "Double precision DIVIDE");
		}
		
		res=find_skel(fix_skel);
		if (res>0)
			clbl("FIX", res+pos+1, "Double Precision to Integer conversion");
		
		res=find_skel(intmul_skel);
		if (res>0)
			clbl("INT_MUL", res+pos+1, "Integer MULTIPLY");
		
		res=find_skel(mldebc_skel);
		if (res<0)
			res=find_skel(mldebc_skel2);
		if (res>0)
			clbl("MLDEBC", res, "Multiply DE by BC");
		else {
			res=find_skel(mldebc_skel3);
			if (res>0)
				clbl("MLDEBC", res+pos+1, "Multiply DE by BC");
		}

		res=find_skel(asctfp_skel);
		if (res<0)
			res=find_skel(asctfp_skel2);
		if (res>0)
			clbl("_ASCTFP", res+pos+1, "ASCII to FP number");

		res=find_skel(hex_asctfp_skel);
		if (res<0)
			res=find_skel(hex_asctfp_skel2);
		if (res>0)
			clbl("H_ASCTFP", res+pos+1, "ASCII to FP number (also '&' prefixes)");

		res=find_skel(hextfp_skel);
		if (res>0)
			clbl("HEXTFP", res+pos+1, "HEX(ASCII) to FP number");

		res=find_skel(dblasctfp_skel);
		if (res>0) {
			clbl("ASCTFP", res+pos+8, "ASCII to FP number (New version)");
			clbl("DBL_ASCTFP", res+pos+1, "ASCII to Double precision FP number");
		} else {
			res=find_skel(dblasctfp_skel2);
			if (res>0)
				clbl("DBL_ASCTFP", res+pos+1, "ASCII to Double precision FP number");
		}
		
		res=find_skel(prnthl_skel);
		if (res<0)
			res=find_skel(prnthl_skel2);
		if (res<0)
			res=find_skel(prnthl_skel3);
		if (res>0)
			clbl("PRNTHL", res+pos+1, "Print number in HL");
		
		res=find_skel(prs_skel);
		if (res<0)
			res=find_skel(prs_skel2);
		if (res<0)
			res=find_skel(prs_skel3);
		if (res>0) {
			clbl("PRNUMS", res-1, "Print number string");
			clbl("PRS", res, "Create string entry and print it");
			clbl("PRS1", res+3, "Print string at HL");
		} else {
			res=find_skel(prnums_skel);
			if (res<0)
				res=find_skel(prnums_skel2);
			if (res>0) {
				clbl("PRNUMS", res+pos+1, "Print number string");
				clbl("PRS", res+pos+2, "Create string entry and print it");
				clbl("PRS1", res+pos+5, "Print string at HL");
			}
		}

		res=find_skel(str_skel);
		if (res<0)
			res=find_skel(str_skel2);
		if (res>0)
			clbl("STR", res+pos+1, "STR BASIC function entry");

		res=find_skel(savstr_skel);
		if (res<0)
			res=find_skel(savstr_skel2);
		if (res>0)
			clbl("SAVSTR", res+pos+1, "Save string in string area");

		res=find_skel(mktmst_skel);
		if (res>0) {
			clbl("MKTMST", res+pos+1, "Make temporary string");
			clbl("CRTMST", res+pos+1+3, "Create temporary string entry");
		}
		else {
			res=find_skel(mktmst_skel2);
			if (res>0) {
				clbl("MKTMST", res, "Make temporary string");
				clbl("CRTMST", res+3, "Create temporary string entry");
			} else {
				res=find_skel(mktmst2_skel);
				if (res>0) {
					clbl("MKTMST", res, "Make temporary string");
					clbl("CRTMST", res+3, "Create temporary string entry");
				}
			}
		}

		res=find_skel(sstsa_skel);
		if (res>0) {
			clbl("SSTSA", res, "Move string on stack to string area");
		}

		res=find_skel(tostra_skel);
		if (res>0) {
			clbl("TOSTRA", res+pos, "Move string in BC, (len in L) to string area");
			clbl("TSALP", res+pos+1, "TOSTRA loop");
		}


		res=find_skel(for_skel);
		if (res<0)
			res=find_skel(for_skel2);
		if (res<0)
			res=find_skel(for_skel3);
		if (res<0)
			res=find_skel(for_skel4);
		if (res>0)
			clbl("FOR", res+pos+1, "'FOR' BASIC instruction");

		
		res=find_skel(fdtlp_skel);
		if (res<0)
			res=find_skel(fdtlp_skel2);
		if (res<0)
			res=find_skel(fdtlp_skel3);
		if (res>0)
			clbl("FDTLP", res+pos+1, "Find next DATA statement");
		
		res=find_skel(data_skel);
		if (res<0)
			res=find_skel(data_skel2);
		if (res<0)
			res=find_skel(data_skel3);
		if (res>0)
			clbl("DATA", res, "DATA statement: find next DATA program line..");

		res=find_skel(restore_skel);
		if (res>0)
			clbl("RESTOR", res+pos+1, "'RESTORE' stmt, init ptr to DATA program line..");

		res=find_skel(new_skel);
		if (res<0)
			res=find_skel(new_skel2);
		if (res<0)
			res=find_skel(new_skel3);
		if (res>0)
			clbl("NEW", res+pos+1, "'NEW' statement");
				
		res=find_skel(newstmt_skel);
		if (res>0)
			clbl("NEW_STMT", res+pos+1, "Interprete next statement");

		res=find_skel(goto_skel);
		if (res>0) {
			res=signed_byte(img[res])+res;
			clbl("GO_TO", res+pos+1, "Go To..");
		}

		res=find_skel(chr_skel);
		if (res>0)
			clbl("CHR", res+pos+1, "CHR$ BASIC function");

		res=find_skel(makint_skel);
		if (res<0)
			res=find_skel(makint_skel2);
		if (res<0)
			res=find_skel(makint_skel3);
		if (res<0)
			res=find_skel(makint_skel4);
		if (res>0)
			clbl("MAKINT", res, "Convert tmp string to int in A register");
		
		res=find_skel(concat_skel);
		if (res>0)
			clbl("CONCAT", res+pos+1, "String concatenation");
		
		res=find_skel(testr_skel);
		if (res<0)
			res=find_skel(testr_skel2);
		if (res<0)
			res=find_skel(testr_skel3);
		if (res>0)
			clbl("TESTR", res, "Test if enough room for string");

		res=find_skel(topool_skel);
		if (res<0)
			res=find_skel(topool_skel2);
		if (res>0)
			clbl("TOPOOL", res, "Save in string pool");

		res=find_skel(tstopl_skel);
		if (res<0)
			res=find_skel(tstopl_skel2);
		if (res>0)
			clbl("TSTOPL", res+pos+1, "Temporary string to pool");
		else {
			res=find_skel(tstopl_skel3);
			if (res<0)
				res=find_skel(tstopl_skel4);
			if (res>0)
				clbl("TSTOPL", res, "Temporary string to pool");
		}
		
		res=find_skel(opnpar_skel);
		if (res>0)
			clbl("OPNPAR", res+pos+1, "Chk Syntax, make sure '(' follows");

		res=find_skel(eval_skel);
		if (res>0) {
			clbl("EVAL", res+pos+1, "a.k.a. GETNUM, evaluate expression");
			clbl("EVAL1", res+pos+1+3, "Save precedence and eval until precedence break");
			clbl("EVAL2", res+pos+1+12, "Evaluate expression until precedence break");
			clbl("EVAL3", res+pos+1+15, "Evaluate expression until precedence break");
		}

		res=find_skel(eval_skel2);
		if (res>0) {
			clbl("EVAL", res+pos+1, "a.k.a. GETNUM, evaluate expression");
			clbl("EVAL1", res+pos+1+3, "Save precedence and eval until precedence break");
			clbl("EVAL2", res+pos+1+15, "Evaluate expression until precedence break");
			clbl("EVAL3", res+pos+1+18, "Evaluate expression until precedence break");
		}

		res=find_skel(eval_skel3);
		if (res>0) {
			clbl("EVAL", res+pos+1, "a.k.a. GETNUM, evaluate expression");
			clbl("EVAL1", res+pos+1+3, "Save precedence and eval until precedence break");
			clbl("EVAL2", res+pos+1+19, "Evaluate expression until precedence break");
			clbl("EVAL3", res+pos+1+22, "Evaluate expression until precedence break");
		}
		
		res=find_skel(getnum_skel);
		if (res<0)
			res=find_skel(getnum_skel2);
		if (res<0)
			res=find_skel(getnum_skel3);
		if (res>0) {
			//clbl("GETNUM", res, "BASIC interpreter entry to get a number (EVAL on recent versions)");
			clbl("EVAL", res+pos+1, "(a.k.a. GETNUM, evaluate expression (GETNUM)");
			clbl("EVAL1", res+pos+1+3, "Save precedence and eval until precedence break");
		}
		
		res=find_skel(eval3_ex_skel);
		if (res>0) {
			clbl("EVAL3", res+pos+1+3, "Evaluate expression until precedence break");
		}
		

		res=find_skel(stkths_skel);
		if (res>0)
			clbl("STKTHS", res+pos+1, "Stack expression item and get next one");

		res=find_skel(crtst_skel);
		if (res>0) {
			clbl("CRTST", res+pos+1, "Create String");
			clbl("QTSTR", res+pos+2, "Create quote terminated String");
			clbl("DTSTR", res+pos+5, "Create String, termination char in D");
		}
		
		res=find_skel(baktmp_skel);
		if (res<0)
			res=find_skel(baktmp_skel2);
		if (res>0)
			clbl("BAKTMP", res+pos+1, "Back to last tmp-str entry");
		
		res=find_skel(getstr_skel);
		if (res>0) {
			clbl("GETSTR", res+pos+1, "Get string pointed by FPREG 'Type Error' if it is not");
			clbl("GSTRCU", res+pos+1+3, "Get string pointed by FPREG");
			clbl("GSTRHL", res+pos+1+6, "Get string pointed by HL");
			clbl("GSTRDE", res+pos+1+7, "Get string pointed by DE");
		}
		
		res=find_skel(tststr_skel);
		if (res>0)
			clbl("TSTSTR", res, "Test a string, 'Type Error' if it is not");
		
		res=find_skel(numasc_skel);
		if (res>0)
			clbl("NUMASC", res, "Number to ASCII conversion");

		res=find_skel(atoh_skel);
		if (res<0)
			res=find_skel(atoh_skel2);
		if (res>0)
			clbl("ATOH", res+pos+1, "ASCII to Integer, result in DE");

		printf("\n");
		
		res=find_skel(lnum_range_skel);
		if (res>0) {
			clbl("LNUM_RANGE", res+pos+1, "Read numeric range function parameters");
			dlbl("LNUM_PARM", img[res+9] + 256*img[res+10], "Read numeric function parameter");
		}
		
		res=find_skel(getchr_skel);
		if (res<0)
		res=find_skel(getchr_skel2);
		if (res>0) {
			clbl("CHRGTB", res, "(a.k.a. GETCHR, GETNEXT), pick next char from program");
		} else {
			res=find_skel(getchr_skel3);
			if (res<0)
				res=find_skel(getchr_skel4);
			if (res<0)
				res=find_skel(getchr_skel5);
			if (res>0)
				clbl("CHRGTB", res+pos+1, "(a.k.a. GETCHR, GETNEXT), pick next char from program");
		}
	
		res=find_skel(chrgtb2_skel);
		if (res>0)
			clbl("_CHRGTB", res+pos, "Pick next char from program");

		res=find_skel(chrckb2_skel);
		if (res>0)
			clbl("_CHRCKB", res+pos+1, "Pick current char (or token) on program");
		
		res=find_skel(ucase_skel);
		if (res>0) {
			clbl("UCASE_HL", res+pos+1, "Get char from (HL) and make upper case");
			clbl("UCASE", res+pos+2, "Make char in 'A' upper case");
		}
		
		res=find_skel(getk_skel);
		if (res>0)
			clbl("GETK", res, "Get key in 'A'");
		
		res=find_skel(rinput_skel);
		if (res<0)
			res=find_skel(rinput_skel2);
		if (res<0)
			res=find_skel(rinput_skel3);
		if (res>0)
			clbl("RINPUT", res, "Line input");
		else {
			res=find_skel(rinput_skel4);
			if (res>0)
				clbl("RINPUT", res+pos, "Line input");
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
		if (res<0)
			res=find_skel(outc_skel6);
		if (res>0)
			clbl("OUTC", res, "Output char in 'A' to console");


		/* MS BASIC errors */
		
		printf("\n");
		
		res=find_skel(datsnr_skel);
		if (res>0) {
			clbl("DATSNR", res+pos+1, "'SN err' entry for Input STMT");
			clbl("SNERR", res+pos+1+6, "entry for '?SN ERROR'");
		}
		res=find_skel(fcerr_skel);
		if (res<0)
			res=find_skel(fcerr_skel2);
		if (res<0)
			res=find_skel(fcerr_skel3);
		if (res<0)
			res=find_skel(fcerr_skel4);
		if (res>0)
			clbl("FCERR", res, "entry for '?FC ERROR'");
		
		res=find_skel(ulerr_skel);
		if (res>0)
			clbl("ULERR", res, "entry for '?UL ERROR'");

		printf("\n\n");

		/* MS BASIC commands */
		jptab=find_skel(jptab_msbasic_skel);
		if (jptab<0)
			jptab=find_skel(jptab_msbasic_skel2);
		if (jptab<0)
			jptab=find_skel(jptab_msbasic_skel3);
		if (jptab>0) {
			printf("\n# JP table for statements = $%04X\n",jptab);
			if (SKOOLMODE) {
				printf("@ $%04x label=%s\n", jptab, "FNCTAB");
				printf("w $%04x %s\n", jptab, "Jump table for statements and functions");
			}

			printf("\n");

			/* hack for PC-6001 ROM v.60 */
			res=find_skel(pc6001_60_page);
			if (res>0) {
				jptab=0x134+0x61;
				printf("\n#   (applying a PC-6001 table shift hack, new pos: $%04X)\n",jptab);
			}
			
		}

		res=find_skel(tkmsbasic_ex_skel);
		
		if (res>0) {
			res+=1;
			
			printf("\n# TOKEN table position = $%04X, word list in 'extended BASIC' mode.\n",res);
			if (SKOOLMODE) {
				printf("@ $%04x label=%s\n", res-1, "WORDS");
				printf("t $%04x %s\n", res-1, "BASIC keyword list");
			}
			res-=pos;
			
			token_range=find_skel(tkrange_ex_skel);
			if (token_range>0)
				printf("#\tToken range: %d\n",token_range);
			else token_range=81;
			
			printf("\n# -- STATEMENTS --\n");
			
			res2=find_skel(lnum_tokens_skel);
			if ((res2>0) && (img[res2+14]==0)) {
					printf("\n#\tRESTORE\t\t[%d]\t",img[res2++]);
					printf("\n#\tAUTO\t\t[%d]\t",img[res2++]);
					printf("\n#\tRENUM\t\t[%d]\t",img[res2++]);
					printf("\n#\tDELETE\t\t[%d]\t",img[res2++]);
					printf("\n#\tRESUME\t\t[%d]\t",img[res2++]);
					printf("\n#\tERL\t\t[%d]\t",img[res2++]);
					printf("\n#\tELSE\t\t[%d]\t",img[res2++]);
					printf("\n#\tRUN\t\t[%d]\t",img[res2++]);
					printf("\n#\tLIST\t\t[%d]\t",img[res2++]);
					printf("\n#\tLLIST\t\t[%d]\t",img[res2++]);
					printf("\n#\tGOTO\t\t[%d]\t",img[res2++]);
					printf("\n#\tRETURN\t\t[%d]\t",img[res2++]);
					printf("\n#\tTHEN\t\t[%d]\t",img[res2++]);
					printf("\n#\tGOSUB\t\t[%d]\t",img[res2++]);
			}
			
			res2=find_skel(using_tokens_skel);
			if (res2>0) {
				if (SKOOLMODE) {
					res2 += 2;
					printf("\n@ $%04x label=__%s\n", img[res2] + 256*img[res2+1], "USING");
					printf("w $%04x %s\n", img[res2] + 256*img[res2+1], "PRINT USING");
				} else {
					printf("\n#\tUSING\t\t[%d]\t",img[res2]);
					res2 +=2;
					printf("- $%04X",img[res2] + 256*img[res2+1] );
				}
				res2 += 3;
				if (SKOOLMODE) {
					res2 += 2;
					printf("\n@ $%04x label=__%s\n", img[res2] + 256*img[res2+1], "TAB(");
					printf("w $%04x %s\n", img[res2] + 256*img[res2+1], "PRINT TAB(");
				} else {
					printf("\n#\tTAB(\t\t[%d]\t",img[res2]);
					res2 +=2;
					printf("- $%04X",img[res2] + 256*img[res2+1] );
				}
				res2 += 3;
				printf("\n#\tSPC(\t\t[%d]\t",img[res2]);
				printf("- same as TAB(");
			}

			res2=find_skel(equal_tk_skel);
			if (res2>0)
				printf("\n#\t= assignment\t\t[%d]\t",res2);
	
			res2=find_skel(tok_ex_skel);
			if (res2>0) {
				if (SKOOLMODE) {
					res2 += 2;
					printf("\n@ $%04x label=__%s\n", signed_byte(img[res2])+res2+1, "OPRND");
					printf("w $%04x %s\n", signed_byte(img[res2])+res2+1, "'+' operand evaluation");
				} else {
					printf("\n#\t+ operand\t\t[%d]\t",img[res2]);
					res2 += 2;
					printf("- $%04X",signed_byte(img[res2])+res2+1);
				}
				res2 += 2;
				
				if (SKOOLMODE) {
					res2 += 2;
					printf("\n@ $%04x label=__%s\n", img[res2] + 256*img[res2+1], "SUB_OPRND");
					printf("w $%04x %s\n", img[res2] + 256*img[res2+1], "'-' operand evaluation");
				} else {
					printf("\n#\t- operand\t\t[%d]\t",img[res2]);
					res2 += 2;
					printf("- $%04X",img[res2] + 256*img[res2+1] );
				}
				res2 += 3;
				
				if (SKOOLMODE) {
					res2 += 2;
					printf("\n@ $%04x label=__%s\n", img[res2] + 256*img[res2+1], "QTSTR");
					printf("w $%04x %s\n", img[res2] + 256*img[res2+1], "quoted string evaluation");
				} else {
					printf("\n#\t\" string\t\t[%d]\t",img[res2]);
					res2 += 2;
					printf("- $%04X",img[res2] + 256*img[res2+1] );
				}
				res2 += 3;
				
				if (SKOOLMODE) {
					res2 += 2;
					printf("\n@ $%04x label=__%s\n", img[res2] + 256*img[res2+1], "NOT");
					printf("w $%04x %s\n", img[res2] + 256*img[res2+1], "eval NOT boolean operation");
				} else {
					printf("\n#\tNOT\t\t[%d]\t",img[res2]);
					res2 += 2;
					printf("- $%04X",img[res2] + 256*img[res2+1] );
				}
				res2 += 3;
				
				if (SKOOLMODE) {
					res2 += 2;
					printf("\n@ $%04x label=__%s\n", img[res2] + 256*img[res2+1], "HEXTFP");
					printf("w $%04x %s\n", img[res2] + 256*img[res2+1], "Convert HEX to FP");
				} else {
					printf("\n#\t& specifier\t\t[%d]\t",img[res2]);
					res2 += 2;
					printf("- $%04X",img[res2] + 256*img[res2+1] );
				}
				res2 += 3;
				
				if (img[res2+1] == 0x20) {
					if (SKOOLMODE) {
						printf("\n@ $%04x label=__%s\n", res2+3, "ERR");
						printf("w $%04x %s\n", res2+3, "ERR function evaluation");
					} else {
						printf("\n#\tERR\t\t[%d]\t",img[res2]);
						printf("- $%04X",res2+3);
					}
					/* JR to next OPCODE group */
					res2 += 2;
					res2=signed_byte(img[res2])+res2+1;
					if ((img[res2] == 0xFE)&&(img[res2+2] == 0x20)) {
						res2++;
						if (SKOOLMODE) {
							printf("\n@ $%04x label=__%s\n", res2+3, "ERL");
							printf("w $%04x %s\n", res2+3, "ERL function evaluation");
						} else {
							printf("\n#\tERL\t\t[%d]\t",img[res2]);
							printf("- $%04X",res2+3);
						}
					/* JR to next OPCODE group */
					res2 += 2;
					res2=signed_byte(img[res2])+res2+1;
					if (img[res2] == 0xFE)
						if (img[res2+2]==0xCA) {
							/* Extra commands only in latest versions (MSX, SVI..) */
							res2++;
							while (img[res2+1]==0xCA)  {
								printf("\n#\tTOKEN_?\t\t[%d]\t",img[res2]);
								res2 += 2;
								printf("- $%04X",img[res2] + 256*img[res2+1] );
								res2 += 3;
							}
							res2--;
						}
						if (img[res2+2]==0x20) {
							/* This should be present also on all the later Ext. Basic variants */
							res2++;
							if (SKOOLMODE) {
								printf("\n@ $%04x label=__%s\n", res2+3, "VARPTR");
								printf("w $%04x %s\n", res2+3, "VARPTR function evaluation");
							} else {
								printf("\n#\tVARPTR\t\t[%d]\t",img[res2]);
								printf("- $%04X",res2+3);
							}
							/* JR to next OPCODE group */
							res2 += 2;
							res2=signed_byte(img[res2])+res2+1;
							if ((img[res2] == 0xFE) && (img[res2+2]==0xCA)) {
								res2++;
								if (SKOOLMODE) {
									res2 += 2;
									printf("\n@ $%04x label=__%s\n", img[res2] + 256*img[res2+1], "USR");
									printf("w $%04x %s\n", img[res2] + 256*img[res2+1], "eval user M/C functions");
								} else {
									printf("\n#\tUSR\t\t[%d]\t",img[res2]);
									res2 += 2;
									printf("- $%04X",img[res2] + 256*img[res2+1] );
								}
								res2 += 3;
	
								if (SKOOLMODE) {
									res2 += 2;
									printf("\n@ $%04x label=__%s\n", img[res2] + 256*img[res2+1], "INSTR");
									printf("w $%04x %s\n", img[res2] + 256*img[res2+1], "INSTR function");
								} else {
									printf("\n#\tINSTR\t\t[%d]\t",img[res2]);
									res2 += 2;
									printf("- $%04X",img[res2] + 256*img[res2+1] );
								}
								res2 += 3;
								
								/* TOKEN list order here changes depending on the implementation,
								   e.g. POINT on TA Alphatronics, INKEY$ on SVI and MSX */
								while (img[res2+1]==0xCA)  {
									printf("\n#\tTOKEN_?\t\t[%d]\t",img[res2]);
									res2 += 2;
									printf("- $%04X",img[res2] + 256*img[res2+1] );
									res2 += 3;
								}
								res2--;
								
							}
						}
					}
				}

				
			}
			printf("\n");
			
			res2=find_skel(else_token_skel);
			if (res2>0)
				printf("\n#\tELSE\t\t[%d]\n",res2);

			chr='A';
			clear_token();
			append_c(chr);
			printf("\n#\t%c", chr);

			for (i=res; img[i+8]!='<'; i++) {
				if ((img[i-1]==0)&&(img[i]==0)) {chr++; i++;}
				
				if (img[i-1]==0) {
					if (token[1]  == '\0')
					printf("\n#");
					chr++; printf("\t%c", chr); clear_token(); append_c(chr);
				}

				c=img[i];
				if (c>=128)	{
					c-=128;
					printf("%c",c);
					append_c(c);
					i++;
					

					if (jptab>0) {
						if (img[i]>128) {
							/* MSX/SVI: to be excluded codes between 217 and 220 */
							/* Depending on "token_range" other cases may be different !!  (e.g. Triumph Adler Alphatronic..) */
							if (img[i]<(129+token_range)) {
									address=img[jptab+2*(img[i]-129)-pos]+256*img[jptab+2*(img[i]-129)-pos+1];
									if (SKOOLMODE)
										printf("\n@ $%04x label=__%s\n#", address, token);
									else
										printf("      \t[%d]\t- $%04X\n#",img[i],address);
							} else
								printf("      \t[%d]\n#",img[i]);
						} else {
							address=img[jptab+2*(img[i]+token_range-1)-pos]+256*img[jptab+2*(img[i]+token_range-1)-pos+1];
							if (SKOOLMODE)
								printf("\n@ $%04x label=__%s\n#", address, token);
							else
							printf("      \t[%d]\t- $%04X\n#",img[i],address);
						}
					} else
						printf("      \t[%d]\n#",img[i]);

					if (img[i+1]!=0) {printf("\t%c", chr); clear_token(); append_c(chr);}
				} else if (c!=0) {printf("%c",c); append_c(c);}
			}

			
		} else {
			
			
		/* Classic MS BASIC MODE */
		
			res=find_skel(tkmsbasic_skel)-1;
			if (res<0)
				res=find_skel(tkmsbasic_skel2);
			if (res<0)
				res=find_skel(tkmsbasic_skel3);
			if (res<0)
				res=find_skel(tkmsbasic_skel4)+1;
			if (res>0) {
				res=res+1-pos;
				printf("\n\n\n# TOKEN table position = $%04X, word list in classic encoding mode\n",res+pos);
				if (SKOOLMODE) {
					printf("@ $%04x label=%s\n", res+pos-1, "WORDS");
					printf("t $%04x %s\n", res+pos-1, "BASIC keyword list");
				}
				new_tk_found=0;
				printf("\n# -- STATEMENTS --\n");
				printf("\n#\t ---  ");
				chr=find_skel(tkmsbasic_code_skel)+1;
				for (i=res; img[i]!=128; i++) {
					
					if ((new_tk_found!=1) && (((c == 'W') && (img[i-2] == 'E') && ((img[i-3] == 'N') || (img[i-3] == ('N'+0x80)))) && (img[i+1] != 'L'))) {
						new_tk_found=1;
						printf("\n\n# -- OPERATORS & extras --\n");
					}
					
					if ((c == '<') && ((img[i-2] != '=') || (img[i-2] != ('='+0x80)))) {
						jptab=find_skel(fnctab_msbasic_skel);
						if (jptab<0)
							jptab=find_skel(fnctab_msbasic_skel2);
						if (jptab<0)
							jptab=find_skel(fnctab_msbasic_skel3);
						if (jptab>0) {
							printf("\n\n# JP table for functions = $%04X\n",jptab);
							if (SKOOLMODE) {
								printf("@ $%04x label=%s\n", jptab, "FNCTAB_FN");
								printf("w $%04x %s\n", jptab, "Extra jump table for functions");
							}
							/* hack for PC-6001 ROM v.60 */
							res=find_skel(pc6001_60_page);
							if (res>0) {
								jptab=0x134+0xB7;
								printf("\n\n#   (applying a PC-6001 table shift hack, new pos: $%04X)\n\n",jptab);
							}
						}
						new_tk_found=0;
						printf("\n# -- FUNCTIONS --\n");
					}
					
					c=img[i];
					if (c>=128) {
						c-=128; 
						if (((jptab-pos)>0) && !(new_tk_found)) {
							address=img[jptab-pos]+256*img[jptab-pos+1];
							if (SKOOLMODE)
								printf("\n@ $%04x label=__%s", address, token);
								//printf("t $%04x %s\n", img[jptab-pos]+256*img[jptab-pos+1], token);
							else
								printf("\n$%04X - [%d] ", address, chr);

							jptab+=2;
						} else {
							printf("\n#\t %d  ",chr);
						}
						chr++;
					}
					
					printf("%c",c);
					
					if ((new_tk_found!=1) && (
						((img[i+1]  == 'T'+0x80) && (img[i+2] == 'A') && ((img[i+3] == 'B') || (img[i+3] == ('B'))))
						|| ((img[i+2] == 'S') && (img[i+3] == 'I') && (img[i+4] == 'N') && ((img[i+5] == 'G')||(img[i+5] == 'G'+0x80)))
						)) {
						new_tk_found=1;
						printf("\n\n# -- OPERATORS & extras --\n");
					}

				}	
			} else {

				res=find_skel(tkmsbasic_old_skel);
				if (res<0)
					res=find_skel(tkmsbasic_old_skel);
				if (res>0) {
					res=res+1;
					printf("\n\n\n# TOKEN table position = $%04X, word list in earlier encoding mode.\n",res+pos);
					new_tk_found=0;
					printf("\n# -- STATEMENTS --\n");
					printf("\n#\t ---  ");
					chr=128;
					
					if ((jptab-pos)>0) {
							address=img[jptab-pos]+256*img[jptab-pos+1];
							if (SKOOLMODE)
								printf("\n@ $%04x label=__%s", address, token);
							else
								printf("\n$%04X - [%d] ", address, chr);
							jptab+=2;
					}
					else
							printf("\n#\t %d  ",chr);
						
					for (i=res; ((img[i]!=128)&&(img[i]!=0)); i++) {
						c=img[i];
						if (c>=128) c-=128;
						if (!new_tk_found && (
								(img[i+1]  == '@') || ((img[i+1]  == 'T') && (img[i+2] == 'A') && ((img[i+3] == 'B') || (img[i+3] == ('B'+0x80)))) 
								|| ((img[i+1] == 'T') && (img[i+2] == 'O'+0x80) && (img[i+3] == 'F') && (img[i+4] == 'N'+0x80)) 
								|| ((img[i+2] == 'S') && (img[i+3] == 'I') && (img[i+4] == 'N') && (img[i+5] == 'G'+0x80))
							)) {
							printf("%c",c);
							new_tk_found=1;
							printf("\n\n# -- OPERATORS & extras --\n");
						} else {
							if ((img[i+1]  == 'S') && (img[i+2] == 'G') && ((img[i+3] == 'N') || (img[i+3] == ('N'+0x80)))) {
								printf("%c",c);
								jptab=find_skel(fnctab_msbasic_skel);
								if (jptab<0)
									jptab=find_skel(fnctab_msbasic_skel2);
								if (jptab<0)
									jptab=find_skel(fnctab_msbasic_skel3);
								if ((jptab-pos)>0) {
									printf("\n\n# JP table for functions = $%04X\n",jptab);
									if (SKOOLMODE) {
										printf("@ $%04x label=%s\n", jptab, "FNCTAB_FN");
										printf("w $%04x %s\n", jptab, "Extra jump table for functions");
									}
								}
								new_tk_found=0;
								printf("\n# -- FUNCTIONS --\n");
							} else	printf("%c",c);
						}
						if (img[i]>=128) {
							if (((jptab-pos)>0) && !(new_tk_found)) {
								address=img[jptab-pos]+256*img[jptab-pos+1];
								if (SKOOLMODE)
									printf("\n@ $%04x label=__%s", address, token);
								else
									printf("\n$%04X - [%d] ", address, chr);
								jptab+=2;
							} else
								printf("\n#\t %d  ",chr);
							chr++;
						}

					}
				}
			
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
						c=img[i] & 0xBF;
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

/***************************************************************
 *		MemoDB.h
 *			Header for Rex addin program.
 ***************************************************************/
#ifndef MEMODB_H
#define MEMODB_H

	//Table 4000
	enum {
		MEMO_RECID = 1,
		MEMO_TITLE,
		MEMO_ISREAD,
		MEMO_LINE,
		MEMO_SHIORI,
		MEMO_BODY,
		MEMO_CATEGORY
	};

	enum {
		IDX_MEMO_ID = 1,
		IDX_MEMO_TITLE
	};
	
	//Table 4001: see StatusDB.h

	//Table 4002
	enum {
		MEMOCAT_ID = 1,
		MEMOCAT_NAME,
		MEMOCAT_RECORDS,
		MEMOCAT_IMPREC
	};

	enum {
		IDX_MEMOCAT_ID = 1,
		IDX_MEMOCAT_NAME
	};

	//Table 4003
	enum {
		MEMOLNK_MEMO_RECID = 1,
		MEMOLNK_CATEGORY_SEQ,
		MEMOLNK_CATEGORY_ID,
		MEMOLNK_HEADING,
		MEMOLNK_CATHEADING
	};

	enum {
		IDX_MEMOLNK_KEY = 1,
		IDX_MEMOLNK_HEADING,
		IDX_MEMOLNK_CATSEQ
	};
	
	//Table 4004: see TextInfDB.h

#endif



/***************************************************************
 *		TaskDB.h
 *			Header for Rex addin program.
 ***************************************************************/
#ifndef TASKDB_H
#define TASKDB_H

	//Table 3000
	enum {
		TASK_RECID = 1,
		TASK_TITLE,
		TASK_NOTES,
		TASK_STARTDATE,
		TASK_DUEDATE,
		TASK_COMPLETE,
		TASK_PRIORITY,
		TASK_ENDDATE,
		TASK_ALARMDATE
	};

	enum {
		IDX_TASK_ID = 1,
		IDX_TASK_TITLE
	};
	
	//Table 3001: see StatusDB.h

	//Table 3002: unknown

	//Table 3003: unknown
	
	//Table 3004: see TextInfDB.h

#endif



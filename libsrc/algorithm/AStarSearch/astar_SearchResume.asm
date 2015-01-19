; struct astar_path __FASTCALL__ *astar_SearchResume(struct astar_path *p)
; resume a search previously stopped
; 01.2007 aralbrec

PUBLIC astar_SearchResume
EXTERN astar_Search
EXTERN ASMDISP_ASTAR_SEARCH_RESUME_SUCCESS, ASMDISP_ASTAR_SEARCH_RESUME_FAIL

; enter : hl = path to start search with
;              if 0, search not resumed from path but from queue

.astar_SearchResume

   ld a,h
   or l
   jp z, astar_Search + ASMDISP_ASTAR_SEARCH_RESUME_SUCCESS
   
   jp astar_Search + ASMDISP_ASTAR_SEARCH_RESUME_FAIL

/*
 *      Main Topic include file
 *
 *      Do not include yourself!!
 */


#ifdef TOPIC1
.in_topic1
                defb in_topic1end - in_topic1
                APPLTEXT(TOPIC1)
#ifdef TOPIC1HELP1
                defb    ( in_topic1_hlp - in_help) / 256
                defb    ( in_topic1_hlp - in_help) % 256
#else
                defb    0,0             ;ptr to help - use \0 of TOPIC1
#endif
#ifdef TOPIC1ATTR
                APPLBYTE(TOPIC1ATTR)
#else
                defb    0
#endif 
                defb in_topic1end - in_topic1
.in_topic1end
#endif /* TOPIC1 */


#ifdef TOPIC2
.in_topic2
                defb in_topic2end - in_topic2
                APPLTEXT(TOPIC2)
#ifdef TOPIC2HELP1
                defb    ( in_topic2_hlp - in_help) / 256
                defb    ( in_topic2_hlp - in_help) % 256
#else
                defb    0,0             ;ptr to help - use \0 of TOPIC2
#endif
#ifdef TOPIC2ATTR
                APPLBYTE(TOPIC2ATTR)
#else
                defb    0
#endif 
                defb in_topic2end - in_topic2
.in_topic2end
#endif /* TOPIC2 */


#ifdef TOPIC3
.in_topic3
                defb in_topic3end - in_topic3
                APPLTEXT(TOPIC3)
#ifdef TOPIC3HELP1
                defb    ( in_topic3_hlp - in_help) / 256
                defb    ( in_topic3_hlp - in_help) % 256
#else
                defb    0,0             ;ptr to help - use \0 of TOPIC3
#endif
#ifdef TOPIC3ATTR
                APPLBYTE(TOPIC3ATTR)
#else
                defb    0
#endif 
                defb in_topic3end - in_topic3
.in_topic3end
#endif /* TOPIC3 */


#ifdef TOPIC4
.in_topic4
                defb in_topic4end - in_topic4
                APPLTEXT(TOPIC4)
#ifdef TOPIC4HELP1
                defb    ( in_topic4_hlp - in_help) / 256
                defb    ( in_topic4_hlp - in_help) % 256
#else
                defb    0,0             ;ptr to help - use \0 of TOPIC4
#endif
#ifdef TOPIC4ATTR
                APPLBYTE(TOPIC4ATTR)
#else
                defb    0
#endif 
                defb in_topic4end - in_topic4
.in_topic4end
#endif /* TOPIC4 */


#ifdef TOPIC5
.in_topic5
                defb in_topic5end - in_topic5
                APPLTEXT(TOPIC5)
#ifdef TOPIC5HELP1
                defb    ( in_topic5_hlp - in_help) / 256
                defb    ( in_topic5_hlp - in_help) % 256
#else
                defb    0,0             ;ptr to help - use \0 of TOPIC5
#endif
#ifdef TOPIC5ATTR
                APPLBYTE(TOPIC5ATTR)
#else
                defb    0
#endif 
                defb in_topic5end - in_topic5
.in_topic5end
#endif /* TOPIC5 */


#ifdef TOPIC6
.in_topic6
                defb in_topic6end - in_topic6
                APPLTEXT(TOPIC6)
#ifdef TOPIC6HELP1
                defb    ( in_topic6_hlp - in_help) / 256
                defb    ( in_topic6_hlp - in_help) % 256
#else
                defb    0,0             ;ptr to help - use \0 of TOPIC6
#endif
#ifdef TOPIC6ATTR
                APPLBYTE(TOPIC6ATTR)
#else
                defb    0
#endif 
                defb in_topic6end - in_topic6
.in_topic6end
#endif /* TOPIC6 */


#ifdef TOPIC7
.in_topic7
                defb in_topic7end - in_topic7
                APPLTEXT(TOPIC7)
#ifdef TOPIC7HELP1
                defb    ( in_topic7_hlp - in_help) / 256
                defb    ( in_topic7_hlp - in_help) % 256
#else
                defb    0,0             ;ptr to help - use \0 of TOPIC7
#endif
#ifdef TOPIC7ATTR
                APPLBYTE(TOPIC7ATTR)
#else
                defb    0
#endif 
                defb in_topic7end - in_topic7
.in_topic7end
#endif /* TOPIC7 */



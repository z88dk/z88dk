/*
 *      Header for command entries for Topic 4
 *
 *      Do not include yourself - included by application.h
 *
 *      7/4/99 djm
 */


#ifdef TOPIC4_1
.in_com_4_1
        defb    in_com_4_1end - in_com_4_1
        APPLBYTE(TOPIC4_1CODE)
        APPLNAME(TOPIC4_1KEY)
        APPLTEXT(TOPIC4_1)
#ifdef TOPIC4_1HELP1
        defb    (in_com_hlp4_1 - in_help) /256
        defb    (in_com_hlp4_1 - in_help) %256
#else
        defb    0,0               ;pointer to help - use \0
#endif  /* TOPIC4_1HELP1) */
#ifdef TOPIC4_1ATTR
        APPLBYTE(TOPIC4_1ATTR)
#else
        defb    0
#endif /* TOPIC4_1ATTR */
        defb    in_com_4_1end - in_com_4_1
.in_com_4_1end
#endif /* TOPIC4_1 */


#ifdef TOPIC4_2
.in_com_4_2
        defb    in_com_4_2end - in_com_4_2
        APPLBYTE(TOPIC4_2CODE)
        APPLNAME(TOPIC4_2KEY)
        APPLTEXT(TOPIC4_2)
#ifdef TOPIC4_2HELP1
        defb    (in_com_hlp4_2 - in_help) /256
        defb    (in_com_hlp4_2 - in_help) %256
#else
        defb    0,0               ;pointer to help - use \0
#endif  /* TOPIC4_2HELP1) */
#ifdef TOPIC4_2ATTR
        APPLBYTE(TOPIC4_2ATTR)
#else
        defb    0
#endif /* TOPIC4_2ATTR */
        defb    in_com_4_2end - in_com_4_2
.in_com_4_2end
#endif /* TOPIC4_2 */


#ifdef TOPIC4_3
.in_com_4_3
        defb    in_com_4_3end - in_com_4_3
        APPLBYTE(TOPIC4_3CODE)
        APPLNAME(TOPIC4_3KEY)
        APPLNAME(TOPIC4_3)
#ifdef TOPIC4_3HELP1
        defb    (in_com_hlp4_3 - in_help) /256
        defb    (in_com_hlp4_3 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_3HELP1) */
#ifdef TOPIC4_3ATTR
        APPLBYTE(TOPIC4_3ATTR)
#else
        defb    0
#endif /* TOPIC4_3ATTR */
        defb    in_com_4_3end - in_com_4_3
.in_com_4_3end
#endif /* TOPIC4_3 */


#ifdef TOPIC4_4
.in_com_4_4
        defb    in_com_4_4end - in_com_4_4
        APPLBYTE(TOPIC4_4CODE)
        APPLNAME(TOPIC4_4KEY)
        APPLNAME(TOPIC4_4)
#ifdef TOPIC4_4HELP1
        defb    (in_com_hlp4_4 - in_help) /256
        defb    (in_com_hlp4_4 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_4HELP1) */
#ifdef TOPIC4_4ATTR
        APPLBYTE(TOPIC4_4ATTR)
#else
        defb    0
#endif /* TOPIC4_4ATTR */
        defb    in_com_4_4end - in_com_4_4
.in_com_4_4end
#endif /* TOPIC4_4 */


#ifdef TOPIC4_5
.in_com_4_5
        defb    in_com_4_5end - in_com_4_5
        APPLBYTE(TOPIC4_5CODE)
        APPLNAME(TOPIC4_5KEY)
        APPLNAME(TOPIC4_5)
#ifdef TOPIC4_5HELP1
        defb    (in_com_hlp4_5 - in_help) /256
        defb    (in_com_hlp4_5 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_5HELP1) */
#ifdef TOPIC4_5ATTR
        APPLBYTE(TOPIC4_5ATTR)
#else
        defb    0
#endif /* TOPIC4_5ATTR */
        defb    in_com_4_5end - in_com_4_5
.in_com_4_5end
#endif /* TOPIC4_5 */


#ifdef TOPIC4_6
.in_com_4_6
        defb    in_com_4_6end - in_com_4_6
        APPLBYTE(TOPIC4_6CODE)
        APPLNAME(TOPIC4_6KEY)
        APPLNAME(TOPIC4_6)
#ifdef TOPIC4_6HELP1
        defb    (in_com_hlp4_6 - in_help) /256
        defb    (in_com_hlp4_6 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_6HELP1) */
#ifdef TOPIC4_6ATTR
        APPLBYTE(TOPIC4_6ATTR)
#else
        defb    0
#endif /* TOPIC4_6ATTR */
        defb    in_com_4_6end - in_com_4_6
.in_com_4_6end
#endif /* TOPIC4_6 */


#ifdef TOPIC4_7
.in_com_4_7
        defb    in_com_4_7end - in_com_4_7
        APPLBYTE(TOPIC4_7CODE)
        APPLNAME(TOPIC4_7KEY)
        APPLNAME(TOPIC4_7)
#ifdef TOPIC4_7HELP1
        defb    (in_com_hlp4_7 - in_help) /256
        defb    (in_com_hlp4_7 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_7HELP1) */
#ifdef TOPIC4_7ATTR
        APPLBYTE(TOPIC4_7ATTR)
#else
        defb    0
#endif /* TOPIC4_7ATTR */
        defb    in_com_4_7end - in_com_4_7
.in_com_4_7end
#endif /* TOPIC4_7 */


#ifdef TOPIC4_8
.in_com_4_8
        defb    in_com_4_8end - in_com_4_8
        APPLBYTE(TOPIC4_8CODE)
        APPLNAME(TOPIC4_8KEY)
        APPLNAME(TOPIC4_8)
#ifdef TOPIC4_8HELP1
        defb    (in_com_hlp4_8 - in_help) /256
        defb    (in_com_hlp4_8 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_8HELP1) */
#ifdef TOPIC4_8ATTR
        APPLBYTE(TOPIC4_8ATTR)
#else
        defb    0
#endif /* TOPIC4_8ATTR */
        defb    in_com_4_8end - in_com_4_8
.in_com_4_8end
#endif /* TOPIC4_8 */


#ifdef TOPIC4_9
.in_com_4_9
        defb    in_com_4_9end - in_com_4_9
        APPLBYTE(TOPIC4_9CODE)
        APPLNAME(TOPIC4_9KEY)
        APPLNAME(TOPIC4_9)
#ifdef TOPIC4_9HELP1
        defb    (in_com_hlp4_9 - in_help) /256
        defb    (in_com_hlp4_9 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_9HELP1) */
#ifdef TOPIC4_9ATTR
        APPLBYTE(TOPIC4_9ATTR)
#else
        defb    0
#endif /* TOPIC4_9ATTR */
        defb    in_com_4_9end - in_com_4_9
.in_com_4_9end
#endif /* TOPIC4_9 */


#ifdef TOPIC4_10
.in_com_4_10
        defb    in_com_4_10end - in_com_4_10
        APPLBYTE(TOPIC4_10CODE)
        APPLNAME(TOPIC4_10KEY)
        APPLNAME(TOPIC4_10)
#ifdef TOPIC4_10HELP1
        defb    (in_com_hlp4_10 - in_help) /256
        defb    (in_com_hlp4_10 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_10HELP1) */
#ifdef TOPIC4_10ATTR
        APPLBYTE(TOPIC4_10ATTR)
#else
        defb    0
#endif /* TOPIC4_10ATTR */
        defb    in_com_4_10end - in_com_4_10
.in_com_4_10end
#endif /* TOPIC4_10 */


#ifdef TOPIC4_11
.in_com_4_11
        defb    in_com_4_11end - in_com_4_11
        APPLBYTE(TOPIC4_11CODE)
        APPLNAME(TOPIC4_11KEY)
        APPLNAME(TOPIC4_11)
#ifdef TOPIC4_11HELP1
        defb    (in_com_hlp4_11 - in_help) /256
        defb    (in_com_hlp4_11 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_11HELP1) */
#ifdef TOPIC4_11ATTR
        APPLBYTE(TOPIC4_11ATTR)
#else
        defb    0
#endif /* TOPIC4_11ATTR */
        defb    in_com_4_11end - in_com_4_11
.in_com_4_11end
#endif /* TOPIC4_11 */


#ifdef TOPIC4_12
.in_com_4_12
        defb    in_com_4_12end - in_com_4_12
        APPLBYTE(TOPIC4_12CODE)
        APPLNAME(TOPIC4_12KEY)
        APPLNAME(TOPIC4_12)
#ifdef TOPIC4_12HELP1
        defb    (in_com_hlp4_12 - in_help) /256
        defb    (in_com_hlp4_12 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_12HELP1) */
#ifdef TOPIC4_12ATTR
        APPLBYTE(TOPIC4_12ATTR)
#else
        defb    0
#endif /* TOPIC4_12ATTR */
        defb    in_com_4_12end - in_com_4_12
.in_com_4_12end
#endif /* TOPIC4_12 */


#ifdef TOPIC4_13
.in_com_4_13
        defb    in_com_4_13end - in_com_4_13
        APPLBYTE(TOPIC4_13CODE)
        APPLNAME(TOPIC4_13KEY)
        APPLNAME(TOPIC4_13)
#ifdef TOPIC4_13HELP1
        defb    (in_com_hlp4_13 - in_help) /256
        defb    (in_com_hlp4_13 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_13HELP1) */
#ifdef TOPIC4_13ATTR
        APPLBYTE(TOPIC4_13ATTR)
#else
        defb    0
#endif /* TOPIC4_13ATTR */
        defb    in_com_4_13end - in_com_4_13
.in_com_4_13end
#endif /* TOPIC4_13 */


#ifdef TOPIC4_14
.in_com_4_14
        defb    in_com_4_14end - in_com_4_14
        APPLBYTE(TOPIC4_14CODE)
        APPLNAME(TOPIC4_14KEY)
        APPLNAME(TOPIC4_14)
#ifdef TOPIC4_14HELP1
        defb    (in_com_hlp4_14 - in_help) /256
        defb    (in_com_hlp4_14 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_14HELP1) */
#ifdef TOPIC4_14ATTR
        APPLBYTE(TOPIC4_14ATTR)
#else
        defb    0
#endif /* TOPIC4_14ATTR */
        defb    in_com_4_14end - in_com_4_14
.in_com_4_14end
#endif /* TOPIC4_14 */


#ifdef TOPIC4_15
.in_com_4_15
        defb    in_com_4_15end - in_com_4_15
        APPLBYTE(TOPIC4_15CODE)
        APPLNAME(TOPIC4_15KEY)
        APPLNAME(TOPIC4_15)
#ifdef TOPIC4_15HELP1
        defb    (in_com_hlp4_15 - in_help) /256
        defb    (in_com_hlp4_15 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_15HELP1) */
#ifdef TOPIC4_15ATTR
        APPLBYTE(TOPIC4_15ATTR)
#else
        defb    0
#endif /* TOPIC4_15ATTR */
        defb    in_com_4_15end - in_com_4_15
.in_com_4_15end
#endif /* TOPIC4_15 */


#ifdef TOPIC4_16
.in_com_4_16
        defb    in_com_4_16end - in_com_4_16
        APPLBYTE(TOPIC4_16CODE)
        APPLNAME(TOPIC4_16KEY)
        APPLNAME(TOPIC4_16)
#ifdef TOPIC4_16HELP1
        defb    (in_com_hlp4_16 - in_help) /256
        defb    (in_com_hlp4_16 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_16HELP1) */
#ifdef TOPIC4_16ATTR
        APPLBYTE(TOPIC4_16ATTR)
#else
        defb    0
#endif /* TOPIC4_16ATTR */
        defb    in_com_4_16end - in_com_4_16
.in_com_4_16end
#endif /* TOPIC4_16 */


#ifdef TOPIC4_17
.in_com_4_17
        defb    in_com_4_17end - in_com_4_17
        APPLBYTE(TOPIC4_17CODE)
        APPLNAME(TOPIC4_17KEY)
        APPLNAME(TOPIC4_17)
#ifdef TOPIC4_17HELP1
        defb    (in_com_hlp4_17 - in_help) /256
        defb    (in_com_hlp4_17 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_17HELP1) */
#ifdef TOPIC4_17ATTR
        APPLBYTE(TOPIC4_17ATTR)
#else
        defb    0
#endif /* TOPIC4_17ATTR */
        defb    in_com_4_17end - in_com_4_17
.in_com_4_17end
#endif /* TOPIC4_17 */


#ifdef TOPIC4_18
.in_com_4_18
        defb    in_com_4_18end - in_com_4_18
        APPLBYTE(TOPIC4_18CODE)
        APPLNAME(TOPIC4_18KEY)
        APPLNAME(TOPIC4_18)
#ifdef TOPIC4_18HELP1
        defb    (in_com_hlp4_18 - in_help) /256
        defb    (in_com_hlp4_18 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_18HELP1) */
#ifdef TOPIC4_18ATTR
        APPLBYTE(TOPIC4_18ATTR)
#else
        defb    0
#endif /* TOPIC4_18ATTR */
        defb    in_com_4_18end - in_com_4_18
.in_com_4_18end
#endif /* TOPIC4_18 */


#ifdef TOPIC4_19
.in_com_4_19
        defb    in_com_4_19end - in_com_4_19
        APPLBYTE(TOPIC4_19CODE)
        APPLNAME(TOPIC4_19KEY)
        APPLNAME(TOPIC4_19)
#ifdef TOPIC4_19HELP1
        defb    (in_com_hlp4_19 - in_help) /256
        defb    (in_com_hlp4_19 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_19HELP1) */
#ifdef TOPIC4_19ATTR
        APPLBYTE(TOPIC4_19ATTR)
#else
        defb    0
#endif /* TOPIC4_19ATTR */
        defb    in_com_4_19end - in_com_4_19
.in_com_4_19end
#endif /* TOPIC4_19 */


#ifdef TOPIC4_20
.in_com_4_20
        defb    in_com_4_20end - in_com_4_20
        APPLBYTE(TOPIC4_20CODE)
        APPLNAME(TOPIC4_20KEY)
        APPLNAME(TOPIC4_20)
#ifdef TOPIC4_20HELP1
        defb    (in_com_hlp4_20 - in_help) /256
        defb    (in_com_hlp4_20 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_20HELP1) */
#ifdef TOPIC4_20ATTR
        APPLBYTE(TOPIC4_20ATTR)
#else
        defb    0
#endif /* TOPIC4_20ATTR */
        defb    in_com_4_20end - in_com_4_20
.in_com_4_20end
#endif /* TOPIC4_20 */


#ifdef TOPIC4_21
.in_com_4_21
        defb    in_com_4_21end - in_com_4_21
        APPLBYTE(TOPIC4_21CODE)
        APPLNAME(TOPIC4_21KEY)
        APPLNAME(TOPIC4_21)
#ifdef TOPIC4_21HELP1
        defb    (in_com_hlp4_21 - in_help) /256
        defb    (in_com_hlp4_21 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_21HELP1) */
#ifdef TOPIC4_21ATTR
        APPLBYTE(TOPIC4_21ATTR)
#else
        defb    0
#endif /* TOPIC4_21ATTR */
        defb    in_com_4_21end - in_com_4_21
.in_com_4_21end
#endif /* TOPIC4_21 */


#ifdef TOPIC4_22
.in_com_4_22
        defb    in_com_4_22end - in_com_4_22
        APPLBYTE(TOPIC4_22CODE)
        APPLNAME(TOPIC4_22KEY)
        APPLNAME(TOPIC4_22)
#ifdef TOPIC4_22HELP1
        defb    (in_com_hlp4_22 - in_help) /256
        defb    (in_com_hlp4_22 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_22HELP1) */
#ifdef TOPIC4_22ATTR
        APPLBYTE(TOPIC4_22ATTR)
#else
        defb    0
#endif /* TOPIC4_22ATTR */
        defb    in_com_4_22end - in_com_4_22
.in_com_4_22end
#endif /* TOPIC4_22 */


#ifdef TOPIC4_23
.in_com_4_23
        defb    in_com_4_23end - in_com_4_23
        APPLBYTE(TOPIC4_23CODE)
        APPLNAME(TOPIC4_23KEY)
        APPLNAME(TOPIC4_23)
#ifdef TOPIC4_23HELP1
        defb    (in_com_hlp4_23 - in_help) /256
        defb    (in_com_hlp4_23 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_23HELP1) */
#ifdef TOPIC4_23ATTR
        APPLBYTE(TOPIC4_23ATTR)
#else
        defb    0
#endif /* TOPIC4_23ATTR */
        defb    in_com_4_23end - in_com_4_23
.in_com_4_23end
#endif /* TOPIC4_23 */


#ifdef TOPIC4_24
.in_com_4_24
        defb    in_com_4_24end - in_com_4_24
        APPLBYTE(TOPIC4_24CODE)
        APPLNAME(TOPIC4_24KEY)
        APPLNAME(TOPIC4_24)
#ifdef TOPIC4_24HELP1
        defb    (in_com_hlp4_24 - in_help) /256
        defb    (in_com_hlp4_24 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC4_24HELP1) */
#ifdef TOPIC4_24ATTR
        APPLBYTE(TOPIC4_24ATTR)
#else
        defb    0
#endif /* TOPIC4_24ATTR */
        defb    in_com_4_24end - in_com_4_24
.in_com_4_24end
#endif /* TOPIC4_24 */

/*
 * If we have the first item of next topic, then we carry on!
 */

#ifdef TOPIC5_1
        defb    1               ;end marker of current topic
#endif

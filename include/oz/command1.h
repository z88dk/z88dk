/*
 *      Header for command entries for Topic 1
 *
 *      Do not include yourself - included by application.h
 *
 *      7/4/99 djm
 */


#ifdef TOPIC1_1
.in_com_1_1
        defb    in_com_1_1end - in_com_1_1
        APPLBYTE(TOPIC1_1CODE)
        APPLNAME(TOPIC1_1KEY)
        APPLTEXT(TOPIC1_1)
#ifdef TOPIC1_1HELP1
        defb    (in_com_hlp1_1 - in_help) /256
        defb    (in_com_hlp1_1 - in_help) %256
#else
        defb    0,0               ;pointer to help - use \0
#endif  /* TOPIC1_1HELP1) */
#ifdef TOPIC1_1ATTR
        APPLBYTE(TOPIC1_1ATTR)
#else
        defb    0
#endif /* TOPIC1_1ATTR */
        defb    in_com_1_1end - in_com_1_1
.in_com_1_1end
#endif /* TOPIC1_1 */


#ifdef TOPIC1_2
.in_com_1_2
        defb    in_com_1_2end - in_com_1_2
        APPLBYTE(TOPIC1_2CODE)
        APPLNAME(TOPIC1_2KEY)
        APPLTEXT(TOPIC1_2)
#ifdef TOPIC1_2HELP1
        defb    (in_com_hlp1_2 - in_help) /256
        defb    (in_com_hlp1_2 - in_help) %256
#else
        defb    0,0               ;pointer to help - use \0
#endif  /* TOPIC1_2HELP1) */
#ifdef TOPIC1_2ATTR
        APPLBYTE(TOPIC1_2ATTR)
#else
        defb    0
#endif /* TOPIC1_2ATTR */
        defb    in_com_1_2end - in_com_1_2
.in_com_1_2end
#endif /* TOPIC1_2 */


#ifdef TOPIC1_3
.in_com_1_3
        defb    in_com_1_3end - in_com_1_3
        APPLBYTE(TOPIC1_3CODE)
        APPLNAME(TOPIC1_3KEY)
        APPLNAME(TOPIC1_3)
#ifdef TOPIC1_3HELP1
        defb    (in_com_hlp1_3 - in_help) /256
        defb    (in_com_hlp1_3 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_3HELP1) */
#ifdef TOPIC1_3ATTR
        APPLBYTE(TOPIC1_3ATTR)
#else
        defb    0
#endif /* TOPIC1_3ATTR */
        defb    in_com_1_3end - in_com_1_3
.in_com_1_3end
#endif /* TOPIC1_3 */


#ifdef TOPIC1_4
.in_com_1_4
        defb    in_com_1_4end - in_com_1_4
        APPLBYTE(TOPIC1_4CODE)
        APPLNAME(TOPIC1_4KEY)
        APPLNAME(TOPIC1_4)
#ifdef TOPIC1_4HELP1
        defb    (in_com_hlp1_4 - in_help) /256
        defb    (in_com_hlp1_4 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_4HELP1) */
#ifdef TOPIC1_4ATTR
        APPLBYTE(TOPIC1_4ATTR)
#else
        defb    0
#endif /* TOPIC1_4ATTR */
        defb    in_com_1_4end - in_com_1_4
.in_com_1_4end
#endif /* TOPIC1_4 */


#ifdef TOPIC1_5
.in_com_1_5
        defb    in_com_1_5end - in_com_1_5
        APPLBYTE(TOPIC1_5CODE)
        APPLNAME(TOPIC1_5KEY)
        APPLNAME(TOPIC1_5)
#ifdef TOPIC1_5HELP1
        defb    (in_com_hlp1_5 - in_help) /256
        defb    (in_com_hlp1_5 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_5HELP1) */
#ifdef TOPIC1_5ATTR
        APPLBYTE(TOPIC1_5ATTR)
#else
        defb    0
#endif /* TOPIC1_5ATTR */
        defb    in_com_1_5end - in_com_1_5
.in_com_1_5end
#endif /* TOPIC1_5 */


#ifdef TOPIC1_6
.in_com_1_6
        defb    in_com_1_6end - in_com_1_6
        APPLBYTE(TOPIC1_6CODE)
        APPLNAME(TOPIC1_6KEY)
        APPLNAME(TOPIC1_6)
#ifdef TOPIC1_6HELP1
        defb    (in_com_hlp1_6 - in_help) /256
        defb    (in_com_hlp1_6 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_6HELP1) */
#ifdef TOPIC1_6ATTR
        APPLBYTE(TOPIC1_6ATTR)
#else
        defb    0
#endif /* TOPIC1_6ATTR */
        defb    in_com_1_6end - in_com_1_6
.in_com_1_6end
#endif /* TOPIC1_6 */


#ifdef TOPIC1_7
.in_com_1_7
        defb    in_com_1_7end - in_com_1_7
        APPLBYTE(TOPIC1_7CODE)
        APPLNAME(TOPIC1_7KEY)
        APPLNAME(TOPIC1_7)
#ifdef TOPIC1_7HELP1
        defb    (in_com_hlp1_7 - in_help) /256
        defb    (in_com_hlp1_7 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_7HELP1) */
#ifdef TOPIC1_7ATTR
        APPLBYTE(TOPIC1_7ATTR)
#else
        defb    0
#endif /* TOPIC1_7ATTR */
        defb    in_com_1_7end - in_com_1_7
.in_com_1_7end
#endif /* TOPIC1_7 */


#ifdef TOPIC1_8
.in_com_1_8
        defb    in_com_1_8end - in_com_1_8
        APPLBYTE(TOPIC1_8CODE)
        APPLNAME(TOPIC1_8KEY)
        APPLNAME(TOPIC1_8)
#ifdef TOPIC1_8HELP1
        defb    (in_com_hlp1_8 - in_help) /256
        defb    (in_com_hlp1_8 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_8HELP1) */
#ifdef TOPIC1_8ATTR
        APPLBYTE(TOPIC1_8ATTR)
#else
        defb    0
#endif /* TOPIC1_8ATTR */
        defb    in_com_1_8end - in_com_1_8
.in_com_1_8end
#endif /* TOPIC1_8 */


#ifdef TOPIC1_9
.in_com_1_9
        defb    in_com_1_9end - in_com_1_9
        APPLBYTE(TOPIC1_9CODE)
        APPLNAME(TOPIC1_9KEY)
        APPLNAME(TOPIC1_9)
#ifdef TOPIC1_9HELP1
        defb    (in_com_hlp1_9 - in_help) /256
        defb    (in_com_hlp1_9 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_9HELP1) */
#ifdef TOPIC1_9ATTR
        APPLBYTE(TOPIC1_9ATTR)
#else
        defb    0
#endif /* TOPIC1_9ATTR */
        defb    in_com_1_9end - in_com_1_9
.in_com_1_9end
#endif /* TOPIC1_9 */


#ifdef TOPIC1_10
.in_com_1_10
        defb    in_com_1_10end - in_com_1_10
        APPLBYTE(TOPIC1_10CODE)
        APPLNAME(TOPIC1_10KEY)
        APPLNAME(TOPIC1_10)
#ifdef TOPIC1_10HELP1
        defb    (in_com_hlp1_10 - in_help) /256
        defb    (in_com_hlp1_10 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_10HELP1) */
#ifdef TOPIC1_10ATTR
        APPLBYTE(TOPIC1_10ATTR)
#else
        defb    0
#endif /* TOPIC1_10ATTR */
        defb    in_com_1_10end - in_com_1_10
.in_com_1_10end
#endif /* TOPIC1_10 */


#ifdef TOPIC1_11
.in_com_1_11
        defb    in_com_1_11end - in_com_1_11
        APPLBYTE(TOPIC1_11CODE)
        APPLNAME(TOPIC1_11KEY)
        APPLNAME(TOPIC1_11)
#ifdef TOPIC1_11HELP1
        defb    (in_com_hlp1_11 - in_help) /256
        defb    (in_com_hlp1_11 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_11HELP1) */
#ifdef TOPIC1_11ATTR
        APPLBYTE(TOPIC1_11ATTR)
#else
        defb    0
#endif /* TOPIC1_11ATTR */
        defb    in_com_1_11end - in_com_1_11
.in_com_1_11end
#endif /* TOPIC1_11 */


#ifdef TOPIC1_12
.in_com_1_12
        defb    in_com_1_12end - in_com_1_12
        APPLBYTE(TOPIC1_12CODE)
        APPLNAME(TOPIC1_12KEY)
        APPLNAME(TOPIC1_12)
#ifdef TOPIC1_12HELP1
        defb    (in_com_hlp1_12 - in_help) /256
        defb    (in_com_hlp1_12 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_12HELP1) */
#ifdef TOPIC1_12ATTR
        APPLBYTE(TOPIC1_12ATTR)
#else
        defb    0
#endif /* TOPIC1_12ATTR */
        defb    in_com_1_12end - in_com_1_12
.in_com_1_12end
#endif /* TOPIC1_12 */


#ifdef TOPIC1_13
.in_com_1_13
        defb    in_com_1_13end - in_com_1_13
        APPLBYTE(TOPIC1_13CODE)
        APPLNAME(TOPIC1_13KEY)
        APPLNAME(TOPIC1_13)
#ifdef TOPIC1_13HELP1
        defb    (in_com_hlp1_13 - in_help) /256
        defb    (in_com_hlp1_13 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_13HELP1) */
#ifdef TOPIC1_13ATTR
        APPLBYTE(TOPIC1_13ATTR)
#else
        defb    0
#endif /* TOPIC1_13ATTR */
        defb    in_com_1_13end - in_com_1_13
.in_com_1_13end
#endif /* TOPIC1_13 */


#ifdef TOPIC1_14
.in_com_1_14
        defb    in_com_1_14end - in_com_1_14
        APPLBYTE(TOPIC1_14CODE)
        APPLNAME(TOPIC1_14KEY)
        APPLNAME(TOPIC1_14)
#ifdef TOPIC1_14HELP1
        defb    (in_com_hlp1_14 - in_help) /256
        defb    (in_com_hlp1_14 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_14HELP1) */
#ifdef TOPIC1_14ATTR
        APPLBYTE(TOPIC1_14ATTR)
#else
        defb    0
#endif /* TOPIC1_14ATTR */
        defb    in_com_1_14end - in_com_1_14
.in_com_1_14end
#endif /* TOPIC1_14 */


#ifdef TOPIC1_15
.in_com_1_15
        defb    in_com_1_15end - in_com_1_15
        APPLBYTE(TOPIC1_15CODE)
        APPLNAME(TOPIC1_15KEY)
        APPLNAME(TOPIC1_15)
#ifdef TOPIC1_15HELP1
        defb    (in_com_hlp1_15 - in_help) /256
        defb    (in_com_hlp1_15 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_15HELP1) */
#ifdef TOPIC1_15ATTR
        APPLBYTE(TOPIC1_15ATTR)
#else
        defb    0
#endif /* TOPIC1_15ATTR */
        defb    in_com_1_15end - in_com_1_15
.in_com_1_15end
#endif /* TOPIC1_15 */


#ifdef TOPIC1_16
.in_com_1_16
        defb    in_com_1_16end - in_com_1_16
        APPLBYTE(TOPIC1_16CODE)
        APPLNAME(TOPIC1_16KEY)
        APPLNAME(TOPIC1_16)
#ifdef TOPIC1_16HELP1
        defb    (in_com_hlp1_16 - in_help) /256
        defb    (in_com_hlp1_16 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_16HELP1) */
#ifdef TOPIC1_16ATTR
        APPLBYTE(TOPIC1_16ATTR)
#else
        defb    0
#endif /* TOPIC1_16ATTR */
        defb    in_com_1_16end - in_com_1_16
.in_com_1_16end
#endif /* TOPIC1_16 */


#ifdef TOPIC1_17
.in_com_1_17
        defb    in_com_1_17end - in_com_1_17
        APPLBYTE(TOPIC1_17CODE)
        APPLNAME(TOPIC1_17KEY)
        APPLNAME(TOPIC1_17)
#ifdef TOPIC1_17HELP1
        defb    (in_com_hlp1_17 - in_help) /256
        defb    (in_com_hlp1_17 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_17HELP1) */
#ifdef TOPIC1_17ATTR
        APPLBYTE(TOPIC1_17ATTR)
#else
        defb    0
#endif /* TOPIC1_17ATTR */
        defb    in_com_1_17end - in_com_1_17
.in_com_1_17end
#endif /* TOPIC1_17 */


#ifdef TOPIC1_18
.in_com_1_18
        defb    in_com_1_18end - in_com_1_18
        APPLBYTE(TOPIC1_18CODE)
        APPLNAME(TOPIC1_18KEY)
        APPLNAME(TOPIC1_18)
#ifdef TOPIC1_18HELP1
        defb    (in_com_hlp1_18 - in_help) /256
        defb    (in_com_hlp1_18 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_18HELP1) */
#ifdef TOPIC1_18ATTR
        APPLBYTE(TOPIC1_18ATTR)
#else
        defb    0
#endif /* TOPIC1_18ATTR */
        defb    in_com_1_18end - in_com_1_18
.in_com_1_18end
#endif /* TOPIC1_18 */


#ifdef TOPIC1_19
.in_com_1_19
        defb    in_com_1_19end - in_com_1_19
        APPLBYTE(TOPIC1_19CODE)
        APPLNAME(TOPIC1_19KEY)
        APPLNAME(TOPIC1_19)
#ifdef TOPIC1_19HELP1
        defb    (in_com_hlp1_19 - in_help) /256
        defb    (in_com_hlp1_19 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_19HELP1) */
#ifdef TOPIC1_19ATTR
        APPLBYTE(TOPIC1_19ATTR)
#else
        defb    0
#endif /* TOPIC1_19ATTR */
        defb    in_com_1_19end - in_com_1_19
.in_com_1_19end
#endif /* TOPIC1_19 */


#ifdef TOPIC1_20
.in_com_1_20
        defb    in_com_1_20end - in_com_1_20
        APPLBYTE(TOPIC1_20CODE)
        APPLNAME(TOPIC1_20KEY)
        APPLNAME(TOPIC1_20)
#ifdef TOPIC1_20HELP1
        defb    (in_com_hlp1_20 - in_help) /256
        defb    (in_com_hlp1_20 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_20HELP1) */
#ifdef TOPIC1_20ATTR
        APPLBYTE(TOPIC1_20ATTR)
#else
        defb    0
#endif /* TOPIC1_20ATTR */
        defb    in_com_1_20end - in_com_1_20
.in_com_1_20end
#endif /* TOPIC1_20 */


#ifdef TOPIC1_21
.in_com_1_21
        defb    in_com_1_21end - in_com_1_21
        APPLBYTE(TOPIC1_21CODE)
        APPLNAME(TOPIC1_21KEY)
        APPLNAME(TOPIC1_21)
#ifdef TOPIC1_21HELP1
        defb    (in_com_hlp1_21 - in_help) /256
        defb    (in_com_hlp1_21 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_21HELP1) */
#ifdef TOPIC1_21ATTR
        APPLBYTE(TOPIC1_21ATTR)
#else
        defb    0
#endif /* TOPIC1_21ATTR */
        defb    in_com_1_21end - in_com_1_21
.in_com_1_21end
#endif /* TOPIC1_21 */


#ifdef TOPIC1_22
.in_com_1_22
        defb    in_com_1_22end - in_com_1_22
        APPLBYTE(TOPIC1_22CODE)
        APPLNAME(TOPIC1_22KEY)
        APPLNAME(TOPIC1_22)
#ifdef TOPIC1_22HELP1
        defb    (in_com_hlp1_22 - in_help) /256
        defb    (in_com_hlp1_22 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_22HELP1) */
#ifdef TOPIC1_22ATTR
        APPLBYTE(TOPIC1_22ATTR)
#else
        defb    0
#endif /* TOPIC1_22ATTR */
        defb    in_com_1_22end - in_com_1_22
.in_com_1_22end
#endif /* TOPIC1_22 */


#ifdef TOPIC1_23
.in_com_1_23
        defb    in_com_1_23end - in_com_1_23
        APPLBYTE(TOPIC1_23CODE)
        APPLNAME(TOPIC1_23KEY)
        APPLNAME(TOPIC1_23)
#ifdef TOPIC1_23HELP1
        defb    (in_com_hlp1_23 - in_help) /256
        defb    (in_com_hlp1_23 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_23HELP1) */
#ifdef TOPIC1_23ATTR
        APPLBYTE(TOPIC1_23ATTR)
#else
        defb    0
#endif /* TOPIC1_23ATTR */
        defb    in_com_1_23end - in_com_1_23
.in_com_1_23end
#endif /* TOPIC1_23 */


#ifdef TOPIC1_24
.in_com_1_24
        defb    in_com_1_24end - in_com_1_24
        APPLBYTE(TOPIC1_24CODE)
        APPLNAME(TOPIC1_24KEY)
        APPLNAME(TOPIC1_24)
#ifdef TOPIC1_24HELP1
        defb    (in_com_hlp1_24 - in_help) /256
        defb    (in_com_hlp1_24 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC1_24HELP1) */
#ifdef TOPIC1_24ATTR
        APPLBYTE(TOPIC1_24ATTR)
#else
        defb    0
#endif /* TOPIC1_24ATTR */
        defb    in_com_1_24end - in_com_1_24
.in_com_1_24end
#endif /* TOPIC1_24 */

/*
 * If we have the first item of next topic, then we carry on!
 */

#ifdef TOPIC2_1
        defb    1               ;end marker of current topic
#endif

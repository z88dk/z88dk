/*
 *      Header for command entries for Topic 7
 *
 *      Do not include yourself - included by application.h
 *
 *      7/4/99 djm
 */


#ifdef TOPIC7_1
.in_com_7_1
        defb    in_com_7_1end - in_com_7_1
        APPLBYTE(TOPIC7_1CODE)
        APPLNAME(TOPIC7_1KEY)
        APPLTEXT(TOPIC7_1)
#ifdef TOPIC7_1HELP1
        defb    (in_com_hlp7_1 - in_help) /256
        defb    (in_com_hlp7_1 - in_help) %256
#else
        defb    0,0               ;pointer to help - use \0
#endif  /* TOPIC7_1HELP1) */
#ifdef TOPIC7_1ATTR
        APPLBYTE(TOPIC7_1ATTR)
#else
        defb    0
#endif /* TOPIC7_1ATTR */
        defb    in_com_7_1end - in_com_7_1
.in_com_7_1end
#endif /* TOPIC7_1 */


#ifdef TOPIC7_2
.in_com_7_2
        defb    in_com_7_2end - in_com_7_2
        APPLBYTE(TOPIC7_2CODE)
        APPLNAME(TOPIC7_2KEY)
        APPLTEXT(TOPIC7_2)
#ifdef TOPIC7_2HELP1
        defb    (in_com_hlp7_2 - in_help) /256
        defb    (in_com_hlp7_2 - in_help) %256
#else
        defb    0,0               ;pointer to help - use \0
#endif  /* TOPIC7_2HELP1) */
#ifdef TOPIC7_2ATTR
        APPLBYTE(TOPIC7_2ATTR)
#else
        defb    0
#endif /* TOPIC7_2ATTR */
        defb    in_com_7_2end - in_com_7_2
.in_com_7_2end
#endif /* TOPIC7_2 */


#ifdef TOPIC7_3
.in_com_7_3
        defb    in_com_7_3end - in_com_7_3
        APPLBYTE(TOPIC7_3CODE)
        APPLNAME(TOPIC7_3KEY)
        APPLNAME(TOPIC7_3)
#ifdef TOPIC7_3HELP1
        defb    (in_com_hlp7_3 - in_help) /256
        defb    (in_com_hlp7_3 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_3HELP1) */
#ifdef TOPIC7_3ATTR
        APPLBYTE(TOPIC7_3ATTR)
#else
        defb    0
#endif /* TOPIC7_3ATTR */
        defb    in_com_7_3end - in_com_7_3
.in_com_7_3end
#endif /* TOPIC7_3 */


#ifdef TOPIC7_4
.in_com_7_4
        defb    in_com_7_4end - in_com_7_4
        APPLBYTE(TOPIC7_4CODE)
        APPLNAME(TOPIC7_4KEY)
        APPLNAME(TOPIC7_4)
#ifdef TOPIC7_4HELP1
        defb    (in_com_hlp7_4 - in_help) /256
        defb    (in_com_hlp7_4 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_4HELP1) */
#ifdef TOPIC7_4ATTR
        APPLBYTE(TOPIC7_4ATTR)
#else
        defb    0
#endif /* TOPIC7_4ATTR */
        defb    in_com_7_4end - in_com_7_4
.in_com_7_4end
#endif /* TOPIC7_4 */


#ifdef TOPIC7_5
.in_com_7_5
        defb    in_com_7_5end - in_com_7_5
        APPLBYTE(TOPIC7_5CODE)
        APPLNAME(TOPIC7_5KEY)
        APPLNAME(TOPIC7_5)
#ifdef TOPIC7_5HELP1
        defb    (in_com_hlp7_5 - in_help) /256
        defb    (in_com_hlp7_5 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_5HELP1) */
#ifdef TOPIC7_5ATTR
        APPLBYTE(TOPIC7_5ATTR)
#else
        defb    0
#endif /* TOPIC7_5ATTR */
        defb    in_com_7_5end - in_com_7_5
.in_com_7_5end
#endif /* TOPIC7_5 */


#ifdef TOPIC7_6
.in_com_7_6
        defb    in_com_7_6end - in_com_7_6
        APPLBYTE(TOPIC7_6CODE)
        APPLNAME(TOPIC7_6KEY)
        APPLNAME(TOPIC7_6)
#ifdef TOPIC7_6HELP1
        defb    (in_com_hlp7_6 - in_help) /256
        defb    (in_com_hlp7_6 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_6HELP1) */
#ifdef TOPIC7_6ATTR
        APPLBYTE(TOPIC7_6ATTR)
#else
        defb    0
#endif /* TOPIC7_6ATTR */
        defb    in_com_7_6end - in_com_7_6
.in_com_7_6end
#endif /* TOPIC7_6 */


#ifdef TOPIC7_7
.in_com_7_7
        defb    in_com_7_7end - in_com_7_7
        APPLBYTE(TOPIC7_7CODE)
        APPLNAME(TOPIC7_7KEY)
        APPLNAME(TOPIC7_7)
#ifdef TOPIC7_7HELP1
        defb    (in_com_hlp7_7 - in_help) /256
        defb    (in_com_hlp7_7 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_7HELP1) */
#ifdef TOPIC7_7ATTR
        APPLBYTE(TOPIC7_7ATTR)
#else
        defb    0
#endif /* TOPIC7_7ATTR */
        defb    in_com_7_7end - in_com_7_7
.in_com_7_7end
#endif /* TOPIC7_7 */


#ifdef TOPIC7_8
.in_com_7_8
        defb    in_com_7_8end - in_com_7_8
        APPLBYTE(TOPIC7_8CODE)
        APPLNAME(TOPIC7_8KEY)
        APPLNAME(TOPIC7_8)
#ifdef TOPIC7_8HELP1
        defb    (in_com_hlp7_8 - in_help) /256
        defb    (in_com_hlp7_8 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_8HELP1) */
#ifdef TOPIC7_8ATTR
        APPLBYTE(TOPIC7_8ATTR)
#else
        defb    0
#endif /* TOPIC7_8ATTR */
        defb    in_com_7_8end - in_com_7_8
.in_com_7_8end
#endif /* TOPIC7_8 */


#ifdef TOPIC7_9
.in_com_7_9
        defb    in_com_7_9end - in_com_7_9
        APPLBYTE(TOPIC7_9CODE)
        APPLNAME(TOPIC7_9KEY)
        APPLNAME(TOPIC7_9)
#ifdef TOPIC7_9HELP1
        defb    (in_com_hlp7_9 - in_help) /256
        defb    (in_com_hlp7_9 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_9HELP1) */
#ifdef TOPIC7_9ATTR
        APPLBYTE(TOPIC7_9ATTR)
#else
        defb    0
#endif /* TOPIC7_9ATTR */
        defb    in_com_7_9end - in_com_7_9
.in_com_7_9end
#endif /* TOPIC7_9 */


#ifdef TOPIC7_10
.in_com_7_10
        defb    in_com_7_10end - in_com_7_10
        APPLBYTE(TOPIC7_10CODE)
        APPLNAME(TOPIC7_10KEY)
        APPLNAME(TOPIC7_10)
#ifdef TOPIC7_10HELP1
        defb    (in_com_hlp7_10 - in_help) /256
        defb    (in_com_hlp7_10 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_10HELP1) */
#ifdef TOPIC7_10ATTR
        APPLBYTE(TOPIC7_10ATTR)
#else
        defb    0
#endif /* TOPIC7_10ATTR */
        defb    in_com_7_10end - in_com_7_10
.in_com_7_10end
#endif /* TOPIC7_10 */


#ifdef TOPIC7_11
.in_com_7_11
        defb    in_com_7_11end - in_com_7_11
        APPLBYTE(TOPIC7_11CODE)
        APPLNAME(TOPIC7_11KEY)
        APPLNAME(TOPIC7_11)
#ifdef TOPIC7_11HELP1
        defb    (in_com_hlp7_11 - in_help) /256
        defb    (in_com_hlp7_11 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_11HELP1) */
#ifdef TOPIC7_11ATTR
        APPLBYTE(TOPIC7_11ATTR)
#else
        defb    0
#endif /* TOPIC7_11ATTR */
        defb    in_com_7_11end - in_com_7_11
.in_com_7_11end
#endif /* TOPIC7_11 */


#ifdef TOPIC7_12
.in_com_7_12
        defb    in_com_7_12end - in_com_7_12
        APPLBYTE(TOPIC7_12CODE)
        APPLNAME(TOPIC7_12KEY)
        APPLNAME(TOPIC7_12)
#ifdef TOPIC7_12HELP1
        defb    (in_com_hlp7_12 - in_help) /256
        defb    (in_com_hlp7_12 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_12HELP1) */
#ifdef TOPIC7_12ATTR
        APPLBYTE(TOPIC7_12ATTR)
#else
        defb    0
#endif /* TOPIC7_12ATTR */
        defb    in_com_7_12end - in_com_7_12
.in_com_7_12end
#endif /* TOPIC7_12 */


#ifdef TOPIC7_13
.in_com_7_13
        defb    in_com_7_13end - in_com_7_13
        APPLBYTE(TOPIC7_13CODE)
        APPLNAME(TOPIC7_13KEY)
        APPLNAME(TOPIC7_13)
#ifdef TOPIC7_13HELP1
        defb    (in_com_hlp7_13 - in_help) /256
        defb    (in_com_hlp7_13 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_13HELP1) */
#ifdef TOPIC7_13ATTR
        APPLBYTE(TOPIC7_13ATTR)
#else
        defb    0
#endif /* TOPIC7_13ATTR */
        defb    in_com_7_13end - in_com_7_13
.in_com_7_13end
#endif /* TOPIC7_13 */


#ifdef TOPIC7_14
.in_com_7_14
        defb    in_com_7_14end - in_com_7_14
        APPLBYTE(TOPIC7_14CODE)
        APPLNAME(TOPIC7_14KEY)
        APPLNAME(TOPIC7_14)
#ifdef TOPIC7_14HELP1
        defb    (in_com_hlp7_14 - in_help) /256
        defb    (in_com_hlp7_14 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_14HELP1) */
#ifdef TOPIC7_14ATTR
        APPLBYTE(TOPIC7_14ATTR)
#else
        defb    0
#endif /* TOPIC7_14ATTR */
        defb    in_com_7_14end - in_com_7_14
.in_com_7_14end
#endif /* TOPIC7_14 */


#ifdef TOPIC7_15
.in_com_7_15
        defb    in_com_7_15end - in_com_7_15
        APPLBYTE(TOPIC7_15CODE)
        APPLNAME(TOPIC7_15KEY)
        APPLNAME(TOPIC7_15)
#ifdef TOPIC7_15HELP1
        defb    (in_com_hlp7_15 - in_help) /256
        defb    (in_com_hlp7_15 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_15HELP1) */
#ifdef TOPIC7_15ATTR
        APPLBYTE(TOPIC7_15ATTR)
#else
        defb    0
#endif /* TOPIC7_15ATTR */
        defb    in_com_7_15end - in_com_7_15
.in_com_7_15end
#endif /* TOPIC7_15 */


#ifdef TOPIC7_16
.in_com_7_16
        defb    in_com_7_16end - in_com_7_16
        APPLBYTE(TOPIC7_16CODE)
        APPLNAME(TOPIC7_16KEY)
        APPLNAME(TOPIC7_16)
#ifdef TOPIC7_16HELP1
        defb    (in_com_hlp7_16 - in_help) /256
        defb    (in_com_hlp7_16 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_16HELP1) */
#ifdef TOPIC7_16ATTR
        APPLBYTE(TOPIC7_16ATTR)
#else
        defb    0
#endif /* TOPIC7_16ATTR */
        defb    in_com_7_16end - in_com_7_16
.in_com_7_16end
#endif /* TOPIC7_16 */


#ifdef TOPIC7_17
.in_com_7_17
        defb    in_com_7_17end - in_com_7_17
        APPLBYTE(TOPIC7_17CODE)
        APPLNAME(TOPIC7_17KEY)
        APPLNAME(TOPIC7_17)
#ifdef TOPIC7_17HELP1
        defb    (in_com_hlp7_17 - in_help) /256
        defb    (in_com_hlp7_17 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_17HELP1) */
#ifdef TOPIC7_17ATTR
        APPLBYTE(TOPIC7_17ATTR)
#else
        defb    0
#endif /* TOPIC7_17ATTR */
        defb    in_com_7_17end - in_com_7_17
.in_com_7_17end
#endif /* TOPIC7_17 */


#ifdef TOPIC7_18
.in_com_7_18
        defb    in_com_7_18end - in_com_7_18
        APPLBYTE(TOPIC7_18CODE)
        APPLNAME(TOPIC7_18KEY)
        APPLNAME(TOPIC7_18)
#ifdef TOPIC7_18HELP1
        defb    (in_com_hlp7_18 - in_help) /256
        defb    (in_com_hlp7_18 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_18HELP1) */
#ifdef TOPIC7_18ATTR
        APPLBYTE(TOPIC7_18ATTR)
#else
        defb    0
#endif /* TOPIC7_18ATTR */
        defb    in_com_7_18end - in_com_7_18
.in_com_7_18end
#endif /* TOPIC7_18 */


#ifdef TOPIC7_19
.in_com_7_19
        defb    in_com_7_19end - in_com_7_19
        APPLBYTE(TOPIC7_19CODE)
        APPLNAME(TOPIC7_19KEY)
        APPLNAME(TOPIC7_19)
#ifdef TOPIC7_19HELP1
        defb    (in_com_hlp7_19 - in_help) /256
        defb    (in_com_hlp7_19 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_19HELP1) */
#ifdef TOPIC7_19ATTR
        APPLBYTE(TOPIC7_19ATTR)
#else
        defb    0
#endif /* TOPIC7_19ATTR */
        defb    in_com_7_19end - in_com_7_19
.in_com_7_19end
#endif /* TOPIC7_19 */


#ifdef TOPIC7_20
.in_com_7_20
        defb    in_com_7_20end - in_com_7_20
        APPLBYTE(TOPIC7_20CODE)
        APPLNAME(TOPIC7_20KEY)
        APPLNAME(TOPIC7_20)
#ifdef TOPIC7_20HELP1
        defb    (in_com_hlp7_20 - in_help) /256
        defb    (in_com_hlp7_20 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_20HELP1) */
#ifdef TOPIC7_20ATTR
        APPLBYTE(TOPIC7_20ATTR)
#else
        defb    0
#endif /* TOPIC7_20ATTR */
        defb    in_com_7_20end - in_com_7_20
.in_com_7_20end
#endif /* TOPIC7_20 */


#ifdef TOPIC7_21
.in_com_7_21
        defb    in_com_7_21end - in_com_7_21
        APPLBYTE(TOPIC7_21CODE)
        APPLNAME(TOPIC7_21KEY)
        APPLNAME(TOPIC7_21)
#ifdef TOPIC7_21HELP1
        defb    (in_com_hlp7_21 - in_help) /256
        defb    (in_com_hlp7_21 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_21HELP1) */
#ifdef TOPIC7_21ATTR
        APPLBYTE(TOPIC7_21ATTR)
#else
        defb    0
#endif /* TOPIC7_21ATTR */
        defb    in_com_7_21end - in_com_7_21
.in_com_7_21end
#endif /* TOPIC7_21 */


#ifdef TOPIC7_22
.in_com_7_22
        defb    in_com_7_22end - in_com_7_22
        APPLBYTE(TOPIC7_22CODE)
        APPLNAME(TOPIC7_22KEY)
        APPLNAME(TOPIC7_22)
#ifdef TOPIC7_22HELP1
        defb    (in_com_hlp7_22 - in_help) /256
        defb    (in_com_hlp7_22 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_22HELP1) */
#ifdef TOPIC7_22ATTR
        APPLBYTE(TOPIC7_22ATTR)
#else
        defb    0
#endif /* TOPIC7_22ATTR */
        defb    in_com_7_22end - in_com_7_22
.in_com_7_22end
#endif /* TOPIC7_22 */


#ifdef TOPIC7_23
.in_com_7_23
        defb    in_com_7_23end - in_com_7_23
        APPLBYTE(TOPIC7_23CODE)
        APPLNAME(TOPIC7_23KEY)
        APPLNAME(TOPIC7_23)
#ifdef TOPIC7_23HELP1
        defb    (in_com_hlp7_23 - in_help) /256
        defb    (in_com_hlp7_23 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_23HELP1) */
#ifdef TOPIC7_23ATTR
        APPLBYTE(TOPIC7_23ATTR)
#else
        defb    0
#endif /* TOPIC7_23ATTR */
        defb    in_com_7_23end - in_com_7_23
.in_com_7_23end
#endif /* TOPIC7_23 */


#ifdef TOPIC7_24
.in_com_7_24
        defb    in_com_7_24end - in_com_7_24
        APPLBYTE(TOPIC7_24CODE)
        APPLNAME(TOPIC7_24KEY)
        APPLNAME(TOPIC7_24)
#ifdef TOPIC7_24HELP1
        defb    (in_com_hlp7_24 - in_help) /256
        defb    (in_com_hlp7_24 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC7_24HELP1) */
#ifdef TOPIC7_24ATTR
        APPLBYTE(TOPIC7_24ATTR)
#else
        defb    0
#endif /* TOPIC7_24ATTR */
        defb    in_com_7_24end - in_com_7_24
.in_com_7_24end
#endif /* TOPIC7_24 */


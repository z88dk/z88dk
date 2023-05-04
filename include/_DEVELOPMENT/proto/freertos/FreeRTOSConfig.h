/*
 * FreeRTOS Kernel V10.5.1+
 * Copyright (C) 2021 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
 *
 * SPDX-License-Identifier: MIT
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * https://www.FreeRTOS.org
 * https://github.com/FreeRTOS
 *
 */

include(__link__.m4)

#ifndef FREERTOS_CONFIG_H
#define FREERTOS_CONFIG_H

/*-----------------------------------------------------------
 * Application specific definitions.
 *
 * These definitions should be adjusted for your particular hardware and
 * application requirements.
 *
 * THESE PARAMETERS ARE DESCRIBED WITHIN THE 'CONFIGURATION' SECTION OF THE
 * FreeRTOS API DOCUMENTATION AVAILABLE ON THE FreeRTOS.org WEB SITE.
 *
 * See https://www.freertos.org/a00110.html.
 *----------------------------------------------------------*/

/* And on to the things the same no matter the Z180 type... */
#define configUSE_PREEMPTION                1

#define configCPU_CLOCK_HZ                  ( ( uint32_t ) __CPU_CLOCK )
#define configMAX_PRIORITIES                8
#define configIDLE_SHOULD_YIELD             1
#define configMINIMAL_STACK_SIZE            ( 48 + 16 )
#define configMAX_TASK_NAME_LEN             ( 8 )

#define configQUEUE_REGISTRY_SIZE           0
#define configCHECK_FOR_STACK_OVERFLOW      0

#define configUSE_TRACE_FACILITY            0
#define configTICK_TYPE_WIDTH_IN_BITS       TICK_TYPE_WIDTH_16_BITS

#define configUSE_MUTEXES                   1
#define configUSE_RECURSIVE_MUTEXES         1
#define configUSE_COUNTING_SEMAPHORES       1
#define configUSE_TIME_SLICING              1
#define configUSE_QUEUE_SETS                0
#define configUSE_MALLOC_FAILED_HOOK        0

#define configSUPPORT_DYNAMIC_ALLOCATION    1
#define configSUPPORT_STATIC_ALLOCATION     0

#define configUSE_IDLE_HOOK                 0
#define configUSE_TICK_HOOK                 0

/* Timer definitions. */
#define configUSE_TIMERS                    1
#define configTIMER_TASK_PRIORITY           configMAX_PRIORITIES-1
#define configTIMER_QUEUE_LENGTH            ( 10 )
#define configTIMER_TASK_STACK_DEPTH        configMINIMAL_STACK_SIZE

/* Set the stack depth type to be uint16_t. */
#define configSTACK_DEPTH_TYPE              uint16_t

/* Set the stack pointer type to be uint16_t, otherwise it defaults to unsigned long */
#define portPOINTER_SIZE_TYPE               uint16_t

/* Set the following definitions to 1 to include the API function, or zero
to exclude the API function. */

#define INCLUDE_vTaskPrioritySet                1
#define INCLUDE_uxTaskPriorityGet               1
#define INCLUDE_vTaskDelete                     1
#define INCLUDE_vTaskCleanUpResources           1
#define INCLUDE_vTaskSuspend                    1
#define INCLUDE_vResumeFromISR                  1
#define INCLUDE_xTaskDelayUntil                 1
#define INCLUDE_vTaskDelay                      1
#define INCLUDE_xTaskGetSchedulerState          0
#define INCLUDE_xTaskGetIdleTaskHandle          0 // create an idle task handle.
#define INCLUDE_xTaskGetCurrentTaskHandle       1
#define INCLUDE_uxTaskGetStackHighWaterMark     1

/**
 * configASSERT macro: https://www.freertos.org/a00110.html#configASSERT
 */
#ifndef configASSERT
    #define configDEFAULT_ASSERT 0
#else
    /**
     * Enable configASSERT macro if it is defined.
     */
    #ifndef configDEFAULT_ASSERT
        #define configDEFAULT_ASSERT 1
    #endif

    /**
     * Define a hook method for configASSERT macro if configASSERT is enabled.
     */
    #if configDEFAULT_ASSERT == 1
        extern void vApplicationAssertHook();
        #define configASSERT( x ) if (( x ) == 0) { vApplicationAssertHook(); }
    #endif
#endif


#endif /* FREERTOS_CONFIG_H */

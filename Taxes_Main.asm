;--------TAX_Main--------
; Makes calls to the following subroutiens: Gross_Input, EDU_DEP_INPUTS, Fed_Taxes_Paid,
; State_Taxes_Paid, State_Calc, and Fed_Calc.

			.ORIG x2900

			AND     R0, R0, #0		; clear all registers just in case
			AND 	R1, R1, #0     	
			AND 	R2, R2, #0
			AND 	R3, R3, #0
			AND 	R4, R4, #0
			AND 	R5, R5, #0
			AND 	R6, R6, #0

			LD 	R6, ASCII_CONVERT    	; convert ASCII to decimal (load -48 in R7)

			LEA	R0, MESSAGE
			PUTS
			GETC
			OUT
			ADD	R5, R0, R6
			LD	R0, ENDLINE
			PUTC
			LD	R0, ENDLINE
			PUTC
			ADD	R4, R5, -1
			BRz	STATE
			ADD	R4, R5, -2
			BRz	FEDERAL
			LD 	R0, ENDLINE
			PUTC
			LEA	R0, ERROR_MESSAGE	; If input isn't 1 or 2 then return error message and exit
			PUTS
			HALT
			
STATE
			LD	R5, GROSS_INPUT_SUB	; Jumps to gross_income subroutine and returns GROSS_INCOME_1 and GROSS_INCOME_2.
			JSRR	R5
			LDR	R3, R2, 0
			ST	R3, GROSS_INCOME_1
			LDR	R1, R0, 0
			ST	R1, GROSS_INCOME_2

			LD	R5, EDU_DEP_INPUTS_SUB	; Jumps to EDU_DEP_INPUTS subroutine and returns NUMBER_DEPENDENTS and EDU_EXPENSES.
			JSRR	R5
			LDR	R3, R2, 0
			ST	R3, NUMBER_DEPENDENTS
			LDR	R1, R0, 0
			ST	R1, EDU_EXPENSES

			LD	R5, STATE_PAID_SUB	; Jumps to STATE_PAID subroutine and returns STATE_TAXES_1 and STATE_TAXES_2.
			JSRR	R5
			LDR	R3, R2, 0
			ST	R3, STATE_TAXES_1

			LEA	R0, GROSS_INCOME_1	; Jumps to STATE_CALC subroutine and passes multiple stored values.
			LEA	R1, GROSS_INCOME_2
			LEA	R2, NUMBER_DEPENDENTS
			LEA	R3, STATE_TAXES_1
			LD	R5, STATE_CALC_SUB
			JSRR	R5


			HALT

FEDERAL
			LD	R5, GROSS_INPUT_SUB	; Jumps to gross_income subroutine and returns GROSS_INCOME_1 and GROSS_INCOME_2.
			JSRR	R5
			LDR	R3, R2, 0
			ST	R3, GROSS_INCOME_1
			LDR	R1, R0, 0
			ST	R1, GROSS_INCOME_2

			LD	R5, EDU_DEP_INPUTS_SUB	; Jumps to EDU_DEP_INPUTS subroutine and returns NUMBER_DEPENDENTS and EDU_EXPENSES.
			JSRR	R5
			LDR	R3, R2, 0
			ST	R3, NUMBER_DEPENDENTS
			LDR	R1, R0, 0
			ST	R1, EDU_EXPENSES
			
			LD	R5, FED_PAID_SUB	; Jumps to FED_PAID subroutine and returns FED_TAXES_1 and FED_TAXES_2.
			JSRR	R5
			LDR	R3, R2, 0
			ST	R3, FED_TAXES_1

			LEA	R0, GROSS_INCOME_1	; Jumps to FED_CALC subroutine and passes multiple stored values.
			LEA	R1, GROSS_INCOME_2
			LEA	R2, NUMBER_DEPENDENTS
			LEA	R3, FED_TAXES_1
			LEA	R4, EDU_EXPENSES
			LD	R5, FED_CALC_SUB
			JSRR	R5

			HALT



MESSAGE			.STRINGZ "Enter 1 for state or 2 for federal: "
ERROR_MESSAGE		.STRINGZ "Incorrect Input"

ASCII_CONVERT		.FILL #-48
GROSS_INPUT_SUB		.FILL x3100
EDU_DEP_INPUTS_SUB	.FILL x3300
FED_PAID_SUB		.FILL x3500
STATE_PAID_SUB		.FILL x3700
STATE_CALC_SUB		.FILL x3900
FED_CALC_SUB		.FILL x4100
SaveR7			.FILL x0000
ENDLINE			.FILL x0A

GROSS_INCOME_1		.BLKW 1
GROSS_INCOME_2		.BLKW 1
NUMBER_DEPENDENTS	.BLKW 1
EDU_EXPENSES		.BLKW 1
FED_TAXES_1		.BLKW 1
FED_TAXES_2		.BLKW 1
STATE_TAXES_1 		.BLKW 1
STATE_TAXES_2		.BLKW 1



.END
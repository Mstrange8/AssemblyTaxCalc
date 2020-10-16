;--------------FED_CALC-------------
;
			.ORIG x4100
			
			ST	R7, SaveR7		; Saves location of main in SaveR7

			LDR	R5, R0, 0
			ST	R5, GROSS_INCOME_1
			LDR	R5, R1, 0
			ST	R5, GROSS_INCOME_2
			LDR	R5, R2, 0
			ST	R5, NUMBER_DEPENDENTS
			LDR	R5, R3, 0
			ST	R5, FED_TAXES_1
			LDR	R5, R4, 0
			ST	R5, EDU_EXPENSES
			LD	R6, CONVERT	

			AND     R0, R0, #0		; clear all registers just in case
			AND 	R1, R1, #0     	
			AND 	R2, R2, #0
			AND 	R3, R3, #0
			AND 	R4, R4, #0
			AND 	R5, R5, #0

							;	
							; 0-99,999: 12.5 percent<>100,000-199,999: 16.5 percent<>200,000+: 20 percent
			LD	R5, GROSS_INCOME_1
			ADD	R4, R5, -10
			ST	R5, GROSS_INCOME_1
			BRn	BOTTOM_BRACKET
			ADD	R4, R4, -10
			BRn	MIDDLE_BRACKET
			BR	TOP_BRACKET
BOTTOM_BRACKET						; Chnages taxes to be taxed by 12.5 percent
			ADD	R3, R3, 8
			NOT	R3, R3
			ADD	R3, R3, 1
			ST	R3, TAX_PERCENTAGE
			LD	R3, BOT_VAL
			ST	R3, VAL
			AND	R3, R3, 0
			AND	R4, R4, 0
			BR	RETURN3
MIDDLE_BRACKET						; Changes taxes to be taxed by 16.5 percent
			ADD	R3, R3, 6
			NOT	R3, R3
			ADD	R3, R3, 1
			ST	R3, TAX_PERCENTAGE
			LD	R3, MID_VAL
			ST	R3, VAL
			AND	R3, R3, 0
			AND	R4, R4, 0
			BR	RETURN3
TOP_BRACKET						; Changes taxes to be taxed by 20 percent
			ADD	R3, R3, 5
			NOT	R3, R3
			ADD	R3, R3, 1
			ST	R3, TAX_PERCENTAGE
			LD	R3, TOP_VAL
			ST	R3, VAL
			AND	R3, R3, 0
			AND	R4, R4, 0
			BR	RETURN3
RETURN3
							;
							; Multiply GROSS_INCOME_1 by VAL
			LD	R5, GROSS_INCOME_1
			LD	R4, VAL
MULTI_HUNDRED
			ADD	R2, R2, R5
			ADD	R4, R4, -1
			BRp	MULTI_HUNDRED
			AND	R5, R5, 0
			ST	R2, GROSS_INCOME_1
			AND	R2, R2, 0
			AND	R4, R4, 0

							;
							; Divide GROSS_INCOME_2 by TAX_PERCENTAGE
			LD	R5, GROSS_INCOME_2
			AND	R3, R3, 0
			ADD	R3, R3, -1
DIVLOOP
			ADD	R3, R3, 1
			LD	R4, TAX_PERCENTAGE
			ADD	R5, R5, R4
			BRzp	DIVLOOP
			LD	R1, GROSS_INCOME_1
			ADD	R1, R1, R3		; Add GROSS_INCOME_1 and GROSS_INCOME_2 and store in R1 as taxes owed
			NOT	R1, R1
			ADD	R1, R1, 1
							;
							; Multiplies number of dependents by 1000 and stores total dependent deduction in DEPENDENT_TOTAL
			LD	R5, DEPENDENT_DEDUCT
			LD	R4, NUMBER_DEPENDENTS
DEP_LOOP
			ADD	R2, R2, R5
			ADD	R4, R4, -1
			BRp	DEP_LOOP
			AND	R5, R5, 0
			ST	R2, DEPENDENT_TOTAL	; Dependent deduction represented as positive
			AND	R2, R2,0
							;
							; If educational expenses greater then 3000 then call EDU to get tax credit
			LD	R2, EDU_EXPENSES
			LD	R3, EDU_CREDIT
			ADD	R2, R2, R3
			BRp	EDU
RETURN4
			AND	R2, R2, 0
			AND	R3, R3, 0
			AND	R4, R4, 0
			LD	R2, DEPENDENT_TOTAL
							; 
							; Adds taxes owed to taxes paid. If user owes taxes then jump to NEGATIVE_STATE. If fed owes user then jump to POSITIVE_STATE
			ADD	R1, R1, R2
			LD	R2, FED_TAXES_1
			ADD	R1, R1, R2
			BRzp	POSITIVE_STATE
			ADD	R1, R1, 0
			BRn	NEGATIVE_STATE
RETURN5							; Prints out taxes user owes or recieves to console
			AND	R3, R3, 0
			ADD	R3, R3, -1
			LD	R4, TEN_THOU
SUBp_TEN_THOU						; Prints out ten thousandth place
			ADD	R3, R3, 1
			ADD	R1, R4, R1
			BRzp	SUBp_TEN_THOU
			NOT	R4, R4
			ADD	R2, R4, 1
			ADD	R1, R2, R1
			ADD	R0, R3,	R6
			PUTC

			
			LD	R4, THOU
			AND	R3, R3, 0
			ADD	R3, R3, -1

SUBp_THOU						; Prints out thousandth place
			ADD	R3, R3, 1
			ADD	R1, R4, R1
			BRzp	SUBp_THOU
			NOT	R4, R4
			ADD	R4, R4, 1
			ADD	R1, R4, R1
			ADD	R0, R3, R6
			PUTC

			LD	R4, HUN
			AND	R3, R3, 0
			ADD	R3, R3, -1
SUBp_HUN						; Prints out hundredth place
			ADD	R3, R3, 1
			ADD	R1, R4, R1
			BRzp	SUBp_HUN
			NOT	R4, R4
			ADD	R4, R4, 1
			ADD	R1, R4, R1
			ADD	R0, R3, R6
			PUTC

			LD	R4, TEN
			AND	R3, R3, 0
			ADD	R3, R3, -1
SUBp_TEN						; Prints out tens place
			ADD	R3, R3, 1
			ADD	R1, R4, R1
			BRzp	SUBp_TEN
			NOT	R4, R4
			ADD	R4, R4, 1
			ADD	R1, R4, R1
			ADD	R0, R3, R6
			PUTC
							; Prints outs ones place
			ADD	R0, R1, R6
			PUTC
			LD	R7, SaveR7
			RET

POSITIVE_STATE						; Prints message that fed owes user
			LD	R0, ENDLINE
			PUTC		
			LD	R0, ENDLINE
			PUTC
			LEA	R0, POSITIVE
			PUTS
			LD	R0, DOLLAR
			PUTC
			AND	R0, R0, 0
			BR	RETURN5
NEGATIVE_STATE						; Prints out message that user owes fed
			LD	R0, ENDLINE
			PUTC		
			LD	R0, ENDLINE
			PUTC
			LEA	R0, NEGATIVE
			PUTS
			LD	R0, DOLLAR
			PUTC
			AND	R0, R0, 0
			NOT	R1, R1
			ADD	R1, R1, 1
			BR	RETURN5
					
EDU							; Adds 1200 to the total deduction for educational expenses
			LD	R3, DEPENDENT_TOTAL
			LD	R4, EDU_DEDUCT
			ADD	R3, R3, R4
			ST	R3, DEPENDENT_TOTAL
			BR	RETURN4


POSITIVE		.STRINGZ "Amount federal owes you: "
NEGATIVE		.STRINGZ "Amount you owe federal: "

DEPENDENT_DEDUCT	.FILL #1000
SaveR7			.FILL x0000
TEN_THOU		.FILL #-10000
THOU			.FILL #-1000
HUN			.FILL #-100
TEN			.FILL #-10
ENDLINE			.FILL x0A
CONVERT			.FILL #48
DOLLAR			.FILL #36
TAX_PERCENTAGE		.FILL #00
EDU_CREDIT		.FILL #-3000
EDU_DEDUCT		.FILL #1200
BOT_VAL			.FILL #1250
MID_VAL			.FILL #1650
TOP_VAL			.FILL #2000
VAL			.FILL #00

DEPENDENT_TOTAL		.BLKW 1
GROSS_INCOME_1		.BLKW 1
GROSS_INCOME_2		.BLKW 1
NUMBER_DEPENDENTS	.BLKW 1
FED_TAXES_1		.BLKW 1
EDU_EXPENSES		.BLKW 1
.END
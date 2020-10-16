;---------STATE_CALC---------
; 

			.ORIG x3900
			
			ST	R7, SaveR7		; Saves location of main in SaveR7

			LDR	R5, R0, 0
			ST	R5, GROSS_INCOME_1
			LDR	R5, R1, 0
			ST	R5, GROSS_INCOME_2
			LDR	R5, R2, 0
			ST	R5, NUMBER_DEPENDENTS
			LDR	R5, R3, 0
			ST	R5, STATE_TAXES_1
			LD	R6, CONVERT

			AND     R0, R0, #0		; clear all registers just in case
			AND 	R1, R1, #0     	
			AND 	R2, R2, #0
			AND 	R3, R3, #0

							;
							; Multiplies number of dependents by 579 and stores total dependent deduction in DEPENDENT_TOTAL
			LD	R5, DEPENDENT_DEDUCT
			LD	R4, NUMBER_DEPENDENTS
DEP_LOOP
			ADD	R2, R2, R5
			ADD	R4, R4, -1
			BRp	DEP_LOOP
			AND	R5, R5, 0
			NOT	R2, R2
			ADD	R2, R2, 1
			ST	R2, DEPENDENT_TOTAL	; Dependent deduction represented as negative
			AND	R2, R2,0
			
			LD	R1, GROSS_INCOME_2
			LD	R2, DEPENDENT_TOTAL
			ADD	R2, R2, R1
			BRzp	POSITIVE_GROSS		; Subtract dep deduction from last 4 digits of income. If postive jump to positive label, if negative jump to negative label.
			ADD	R2, R2, 0
			BRn	NEGATIVE_GROSS
RETURN1
							;
							; Multiply GROSS_INCOME_1 by 500
			LD	R5, GROSS_INCOME_1
			LD	R4, HUNDRED
MULTI_HUNDRED
			ADD	R2, R2, R5
			ADD	R4, R4, -1
			BRp	MULTI_HUNDRED
			AND	R5, R5, 0
			ST	R2, GROSS_INCOME_1
			AND	R2, R2, 0
			AND	R4, R4, 0
							;
							; Divide GROSS_INCOME_2 by 20
			LD	R5, GROSS_INCOME_2
			AND	R3, R3, 0
			ADD	R3, R3, -1
DIVLOOP
			ADD	R3, R3, 1
			LD	R4, DIV
			ADD	R5, R5, R4
			BRzp	DIVLOOP
			LD	R1, GROSS_INCOME_1
			ADD	R1, R1, R3		; Add GROSS_INCOME_1 and GROSS_INCOME_2 and store in R1
			NOT	R1, R1
			ADD	R1, R1, 1
			LD	R2, STATE_TAXES_1
							;
							; Adds taxes owed to taxes paid. If user owes taxes then jump to NEGATIVE_STATE. If fed owes user then jump to POSITIVE_STATE
			ADD	R1, R1, R2
			BRzp	POSITIVE_STATE
			ADD	R1, R1, 0
			BRn	NEGATIVE_STATE

POSITIVE_STATE						; Prints out amount state owes user to console
			LD	R0, ENDLINE
			PUTC		
			LD	R0, ENDLINE
			PUTC
			LEA	R0, POSITIVE
			PUTS
			LD	R0, DOLLAR
			PUTC
			AND	R0, R0, 0
			;NOT	R1, R1
			;ADD	R1, R1, 1

			AND	R3, R3, 0
			ADD	R3, R3, -1
			LD	R4, TEN_THOU
SUBp_TEN_THOU						; Prints out ten thousandths place
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
							; Prints out ones place
			ADD	R0, R1, R6
			PUTC
			LD	R7, SaveR7
			RET


NEGATIVE_STATE						; Prints out amount user owes to state to console
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
			AND	R3, R3, 0
			ADD	R3, R3, -1
			LD	R4, TEN_THOU
SUBn_TEN_THOU						; Prints out ten thousandth place
			ADD	R3, R3, 1
			ADD	R1, R4, R1
			BRzp	SUBn_TEN_THOU
			NOT	R4, R4
			ADD	R2, R4, 1
			ADD	R1, R2, R1
			ADD	R0, R3,	R6
			PUTC

			
			LD	R4, THOU
			AND	R3, R3, 0
			ADD	R3, R3, -1

SUBn_THOU						; Prints out thousandth place
			ADD	R3, R3, 1
			ADD	R1, R4, R1
			BRzp	SUBn_THOU
			NOT	R4, R4
			ADD	R4, R4, 1
			ADD	R1, R4, R1
			ADD	R0, R3, R6
			PUTC

			LD	R4, HUN
			AND	R3, R3, 0
			ADD	R3, R3, -1
SUBn_HUN						; Prints out hundredth place
			ADD	R3, R3, 1
			ADD	R1, R4, R1
			BRzp	SUBn_HUN
			NOT	R4, R4
			ADD	R4, R4, 1
			ADD	R1, R4, R1
			ADD	R0, R3, R6
			PUTC

			LD	R4, TEN
			AND	R3, R3, 0
			ADD	R3, R3, -1
SUBn_TEN						; Prints out tens place
			ADD	R3, R3, 1
			ADD	R1, R4, R1
			BRzp	SUBn_TEN
			NOT	R4, R4
			ADD	R4, R4, 1
			ADD	R1, R4, R1
			ADD	R0, R3, R6
			PUTC
							; Prints out ones place
			ADD	R0, R1, R6
			PUTC
			LD	R7, SaveR7
			RET


POSITIVE_GROSS						; Subracts dependent deduction from gross income
			LD	R2, GROSS_INCOME_2
			LD	R3, DEPENDENT_TOTAL
			ADD	R4, R2, R3
			ST	R4, GROSS_INCOME_2
			AND	R2, R2, 0
			AND	R3, R3, 0
			AND	R4, R4, 0
			BR	RETURN1
NEGATIVE_GROSS						; Subtracts dependent deduction from gross income
			LD	R1, GROSS_INCOME_1
			LD	R2, GROSS_INCOME_2
			LD	R3, DEPENDENT_TOTAL
			LD	R5, SUBTRACT
			ADD	R1, R1, -1
			ST	R1, GROSS_INCOME_1
			ADD	R4, R2, R3
			ADD	R4, R4, R5
			ST	R4, GROSS_INCOME_2
			AND	R1, R1, 0
			AND	R2, R2, 0
			AND	R3, R3, 0
			AND	R4, R4, 0
			AND	R5, R5, 0
			BR	RETURN1


POSITIVE		.STRINGZ "Amount state owes you: "
NEGATIVE		.STRINGZ "Amount you owe state: "

DEPENDENT_DEDUCT	.FILL #579
SaveR7			.FILL x0000
SUBTRACT		.FILL #10000
TEN_THOU		.FILL #-10000
THOU			.FILL #-1000
HUN			.FILL #-100
TEN			.FILL #-10
HUNDRED			.FILL #500
DIV			.FILL #-20
ENDLINE			.FILL x0A
CONVERT			.FILL #48
DOLLAR			.FILL #36

DEPENDENT_TOTAL		.BLKW 1
GROSS_INCOME_1		.BLKW 1
GROSS_INCOME_2		.BLKW 1
NUMBER_DEPENDENTS	.BLKW 1
STATE_TAXES_1		.BLKW 1
.END



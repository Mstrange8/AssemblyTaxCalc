; ---------GROSS_INPUT-----------
; Asks for gross income input and stores first three numbers in
; GROSS_INCOME_1 and last three numbers in GROSS_INCOME_2.

			.ORIG x3100

			ST	R7, SaveR7	; store location of jump from main in R7
			AND     R0, R0, #0	; clear all registers just in case
			AND 	R1, R1, #0     	
			AND 	R2, R2, #0
			AND 	R3, R3, #0
			AND 	R4, R4, #0
			AND 	R5, R5, #0
			
			
			LD	R5, TERM
			LD	R4, TERM_2
			LEA	R0, GROSS_MESSAGE    ; asks for input values
			PUTS			     ; prints message asking for gross income
			GETC			     ; get char for hundred thousands place
			ADD	R1, R5, R0
			BRn	EXIT
			ADD	R1, R4, R0
			BRp	EXIT			
			OUT			     
			ADD	R0, R0, R6
			ST	R0, Hundred_Thou_Gross
			GETC			     ; get char for ten thousands place
			ADD	R1, R5, R0
			BRn	EXIT
			ADD	R1, R4, R0
			BRp	EXIT			
			OUT
			ADD	R0, R0, R6
			ST	R0, Ten_Thou_Gross
			GETC			     ; get char for thousands place
			ADD	R1, R5, R0
			BRn	EXIT
			ADD	R1, R4, R0
			BRp	EXIT			
			OUT
			ADD	R0, R0, R6
			ST	R0, Thou_Gross
			GETC			     ; get char for hundreds place
			ADD	R1, R5, R0
			BRn	EXIT
			ADD	R1, R4, R0
			BRp	EXIT			
			OUT
			ADD	R0, R0, R6
			ST	R0, Hundred_Gross
			GETC			     ; get char for tens place
			ADD	R1, R5, R0
			BRn	EXIT
			ADD	R1, R4, R0
			BRp	EXIT
			OUT
			ADD	R0, R0, R6
			ST	R0, Ten_Gross
			GETC			     ; get char for ones place
			ADD	R1, R5, R0
			BRn	EXIT
			ADD	R1, R4, R0
			BRp	EXIT
			OUT
			ADD	R5, R0, 0
			ADD	R5, R5, R6
			ST	R5, One_Gross
							;
							; Store number in hundred thou place
			LD	R5, Hundred_Thou_Gross
			LD	R4, TEN
MULTI_HUN_THOU
			ADD	R2, R2, R5
			ADD	R4, R4, -1
			BRp	MULTI_HUN_THOU
			AND	R5, R5, 0
			ST	R2, Hundred_Thou_Gross
			AND	R2, R2, 0
							;
							; Add hundred_thou and ten_thou together. Store in GROSS_INCOME_1
			LD	R2, Hundred_Thou_Gross
			LD	R3, Ten_Thou_Gross
			ADD	R5, R2, R3
			ST	R5, GROSS_INCOME_1
			AND	R5, R5, 0
			AND	R3, R3, 0
			AND	R2, R2, 0
							;
							; Store number in thousands place
			LD	R5, Thou_Gross
			LD	R4, THOU
MULTI_THOU	
			ADD	R2, R2, R5
			ADD	R4, R4, -1
			BRp	MULTI_THOU
			AND	R5, R5, 0
			ST	R2, Thou_Gross
			AND	R2, R2, 0
							;
							; Store number in hundreds place	
			LD	R5, Hundred_Gross
			LD	R4, HUNDRED	
MULTI_HUNDRED
			ADD	R2, R2, R5
			ADD	R4, R4, -1
			BRp	MULTI_HUNDRED
			AND	R5, R5, 0
			ST	R2, Hundred_Gross
			AND	R2, R2, 0
							;
							; Store number in tens place
			LD	R5, Ten_Gross
			LD	R4, TEN
MULTI_TEN
			ADD	R2, R2, R5
			ADD	R4, R4, -1
			BRp	MULTI_TEN
			AND	R5, R5, 0
			ST	R2, Ten_Gross
			AND	R2, R2, 0		
							;
							; Add thousands, hundreds, tens, and ones together. Store in GROSS_INCOME_2
			LD	R1, Thou_Gross
			LD	R2, Hundred_Gross
			LD	R3, Ten_Gross
			LD	R4, One_Gross
			ADD	R5, R1, R2
			ADD	R5, R5, R3
			ADD	R5, R5, R4
			ST	R5, GROSS_INCOME_2
			AND	R5, R5, 0
			AND	R4, R4, 0
			AND	R3, R3, 0
			AND 	R2, R2, 0
			AND	R1, R1, 0

			LEA	R2, GROSS_INCOME_1
			LEA	R0, GROSS_INCOME_2
			LD	R7, SaveR7
			RET
					
EXIT			LD 	R0, ENDLINE
			PUTC
			LEA	R0, ERROR_MESSAGE
			PUTS
			HALT
ERROR_MESSAGE	.STRINGZ "Incorrect input"
GROSS_MESSAGE	.STRINGZ "Income to nearest dollar in range(0-600,000)(e.g. 096735):"

THOU			.FILL #1000
HUNDRED			.FILL #100
TEN			.FILL #10
SaveR7			.FILL x0000
TERM			.FILL #-48
TERM_2			.FILL #-57
ENDLINE			.FILL x0A

GROSS_INCOME_1		.BLKW 1
GROSS_INCOME_2		.BLKW 1
Hundred_Thou_Gross	.BLKW 1
Ten_Thou_Gross		.BLKW 1
Thou_Gross		.BLKW 1
Hundred_Gross		.BLKW 1
Ten_Gross		.BLKW 1
One_Gross		.BLKW 1
.END
		
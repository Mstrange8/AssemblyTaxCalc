; --------STATE_TAXES_PAID_INPUT-------
; Asks for state taxes paid. Stores the value in STATE_PAID.

			.ORIG x3700

			ST	R7, SaveR7
			AND     R0, R0, #0	; clear all registers just in case
			AND 	R1, R1, #0     	
			AND 	R2, R2, #0
			AND 	R3, R3, #0
			AND 	R4, R4, #0
			AND 	R5, R5, #0

			
			LD	R5, TERM
			LD	R4, TERM_2
			LD	R0, ENDLINE
			PUTC
			LEA	R0, STATE_MESSAGE
			PUTS

			GETC
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
			LD	R5, Ten_Thou_Gross
			LD	R4, TEN_THOU
STATE_TEN_THOU
			ADD	R2, R2, R5
			ADD	R4, R4, -1
			BRp	STATE_TEN_THOU
			AND	R5, R5, 0
			ST	R2, Ten_Thou_Gross
			AND	R2, R2, 0
							;
							; Store number in thou place
			LD	R5, Thou_Gross
			LD	R4, THOU
STATE_THOU
			ADD	R2, R2, R5
			ADD	R4, R4, -1
			BRp	STATE_THOU
			AND	R5, R5, 0
			ST	R2, Thou_Gross
			AND	R2, R2, 0
							;
							; Store number in hundred place
			LD	R5, Hundred_Gross
			LD	R4, HUNDRED
STATE_HUNDRED
			ADD	R2, R2, R5
			ADD	R4, R4, -1
			BRp	STATE_HUNDRED
			AND	R5, R5, 0
			ST	R2, Hundred_Gross
			AND	R2, R2, 0
							;
							; Store number in ten place
			LD	R5, Ten_Gross
			LD	R4, TEN
STATE_TEN
			ADD	R2, R2, R5
			ADD	R4, R4, -1
			BRp	STATE_TEN
			AND	R5, R5, 0
			ST	R2, Ten_Gross
			AND	R2, R2, 0
							;
							; Add hundreds, tens, and ones together. Store in STATE_TAXES_1
			LD	R0, Ten_Thou_Gross
			LD	R1, Thou_Gross
			LD	R2, Hundred_Gross
			LD	R3, Ten_Gross
			LD	R4, One_Gross
			ADD	R5, R0, R1
			ADD	R5, R5, R2
			ADD	R5, R5, R3
			ADD	R5, R5, R4
			ST	R5, STATE_TAXES_1
			AND	R5, R5, 0
			AND	R4, R4, 0
			AND	R3, R3, 0
			AND 	R2, R2, 0
			AND	R1, R1, 0


			LEA	R2, STATE_TAXES_1
			LD	R7, SaveR7
			RET

EXIT			LD 	R0, ENDLINE
			PUTC
			LEA	R0, ERROR_MESSAGE
			PUTS
			HALT

ERROR_MESSAGE	.STRINGZ "Incorrect input"
STATE_MESSAGE	.STRINGZ "State taxes paid to nearest dollar in range(0-30,000)(e.g. 06400):"

TEN_THOU		.FILL #10000
THOU			.FILL #1000
HUNDRED			.FILL #100
TEN			.FILL #10
SaveR7			.FILL x0000
ENDLINE			.FILL x0A
TERM			.FILL #-48
TERM_2			.FILL #-57

STATE_TAXES_1		.BLKW 1
Ten_Thou_Gross		.BLKW 1
Thou_Gross		.BLKW 1
Hundred_Gross		.BLKW 1
Ten_Gross		.BLKW 1
One_Gross		.BLKW 1
.END

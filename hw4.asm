TITLE Assignment4 (hw4.asm)

; Troy Lopez
; CS 271 Assignment4 2/28/24
; generate array of random numbers based on user input
; then sort and display some stats

INCLUDE Irvine32.inc

UPPLIM		EQU		200
LOWLIM		EQU		10


.data
	; variable definitions
	; Notion:
	; prThing prints
	; usThing input

	prIntro1	BYTE	"HW4: Sorting random numbers, by Troy Lopez",0
	prIntro2	BYTE	"This generates N numbers in range [lo, hi], and displays, sorts, and displays again. Then, median value is calculated and displahyed.",0

	prData1		BYTE	"How many numbers should be generated? [10, 200]: ",0
	usNum		DWORD	?
	prErr1		BYTE	"Invalid Input, please try again.",0
	prData2		BYTE	"Enter Lower bound (lo): ",0
	usLo		DWORD	?
	prData3		BYTE	"Enter Upper bound (hi): ",0
	usHi		DWORD	?

	prArr1		BYTE	"The unsorted random numbers: ",0
	prArr2		BYTE	"The sorted random numbers:",0

	prMed		BYTE	"The median value: ",0

	prAgain		BYTE	"Would you like to go again? (y/n)",0

.code

main		PROC
	CALL	intr
	
	; PBR
	PUSH	OFFSET usHi
	PUSH	OFFSET usLo
	PUSH	OFFSET usNum
	CALL	getUsData

main		ENDP

; Prints out the instructions for the program. Touches EDX. No significant pre/post conditions
intr		PROC
	MOV		edx, OFFSET prIntro1
	CALL	WRITESTRING
	CALL	CRLF
	MOV		edx, OFFSET	prIntro2
	CALL	WRITESTRING
	CALL	CRLF
	RET
intr		ENDP

getUsData	PROC
	; stack frame
	PUSH	ebp
	MOV		ebp, esp

	;	printing out the prompt
	MOV		edx, OFFSET PrData1
	CALL	WRITESTRING
	CALL	READINT
	PUSH	eax	; pass to validate by reference (could be value but that is hard)
	CALL	validate
	; once good, get next data
	MOV		eax, [ebp + 8]
	CALL	WRITEDEC

getUsData	ENDP

validate	PROC
	; stack frame
	; stack frame
	PUSH	ebp
	MOV		ebp, esp

	MOV		eax, [ebp + 8]
	
	; for debugging, print out what we are checking
	;CALL	WRITEINT
	;CALL	CRLF

	CMP		eax, LOWLIM
	JL		invalid
	CMP		eax, UPPLIM
	JG		invalid
	; if all good return
	POP		ebp
	RET
	invalid:
		MOV     edx, OFFSET prErr1
        CALL    WRITESTRING
        CALL    CRLF
		CALL	getUsData
validate	ENDP



END	main
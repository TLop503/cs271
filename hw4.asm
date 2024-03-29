TITLE Assignment4 (hw4.asm)

; Troy Lopez
; CS 271 Assignment4 2/28/24
; generate array of random numbers based on user input
; then sort and display some stats

INCLUDE Irvine32.inc

UPPLIM		EQU		200
LOWLIM		EQU		10
ZERO		EQU		1
THOUS		EQU		999
MAX_SIZE	EQU		201	; needs to be + 1 to avoid memory addresses getting tangled in
FOUR		EQU		4


.data
	; variable definitions
	; Notion:
	; prThing prints
	; usThing input

	prIntro1	BYTE	"HW4: Sorting random numbers, by Troy Lopez",0
	prIntro2	BYTE	"This generates N numbers in range [lo, hi], and displays, sorts, and displays again. Then, median value is calculated and displahyed.",0

	prData1		BYTE	"How many numbers should be generated? [10, 200]: ",0
	usNum		DWORD	69
	prErr1		BYTE	"Invalid Input, please try again.",0
	prData2		BYTE	"Enter Lower bound (lo): ",0
	usLo		DWORD	420
	prData3		BYTE	"Enter Upper bound (hi): ",0
	usHi		DWORD	7331

	array		DWORD	MAX_SIZE	DUP(?)	;the array, intially full of garbage

	prArr1		BYTE	"The unsorted random numbers: ",0
	prArr2		BYTE	"The sorted random numbers:",0
	space		BYTE	"   ",0
	pointfive	BYTE	".5",0

	flag		DWORD	0

	prMed		BYTE	"The median value: ",0

	prAgain		BYTE	"Would you like to go again? (1/0)",0
	bye	        BYTE    "Closing program. Goodbye",0

.code

; main access point, where all other logic stems from
main PROC
	call intro

	push	OFFSET usNum
	push	OFFSET usLo
	Push	OFFSET usHi
	call	getData
	
	Push	usLo
	Push	usHi
	push	OFFSET	array
	push	usNum
	call	fillArray

	Push	usNum
	Push	OFFSET	array
	Push	OFFSET	prArr1
	CALL	printList
	CALL	CRLF

	Push	flag
	Push	usNum
	Push	OFFSET	array
	;CALL	bubbleSort	; this is defunct and only persists for historical purposes
	CALL	sorting
	
	Push	usNum
	Push	OFFSET	array
	Push	OFFSET	prArr2
	CALL	printList

	push	usNum
	push	OFFSET array
	call	median

	call	goAgain

	exit
main ENDP

; print intro, via edx. no pre/post conditions, no paramaters.
intro PROC
	mov		edx, OFFSET	prIntro1
	call	WRITESTRING
	call	CRLF
	mov		edx, OFFSET prIntro2
	call	WRITESTRING
	call	CRLF
	call	CRLF
	ret
intro ENDP

; prints out requests for, and then validates, input. takes usLo, usHi, and usNum.
; touches ebp, esp, ebx, edx, eax, [ebx], ecx.
; this could be further optimized to be called 3x, once for each inputted value, but for the sake of my 
; sanity is handled like this
; afterwards params will be populated
getData	PROC
		PUSH	ebp
		MOV		ebp, esp	;frame

	getNum:
		mov		ebx, [ebp+16]
		mov		edx, OFFSET	prData1
		call	WRITESTRING
		call	READINT
		mov		[ebx], eax	;store input in usNum?
		; shitty validation to be improved if I have time
		cmp		eax, LOWLIM
		jl		invalidNum
		cmp		eax, UPPLIM
		jg		invalidNum

		jmp		getLo

	invalidNum:
		mov		edx, OFFSET prErr1
		CALL	WRITESTRING
		CALL	CRLF
		jmp		getNum

	getLo:
		mov		ebx, [ebp+12]
		mov		edx, OFFSET	prData2
		call	WRITESTRING
		call	READINT
		mov		[ebx], eax	;store input in usNum?
		; shitty validation to be improved if I have time
		
		cmp		eax, ZERO
		jl		invalidLo
		cmp		eax, THOUS
		jg		invalidLo

		jmp		getHi

	invalidLo:
		mov		edx, OFFSET prErr1
		CALL	WRITESTRING
		CALL	CRLF
		jmp		getLo

	getHi:
		mov		ebx, [ebp+8] ; hi, inputted
		mov		ecx, [ebp+12] ;lo
		mov		edx, OFFSET	prData3
		call	WRITESTRING
		call	READINT
		mov		[ebx], eax	;store input in usNum?
		; shitty validation to be improved if I have time
		cmp		eax,[ecx]
		jl		invalidHi
		cmp		eax, THOUS
		jg		invalidHi

		jmp		ending

	invalidHi:
		mov		edx, OFFSET prErr1
		CALL	WRITESTRING
		CALL	CRLF
		jmp		getHi

	ending:
		pop		ebp
		ret		12
getData		ENDP

; populates the array with usNum values between usLo and usHi. Those are also the paramaters (array is PBR).
; requires paramaters are correctly populated. Afterwards the array will contain random values to sort out.
; touches ebp, esp, ecx, edi, eax, [edi]. uses a looop to smooth the proccess.
fillArray	PROC
		PUSH	ebp
		MOV		ebp, esp	;frame

		; get usNum for loop counter
		mov		ecx, [ebp+8];
		
		;get array into edi
		mov		edi, [ebp+12]

		again:	;the loop
			mov		eax, [ebp+16]	;get upper limit
			sub		eax, [ebp+20]	;sub low
			inc		eax		; b/c exclusive
			call	RANDOMRANGE	;[0, eax]
			add		eax, [ebp+20]
			; code above this line works and indexes are correct

			; populate array
			mov		[edi], eax
			;CALL	WRITEINT
			;CALL	CRLF
			add		edi, 4

			loop again

			pop ebp
			ret	16
fillArray	ENDP


; print out the title paramater and the the contents of the array paramater, 10 per line. 
; requires both params to be populated, but doesn''t actually mutuate anyhting.
; touches ebp, esp, ecx, esi, ebx, eax, edx
printList	PROC
		PUSH	ebp
		MOV		ebp, esp	;frame
		
		mov		edx, [ebp+8]	;title
		CALL	WRITESTRING
		CALL	CRLF
		; above works

		mov		ecx, [ebp+16]	;total items
		mov		esi, [ebp+12]	;the array

		mov		ebx, 0	;line counter


		again:	;the loop
			inc		ebx
			cmp		ebx, 11
			je		newline
			jmp		print

			newline:
				call	CRLF
				mov		ebx, 1

			print:
				mov		eax, [esi]
				call	writedec
				mov		edx, OFFSET space	; for spacing
				call	writestring
				add		esi, 4
				loop	again

		ending:
			pop		ebp
			ret		12
printList	ENDP		

; this is defunct, here be dragons
bubbleSort	PROC

	PUSH	ebp
	MOV		ebp, esp
	
	mov		edi, [ebp+8]


	; flag is stored at +16
	; num is stored at +12
	; array is stored at +8


	mov		ecx, [ebp + 12]	; works

	outer:
		mov		eax, 0
		mov		[ebp + 16], eax		;should work
		
		push	ecx		; save for loop. outer i is now stored in +4
		dec		ecx		; start inner loop from one less
		inner:
			; if statement goes here
			; i = [ebp - 4]
			; j = ecx
			mov		eax,	[ebp - 4]
			mov		edx, FOUR
			mul		edx
			mov		ebx, eax		; i is in ebx


			mov		eax, ecx
			mov		edx, FOUR
			mul		edx			; j is in eax

			mov		eax, [edi+eax]
			mov		ebx, [edi+ebx]
			cmp		eax, ebx

			swap:
				;stuff goes here
				
			loop inner
		;jmp else

		;notswapped:
			; break out of outer
		
		;else:
		;	pop		ecx
		;	loop	outer
			

		

			


	pop		ebp
	ret
bubbleSort	ENDP
			

; sort given array with size num. takes in array and num as paramaters, and requires the array is populated with num values
; this will sort the array (by reference) using what should be pretty similiar to bubble sort
; but is slightly haunted by caffiene and having been written at 1am.
; I appreciate your patience with grading this.
; touches ebp, esp, eax, ecx, esi
; after running array will be sorted highest to lowest
sorting		PROC
	; flag is stored at +16 but isn't used right now'
	; num is stored at +12
	; array is stored at +8
	push	ebp
	mov		ebp, esp

	mov		eax, [ebp+12]
	mov		ecx, eax		; put user num in loop counter for outer loop

	mov		esi, [ebp+8]	; put array in esi

	;inc		ecx		; start from 1 in from end

	outer:
		push	ecx		;save for later
		mov		ecx, [ebp+12]	;get user num again
		mov		esi, [ebp+8]	; load arr again from start

		inner:
			mov		eax, [esi]		;arr to esi
			cmp		[esi+4], eax	;check against next index
			jl		contd	; don''t swap
			; swap goes here
			mov		eax, [esi]
			mov		ebx, [esi+4]
			mov		[esi], ebx
			mov		[esi+4], eax

			contd:
				add		esi, 4
				loop	inner
				pop		ecx		; restore outer loop
				loop	outer

	pop		ebp
	ret		12
sorting endp

; finds the median value in paramater array by dividing the size (also a param) in two
; just prints, doesn't mutate anything'
; uses ebp, esp, eax, esi, edx
; cases where no median exist are handled by averaging the 2 closest values, 
; and adding a ".5" as neccesary
; slightly mispelled labels are to avoid naming overlaps.
median	proc
	push	ebp
	mov		ebp, esp

	; array is 8
	; size is 12

	mov		eax, [ebp+12]	;l size to eax
	mov		esi, [ebp+8]	; put array in esi

	mov		edx, 0

	mov		ebx, 2
	div		ebx	;eax / 2
	cmp		edx, 1	;remainder
	je		oddd
	jmp		evenn

	oddd:	
		; target is in eax
		mov		ebx, four
		mul		ebx
		call	crlf
		mov		eax,  [esi + eax]
		call	writedec
		jmp		outside		; like end but w/ a different name
	evenn:
		; target is in eax
		dec		eax		; step into middle
		mov		ebx, four
		mul		ebx		; to properly index the array of dwords
		mov		ebx, eax
		call	crlf
		mov		eax,  [esi + ebx]
		add		ebx, four
		add		eax, [esi + ebx]	;get next as well
		mov		ebx, 2
		div		ebx	; mean of 2 closest to median in eax, but may need a .5
		cmp		edx, 1	;remainder
		je		addfive
		jmp		print

		addfive:	; add a .5 to neccessary values
			call	crlf
			call	writedec
			mov		edx, OFFSET	pointfive
			call	writestring
			jmp		outside

		print:
			call	crlf
			call	writedec
			jmp		outside

	outside:
		pop		ebp
		ret
	
	ret 8
median	endp

; asks if user wants to repeat program. uses EDX, EAX. no strict PREC. Post: user returns to main or restarts main.
goAgain PROC
    call    Crlf
    mov     edx, OFFSET prAgain
	call    WriteString
	call    Crlf

	call	ReadInt		                ;get input
	call	Crlf

	; 8.1 check user input
	cmp eax, 0		            ;Important, check against int, not char
	jne restart                    ; jump to doCalcs if usAgain is not equal to 0
    RET

    restart:
        CALL    main    ;restart program
goagain ENDP


; end program. EDX. PREC: user got here by choosing no in goAgain. Post: program exits.
theEnd PROC
	mov edx, OFFSET bye
	call WriteString
    EXIT    ;shoot self in foot to exit early so main doesnt call this multiple times
theEnd ENDP



END main
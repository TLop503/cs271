TITLE Assignment3 (hw3.asm)

; Troy Lopez
; CS 271 Assignment4     2/18/24
; Gets user input and calculates factors. Exercises understanding of control flow with psuedo-loops

INCLUDE Irvine32.inc

UPPLIM     EQU     401     ; 401 so check is inclusive
LOWLIM     EQU     0     

.data
    ; variable definitions
    ; Notation:
    ; prThing is a string to be printed
    ; usThing is a user inputted value
    
    intro1  BYTE    "Hw3: Composite Numbers, by Troy Lopez",0
    
    data1   BYTE    "Enter the number of composites to display, up to 400 (inclusive)",0
    usLim   DWORD   ?
    debug1  BYTE    "data is good (debug message)",0
    dataEr  BYTE    "Out of range, try again",0




    lpctr   DWORD   ?
    toCheck DWORD   ?
    flag    DWORD   ?
    space   BYTE    "  ",0

    prAgain BYTE    "Would you like to go again? (1 = y/0 = n)",0
    usAgain DWORD   ?
    bye     BYTE    "Closing program. Goodbye",0
.code

main PROC
    
    CALL    intr
    CALL    getUsData
    ;CALL    showComposites
    CALL    goAgain
    CALL    theEnd
    EXIT
main ENDP

intr PROC
    MOV     edx, OFFSET intro1
    CALL    WRITESTRING
    CALL    CRLF
    CALL    CRLF
intr ENDP

getUsData PROC
    MOV     edx, OFFSET data1   ; Print prompt for data
    CALL    WRITESTRING    
    CALL    READINT             ; Get user input
    MOV     usLim, EAX
    CALL    validate
    ret
getUsData ENDP

validate PROC
    ; Verify if the user input is within the acceptable range
    MOV     EAX, usLim        ; Move the user input into EAX
    CMP     EAX, LOWLIM       ; Compare with the lower limit
    JL      invalid           ; Jump to invalid if less than the lower limit
    CMP     EAX, UPPLIM       ; Compare with the upper limit
    JG      invalid           ; Jump to invalid if greater than the upper limit
    ; if all checks pass return to normal
    RET

    invalid:
        ; Print error message and prompt user again
        MOV     edx, OFFSET dataEr
        CALL    WRITESTRING
        CALL    CRLF
        CALL    getUsData        ; Prompt user again
validate ENDP


showComposites PROC
    MOV     ECX, usLim
    DEC     ECX     ; denominator needs to be less than numerator to check composites

    outer:
        MOV     EAX, usLim
        MOV     toCheck, EAX
        SUB     toCheck, ECX    ; start from 1 then increase as x decreases

        PUSH    ECX     ; save for later
        MOV     ECX, toCheck
        DEC     ECX     ; start looking for valid denominators from check

        inner:
            MOV     EDX, 0 ; fill EDX for division
            
            CMP     ECX, 1
            JLE      restart ; dont check tocheck / 1, b/c this will always be 0

            MOV     EAX, toCheck
            DIV     ECX
            CMP     EDX, 0  ; if no remainder number is composite
            JE      print

            LOOP    inner  ; otherwise restart
            JMP     restart ; to skip over print once loop ends
            
            print:
                MOV     EDX, toCheck
                CALL    WRITESTRING
                MOV     EDX, OFFSET space
                CALL    WRITESTRING
                JMP     restart

            restart:
                POP     ECX
                LOOP    outer ; restore ECX and move to next number to check
    ; outer loop will happen again after printing or after exhausting factors
showComposites ENDP

goAgain PROC
    call    Crlf
    mov     edx, OFFSET prAgain
	call    WriteString
	call    Crlf

	call	ReadInt		                ;get input
	mov		usAgain, eax
	call	Crlf

	; 8.1 check user input
	cmp usAgain, 0		            ;Important, check against int, not char
	jne restart                    ; jump to doCalcs if usAgain is not equal to 0
    RET

    restart:
        CALL    main    ;restart program
goagain ENDP

theEnd PROC
	mov edx, OFFSET bye
	call WriteString
theEnd ENDP


END main
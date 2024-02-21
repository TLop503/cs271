TITLE Assignment3 (hw3.asm)

; Troy Lopez
; CS 271 Assignment4     2/18/24
; Gets user input and calculates factors. Exercises understanding of control flow with psuedo-loops

INCLUDE Irvine32.inc

UPPLIM     EQU     400
LOWLIM     EQU     4    ; b/c 1 breaks

.data
    ; variable definitions
    ; Notation:
    ; prThing is a string to be printed
    ; usThing is a user inputted value
    
    intro1  BYTE    "Hw3: Composite Numbers, by Troy Lopez",0
    
    data1   BYTE    "Enter the number of composites to display, from [4-100] (b/c the first composite number is 4)",0
    usLim   DWORD   ?
    debug1  BYTE    "data is good (debug message)",0
    dataEr  BYTE    "Out of range, try again",0

    lnctr   DWORD   0




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
    CALL    showComposites
    CALL    goAgain
    CALL    theEnd
    RET
main ENDP

; Prints out the instructions for the program. Touches EDX. No significant pre/post conditions
intr PROC
    MOV     edx, OFFSET intro1
    CALL    WRITESTRING
    CALL    CRLF
    CALL    CRLF
    RET
intr ENDP

; gets user data. uses EDX, EAX. no prec. post condition: calls validate to check usLim
getUsData PROC
    MOV     edx, OFFSET data1   ; Print prompt for data
    CALL    WRITESTRING    
    CALL    READINT             ; Get user input
    MOV     usLim, EAX
    CALL    validate
    ret
getUsData ENDP

; verifies usLim is within valid range. Uses EAX, EDX. Prec: usLim is filled. Post: either data is called again, or funciton returns thru data to main.
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

; print out every composite number up to usLim. Uses ECX, EAX, EDX, and 1 stack slot. Prec: usLim has been verified. Post: return to main after printing
; outer iterates through numbers to be checked, using push/pop to store ECX between iterations. 
; inner checks each factor until composite or not is determined
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
            JLE     restart ; dont check tocheck / 1, b/c this will always be 0

            MOV     EAX, toCheck
            DIV     ECX
            CMP     EDX, 0  ; if no remainder number is composite
            JE      print

            LOOP    inner  ; otherwise restart
            JMP     restart ; to skip over print once loop ends
            
            print:
                inc     lnctr
                cmp     lnctr, 11   ;at most 10 per line
                je      newline
                jmp     printNum

                newline:
                    CALL    CRLF
                    mov     lnctr, 1
                printNum:
                    MOV     EAX, toCheck
                    CALL    WRITEDEC
                    MOV     EDX, OFFSET space
                    CALL    WRITESTRING
                    JMP     restart

            restart:
                POP     ECX
                LOOP    outer ; restore ECX and move to next number to check
                RET
    ; outer loop will happen again after printing or after exhausting factors
showComposites ENDP

; asks if user wants to repeat program. uses EDX, EAX. no strict PREC. Post: user returns to main or restarts main.
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

; end program. EDX. PREC: user got here by choosing no in goAgain. Post: program exits.
theEnd PROC
	mov edx, OFFSET bye
	call WriteString
    EXIT    ;shoot self in foot to exit early so main doesnt call this multiple times
theEnd ENDP


END main
;=====macros=========================
%macro printHexNumberInt 0
	pushad
	mov eax,[toPrintInt]
  push eax
  push format_str_hex
	call printf
  add esp,8
	popad
%endmacro

%macro printHexNumber1Digit 0
	pushad
  mov eax,0
	mov al,[toPrintChar]
  push eax
  push format_str_hex
	call printf
  add esp,8
	popad
%endmacro

%macro printHexNumber1DigitNoNewLine 0
	pushad
  mov eax,0
	mov al,[toPrintChar]
  push eax
  push format_str_hex_noNewline
	call printf
  add esp,8
	popad
%endmacro

%macro printHexNumber1DigitNoNewLineDebug 0
	pushad
  mov eax,0
	mov al,[toPrintChar]
  push eax
  push format_str_hex_noNewline
  push dword[stderr]
	call fprintf
  add esp,12
	popad
%endmacro



%macro printStringPtr 0
	pushad
	mov eax,[toPrintStr]
  push eax
  push format_str_s
	call printf
  add esp,8
	popad
%endmacro

%macro printStringPtrDebug 0
	pushad
	mov eax,[toPrintStr]
  push eax
  push format_str_s
  push dword[stderr]
	call fprintf
  add esp,12
	popad
%endmacro


%macro printString 0
	pushad
	mov eax,toPrintStr
  push eax
  push format_str_s
	call printf
  add esp,8
	popad
%endmacro

%macro calcPrompt 0
	pushad
	mov eax,calc_message
  push eax
  push format_str_s_noNewline
	call printf
  add esp,8
	popad
%endmacro

%macro print_fullNumber 0
pushad
mov ecx, dword[ptr_currentLinkedList]
mov byte[leadingZerosFlag],1
push '#'

%%pushLoop:
  cmp ecx,0
  je %%endOfPushLoop
  mov edx,0
  mov dl,byte[ecx]
  push edx
  mov ecx,dword[ecx+1]
  jmp %%pushLoop

%%endOfPushLoop:

%%printAnotherNumberFromRegularStackPop:
  ; cmp byte[leadingZerosFlag],1
  ; je %%ignoreZeros
  ; ;--dont ignore zeros
  pop eax
  cmp al,'#'
  je %%endOfPrintFullNumber
  ;--dont ignore zeros and not the end of the number
  mov byte[toPrintChar],al  
  printHexNumber1DigitNoNewLine
  jmp %%printAnotherNumberFromRegularStackPop

  %%ignoreZeros:
  pop eax
  cmp al,'#'
  je %%endOfPrintFullNumber
  ;--not the end of the number
  cmp al,0
  je %%printAnotherNumberFromRegularStackPop
  ;--not the end of the number and not a zero
  mov byte[leadingZerosFlag],0
  mov byte[toPrintChar],al  
  printHexNumber1DigitNoNewLine
  jmp %%printAnotherNumberFromRegularStackPop

%%endOfPrintFullNumber:

mov ecx,format_endOfLine
mov dword[toPrintStr],ecx
printStringPtr

popad
%endmacro

%macro print_fullNumberDebug 0
pushad
mov ecx, dword[ptr_currentLinkedList]
mov byte[leadingZerosFlag],1
push '#'

%%pushLoop:
  cmp ecx,0
  je %%endOfPushLoop
  mov edx,0
  mov dl,byte[ecx]
  push edx
  mov ecx,dword[ecx+1]
  jmp %%pushLoop

%%endOfPushLoop:

%%printAnotherNumberFromRegularStackPop:
  ; cmp byte[leadingZerosFlag],1
  ; je %%ignoreZeros
  ; ;--dont ignore zeros
  pop eax
  cmp al,'#'
  je %%endOfPrintFullNumber
  ;--dont ignore zeros and not the end of the number
  mov byte[toPrintChar],al  
  printHexNumber1DigitNoNewLineDebug
  jmp %%printAnotherNumberFromRegularStackPop

  %%ignoreZeros:
  pop eax
  cmp al,'#'
  je %%endOfPrintFullNumber
  ;--not the end of the number
  cmp al,0
  je %%printAnotherNumberFromRegularStackPop
  ;--not the end of the number and not a zero
  mov byte[leadingZerosFlag],0
  mov byte[toPrintChar],al  
  printHexNumber1DigitNoNewLineDebug
  jmp %%printAnotherNumberFromRegularStackPop

%%endOfPrintFullNumber:

mov ecx,format_endOfLine
mov dword[toPrintStr],ecx
printStringPtrDebug

popad
%endmacro

%macro printEax 0
;***************
	pushad
	push EAX_message
	push format_str_s
  push dword[stderr]
	call fprintf
	add esp,12
	popad

;****************
;***************
	pushad
	push eax
	push format_str_hex
  push dword[stderr]
	call fprintf
	add esp,12
	popad

;****************
%endmacro


%macro printEbx 0
;***************
	pushad
	push EBX_message
	push format_str_s
  push dword[stderr]
	call fprintf
	add esp,12
	popad

;****************
;***************
	pushad
	push ebx
	push format_str_hex
	push dword[stderr]
  call fprintf
	add esp,12
	popad

;****************
%endmacro

%macro printEcx 0
;***************
	pushad
	push ECX_message
	push format_str_s
  push dword[stderr]
	call fprintf
	add esp,12
	popad

;****************
;***************
	pushad
	push ecx
	push format_str_hex
  push dword[stderr]
	call fprintf
	add esp,12
	popad

;****************
%endmacro

%macro printEdx 0
;***************
	pushad
	push EDX_message
	push format_str_s
  push dword[stderr]
	call fprintf
	add esp,12
	popad

;****************
;***************
	pushad
	push edx
	push format_str_hex
  push dword[stderr]
	call fprintf
	add esp,12
	popad

;****************
%endmacro

%macro printMyDebug 0
;***************
	pushad
	push debugCheck
	push format_str_s
  push dword[stderr]
	call fprintf
	add esp,12
	popad

;****************
%endmacro

%macro checkForUnderFlow 1
;***************
  mov dl,byte[currentNumOfOpsInStack]
  cmp dl,%1
  jge %%noUnderFlow
  mov eax,underflow_message
  mov dword[toPrintStr],eax
  printStringPtr
  jmp mainLoop
  %%noUnderFlow:
  ;--continue of the program
  ;****************
%endmacro

%macro checkForOverFlow 0
;***************
  pushad
  mov dl,byte[currentNumOfOpsInStack]
  mov cl,byte[maxOpernads]
  cmp dl,cl
  jl %%noOverFlow
  mov eax,overflow_message
  mov dword[toPrintStr],eax
  printStringPtr
  popad
  jmp mainLoop
  %%noOverFlow:
  popad
  ;--continue of the program
  ;****************
%endmacro

%macro freeOp1 0
;***************
  pushad
  mov eax,[ptr_operand1]
  mov dword [ptr_operand1_curLink],eax  ;eax= headOfTheList
  
  %%loopFreeOp1:
  
  cmp eax,0       
  je %%endOfFreeOp1
  ;printMyDebug
  mov ebx,dword[eax+1]                  ;ebx= nextNode
  
  mov dword[ptr_operand1_curLink],ebx   ;currentLink= nextNode
  
  ;--callfree
  pushad
  push eax
  call free
  add esp,4
  popad
  ;---end of free function
  
  mov eax,dword[ptr_operand1_curLink]
  jmp %%loopFreeOp1
  %%endOfFreeOp1:     

  popad
  ;--continue of the program
  ;****************
%endmacro

%macro freeOp2 0
;***************
  pushad
  mov eax,[ptr_operand2]
  mov dword [ptr_operand2_curLink],eax  ;eax= headOfTheList

  %%loopFreeOp2:
  cmp eax,0                           
  je %%endOfFreeOp2
  mov ebx,dword[eax+1]                  ;ebx= nextNode
  mov dword[ptr_operand2_curLink],ebx   ;currentLink= nextNode

  ;--callfree
  pushad
  push eax
  call free
  add esp,4
  popad
  ;---end of free function
  mov eax,dword[ptr_operand2_curLink]
  jmp %%loopFreeOp2
  %%endOfFreeOp2:
  popad
  ;--continue of the program
  ;****************
%endmacro
;========================================




section .rodata
  
  format_str_s:                 db "%s",10,0
  format_str_i:                 db "%d",10,0
  format_str_hex:               db "%X",10,0
  format_str_hex_noNewline:     db "%X",0
  format_str_s_noNewline:       db "%s",0
  format_endOfLine:             db 0
  problem_withInput_message:    db "There was a problem with one of the input chars - 1",10 , 0
  problem_withArguments_message:    db "Problem detected with on of the program's arguments (argv)",10 , 0
  debugCheck:                   db "** here**",10,0
  underflow_message:            db "Error: Insufficient Number of Arguments on Stack",0
  overflow_message:             db "Error: Operand Stack Overflow",0
  calc_message:                 db "calc: ",0
  EAX_message: db "EAX:" , 0
	EBX_message: db "EBX:" , 0
	ECX_message: db "ECX:" , 0
	EDX_message: db "EDX:" , 0
  op1_message: db "Operand1: " , 0
  op2_message: db "Operand2: " , 0
  result_message: db "the result: " , 0

section .bss

ptr_operands_stack:           resb 4              ;   pointer to the "bottom" location of the stack
ptr_my_esp:                   resb 4              ;   ponter to the current location of the to of the operands stack
ptr_operand1:                 resb 4              ;   pointer to one of the operands
ptr_operand2:                 resb 4   
ptr_operand1_curLink:         resb 4              ;   pointer to one of the operands
ptr_operand2_curLink:         resb 4            ;   pointer to one of the operands
currentNumOfOpsInStack:       resb 1              ;   counts the current number of operand in the stack
my_carry:                     resb 1              ;   flag for my special carry
maxOpernads:                  resb 1              ;   represents the maximal amount of operands possible in the stack
ptr_input:                    resb 4              ;   points to the string came from user's input (stdin)
ptr_currentLinkedList:        resb 4              ;   points to the current number's linked list- from input or from one of the operations
ptr_currentLinkInCurrentLinkedList: resb 4        ;   pointer to the current link on the current linked list  
inputBuffer:                  resb 82             ;   buffer for the input chars from the usres- up to 80 chars
toPrintInt:                   resb 4              ;   use to print one number
toPrintStr:                   resb 4              ;   use to print one string- pointer to string
toPrintPtr:                   resb 4              ;   use to print one number- pointer number
toPrintChar:                  resb 1              ;   use to print one number- pointer number
currentLocationOnInputBuffer: resb 4              ;   use for loop over the input chars: = inputBuffer+ebx, when ebx incremtents until inputBuffer[ebx]==0
firstDigit:                   resb 1              ;   use to store the a current digit to work with
secondDigit:                  resb 1              ;   use to store the a current digit to work with
ptr_currentDigitLink:         resb 4              ;   use for pointer to new link coming from calloc
leadingZerosFlag:             resb 1              ;   on print, represents wether to ignore the coming zeros because they are in the begininig of the number- leading zeros: 00015F=>157
countNumberOfOperations:      resb 4              ;   count how many user operations were performed  
debugModeFlag:                resb 1              ;   flag=0 <==> debug mode =off , flag=1 <==> debug mode = on
inputArgStackSizeNumber:      resb 1              ;   use for convert number from string in argv
checkLeadingZerosAndProcessFlag:    resb 1              ;   uses for check if i saw a zero from the beginning of the word (from the lsb): 0= no leading zeros, 1= leading zeros
ptr_checkLeadingZerosAnd_nextLink:  resb 4              ;   uses to point to the first leading zero, so we will be able to delete it    
checkLeadingZerosNumberOfDigits:    resb 4          ;   count length of the numebr (of the linked list)  
ptr_theLinkThatHisNextIsTheFirstZero:  resb 4              ;   uses to point to the first leading zero, so we will be able to delete it    
wasZeroButWasFirst:                     resb 1




section .text

align 16
  global main
  extern printf
  extern fprintf 
  extern fflush
  extern malloc 
  extern calloc 
  extern free 
  extern gets 
  extern getchar 
  extern fgets 
  extern stderr


main:
push ebp
mov ebp,esp
pushad

call myCalc

mov esp,ebp
pop ebp
ret

;***********************************************
;   loads the program and construct all fields
;***********************************************
myCalc:                    

;check
;printEax


mov dword[ptr_operands_stack],0   
mov dword[ptr_my_esp],0
mov dword[ptr_operand1],0
mov dword[ptr_operand2],0
mov byte[currentNumOfOpsInStack],0
mov byte[my_carry],0
mov byte[maxOpernads],5
mov dword[ptr_input],0
mov dword[ptr_currentLinkedList],0 
mov dword[countNumberOfOperations],0
mov byte[debugModeFlag],0

;--read from input parameters
mov edx,0             ;edx=argc
mov edx,dword[ebp+8]  ; argc

cmp dl,1
jg checkInputArgs
jmp endOfArgsCheck

checkInputArgs:
mov ecx,0
mov ecx,edx           ; ecx=edx=argc
mov eax,0
mov eax,[ebp+12]            ; *argv
cmp ecx,1
je endOfArgsCheck
mov eax,[eax+4]             ; *argv[1]

cmp ecx,3
je debugModeAndNumber

cmp ecx,2
je checkDebugOrNumber

cmp ecx,1
je endOfArgsCheck

debugModeAndNumber:
mov byte[debugModeFlag],1
mov bl,byte[eax]
jmp convertNumberInArgumnet

checkDebugOrNumber:

mov bl,byte[eax]
cmp bl,0
je problemInArguments
cmp bl,'-'
je onlyDebugMode
jmp convertNumberInArgumnet

onlyDebugMode:
mov byte[debugModeFlag],1
jmp endOfArgsCheck






problemInArguments:
mov eax,problem_withArguments_message
mov dword[toPrintStr],eax
printStringPtr
jmp endOfTheProgram

endOfArgsCheck:
;--rest of startup process

jmp zeroBuffer
returnFromZeroBufferStartup:


jmp allocateSpaceForStack
returnFromAllocateOpsStack:

jmp mainLoop



;***********************************************
;   convert string of input argument
;   to number
;***********************************************
convertNumberInArgumnet: 

; mov bl,byte[eax+1]
; mov [toPrintChar],bl
; printHexNumber1Digit

; mov bl,byte[eax+2]
; mov [toPrintChar],bl
; printHexNumber1Digit
;first digit in bl
cmp bl,'9'
jg handleNumbersFromAtoFArgvAAA
cmp bl,0
jle problemInArguments
sub bl,'0' ; '0'-'0'=0
mov byte[inputArgStackSizeNumber],bl
jmp secondDigitInInputArg


handleNumbersFromAtoFArgvAAA:

cmp bl,'A'
jl  problemInArguments
cmp bl,'F'
jg  problemInArguments
sub bl,55 ; 'A'-55=10
mov byte[inputArgStackSizeNumber],bl
jmp secondDigitInInputArg

secondDigitInInputArg:
mov bl,byte[eax+1]    ; mov to bl second digit

cmp bl,0
jle finishWithArgNum

cmp bl,'9'
jg handleNumbersFromAtoFArgvBBB
sub bl,'0' ; '0'-'0'=0
add byte[inputArgStackSizeNumber],bl
jmp finishWithArgNum


handleNumbersFromAtoFArgvBBB:

cmp bl,'A'
jl  problemInArguments
cmp bl,'F'
jg  problemInArguments
sub bl,55 ; 'A'-55=10
add byte[inputArgStackSizeNumber],bl
jmp finishWithArgNum

finishWithArgNum:
mov bl,byte[inputArgStackSizeNumber]
mov byte[maxOpernads],bl
jmp endOfArgsCheck

;***********************************************
;   ends the program and returns, using 
;   c calling convention
;***********************************************
endOfTheProgram: 

mov ebx,0
mov ebx,dword[countNumberOfOperations]
mov dword[toPrintInt],ebx
printHexNumberInt
jmp freeOperandsInOpsStack

returnFromStackFreeOps:

;-----free stack------
pushad
push dword[ptr_operands_stack]
call free
add esp,4
popad
;--end of free function----
mov eax,0
mov eax,[countNumberOfOperations]
ret



;***********************************************
;   puts zeros in all buffer's bytes 
;***********************************************
zeroBuffer: 
mov ebx, 0
zeroBufferLoop:
cmp ebx,80
je returnFromZeroBufferStartup
mov byte[inputBuffer+ebx],0
inc ebx
jmp zeroBufferLoop


;***********************************************
;   allocate space on heap for the specail stack 
;***********************************************
allocateSpaceForStack:
mov ebx,0
mov bl,byte[maxOpernads]
push ebx
push dword 4
call calloc
add esp, 8
mov dword[ptr_operands_stack],eax
mov dword[ptr_my_esp],eax
mov byte[currentNumOfOpsInStack],0
jmp returnFromAllocateOpsStack

;***********************************************
;   main operation of the program, reads an
;   input everytime and acts according to it
;***********************************************
mainLoop:
calcPrompt
jmp readFromUser

returnFromReadFromUser:



jmp endOfTheProgram
;***********************************************
;   readInput from user
;***********************************************
readFromUser:
push inputBuffer
call gets
add esp,4
; mov ebx,inputBuffer
; mov dword[toPrintStr],ebx
; printStringPtr
jmp calculatorMenuOptions



;***********************************************
;   checks the input threw all the calculator's
;   options and decides what to do
;***********************************************
calculatorMenuOptions:

mov bl,byte[inputBuffer]

mov ecx,0



next1:
;--pop&print
cmp bl,'p'
jne next2
mov ecx,dword[countNumberOfOperations]
inc ecx
mov dword[countNumberOfOperations],ecx
mov al,1
checkForUnderFlow al
jmp popAndPrint

next2:
;--bitwise and: op1&op2
cmp bl,'&'
jne next3
mov ecx,dword[countNumberOfOperations]
inc ecx
mov dword[countNumberOfOperations],ecx
mov al,2
checkForUnderFlow al
jmp bitwiseAnd

next3:
;--bitwise or: op1|op2
cmp bl,'|'
jne next4
mov ecx,dword[countNumberOfOperations]
inc ecx
mov dword[countNumberOfOperations],ecx
mov al,2
checkForUnderFlow al
jmp bitwiseOr

next4:
;--addition: op1 + op2
cmp bl,'+'
jne next5
mov ecx,dword[countNumberOfOperations]
inc ecx
mov dword[countNumberOfOperations],ecx
mov al,2
checkForUnderFlow al
jmp plus_additionProcess

next5:
;--duplicate: push [ebp-4]
cmp bl,'d'
jne next6
mov ecx,dword[countNumberOfOperations]
inc ecx
mov dword[countNumberOfOperations],ecx
mov al,1
checkForUnderFlow al
jmp duplicate

next6:
;--exit the program= quit
cmp bl,'q'
je endOfTheProgram

next7:
;--number of digits: push |[ebp-4]|
cmp bl,'n'
jne next8
mov ecx,dword[countNumberOfOperations]
inc ecx
mov dword[countNumberOfOperations],ecx
mov al,1
checkForUnderFlow al
jmp numberOfHexaDecimalDigits

next8:
;no other menu option=>number
checkForOverFlow
jmp parseInputNumber



;***********************************************
;   parse the input string, char by char,
;   to a united number, represented by
;   linked list
;***********************************************
parseInputNumber:
mov dword[ptr_currentLinkedList],0
mov ebx,0           ; counter for loop on chars (for i=0;while chars[i]!=0)
mov byte[leadingZerosFlag],0
mov byte[wasZeroButWasFirst],0

loopOverInputChars:
mov eax,0
mov al, byte[inputBuffer+ebx]

cmp al,0
je handleEndOfLoopOverInputChars
cmp al,'0'
jl problemWithInputString ; al=inputBuffer[ebx]<'0'

cmp al,'9'
jg handleNumbersFromAtoF

;;handleNumbersFrom 0 to 9

sub al,'0' ; '0'-'0'=0
cmp al,0
jne notAZero
cmp bl,0
je zeroButFirst
cmp byte[leadingZerosFlag],0
je incrementToNextChar
mov byte[firstDigit],al
jmp addLinkFromInput

zeroButFirst:
mov byte[leadingZerosFlag],0
mov byte[wasZeroButWasFirst],1
jmp incrementToNextChar

notAZero:
mov byte[leadingZerosFlag],1
mov byte[firstDigit],al
jmp addLinkFromInput



handleNumbersFromAtoF:

cmp al,'A'
jl  problemWithInputString

cmp al,'F'
jg  problemWithInputString
sub al,55 ; 'A'-55=10
mov byte[firstDigit],al
jmp addLinkFromInput

handleEndOfLoopOverInputChars:
cmp ebx,1
jne endOfLoopOverInputChars
cmp byte[wasZeroButWasFirst],1
jne endOfLoopOverInputChars
mov byte[wasZeroButWasFirst],0
mov byte[firstDigit],0
jmp addLinkFromInput

endOfLoopOverInputChars:


jmp enterNumberLinkedListToStackAfterAllFucns



;***********************************************
;   addLink to the input chain
;   from the reading input loop process
;***********************************************
addLinkFromInput:

;-------------calloc
push 5      ; 5 bytes for each node: 1 for digit, 4 for pointer to next node
push 1      ;
call calloc
add esp,8
mov dword[ptr_currentDigitLink],eax
;-------------endOfCalloc

;;remember- ebx- saved for counter on input string
mov eax,dword[ptr_currentDigitLink]

mov dl,byte[firstDigit]
mov byte[eax], dl

mov ecx,dword[ptr_currentLinkedList]


mov dword[eax+1],ecx
mov dword[ptr_currentLinkedList],eax
incrementToNextChar:
inc ebx
jmp loopOverInputChars
;---------------------------------------------------------------------------------



;***********************************************
;   start plus process
;   opernadsStack[ebp-4]+opernadsStack[ebp-8]
;   push the sum result to stack
;***********************************************
plus_additionProcess:


;----first
mov ebx,dword[ptr_my_esp]; get pointer to opernads esp - 4
mov eax,dword[ebx-4]; get the pointer sitting inside the stack in esp - 4
sub ebx,4
mov dword[ptr_my_esp],ebx
mov dl,byte[currentNumOfOpsInStack]
sub dl,1
mov byte[currentNumOfOpsInStack],dl
mov dword [ptr_operand1],eax
mov dword [ptr_operand1_curLink],eax
mov dword[ptr_currentLinkedList],eax

cmp byte[debugModeFlag],1
jne notDebugPlus1
mov eax,op1_message
mov dword[toPrintStr],eax
printStringPtrDebug
print_fullNumberDebug

notDebugPlus1:

;-----secnod
mov eax,dword[ebx-4]; get the pointer sitting inside the stack in esp - 4
sub ebx,4
mov dword[ptr_my_esp],ebx
mov dl,byte[currentNumOfOpsInStack]
sub dl,1
mov byte[currentNumOfOpsInStack],dl
mov dword [ptr_operand2],eax
mov dword [ptr_operand2_curLink],eax
mov dword[ptr_currentLinkedList],eax

cmp byte[debugModeFlag],1
jne notDebugPlus2
mov eax,op2_message
mov dword[toPrintStr],eax
printStringPtrDebug
print_fullNumberDebug

notDebugPlus2:

plus_afterPrints:
mov dword[ptr_currentLinkedList],0
mov dword[ptr_currentLinkInCurrentLinkedList],0
mov byte[my_carry],0



  plusLoop:
    
    mov eax,0
    mov ebx,0

    mov eax,dword[ptr_operand1_curLink]
    cmp eax,0
    je plus_firstOpFinished

    mov ebx,dword[ptr_operand2_curLink]
    cmp ebx,0
    je plus_secondOpFinished
   
    
    mov ecx,0
    mov edx,dword[ptr_operand1_curLink]
    
    mov cl,byte[edx]
    
    mov edx,dword[ptr_operand2_curLink]
    mov al,byte[edx]
    add cl,byte[edx]
    cmp cl,0xF
    jle no_carry
    
    ;there is carry
    
    add cl,byte[my_carry] ; add previous carry
    sub cl,0x10
    mov byte[my_carry],1  ; update my_carry flag
    jmp afterCarryCheck
    
    no_carry:
    add cl,byte[my_carry] ; add previous carry
    cmp cl,0xF

    jle no_carry_2_still
    
    mov byte[my_carry],1
    sub cl,0x10
    jmp afterCarryCheck

    no_carry_2_still:
    mov byte[my_carry],0

    afterCarryCheck:
    
    mov byte[firstDigit],cl
    ; mov [toPrintChar],cl
    ; printHexNumber1Digit
    
    jmp addLinkAfterPlus

      plus_firstOpFinished:
        
        mov ebx,dword[ptr_operand2_curLink]
        cmp ebx,0
        je plus_bothOpernadsFinished
        mov ecx,0
        mov edx,dword[ptr_operand2_curLink]
        mov cl,byte[edx]

        mov dl,byte[my_carry]
        add cl,dl
        cmp cl,0xF
        jle no_carry_plus_firsOpFinished
        
        sub cl,0x10
        mov byte[my_carry],1
        mov byte[firstDigit],cl
        jmp addLinkAfterPlus
        
        no_carry_plus_firsOpFinished:
        
        mov byte[my_carry],0
        mov byte[firstDigit],cl
        jmp addLinkAfterPlus

      plus_secondOpFinished:
        mov ebx,dword[ptr_operand1_curLink]
        cmp ebx,0
        je plus_bothOpernadsFinished
        mov ecx,0
        mov edx,dword[ptr_operand1_curLink]
        mov cl,byte[edx]
        
        mov dl,byte[my_carry]
        add cl,dl
        cmp cl,0xF
        jle no_carry_plus_secondOpFinished
        sub cl,0x10
        mov byte[my_carry],1
        mov byte[firstDigit],cl
        jmp addLinkAfterPlus

        no_carry_plus_secondOpFinished:
        mov byte[my_carry],0
        mov byte[firstDigit],cl
        jmp addLinkAfterPlus
      
      plus_bothOpernadsFinished:
      mov dl,byte[my_carry]
      cmp dl,1
      je plus_addLastLinkForCarry
      jmp plus_finishLoop
      
      plus_addLastLinkForCarry:
      mov byte[firstDigit],1
      mov byte[my_carry],0
      jmp addLinkAfterPlus



      plus_finishLoop:

      freeOp1
      freeOp2

      cmp byte[debugModeFlag],1
      jne notDebugPlus3
      mov eax,result_message
      mov dword[toPrintStr],eax
      printStringPtrDebug
      print_fullNumberDebug
      notDebugPlus3:
      jmp enterNumberLinkedListToStackAfterAllFucns 



;***********************************************
;   addLink to the input chain
;   from the adding process
;***********************************************
addLinkAfterPlus:

;-------------calloc
push 5      ; 5 bytes for each node: 1 for digit, 4 for pointer to next node
push 1      ;
call calloc
add esp,8
mov dword[ptr_currentDigitLink],eax
;-------------endOfCalloc



;;remember- ebx- saved for counter on input string
;;assigning the needed info (byte+pointer) to the new link comes from calloc
mov eax,dword[ptr_currentDigitLink]

mov dl,byte[firstDigit]
mov byte[eax], dl
mov dword[eax+1],0




;add the new link to the end of the list
mov ecx,0
mov ecx,dword[ptr_currentLinkInCurrentLinkedList]
cmp ecx,0
je plus_noLinksInNewList

mov dword[ecx+1],eax
mov [ptr_currentLinkInCurrentLinkedList],eax
jmp plus_incrementOperands

plus_noLinksInNewList:
mov dword[ptr_currentLinkedList],eax
mov dword[ptr_currentLinkInCurrentLinkedList],eax


plus_incrementOperands:
;;increment the pointest for the original lists of the opernads
mov eax,0
mov eax,dword[ptr_operand1_curLink]
cmp eax,0
je plus_dont_inc_op1
mov eax,[eax+1]
mov dword[ptr_operand1_curLink],eax

plus_dont_inc_op1:
mov eax,0
mov eax,dword[ptr_operand2_curLink]
cmp eax,0
je plus_dont_inc_op2
mov eax,[eax+1]
mov dword[ptr_operand2_curLink],eax

plus_dont_inc_op2:
jmp plusLoop
;---------------------------------------------------------------------------------
;***********************************************
;   pop a number from the opernads stack
;   and print it's value to stdout
;***********************************************
popAndPrint:
;check for number of opernads and alert if needed
mov ebx,dword[ptr_my_esp]; get pointer to opernads esp - 4
mov eax,dword[ebx-4]; get the pointer sitting inside the stack in esp - 4
sub ebx,4
mov dword[ptr_my_esp],ebx
mov dl,byte[currentNumOfOpsInStack]
dec dl
mov byte[currentNumOfOpsInStack],dl
mov dword [ptr_currentLinkedList],eax
mov dword[ptr_operand1],eax
print_fullNumber
freeOp1
;free ptr_currentLinkedList
jmp mainLoop

;---------------------------------------------------------------------------------
;***********************************************
;   push a duplication of the number in the top
;   of the opernads stack
;***********************************************
duplicate:

;----first
mov ebx,dword[ptr_my_esp]; get pointer to opernads esp - 4
mov eax,dword[ebx-4]; get the pointer sitting inside the stack in esp - 4

mov dword [ptr_operand1],eax
mov dword [ptr_operand1_curLink],eax
mov dword[ptr_currentLinkedList],eax

cmp byte[debugModeFlag],1
jne notDebugDuplicate1
mov eax,op1_message
mov dword[toPrintStr],eax
printStringPtrDebug
print_fullNumberDebug
notDebugDuplicate1:

mov dword[ptr_currentLinkedList],0
mov dword[ptr_currentLinkInCurrentLinkedList],0


dupLoop:
    
    mov eax,0

    mov eax,dword[ptr_operand1_curLink]
    cmp eax,0
    je dup_firstOpFinished   

    mov ecx,0
    mov edx,dword[ptr_operand1_curLink]
    mov cl,byte[edx]
    mov byte[firstDigit],cl

    
    jmp addLinkAfterDuplicate

      dup_firstOpFinished:

      cmp byte[debugModeFlag],1
      jne notDebugDuplicate2
      mov eax,result_message
      mov dword[toPrintStr],eax
      printStringPtrDebug
      print_fullNumberDebug
      notDebugDuplicate2:
      jmp enterNumberLinkedListToStackAfterAllFucns 


;***********************************************
;   addLink to the input chain
;   from the duplication of the op on the top
;   of the stack
;***********************************************
addLinkAfterDuplicate:
;-------------calloc
push 5      ; 5 bytes for each node: 1 for digit, 4 for pointer to next node
push 1      ;
call calloc
add esp,8
mov dword[ptr_currentDigitLink],eax
;-------------endOfCalloc

;;remember- ebx- saved for counter on input string
;;assigning the needed info (byte+pointer) to the new link comes from calloc
mov eax,dword[ptr_currentDigitLink]

mov dl,byte[firstDigit]
mov byte[eax], dl
mov dword[eax+1],0


;add the new link to the end of the list
mov ecx,0
mov ecx,dword[ptr_currentLinkInCurrentLinkedList]
cmp ecx,0
je dup_noLinksInNewList

mov dword[ecx+1],eax
mov [ptr_currentLinkInCurrentLinkedList],eax
jmp dup_incrementOperands

dup_noLinksInNewList:
mov dword[ptr_currentLinkedList],eax
mov dword[ptr_currentLinkInCurrentLinkedList],eax


dup_incrementOperands:
;;increment the pointest for the original lists of the opernads
mov eax,dword[ptr_operand1_curLink]
mov eax,[eax+1]
mov dword[ptr_operand1_curLink],eax
jmp dupLoop



;---------------------------------------------------------------------------------

;***********************************************
;   start bitwise and process
;   opernadsStack[ebp-4]&opernadsStack[ebp-8]
;   pop two opernads from the opernad stack 
;   and push the result
;   push the result to stack
;***********************************************
bitwiseAnd:
;check for number of opernads and alert if needed

;----first
mov ebx,dword[ptr_my_esp]; get pointer to opernads esp - 4
mov eax,dword[ebx-4]; get the pointer sitting inside the stack in esp - 4
sub ebx,4
mov dword[ptr_my_esp],ebx
mov dl,byte[currentNumOfOpsInStack]
sub dl,1
mov byte[currentNumOfOpsInStack],dl
mov dword [ptr_operand1],eax
mov dword [ptr_operand1_curLink],eax
mov dword[ptr_currentLinkedList],eax

cmp byte[debugModeFlag],1
jne notDebugAnd1
mov eax,op1_message
mov dword[toPrintStr],eax
printStringPtrDebug
print_fullNumberDebug
notDebugAnd1:

;-----secnod
mov eax,dword[ebx-4]; get the pointer sitting inside the stack in esp - 4
sub ebx,4
mov dword[ptr_my_esp],ebx
mov dl,byte[currentNumOfOpsInStack]
sub dl,1
mov byte[currentNumOfOpsInStack],dl
mov dword [ptr_operand2],eax
mov dword [ptr_operand2_curLink],eax
mov dword[ptr_currentLinkedList],eax

cmp byte[debugModeFlag],1
jne notDebugAnd2
mov eax,op2_message
mov dword[toPrintStr],eax
printStringPtrDebug
print_fullNumberDebug
notDebugAnd2:

mov dword[ptr_currentLinkedList],0
mov dword[ptr_currentLinkInCurrentLinkedList],0


  andLoop:
    
    mov eax,0
    mov ebx,0

    mov eax,dword[ptr_operand1_curLink]
    cmp eax,0
    je and_firstOpFinished

    mov ebx,dword[ptr_operand2_curLink]
    cmp ebx,0
    je and_secondOpFinished
   

    mov ecx,0
    mov edx,dword[ptr_operand1_curLink]
    
    mov cl,byte[edx]
    
    mov edx,dword[ptr_operand2_curLink]
    mov al,byte[edx]
    and cl,byte[edx]
    mov byte[firstDigit],cl

    
    jmp addLinkAfterAnd

      and_firstOpFinished:

      and_secondOpFinished:

      cmp byte[debugModeFlag],1
      jne notDebugAnd3
      mov eax,result_message
      mov dword[toPrintStr],eax
      printStringPtrDebug
      print_fullNumberDebug
      notDebugAnd3:
      freeOp1
      freeOp2
      jmp and_deleteLeadingZeros
      returnFromDeleteZerosAnd:


      jmp enterNumberLinkedListToStackAfterAllFucns 


;***********************************************
;   addLink to the input chain
;   from the bitwise and process
;***********************************************
addLinkAfterAnd:

;-------------calloc
push 5      ; 5 bytes for each node: 1 for digit, 4 for pointer to next node
push 1      ;
call calloc
add esp,8
mov dword[ptr_currentDigitLink],eax
;-------------endOfCalloc

;;remember- ebx- saved for counter on input string
;;assigning the needed info (byte+pointer) to the new link comes from calloc
mov eax,dword[ptr_currentDigitLink]

mov dl,byte[firstDigit]
mov byte[eax], dl
mov dword[eax+1],0


;add the new link to the end of the list
mov ecx,0
mov ecx,dword[ptr_currentLinkInCurrentLinkedList]
cmp ecx,0
je noLinksInNewList

mov dword[ecx+1],eax
mov [ptr_currentLinkInCurrentLinkedList],eax
jmp and_incrementOperands

noLinksInNewList:
mov dword[ptr_currentLinkedList],eax
mov dword[ptr_currentLinkInCurrentLinkedList],eax


and_incrementOperands:
;;increment the pointest for the original lists of the opernads
mov eax,dword[ptr_operand1_curLink]
mov eax,[eax+1]
mov dword[ptr_operand1_curLink],eax
mov eax,dword[ptr_operand2_curLink]
mov eax,[eax+1]
mov dword[ptr_operand2_curLink],eax
jmp andLoop

;***********************************************
;   find if there are leadign zeros in the number
;   and delete them- free memory
;***********************************************
and_deleteLeadingZeros:
mov eax,0

mov eax,dword[ptr_currentLinkedList]

;--deubug checks
cmp byte[debugModeFlag],1
jne notDebugAndLeadingZeros
mov dl,byte[eax]
mov byte[toPrintChar],dl
print_fullNumberDebug
printEax
notDebugAndLeadingZeros:

mov dword[ptr_operand1],eax
mov dword[ptr_operand1_curLink],eax
mov byte[checkLeadingZerosAndProcessFlag],0
mov dword[checkLeadingZerosNumberOfDigits],0

mov eax,dword[eax+1]

mov dword[ptr_checkLeadingZerosAnd_nextLink],eax


loopDeleteLeadingZeros_and:
mov ebx,0
mov eax,dword[ptr_operand1_curLink]
cmp eax,0
je finishFirstLoopDeleteLeadingZeros_and

mov ebx,dword[checkLeadingZerosNumberOfDigits]
inc ebx
mov dword[checkLeadingZerosNumberOfDigits],ebx

mov edx,dword[ptr_checkLeadingZerosAnd_nextLink]
cmp edx,0
je finishFirstLoopDeleteLeadingZeros_and


mov ecx,0
mov edx,dword[ptr_checkLeadingZerosAnd_nextLink]
mov cl,byte[edx]
cmp cl,0
jne notZeroLeadingZerosLoop_and
;next digit is zero
cmp byte[checkLeadingZerosAndProcessFlag],1
je dontIncrementLinkThatHisNextIsTheFirst
mov byte[checkLeadingZerosAndProcessFlag],1
mov dword[ptr_theLinkThatHisNextIsTheFirstZero],eax
dontIncrementLinkThatHisNextIsTheFirst:
jmp incrementPointersLeadingZerosLoop

notZeroLeadingZerosLoop_and:
mov byte[checkLeadingZerosAndProcessFlag],0

incrementPointersLeadingZerosLoop:
mov dword[ptr_operand1_curLink],edx
mov edx,dword[edx+1]
mov dword[ptr_checkLeadingZerosAnd_nextLink],edx

jmp loopDeleteLeadingZeros_and

finishFirstLoopDeleteLeadingZeros_and:
mov al,byte[checkLeadingZerosNumberOfDigits]
cmp al,1
jle dontDeleteLeadingZeros
mov al,byte[checkLeadingZerosAndProcessFlag]
cmp al,1
jne dontDeleteLeadingZeros
mov eax,dword[ptr_theLinkThatHisNextIsTheFirstZero]
mov eax,dword[eax+1]
mov dword[ptr_operand1],eax
freeOp1
mov eax,dword[ptr_theLinkThatHisNextIsTheFirstZero]
mov dword[eax+1],0

dontDeleteLeadingZeros:
jmp returnFromDeleteZerosAnd

;---------------------------------------------------------------------------------
;***********************************************
;   start bitwise or process
;   opernadsStack[ebp-4]|opernadsStack[ebp-8]
;   push the result to stack
;***********************************************
bitwiseOr:
;check for number of opernads and alert if needed

;----first
mov ebx,dword[ptr_my_esp]; get pointer to opernads esp - 4
mov eax,dword[ebx-4]; get the pointer sitting inside the stack in esp - 4
sub ebx,4
mov dword[ptr_my_esp],ebx
mov dl,byte[currentNumOfOpsInStack]
sub dl,1
mov byte[currentNumOfOpsInStack],dl
mov dword [ptr_operand1],eax
mov dword [ptr_operand1_curLink],eax
mov dword[ptr_currentLinkedList],eax

cmp byte[debugModeFlag],1
jne notDebugOr1
mov eax,op1_message
mov dword[toPrintStr],eax
printStringPtrDebug
print_fullNumberDebug
notDebugOr1:

;-----secnod
mov eax,dword[ebx-4]; get the pointer sitting inside the stack in esp - 4
sub ebx,4
mov dword[ptr_my_esp],ebx
mov dl,byte[currentNumOfOpsInStack]
sub dl,1
mov byte[currentNumOfOpsInStack],dl
mov dword [ptr_operand2],eax
mov dword [ptr_operand2_curLink],eax
mov dword[ptr_currentLinkedList],eax

cmp byte[debugModeFlag],1
jne notDebugOr2
mov eax,op2_message
mov dword[toPrintStr],eax
printStringPtrDebug
print_fullNumberDebug
notDebugOr2:


mov dword[ptr_currentLinkedList],0
mov dword[ptr_currentLinkInCurrentLinkedList],0

  orLoop:
    
    mov eax,0
    mov ebx,0

    mov eax,dword[ptr_operand1_curLink]
    cmp eax,0
    je or_firstOpFinished

    mov ebx,dword[ptr_operand2_curLink]
    cmp ebx,0
    je or_secondOpFinished
   

    mov ecx,0
    mov edx,dword[ptr_operand1_curLink]
    
    mov cl,byte[edx]
    
    mov edx,dword[ptr_operand2_curLink]
    mov al,byte[edx]
    or cl,byte[edx]
    mov byte[firstDigit],cl

    
    jmp addLinkAfterOr

      or_firstOpFinished:
      mov ebx,dword[ptr_operand2_curLink]
      cmp ebx,0
      je or_bothOpernadsFinished
      mov ecx,0
      mov edx,dword[ptr_operand2_curLink]
      mov cl,byte[edx]
      mov byte[firstDigit],cl
      jmp addLinkAfterOr

      or_secondOpFinished:
      mov ebx,dword[ptr_operand1_curLink]
      cmp ebx,0
      je or_bothOpernadsFinished
      mov ecx,0
      mov edx,dword[ptr_operand1_curLink]
      mov cl,byte[edx]
      mov byte[firstDigit],cl
      jmp addLinkAfterOr



      or_bothOpernadsFinished:
      freeOp1
      freeOp2
      cmp byte[debugModeFlag],1
      jne notDebugOr3
      mov eax,result_message
      mov dword[toPrintStr],eax
      printStringPtrDebug
      print_fullNumberDebug
      notDebugOr3:
      jmp enterNumberLinkedListToStackAfterAllFucns

;***********************************************
;   addLink to the input chain
;   from the bitwise or process
;***********************************************
addLinkAfterOr:
;-------------calloc
push 5      ; 5 bytes for each node: 1 for digit, 4 for pointer to next node
push 1      ;
call calloc
add esp,8
mov dword[ptr_currentDigitLink],eax
;-------------endOfCalloc

;;remember- ebx- saved for counter on input string
;;assigning the needed info (byte+pointer) to the new link comes from calloc
mov eax,dword[ptr_currentDigitLink]

mov dl,byte[firstDigit]
mov byte[eax], dl
mov dword[eax+1],0


;add the new link to the end of the list
mov ecx,0
mov ecx,dword[ptr_currentLinkInCurrentLinkedList]
cmp ecx,0
je or_noLinksInNewList

mov dword[ecx+1],eax
mov [ptr_currentLinkInCurrentLinkedList],eax
jmp or_incrementOperands

or_noLinksInNewList:
mov dword[ptr_currentLinkedList],eax
mov dword[ptr_currentLinkInCurrentLinkedList],eax

or_incrementOperands:
;;increment the pointest for the original lists of the opernads
mov eax,0
mov eax,dword[ptr_operand1_curLink]
cmp eax,0
je or_dont_inc_op1
mov eax,[eax+1]
mov dword[ptr_operand1_curLink],eax

or_dont_inc_op1:
mov eax,0
mov eax,dword[ptr_operand2_curLink]
cmp eax,0
je or_dont_inc_op2
mov eax,[eax+1]
mov dword[ptr_operand2_curLink],eax

or_dont_inc_op2:
jmp orLoop

;---------------------------------------------------------------------------------
;***********************************************
;   pop one operand from the operands stack
;   and push number of hexadecimal digits 
;   as result
;***********************************************
numberOfHexaDecimalDigits:
mov ecx,0   ; ecx will be the counter of the digits

;----first
mov ebx,dword[ptr_my_esp]; get pointer to opernads esp - 4
mov eax,dword[ebx-4]; get the pointer sitting inside the stack in esp - 4
sub ebx,4
mov dword[ptr_my_esp],ebx
mov dl,byte[currentNumOfOpsInStack]
sub dl,1
mov byte[currentNumOfOpsInStack],dl
mov dword [ptr_operand1],eax
mov dword [ptr_operand1_curLink],eax
mov dword[ptr_currentLinkedList],eax
mov dword[ptr_operand1],eax

cmp byte[debugModeFlag],1
jne notDebugNCount1
mov eax,op1_message
mov dword[toPrintStr],eax
printStringPtrDebug
print_fullNumberDebug
notDebugNCount1:

mov dword[ptr_currentLinkedList],0
mov dword[ptr_currentLinkInCurrentLinkedList],0


    nCountLoop_countDigitsToEcx:
    
    mov eax,0

    mov eax,dword[ptr_operand1_curLink]
    cmp eax,0
    je nCount_firstLoopFinished
    inc ecx
    mov eax,dword[ptr_operand1_curLink]
    mov eax,[eax+1]
    mov dword[ptr_operand1_curLink],eax
    
    jmp nCountLoop_countDigitsToEcx



    ; in ecx the number of digits                                     ; for example: 479
    nCount_firstLoopFinished:         

    nCount_secondLoopConvertNumber:
      mov ebx,ecx ;store the current number                           ; ebx=ecx=479
      mov eax,ecx ;use eax to divide and multiply by 16               ; eax=ecx=479      
      
      shr eax,4                                                       ; eax=29                                                       ;
      shl eax,4                                                       ; eax=464
      sub ecx,eax   ; in ecx the rest of the number between 0 to F    ; ecx= 479, eax= 464 => ecx=479-464=15
      
      mov byte[firstDigit],cl
      jmp addLinkAfterNCount

      continueNCountConvert:
      mov ecx,ebx
      shr ecx,4
      cmp ecx,0
      jne nCount_firstLoopFinished
      jmp finishNCountLoop

    finishNCountLoop:
    freeOp1
    cmp byte[debugModeFlag],1
    jne notDebugNCount2
    mov eax,result_message
    mov dword[toPrintStr],eax
    printStringPtrDebug
    print_fullNumberDebug
    notDebugNCount2:
    jmp enterNumberLinkedListToStackAfterAllFucns 



;***********************************************
;   addLink to the input chain
;   from the count digits of the op on the top
;   of the stack
;***********************************************
addLinkAfterNCount:
;-------------calloc
push 5      ; 5 bytes for each node: 1 for digit, 4 for pointer to next node
push 1      ;
call calloc
add esp,8
mov dword[ptr_currentDigitLink],eax
;-------------endOfCalloc

;;remember- ebx- saved for counter on input string
;;assigning the needed info (byte+pointer) to the new link comes from calloc
mov eax,dword[ptr_currentDigitLink]

mov dl,byte[firstDigit]
mov byte[eax], dl
mov dword[eax+1],0


;add the new link to the end of the list
mov edx,0
mov edx,dword[ptr_currentLinkInCurrentLinkedList]
cmp edx,0
je nCount_noLinksInNewList

mov dword[edx+1],eax
mov [ptr_currentLinkInCurrentLinkedList],eax
jmp continueNCountConvert

nCount_noLinksInNewList:
mov dword[ptr_currentLinkedList],eax
mov dword[ptr_currentLinkInCurrentLinkedList],eax
jmp continueNCountConvert

;===forAllFunctions:=======================================
;***********************************************
;   after finish some operation=function
;   push the pointer to the head of the link
;   to the stack
;***********************************************
enterNumberLinkedListToStackAfterAllFucns:

mov eax,[ptr_my_esp]
mov edx,dword[ptr_currentLinkedList]
cmp byte[debugModeFlag],1
jne notDebugModeEnterNumberToStack
printEdx
notDebugModeEnterNumberToStack:
mov dword[eax],edx
;increment opernads stack pointer
add eax,4
mov dword[ptr_my_esp],eax
;int counter of operands
mov dl,byte[currentNumOfOpsInStack]
inc dl
mov byte[currentNumOfOpsInStack],dl
jmp mainLoop

;***********************************************
;   free each number (linkedList)= free all list
;***********************************************
freeOperandsInOpsStack:
mov edx,0

loopOnStackOpsForFree:

cmp dl,byte[currentNumOfOpsInStack]
jge endOfFreeStackLoop
shl edx,2
mov ecx,dword[ptr_operands_stack]
mov ecx,dword[ecx+edx]
mov dword[ptr_operand1],ecx

cmp byte[debugModeFlag],1
jne notDebugFreeStackOps1
printEdx
printEcx
notDebugFreeStackOps1:
freeOp1
shr edx,2
add edx,1
jmp loopOnStackOpsForFree

endOfFreeStackLoop:
jmp returnFromStackFreeOps

;==problems===========================
problemWithInputString:
mov byte[toPrintChar],al
printHexNumber1Digit
mov eax,problem_withInput_message
mov dword[toPrintStr],eax
printStringPtr
jmp endOfTheProgram



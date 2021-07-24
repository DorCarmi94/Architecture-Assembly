section	.rodata			; we define (global) read-only variables in .rodata section
	format_string: db "%s", 10, 0	; format string

section .bss			; we define (global) uninitialized variables in .bss section
	an: resb 12		; enough to store integer in [-2,147,483,648 (-2^31) : 2,147,483,647 (2^31-1)]
	number: resb 4

section .text
	global convertor
	extern printf

convertor:
	push ebp
	mov ebp, esp	
	pushad		

	mov ecx, dword [ebp+8]	; get function argument (pointer to string)

	; code starts

	convert_to_decimal:
	mov ebx, 0 ; will run on input chars 
	mov [number], ebx
	mov edx,0
	handle_char_loop:
	
	mov dl, [ecx+ebx]
	cmp edx, 0
	je restart_ecx
	cmp edx, 10
	je restart_ecx
	sub edx, 48
	push edx
	inc ebx 
	jmp handle_char_loop
	
	restart_ecx:
	mov ecx,1  ; decimal value of char

	loop_pop_stack:
	cmp ebx, 0
	je end_of_pop_stack
	pop edx
	mov eax, ecx
	mul edx
	add [number], eax
	mov eax, ecx
	mov edx, 10
	mul edx
	mov ecx, eax
	dec ebx
	jmp loop_pop_stack
	
	end_of_pop_stack:
	mov eax, 0
	push eax ; we will push chars, it will be the signal of end of string
	mov ebx, [number]; to be changed to what we got 

	loop:
	mov edx, ebx;  ebx =479 , edx=479
	shr edx, 4; ebx =479 , edx=29
	shl edx, 4;ebx =479 , edx=464
	sub ebx, edx ;ebx =15 , edx=464
	xchg ebx, edx;to do: subtitue ebx, edx ; => ebx =464 , edx=15
	mov ecx, 9 
	cmp ecx, edx
	jl handleA_F; convert to ascii ebx and push the outcome ebx =464 , edx=15
	jmp handle0_9

	continueConvert:
	shr ebx, 4 ;ebx =29 , edx=15
	cmp ebx, 0
	jne loop ;to do check if ebx not 0,jmp to loop 
	jmp handle_final_string

	handleA_F:
	mov ecx, edx ; ecx=15
	sub ecx, 10 ; ecx = 5
	add ecx, 65 ; ecx= 'F'
	push ecx
	jmp continueConvert

	handle0_9:
	mov ecx, edx 
	add ecx, 48 ; ecx= '***'
	push ecx
	jmp continueConvert

	handle_final_string:
	mov ecx,0
	loop2:
	pop eax
	mov byte[an+ecx], al
	inc ecx
	cmp al, 0
	jne loop2
	
	; code ends



	push an			; call printf with 2 arguments -  
	push format_string	; pointer to str and pointer to format string
	call printf


	add esp, 8		; clean up stack after call

	popad			
	mov esp, ebp	
	pop ebp
	ret

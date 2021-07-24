section	.rodata			; we define (global) read-only variables in .rodata section
	format_string: db "%d", 10, 0	; format int

section .text
	global assFunc
	extern printf
    extern c_checkValidity

assFunc:
	push ebp
	mov ebp, esp	
	pushad			

	mov eax, dword [ebp+8]	; get function argument (x)
    mov ebx, dword [ebp+12]  ; get function argument (y)

	; your code comes here...

	push eax			; push x argument 
	push ebx	        ; push y argument
	call c_checkValidity
	add esp, 8		; clean up stack after call
	cmp eax, 0	

	jnz push_xPLUSy
	mov eax, dword [ebp+8]	;  (x)
    mov ebx, dword [ebp+12]  ; (y)
	sub eax, ebx
	jmp pushAndPrint

	push_xPLUSy:
	mov eax, dword [ebp+8]	;  (x)
    mov ebx, dword [ebp+12]  ; (y)
	add eax, ebx
	
	pushAndPrint:
	push eax			; call printf with 2 arguments -  
	push format_string	; pointer to str and pointer to format string
	call printf
	add esp, 8		; clean up stack after call
	popad			
	mov esp, ebp	
	pop ebp
	ret

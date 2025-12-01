; char * strdup(const char *str1);
; strdup() returns a pointer to the newly allocated string, or a null pointer if an error occurred 

; Registers
; As per the System V AMD64 ABI convention: 
; the first six interger/pointer arguments are passed in the following registers:
; RDI -> first argument
; RSI -> second argument
; RDX -> third argument
; RCX -> fourth argument
; R8 -> fifth argument
; R9 ->  sixth argument
; 
; RAX -> designated return register 
; ---------------------------------------------------------------------------------------
; For strdup() this means: 
; RDI   -> str1
; RAX   -> return value 
; ---------------------------------------------------------------------------------------

section .text
global  ft_strdup
extern malloc
extern ft_strlen

ft_strdup:
	
	push	rdi				; saves the source pointer on the stack as any function calls (call) can overwrite registers
	
	call	ft_strlen		; returns length of str1 in RAX
	
	mov	rdi, rax			; move size of string in RDI
	call	malloc
	test	rax, rax		; if malloc fails and returns a NULL pointer, test will do "0 AND 0 = 0", and set ZF = 1
	jz		.malloc_fail	; if equal to zero jump to .malloc_fail
	
	pop rsi					; restore source pointer from stack in RSI to be used by ft_strcpy
	mov rdi, rax			; move dest (just allocated) string pointer to rdi to be used by ft_strcpy			
	call ft_strcpy
	jmp .done
	
.malloc_fail:
	pop rsi					; every push must have a pop to balance the stack. the choice for RSI is arbitrary
	xor rax, rax			; make RAX = 0 to be able to return NULL
	jmp .done

.done:
	ret
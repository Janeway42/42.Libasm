; char * strdup(const char *str1);
; strdup() returns a pointer to the duplicated string.
;   It returns NULL if insufficient memory was available, with errno set to indicate the error (ENOMEM - errno.h).

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

%define ENOMEM 12

section .text
global  ft_strdup
extern malloc
extern ft_strlen
extern ft_strcpy
extern __errno_location

ft_strdup:
	
	mov rsi, rdi				; copy the string to duplicate in rsi so ft_strcpy can use it later 
    push rsi					; save str to duplicate
	
	call	ft_strlen			; returns length of str1 in RAX
	
	mov	rdi, rax				; move size of string in RDI
    add rdi, 1					; malloc(sizeof + 1)
	call	malloc wrt ..plt	; "with respect to the PLT" 
	test	rax, rax			; if malloc fails and returns a NULL pointer, test will do "0 AND 0 = 0", and set ZF = 1
	jz		.malloc_fail		; if equal to zero jump to .malloc_fail
    
	mov rdi, rax				; move dest (just allocated) string pointer to rdi to be used by ft_strcpy		
    pop rsi						; pop rsi to be used as the second argument by ft_strcpy
	call ft_strcpy
    test rax, rax
    jz  .malloc_fail
	jmp .done
	
.malloc_fail:
    call	__errno_location wrt ..plt	; [call ___error] for MacOS. It returns an address pointer to errno
	mov	dword [rax], ENOMEM				; errno val for ENOMEM (12) copied at the pointer address. 

	xor rax, rax				; make RAX = 0 to be able to return NULL
	jmp .done

.done:
	ret

; PLT (Procedure Linkage Table) is part of the ELF binary format used on Linux
; It contains stubs that jump to dynamically linked functions in shared libraries (ex: malloc in libc.so)
; "wrt ..plt": NASM generates a relocation that tells the linker "resolve this call through the PLT entry for malloc"

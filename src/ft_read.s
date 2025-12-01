; ssize_t read(int fd, void *buf, size_t count);
; read() returns on success the number of bytes read or -1 on error with errno being set. 

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
; For read() this means: 
; RDI   -> file descriptor
; RSI   -> pointer to the buffer
; RDX   -> count 
; RAX   -> return value 
; ---------------------------------------------------------------------------------------

section .text
global  ft_read

ft_read:

	mov	rax, 0				; 0 is the syscall number for read and must be placed in RAX before the syscall 
	syscall
	cmp	rax, 0 				; check if rax < 0
	jge	.done				; SF = 0, ZF = 0

	neg	rax					; converts rax to a positive value (rax = 0 - rax)
	mov	edi, eax			; copy errno val from RAX (lower 32 bit from RAX) to EDI (lower 32 bit of RDI)
	call	__erno_location	; call ___error for MacOS. It returns an address pointer to errno
	mov	[rax], edi			; errno val from EDI copied at the pointer address
	mov	rax, -1
	jmp	.done

.done:
	ret
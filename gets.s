	.file	"gets.c"
	.text
	.globl	gets
	.type	gets, @function
gets:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbp
	movq	%rdi, %rbx
	jmp	.L2
.L4:
	movb	%al, (%rbx)
	leaq	1(%rbx), %rbx
.L2:
	movl	$0, %eax
	call	getchar
	cmpl	$10, %eax
	je	.L3
	cmpl	$-1, %eax
	jne	.L4
.L3:
	cmpl	$-1, %eax
	sete	%dl
	cmpq	%rbp, %rbx
	sete	%al
	testb	%al, %dl
	jne	.L6
	movb	$0, (%rbx)
	movq	%rbp, %rax
	jmp	.L5
.L6:
	movl	$0, %eax
.L5:
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE0:
	.size	gets, .-gets
	.globl	echo
	.type	echo, @function
echo:
.LFB1:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsp, %rdi
	call	gets
	movq	%rsp, %rdi
	call	puts
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE1:
	.size	echo, .-echo
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-16)"
	.section	.note.GNU-stack,"",@progbits

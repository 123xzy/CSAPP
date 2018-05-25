	.file	"badcnt.c"
	.text
	.globl	thread
	.type	thread, @function
thread:
.LFB125:
	.cfi_startproc
	movq	(%rdi), %rcx
	movl	$0, %eax
	jmp	.L2
.L3:
	movq	cnt(%rip), %rdx
	addq	$1, %rdx
	movq	%rdx, cnt(%rip)
	addq	$1, %rax
.L2:
	cmpq	%rcx, %rax
	jl	.L3
	movl	$0, %eax
	ret
	.cfi_endproc
.LFE125:
	.size	thread, .-thread
	.type	rio_read, @function
rio_read:
.LFB111:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdi, %rbx
	movq	%rsi, %r14
	movq	%rdx, %r13
	leaq	16(%rdi), %r12
	jmp	.L13
.L9:
	movl	$8192, %edx
	movq	%r12, %rsi
	movl	(%rbx), %edi
	call	read
	movl	%eax, 4(%rbx)
	testl	%eax, %eax
	jns	.L6
	call	__errno_location
	cmpl	$4, (%rax)
	je	.L13
	.p2align 4,,5
	jmp	.L11
.L6:
	testl	%eax, %eax
	.p2align 4,,6
	je	.L12
	movq	%r12, 8(%rbx)
.L13:
	movl	4(%rbx), %ebp
	testl	%ebp, %ebp
	jle	.L9
	movslq	%ebp, %rax
	cmpq	%r13, %rax
	jb	.L10
	movl	%r13d, %ebp
.L10:
	movslq	%ebp, %r12
	movq	8(%rbx), %rsi
	movq	%r12, %rdx
	movq	%r14, %rdi
	call	memcpy
	addq	%r12, 8(%rbx)
	subl	%ebp, 4(%rbx)
	movq	%r12, %rax
	jmp	.L7
.L11:
	movq	$-1, %rax
	jmp	.L7
.L12:
	movl	$0, %eax
.L7:
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE111:
	.size	rio_read, .-rio_read
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%s: %s\n"
	.text
	.globl	unix_error
	.type	unix_error, @function
unix_error:
.LFB48:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	call	__errno_location
	movl	(%rax), %edi
	call	strerror
	movq	%rax, %rcx
	movq	%rbx, %rdx
	movl	$.LC0, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, %edi
	call	exit
	.cfi_endproc
.LFE48:
	.size	unix_error, .-unix_error
	.globl	posix_error
	.type	posix_error, @function
posix_error:
.LFB49:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	call	strerror
	movq	%rax, %rcx
	movq	%rbx, %rdx
	movl	$.LC0, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, %edi
	call	exit
	.cfi_endproc
.LFE49:
	.size	posix_error, .-posix_error
	.section	.rodata.str1.1
.LC1:
	.string	"%s: DNS error %d\n"
	.text
	.globl	dns_error
	.type	dns_error, @function
dns_error:
.LFB50:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	call	__h_errno_location
	movl	(%rax), %ecx
	movq	%rbx, %rdx
	movl	$.LC1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, %edi
	call	exit
	.cfi_endproc
.LFE50:
	.size	dns_error, .-dns_error
	.section	.rodata.str1.1
.LC2:
	.string	"%s\n"
	.text
	.globl	app_error
	.type	app_error, @function
app_error:
.LFB51:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %rdx
	movl	$.LC2, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, %edi
	call	exit
	.cfi_endproc
.LFE51:
	.size	app_error, .-app_error
	.section	.rodata.str1.1
.LC3:
	.string	"Fork error"
	.text
	.globl	Fork
	.type	Fork, @function
Fork:
.LFB52:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	fork
	testl	%eax, %eax
	jns	.L24
	movl	$.LC3, %edi
	call	unix_error
.L24:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE52:
	.size	Fork, .-Fork
	.section	.rodata.str1.1
.LC4:
	.string	"Execve error"
	.text
	.globl	Execve
	.type	Execve, @function
Execve:
.LFB53:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	execve
	testl	%eax, %eax
	jns	.L26
	movl	$.LC4, %edi
	call	unix_error
.L26:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE53:
	.size	Execve, .-Execve
	.section	.rodata.str1.1
.LC5:
	.string	"Wait error"
	.text
	.globl	Wait
	.type	Wait, @function
Wait:
.LFB54:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	wait
	testl	%eax, %eax
	jns	.L30
	movl	$.LC5, %edi
	call	unix_error
.L30:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE54:
	.size	Wait, .-Wait
	.section	.rodata.str1.1
.LC6:
	.string	"Waitpid error"
	.text
	.globl	Waitpid
	.type	Waitpid, @function
Waitpid:
.LFB55:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	waitpid
	testl	%eax, %eax
	jns	.L33
	movl	$.LC6, %edi
	call	unix_error
.L33:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE55:
	.size	Waitpid, .-Waitpid
	.section	.rodata.str1.1
.LC7:
	.string	"Kill error"
	.text
	.globl	Kill
	.type	Kill, @function
Kill:
.LFB56:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	kill
	testl	%eax, %eax
	jns	.L35
	movl	$.LC7, %edi
	call	unix_error
.L35:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE56:
	.size	Kill, .-Kill
	.globl	Pause
	.type	Pause, @function
Pause:
.LFB57:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	pause
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE57:
	.size	Pause, .-Pause
	.globl	Sleep
	.type	Sleep, @function
Sleep:
.LFB58:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	sleep
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE58:
	.size	Sleep, .-Sleep
	.globl	Alarm
	.type	Alarm, @function
Alarm:
.LFB59:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	alarm
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE59:
	.size	Alarm, .-Alarm
	.section	.rodata.str1.1
.LC8:
	.string	"Setpgid error"
	.text
	.globl	Setpgid
	.type	Setpgid, @function
Setpgid:
.LFB60:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	setpgid
	testl	%eax, %eax
	jns	.L44
	movl	$.LC8, %edi
	call	unix_error
.L44:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE60:
	.size	Setpgid, .-Setpgid
	.globl	Getpgrp
	.type	Getpgrp, @function
Getpgrp:
.LFB61:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	getpgrp
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE61:
	.size	Getpgrp, .-Getpgrp
	.section	.rodata.str1.1
.LC9:
	.string	"Signal error"
	.text
	.globl	Signal
	.type	Signal, @function
Signal:
.LFB62:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$320, %rsp
	.cfi_def_cfa_offset 336
	movl	%edi, %ebx
	movq	%rsi, 160(%rsp)
	leaq	168(%rsp), %rdi
	call	sigemptyset
	movl	$268435456, 296(%rsp)
	movq	%rsp, %rdx
	leaq	160(%rsp), %rsi
	movl	%ebx, %edi
	call	sigaction
	testl	%eax, %eax
	jns	.L50
	movl	$.LC9, %edi
	call	unix_error
.L50:
	movq	(%rsp), %rax
	addq	$320, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE62:
	.size	Signal, .-Signal
	.section	.rodata.str1.1
.LC10:
	.string	"Sigprocmask error"
	.text
	.globl	Sigprocmask
	.type	Sigprocmask, @function
Sigprocmask:
.LFB63:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	sigprocmask
	testl	%eax, %eax
	jns	.L52
	movl	$.LC10, %edi
	call	unix_error
.L52:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE63:
	.size	Sigprocmask, .-Sigprocmask
	.section	.rodata.str1.1
.LC11:
	.string	"Sigemptyset error"
	.text
	.globl	Sigemptyset
	.type	Sigemptyset, @function
Sigemptyset:
.LFB64:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	sigemptyset
	testl	%eax, %eax
	jns	.L55
	movl	$.LC11, %edi
	call	unix_error
.L55:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE64:
	.size	Sigemptyset, .-Sigemptyset
	.section	.rodata.str1.1
.LC12:
	.string	"Sigfillset error"
	.text
	.globl	Sigfillset
	.type	Sigfillset, @function
Sigfillset:
.LFB65:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	sigfillset
	testl	%eax, %eax
	jns	.L58
	movl	$.LC12, %edi
	call	unix_error
.L58:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE65:
	.size	Sigfillset, .-Sigfillset
	.section	.rodata.str1.1
.LC13:
	.string	"Sigaddset error"
	.text
	.globl	Sigaddset
	.type	Sigaddset, @function
Sigaddset:
.LFB66:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	sigaddset
	testl	%eax, %eax
	jns	.L61
	movl	$.LC13, %edi
	call	unix_error
.L61:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE66:
	.size	Sigaddset, .-Sigaddset
	.section	.rodata.str1.1
.LC14:
	.string	"Sigdelset error"
	.text
	.globl	Sigdelset
	.type	Sigdelset, @function
Sigdelset:
.LFB67:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	sigdelset
	testl	%eax, %eax
	jns	.L64
	movl	$.LC14, %edi
	call	unix_error
.L64:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE67:
	.size	Sigdelset, .-Sigdelset
	.section	.rodata.str1.1
.LC15:
	.string	"Sigismember error"
	.text
	.globl	Sigismember
	.type	Sigismember, @function
Sigismember:
.LFB68:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	sigismember
	testl	%eax, %eax
	jns	.L68
	movl	$.LC15, %edi
	call	unix_error
.L68:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE68:
	.size	Sigismember, .-Sigismember
	.section	.rodata.str1.1
.LC16:
	.string	"Open error"
	.text
	.globl	Open
	.type	Open, @function
Open:
.LFB69:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$0, %eax
	call	open
	testl	%eax, %eax
	jns	.L71
	movl	$.LC16, %edi
	call	unix_error
.L71:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE69:
	.size	Open, .-Open
	.section	.rodata.str1.1
.LC17:
	.string	"Read error"
	.text
	.globl	Read
	.type	Read, @function
Read:
.LFB70:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	read
	testq	%rax, %rax
	jns	.L74
	movl	$.LC17, %edi
	call	unix_error
.L74:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE70:
	.size	Read, .-Read
	.section	.rodata.str1.1
.LC18:
	.string	"Write error"
	.text
	.globl	Write
	.type	Write, @function
Write:
.LFB71:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	write
	testq	%rax, %rax
	jns	.L77
	movl	$.LC18, %edi
	call	unix_error
.L77:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE71:
	.size	Write, .-Write
	.section	.rodata.str1.1
.LC19:
	.string	"Lseek error"
	.text
	.globl	Lseek
	.type	Lseek, @function
Lseek:
.LFB72:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	lseek
	testq	%rax, %rax
	jns	.L80
	movl	$.LC19, %edi
	call	unix_error
.L80:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE72:
	.size	Lseek, .-Lseek
	.section	.rodata.str1.1
.LC20:
	.string	"Close error"
	.text
	.globl	Close
	.type	Close, @function
Close:
.LFB73:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	close
	testl	%eax, %eax
	jns	.L82
	movl	$.LC20, %edi
	call	unix_error
.L82:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE73:
	.size	Close, .-Close
	.section	.rodata.str1.1
.LC21:
	.string	"Select error"
	.text
	.globl	Select
	.type	Select, @function
Select:
.LFB74:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	select
	testl	%eax, %eax
	jns	.L86
	movl	$.LC21, %edi
	call	unix_error
.L86:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE74:
	.size	Select, .-Select
	.section	.rodata.str1.1
.LC22:
	.string	"Dup2 error"
	.text
	.globl	Dup2
	.type	Dup2, @function
Dup2:
.LFB75:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	dup2
	testl	%eax, %eax
	jns	.L89
	movl	$.LC22, %edi
	call	unix_error
.L89:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE75:
	.size	Dup2, .-Dup2
	.section	.rodata.str1.1
.LC23:
	.string	"Stat error"
	.text
	.globl	Stat
	.type	Stat, @function
Stat:
.LFB76:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rsi, %rdx
	movq	%rdi, %rsi
	movl	$1, %edi
	call	__xstat
	testl	%eax, %eax
	jns	.L91
	movl	$.LC23, %edi
	call	unix_error
.L91:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE76:
	.size	Stat, .-Stat
	.section	.rodata.str1.1
.LC24:
	.string	"Fstat error"
	.text
	.globl	Fstat
	.type	Fstat, @function
Fstat:
.LFB77:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rsi, %rdx
	movl	%edi, %esi
	movl	$1, %edi
	call	__fxstat
	testl	%eax, %eax
	jns	.L94
	movl	$.LC24, %edi
	call	unix_error
.L94:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE77:
	.size	Fstat, .-Fstat
	.section	.rodata.str1.1
.LC25:
	.string	"mmap error"
	.text
	.globl	Mmap
	.type	Mmap, @function
Mmap:
.LFB78:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	mmap
	cmpq	$-1, %rax
	jne	.L98
	movl	$.LC25, %edi
	call	unix_error
.L98:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE78:
	.size	Mmap, .-Mmap
	.section	.rodata.str1.1
.LC26:
	.string	"munmap error"
	.text
	.globl	Munmap
	.type	Munmap, @function
Munmap:
.LFB79:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	munmap
	testl	%eax, %eax
	jns	.L100
	movl	$.LC26, %edi
	call	unix_error
.L100:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE79:
	.size	Munmap, .-Munmap
	.section	.rodata.str1.1
.LC27:
	.string	"Malloc error"
	.text
	.globl	Malloc
	.type	Malloc, @function
Malloc:
.LFB80:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	malloc
	testq	%rax, %rax
	jne	.L104
	movl	$.LC27, %edi
	call	unix_error
.L104:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE80:
	.size	Malloc, .-Malloc
	.section	.rodata.str1.1
.LC28:
	.string	"Realloc error"
	.text
	.globl	Realloc
	.type	Realloc, @function
Realloc:
.LFB81:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	realloc
	testq	%rax, %rax
	jne	.L107
	movl	$.LC28, %edi
	call	unix_error
.L107:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE81:
	.size	Realloc, .-Realloc
	.section	.rodata.str1.1
.LC29:
	.string	"Calloc error"
	.text
	.globl	Calloc
	.type	Calloc, @function
Calloc:
.LFB82:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	calloc
	testq	%rax, %rax
	jne	.L110
	movl	$.LC29, %edi
	call	unix_error
.L110:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE82:
	.size	Calloc, .-Calloc
	.globl	Free
	.type	Free, @function
Free:
.LFB83:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	free
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE83:
	.size	Free, .-Free
	.section	.rodata.str1.1
.LC30:
	.string	"Fclose error"
	.text
	.globl	Fclose
	.type	Fclose, @function
Fclose:
.LFB84:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	fclose
	testl	%eax, %eax
	je	.L114
	movl	$.LC30, %edi
	call	unix_error
.L114:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE84:
	.size	Fclose, .-Fclose
	.section	.rodata.str1.1
.LC31:
	.string	"Fdopen error"
	.text
	.globl	Fdopen
	.type	Fdopen, @function
Fdopen:
.LFB85:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	fdopen
	testq	%rax, %rax
	jne	.L118
	movl	$.LC31, %edi
	call	unix_error
.L118:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE85:
	.size	Fdopen, .-Fdopen
	.section	.rodata.str1.1
.LC32:
	.string	"Fgets error"
	.text
	.globl	Fgets
	.type	Fgets, @function
Fgets:
.LFB86:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdx, %rbp
	call	fgets
	movq	%rax, %rbx
	testq	%rax, %rax
	jne	.L121
	movq	%rbp, %rdi
	call	ferror
	testl	%eax, %eax
	je	.L121
	movl	$.LC32, %edi
	call	app_error
.L121:
	movq	%rbx, %rax
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE86:
	.size	Fgets, .-Fgets
	.section	.rodata.str1.1
.LC33:
	.string	"Fopen error"
	.text
	.globl	Fopen
	.type	Fopen, @function
Fopen:
.LFB87:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	fopen
	testq	%rax, %rax
	jne	.L124
	movl	$.LC33, %edi
	call	unix_error
.L124:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE87:
	.size	Fopen, .-Fopen
	.section	.rodata.str1.1
.LC34:
	.string	"Fputs error"
	.text
	.globl	Fputs
	.type	Fputs, @function
Fputs:
.LFB88:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	fputs
	cmpl	$-1, %eax
	jne	.L126
	movl	$.LC34, %edi
	call	unix_error
.L126:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE88:
	.size	Fputs, .-Fputs
	.section	.rodata.str1.1
.LC35:
	.string	"Fread error"
	.text
	.globl	Fread
	.type	Fread, @function
Fread:
.LFB89:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rdx, %rbx
	movq	%rcx, %r12
	call	fread
	movq	%rax, %rbp
	cmpq	%rbx, %rax
	jnb	.L130
	movq	%r12, %rdi
	call	ferror
	testl	%eax, %eax
	je	.L130
	movl	$.LC35, %edi
	call	unix_error
.L130:
	movq	%rbp, %rax
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE89:
	.size	Fread, .-Fread
	.section	.rodata.str1.1
.LC36:
	.string	"Fwrite error"
	.text
	.globl	Fwrite
	.type	Fwrite, @function
Fwrite:
.LFB90:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdx, %rbx
	call	fwrite
	cmpq	%rbx, %rax
	jnb	.L132
	movl	$.LC36, %edi
	call	unix_error
.L132:
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE90:
	.size	Fwrite, .-Fwrite
	.section	.rodata.str1.1
.LC37:
	.string	"Socket error"
	.text
	.globl	Socket
	.type	Socket, @function
Socket:
.LFB91:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	socket
	testl	%eax, %eax
	jns	.L136
	movl	$.LC37, %edi
	call	unix_error
.L136:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE91:
	.size	Socket, .-Socket
	.section	.rodata.str1.1
.LC38:
	.string	"Setsockopt error"
	.text
	.globl	Setsockopt
	.type	Setsockopt, @function
Setsockopt:
.LFB92:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	setsockopt
	testl	%eax, %eax
	jns	.L138
	movl	$.LC38, %edi
	call	unix_error
.L138:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE92:
	.size	Setsockopt, .-Setsockopt
	.section	.rodata.str1.1
.LC39:
	.string	"Bind error"
	.text
	.globl	Bind
	.type	Bind, @function
Bind:
.LFB93:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	bind
	testl	%eax, %eax
	jns	.L141
	movl	$.LC39, %edi
	call	unix_error
.L141:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE93:
	.size	Bind, .-Bind
	.section	.rodata.str1.1
.LC40:
	.string	"Listen error"
	.text
	.globl	Listen
	.type	Listen, @function
Listen:
.LFB94:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	listen
	testl	%eax, %eax
	jns	.L144
	movl	$.LC40, %edi
	call	unix_error
.L144:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE94:
	.size	Listen, .-Listen
	.section	.rodata.str1.1
.LC41:
	.string	"Accept error"
	.text
	.globl	Accept
	.type	Accept, @function
Accept:
.LFB95:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	accept
	testl	%eax, %eax
	jns	.L148
	movl	$.LC41, %edi
	call	unix_error
.L148:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE95:
	.size	Accept, .-Accept
	.section	.rodata.str1.1
.LC42:
	.string	"Connect error"
	.text
	.globl	Connect
	.type	Connect, @function
Connect:
.LFB96:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	connect
	testl	%eax, %eax
	jns	.L150
	movl	$.LC42, %edi
	call	unix_error
.L150:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE96:
	.size	Connect, .-Connect
	.section	.rodata.str1.1
.LC43:
	.string	"Gethostbyname error"
	.text
	.globl	Gethostbyname
	.type	Gethostbyname, @function
Gethostbyname:
.LFB97:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	gethostbyname
	testq	%rax, %rax
	jne	.L154
	movl	$.LC43, %edi
	call	dns_error
.L154:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE97:
	.size	Gethostbyname, .-Gethostbyname
	.section	.rodata.str1.1
.LC44:
	.string	"Gethostbyaddr error"
	.text
	.globl	Gethostbyaddr
	.type	Gethostbyaddr, @function
Gethostbyaddr:
.LFB98:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	gethostbyaddr
	testq	%rax, %rax
	jne	.L157
	movl	$.LC44, %edi
	call	dns_error
.L157:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE98:
	.size	Gethostbyaddr, .-Gethostbyaddr
	.section	.rodata.str1.1
.LC45:
	.string	"Pthread_create error"
	.text
	.globl	Pthread_create
	.type	Pthread_create, @function
Pthread_create:
.LFB99:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	pthread_create
	testl	%eax, %eax
	je	.L159
	movl	$.LC45, %esi
	movl	%eax, %edi
	call	posix_error
.L159:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE99:
	.size	Pthread_create, .-Pthread_create
	.section	.rodata.str1.1
.LC46:
	.string	"Pthread_cancel error"
	.text
	.globl	Pthread_cancel
	.type	Pthread_cancel, @function
Pthread_cancel:
.LFB100:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	pthread_cancel
	testl	%eax, %eax
	je	.L162
	movl	$.LC46, %esi
	movl	%eax, %edi
	call	posix_error
.L162:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE100:
	.size	Pthread_cancel, .-Pthread_cancel
	.section	.rodata.str1.1
.LC47:
	.string	"Pthread_join error"
	.text
	.globl	Pthread_join
	.type	Pthread_join, @function
Pthread_join:
.LFB101:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	pthread_join
	testl	%eax, %eax
	je	.L165
	movl	$.LC47, %esi
	movl	%eax, %edi
	call	posix_error
.L165:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE101:
	.size	Pthread_join, .-Pthread_join
	.section	.rodata.str1.1
.LC48:
	.string	"Pthread_detach error"
	.text
	.globl	Pthread_detach
	.type	Pthread_detach, @function
Pthread_detach:
.LFB102:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	pthread_detach
	testl	%eax, %eax
	je	.L168
	movl	$.LC48, %esi
	movl	%eax, %edi
	call	posix_error
.L168:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE102:
	.size	Pthread_detach, .-Pthread_detach
	.globl	Pthread_exit
	.type	Pthread_exit, @function
Pthread_exit:
.LFB103:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	pthread_exit
	.cfi_endproc
.LFE103:
	.size	Pthread_exit, .-Pthread_exit
	.globl	Pthread_self
	.type	Pthread_self, @function
Pthread_self:
.LFB104:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	pthread_self
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE104:
	.size	Pthread_self, .-Pthread_self
	.globl	Pthread_once
	.type	Pthread_once, @function
Pthread_once:
.LFB105:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	pthread_once
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE105:
	.size	Pthread_once, .-Pthread_once
	.section	.rodata.str1.1
.LC49:
	.string	"Sem_init error"
	.text
	.globl	Sem_init
	.type	Sem_init, @function
Sem_init:
.LFB106:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	sem_init
	testl	%eax, %eax
	jns	.L177
	movl	$.LC49, %edi
	call	unix_error
.L177:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE106:
	.size	Sem_init, .-Sem_init
	.section	.rodata.str1.1
.LC50:
	.string	"P error"
	.text
	.globl	P
	.type	P, @function
P:
.LFB107:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	sem_wait
	testl	%eax, %eax
	jns	.L180
	movl	$.LC50, %edi
	call	unix_error
.L180:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE107:
	.size	P, .-P
	.section	.rodata.str1.1
.LC51:
	.string	"V error"
	.text
	.globl	V
	.type	V, @function
V:
.LFB108:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	sem_post
	testl	%eax, %eax
	jns	.L183
	movl	$.LC51, %edi
	call	unix_error
.L183:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE108:
	.size	V, .-V
	.globl	rio_readn
	.type	rio_readn, @function
rio_readn:
.LFB109:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movl	%edi, %r12d
	movq	%rsi, %rbp
	movq	%rdx, %r13
	movq	%rdx, %rbx
	jmp	.L187
.L192:
	movq	%rbx, %rdx
	movq	%rbp, %rsi
	movl	%r12d, %edi
	call	read
	testq	%rax, %rax
	jns	.L188
	call	__errno_location
	cmpl	$4, (%rax)
	.p2align 4,,2
	je	.L193
	movq	$-1, %rax
	jmp	.L190
.L188:
	testq	%rax, %rax
	jne	.L189
	jmp	.L191
.L193:
	movl	$0, %eax
.L189:
	subq	%rax, %rbx
	addq	%rax, %rbp
.L187:
	testq	%rbx, %rbx
	jne	.L192
.L191:
	movq	%r13, %rax
	subq	%rbx, %rax
.L190:
	addq	$8, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE109:
	.size	rio_readn, .-rio_readn
	.globl	rio_writen
	.type	rio_writen, @function
rio_writen:
.LFB110:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movl	%edi, %r12d
	movq	%rsi, %rbp
	movq	%rdx, %r13
	movq	%rdx, %rbx
	jmp	.L196
.L199:
	movq	%rbx, %rdx
	movq	%rbp, %rsi
	movl	%r12d, %edi
	call	write
	testq	%rax, %rax
	jg	.L197
	call	__errno_location
	cmpl	$4, (%rax)
	.p2align 4,,2
	jne	.L200
	movl	$0, %eax
.L197:
	subq	%rax, %rbx
	addq	%rax, %rbp
.L196:
	testq	%rbx, %rbx
	jne	.L199
	movq	%r13, %rax
	jmp	.L198
.L200:
	movq	$-1, %rax
.L198:
	addq	$8, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE110:
	.size	rio_writen, .-rio_writen
	.globl	rio_readinitb
	.type	rio_readinitb, @function
rio_readinitb:
.LFB112:
	.cfi_startproc
	movl	%esi, (%rdi)
	movl	$0, 4(%rdi)
	leaq	16(%rdi), %rax
	movq	%rax, 8(%rdi)
	ret
	.cfi_endproc
.LFE112:
	.size	rio_readinitb, .-rio_readinitb
	.globl	rio_readnb
	.type	rio_readnb, @function
rio_readnb:
.LFB113:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %r12
	movq	%rsi, %rbp
	movq	%rdx, %r13
	movq	%rdx, %rbx
	jmp	.L204
.L207:
	movq	%rbx, %rdx
	movq	%rbp, %rsi
	movq	%r12, %rdi
	call	rio_read
	testq	%rax, %rax
	js	.L208
	testq	%rax, %rax
	je	.L206
	subq	%rax, %rbx
	addq	%rax, %rbp
.L204:
	testq	%rbx, %rbx
	jne	.L207
.L206:
	movq	%r13, %rax
	subq	%rbx, %rax
	jmp	.L205
.L208:
	movq	$-1, %rax
.L205:
	addq	$8, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE113:
	.size	rio_readnb, .-rio_readnb
	.globl	rio_readlineb
	.type	rio_readlineb, @function
rio_readlineb:
.LFB114:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$24, %rsp
	.cfi_def_cfa_offset 64
	movq	%rdi, %r13
	movq	%rsi, %rbp
	movq	%rdx, %r12
	movl	$1, %ebx
	jmp	.L211
.L216:
	movl	$1, %edx
	leaq	15(%rsp), %rsi
	movq	%r13, %rdi
	call	rio_read
	cmpl	$1, %eax
	jne	.L212
	leaq	1(%rbp), %rdx
	movzbl	15(%rsp), %eax
	movb	%al, 0(%rbp)
	cmpb	$10, %al
	jne	.L213
	addl	$1, %ebx
	movq	%rdx, %rbp
	jmp	.L214
.L212:
	testl	%eax, %eax
	jne	.L217
	cmpl	$1, %ebx
	jne	.L214
	.p2align 4,,6
	jmp	.L218
.L213:
	addl	$1, %ebx
	movq	%rdx, %rbp
.L211:
	movslq	%ebx, %rax
	cmpq	%r12, %rax
	jb	.L216
.L214:
	movb	$0, 0(%rbp)
	subl	$1, %ebx
	movslq	%ebx, %rax
	jmp	.L215
.L217:
	movq	$-1, %rax
	jmp	.L215
.L218:
	movl	$0, %eax
.L215:
	addq	$24, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE114:
	.size	rio_readlineb, .-rio_readlineb
	.section	.rodata.str1.1
.LC52:
	.string	"Rio_readn error"
	.text
	.globl	Rio_readn
	.type	Rio_readn, @function
Rio_readn:
.LFB115:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	rio_readn
	testq	%rax, %rax
	jns	.L221
	movl	$.LC52, %edi
	call	unix_error
.L221:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE115:
	.size	Rio_readn, .-Rio_readn
	.section	.rodata.str1.1
.LC53:
	.string	"Rio_writen error"
	.text
	.globl	Rio_writen
	.type	Rio_writen, @function
Rio_writen:
.LFB116:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdx, %rbx
	call	rio_writen
	cmpq	%rbx, %rax
	je	.L223
	movl	$.LC53, %edi
	call	unix_error
.L223:
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE116:
	.size	Rio_writen, .-Rio_writen
	.globl	Rio_readinitb
	.type	Rio_readinitb, @function
Rio_readinitb:
.LFB117:
	.cfi_startproc
	call	rio_readinitb
	rep ret
	.cfi_endproc
.LFE117:
	.size	Rio_readinitb, .-Rio_readinitb
	.section	.rodata.str1.1
.LC54:
	.string	"Rio_readnb error"
	.text
	.globl	Rio_readnb
	.type	Rio_readnb, @function
Rio_readnb:
.LFB118:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	rio_readnb
	testq	%rax, %rax
	jns	.L228
	movl	$.LC54, %edi
	call	unix_error
.L228:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE118:
	.size	Rio_readnb, .-Rio_readnb
	.section	.rodata.str1.1
.LC55:
	.string	"Rio_readlineb error"
	.text
	.globl	Rio_readlineb
	.type	Rio_readlineb, @function
Rio_readlineb:
.LFB119:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	rio_readlineb
	testq	%rax, %rax
	jns	.L231
	movl	$.LC55, %edi
	call	unix_error
.L231:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE119:
	.size	Rio_readlineb, .-Rio_readlineb
	.globl	open_clientfd
	.type	open_clientfd, @function
open_clientfd:
.LFB120:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbp
	movl	%esi, %r12d
	movl	$0, %edx
	movl	$1, %esi
	movl	$2, %edi
	call	socket
	movl	%eax, %ebx
	testl	%eax, %eax
	js	.L235
	movq	%rbp, %rdi
	call	gethostbyname
	testq	%rax, %rax
	je	.L236
	movq	$0, (%rsp)
	movq	$0, 8(%rsp)
	movw	$2, (%rsp)
	movq	24(%rax), %rcx
	movslq	20(%rax), %rdx
	leaq	4(%rsp), %rsi
	movq	(%rcx), %rdi
	call	bcopy
	movl	%r12d, %esi
#APP
# 747 "/usr/include/csapp.c" 1
	rorw $8, %si
# 0 "" 2
#NO_APP
	movw	%si, 2(%rsp)
	movl	$16, %edx
	movq	%rsp, %rsi
	movl	%ebx, %edi
	call	connect
	testl	%eax, %eax
	jns	.L237
	movl	$-1, %eax
	jmp	.L234
.L235:
	movl	$-1, %eax
	jmp	.L234
.L236:
	movl	$-2, %eax
	jmp	.L234
.L237:
	movl	%ebx, %eax
.L234:
	addq	$16, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE120:
	.size	open_clientfd, .-open_clientfd
	.globl	open_listenfd
	.type	open_listenfd, @function
open_listenfd:
.LFB121:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$40, %rsp
	.cfi_def_cfa_offset 64
	movl	%edi, %ebp
	movl	$1, 28(%rsp)
	movl	$0, %edx
	movl	$1, %esi
	movl	$2, %edi
	call	socket
	movl	%eax, %ebx
	testl	%eax, %eax
	js	.L241
	movl	$4, %r8d
	leaq	28(%rsp), %rcx
	movl	$2, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	setsockopt
	testl	%eax, %eax
	js	.L242
	movq	$0, 8(%rsp)
	movw	$2, (%rsp)
	movl	$0, 4(%rsp)
	movl	%ebp, %edi
#APP
# 780 "/usr/include/csapp.c" 1
	rorw $8, %di
# 0 "" 2
#NO_APP
	movw	%di, 2(%rsp)
	movl	$16, %edx
	movq	%rsp, %rsi
	movl	%ebx, %edi
	call	bind
	testl	%eax, %eax
	js	.L243
	movl	$1024, %esi
	movl	%ebx, %edi
	call	listen
	testl	%eax, %eax
	jns	.L244
	movl	$-1, %eax
	jmp	.L240
.L241:
	movl	$-1, %eax
	jmp	.L240
.L242:
	movl	$-1, %eax
	jmp	.L240
.L243:
	movl	$-1, %eax
	jmp	.L240
.L244:
	movl	%ebx, %eax
.L240:
	addq	$40, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE121:
	.size	open_listenfd, .-open_listenfd
	.section	.rodata.str1.1
.LC56:
	.string	"Open_clientfd Unix error"
.LC57:
	.string	"Open_clientfd DNS error"
	.text
	.globl	Open_clientfd
	.type	Open_clientfd, @function
Open_clientfd:
.LFB122:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	open_clientfd
	testl	%eax, %eax
	jns	.L247
	cmpl	$-1, %eax
	jne	.L248
	movl	$.LC56, %edi
	call	unix_error
.L248:
	movl	$.LC57, %edi
	call	dns_error
.L247:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE122:
	.size	Open_clientfd, .-Open_clientfd
	.section	.rodata.str1.1
.LC58:
	.string	"Open_listenfd error"
	.text
	.globl	Open_listenfd
	.type	Open_listenfd, @function
Open_listenfd:
.LFB123:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	open_listenfd
	testl	%eax, %eax
	jns	.L251
	movl	$.LC58, %edi
	call	unix_error
.L251:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE123:
	.size	Open_listenfd, .-Open_listenfd
	.section	.rodata.str1.1
.LC59:
	.string	"usage:%s<niters>\n"
.LC60:
	.string	"BOOM!cnt=%ld\n"
.LC61:
	.string	"OK!cnt=%ld\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB124:
	.cfi_startproc
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	cmpl	$2, %edi
	je	.L254
	movq	(%rsi), %rsi
	movl	$.LC59, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %edi
	call	exit
.L254:
	movq	8(%rsi), %rdi
	movl	$10, %edx
	movl	$0, %esi
	call	strtol
	cltq
	movq	%rax, 24(%rsp)
	leaq	24(%rsp), %rcx
	movl	$thread, %edx
	movl	$0, %esi
	leaq	16(%rsp), %rdi
	call	Pthread_create
	leaq	24(%rsp), %rcx
	movl	$thread, %edx
	movl	$0, %esi
	leaq	8(%rsp), %rdi
	call	Pthread_create
	movl	$0, %esi
	movq	16(%rsp), %rdi
	call	Pthread_join
	movl	$0, %esi
	movq	8(%rsp), %rdi
	call	Pthread_join
	movq	24(%rsp), %rax
	addq	%rax, %rax
	movq	cnt(%rip), %rdx
	cmpq	%rdx, %rax
	je	.L255
	movq	cnt(%rip), %rsi
	movl	$.LC60, %edi
	movl	$0, %eax
	call	printf
	jmp	.L256
.L255:
	movq	cnt(%rip), %rsi
	movl	$.LC61, %edi
	movl	$0, %eax
	call	printf
.L256:
	movl	$0, %edi
	call	exit
	.cfi_endproc
.LFE124:
	.size	main, .-main
	.globl	cnt
	.bss
	.align 8
	.type	cnt, @object
	.size	cnt, 8
cnt:
	.zero	8
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-16)"
	.section	.note.GNU-stack,"",@progbits

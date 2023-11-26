.global	print_A_func


# function:
#	Print array A
# arguments:
#	stack (+00) - text (input)
#	stack (+04) - array items number (input)
#	stack (+08) - array address (input)
.text
print_A_func:
	lw	a0, +0(sp)		# load string address
	li	a7, 4			# prints a null-terminated string to the console
	ecall
	lw	t0, +4(sp)		# load array items number
	li	t2, 0			# initialize array item counter
	lw	t1, +8(sp)		# load array address

print_A_loop:
	la	a0, lit_tab		# load string address
	li	a7, 4			# prints a null-terminated string to the console
	ecall
	lw	a0, (t1)			# load current item value
	li	a7, 1			# prints an integer
	ecall
	addi	t1, t1, 4		# calculate next array item address
	addi	t2, t2, 1		# increment array item counter
	blt	t2, t0, print_A_loop	# branch if array item counter less than array items number
	la	a0, lit_nl		# load string address
	li	a7, 4			# prints a null-terminated string to the console
	ecall

print_A_end:
	ret				# return

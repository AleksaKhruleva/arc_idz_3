.include "lib_macros.asm"


# test do macro:
# arguments:
#	IF - input file name (literal)
#	OF - output file name (literal)
.macro	test2_do	(%IF, %OF)
	la	t0, %IF			# load input file name address
	sw	t0, if_name, t1		# store input file name address
	la	t0, %OF			# load output file name address
	sw	t0, of_name, t1		# store output file name address
	jal	_test2_do		# do test
.end_macro


# test2 program
_test2:
	# allocate words addresses array
	lw	a1, word_snum		# load default words number
	li	a2, 4			# load pointer item size [sizeof(int)]
	alloc_A	(a1, a2)			# allocate words array
	sw	a0, word_tptr, t0		# store allocated address

	# allocate word counters array
	lw	a1, word_snum		# load default words number
	li	a2, 4			# load pointer item size [sizeof(int)]
	alloc_A	(a1, a2)			# allocate counters array
	sw	a0, word_cptr, t0		# store allocated address

	# initialize words addresses array
	lw	t0, word_tptr		# load words array address
	la	t1, word01		# load word address
	sw	t1, (t0)			# store word addres to array
	addi	t0, t0, 4		# goto next array item
	la	t1, word02		# load word address
	sw	t1, (t0)			# store word addres to array
	addi	t0, t0, 4		# goto next array item
	la	t1, word03		# load word address
	sw	t1, (t0)			# store word addres to array
	addi	t0, t0, 4		# goto next array item
	la	t1, word04		# load word address
	sw	t1, (t0)			# store word addres to array
	addi	t0, t0, 4		# goto next array item
	la	t1, word05		# load word address
	sw	t1, (t0)			# store word addres to array

	# ask user "Output result to console?"
	sw	zero, cout_cons, t0	# save user choice

	# test 1
	test2_do(i1_name, o1_name)
	# test 2
	test2_do(i2_name, o2_name)
	# test 3
	test2_do(i3_name, o3_name)

	# exit
	done
.data
			.align	2
	i1_name:		.asciz	"test1.cpp"	# test input file name
	o1_name:		.asciz	"test1.txt"	# test output file name
	i2_name:		.asciz	"test2.cpp"	# test input file name
	o2_name:		.asciz	"test2.txt"	# test output file name
	i3_name:		.asciz	"test3.cpp"	# test input file name
	o3_name:		.asciz	"test3.txt"	# test output file name

# test do
.text
_test2_do:
# save area:
.eqv	sa_ra	+0(sp)	# stack (+00) - register ra (return address)
.eqv	sa_size	4
	# save registers
	addi	sp, sp, -sa_size		# obtain stack for save area
	sw	ra, sa_ra		# save ra register
	addi	s0, sp, sa_size		# set on-call stack position (arguments area)
	# print Input file name
	coutT	(lit_ifn)		# print welcome text
	lw	a0, if_name		# load input file name address
	coutT0				# print text
	coutT	(lit_nl)			# print new-line

	# print Output file name
	coutT	(lit_ofn)		# print welcome text
	lw	a0, of_name		# load input file name address
	coutT0				# print text
	coutT	(lit_nl)			# print new-line

	# initialize word counters array
	lw	t0, word_cptr		# load word counters array address
	lw	t1, word_snum		# load words number value

_iwca0:	beq	t1, zero, _iwca9		# branch if end of array
	sw	zero, (t0)		# initialize current counter
	addi	t0, t0, 4		# goto next counter number
	addi	t1, t1, -1		# decrement counter
	j	_iwca0			# next itteration
_iwca9:	# end of "_iwca"

	# do idz 3
	lw	a1, if_name		# input file name
	lw	a2, of_name		# output file name
	lw	a3, word_snum		# words number value
	lw	a4, word_tptr		# words addresses array address
	lw	a5, word_cptr		# words counters array address
	idz3	(a1, a2, a3, a4, a5)	# do idz3
	beq	a0, zero, _prf2c		# branch if result code - OK

	coutT	(lit_ifore)		# display error message
	j	_end			# end

	# print result file to console
_prf2c:	coutT	(lit_res)		# print welcome text
	lw	t0, cout_cons		# load "output result to console" flag
	bne	t0, zero, _end		# branch if flag is not YES
	lw	a1, of_name		# load output file name address
	cat	(a1)			# print file context

	# return
_end:	lw	ra, sa_ra		# load ra register
	addi	sp, sp, sa_size		# free stack for save area
	ret				# return

.data
	word_snum:	.word	5		# default words number
	word_tptr:	.word	-1		# words array address
	word_cptr:	.word	-1		# word counters array address
	cout_cons:	.word	-1		# print result to console
	if_name:		.word	-1		# input file name address
	of_name:		.word	-1		# output file name address
			.align	2
	word01:		.asciz	"pragma"
	word02:		.asciz	"include"
	word03:		.asciz	"define"
	word04:		.asciz	"char"
	word05:		.asciz	"int"

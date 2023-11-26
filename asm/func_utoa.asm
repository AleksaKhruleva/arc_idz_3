.global	utoa_func


# function:
#	Unsigned integer to string
# locals area:
.eqv	la_rs	+0(sp)	# stack (+00) - temporary string
.eqv	la_size	12
# save area:
.eqv	sa_ra	+0(sp)	# stack (+00) - register ra (return address)
.eqv	sa_s0	+4(sp)	# stack (+04) - register s0
.eqv	sa_size	8
# arguments area:
.eqv	arg1	+0(s0)	# stack (+00) - (i) - integer value
.eqv	arg2	+4(s0)	# stack (+04) - (i) - result string address
# register usage:
#	s0 - on-call stack position (arguments area)
.text
utoa_func:
	# save registers
	addi	sp, sp, -sa_size		# obtain stack for save area
	sw	ra, sa_ra		# save ra register
	sw	s0, sa_s0		# save s0 register
	addi	s0, sp, sa_size		# set on-call stack position (arguments area)
	# initialize locals area
	addi	sp, sp, -la_size		# obtain stack for locals area
	# initialize work registers
	li	t0, 10			# base for convertion
	li	t1, la_size		# temporary string size (counter)
	lw	t2, arg1			# load integer value for convertion
	mv	t3, sp			# load temporary string address

	# convertion loop
_do_c:	beq	t1, zero, _end_c		# branch if counter equal to zero
	rem	t4, t2, t0		# get next digit
	div	t2, t2, t0		# divide for next loop
	addi	t4, t4, '0'		# make it character
	sb	t4, (t3)			# store current character
	addi	t3, t3, 1		# goto next character in temporary string
	addi	t1, t1, -1		# decrement counter
	j	_do_c			# jump to next iteration

_end_c:
	# reverse result string
	mv	t1, sp			# load first temporary character address
	addi	t2, t1, la_size		# calculate after last temporary character address
	addi	t2, t2, -1		# calculate last temporary character address

_do_r:	bge	t1, t2, _end_r		# branch if left addres less than right
	lbu	t3, (t1)			# load left temporary character value
	lbu	t4, (t2)			# load right temporary character value
	add	t3, t3, t4		# .
	sub	t4, t3, t4		# .
	sub	t3, t3, t4		# swap t3 & t4 values
	sb	t3, (t1)			# store new left temporary character value
	sb	t4, (t2)			# store new right temporary character value
	addi	t1, t1, 1		# goto next left temporary character
	addi	t2, t2, -1		# goto previous right temporary character
	j	_do_r			# jump to next iteration

_end_r:
	# skip leading non-'0' character in result string
	li	t0, '0'			# load test character value
	mv	t1, sp			# load first temporary character address		
	li	t2, la_size		# characters counter
	addi	t2, t2, -1		# decrement counter for one digit mininum

_do_s:	beq	t2, zero, _end_s		# branch if counter equal to zero
	lbu	t3, (t1)			# load curent temporary character value
	bne	t0, t3, _end_s		# branch if current temporary character is non-'0'
	addi	t1, t1, 1		# goto next temporary character
	addi	t2, t2, -1		# decrement counter
	j	_do_s			# jump to next iteration
_end_s:
	addi	t2, t2, 1		# restore counter for last temporary character
	# copy other termporary string to result string
	lw	t0, arg2			# load result string address

_do_m:	beq	t2, zero, _end_m		# branch if counter equal to zero
	lbu	t3, (t1)			# load curent temporary character value
	sb	t3, (t0)			# store current temporary character value to result string
	addi	t1, t1, 1		# goto next temporary character
	addi	t0, t0, 1		# goto next result string character
	addi	t2, t2, -1		# decrement counter
	j	_do_m			# jump to next iteration

_end_m:
	# set '\0' character to end of result string
	sb	zero, (t0)		# store '\0' character value to result string

_end:	# return
	addi	sp, sp, la_size		# restore stack position to save area
	lw	ra, sa_ra		# restore ra register
	lw	s0, sa_s0		# restore s0 register
	addi	sp, sp, sa_size		# restore on-call stack position
	ret				# return

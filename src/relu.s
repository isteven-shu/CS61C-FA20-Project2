.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    # check if a1 >= 1
    bge x0, a1, exception

loop_start:
    addi t0, x0, 0

loop_continue:
    beq t0, a1, loop_end # if t0 == a1 then loop_end
    slli t1, t0, 2 # t1 = t0 * 4
    add t2, t1, a0 # t2 = t1 + a0
    lw t3, 0(t2)
    bge t3, x0, else # if a[t0] < 0 then reset it to 0
    sw x0, 0(t2)
else:
    addi t0, t0, 1
    jal x0 loop_continue
    
loop_end:
    # Epilogue
	ret

exception:
    li a1, 78
    j exit2

#Chuong trinh slection sort so nguyen
#-----------------------------------
#Data segment
.data
#Cac dinh nghia bien
    file_path:		.asciiz		"INT10.BIN"	# Path of input file
    descriptor:  	.word   	0
    array:     	  	.space  	40				# Size of array: 10 elements * 4 bytes = 40 bytes
    n: 	         	.word  		10				# Number of elements in array
    dulieu:		.space		40
    buffer:      	.space  	1024				
    char:        	.space  	1
    tab:       		.asciiz 	"\t"
    endl:        	.asciiz 	"\n"
    space:		.asciiz		" "
#Cac thong bao can in ra man hinh
str_loi: .asciiz "Mo file bi loi."
str_start: .asciiz "Mang ban dau la: "
#-----------------------------------
#Code segment
.text
.globl MAIN
#-----------------------------------
#Chuong trinh chinh
#-----------------------------------
MAIN:
    # Open file for reading
    la $a0, file_path
    li $a1, 0               # Read-only mode
    li $v0, 13              # Syscall to open file
    syscall
    bgez $v0, file_opened   # If file opened successfully, jump to file_opened
baoloi: 
    la $a0, str_loi         # Load error message
    li $v0, 4               # Syscall to print string
    syscall
    j END_MAIN                 # Jump to Kthuc to end the program

file_opened:
    sw $v0, descriptor          # Save file descriptor

    # Read from file
    lw $a0, descriptor          # Load file descriptor
    la $a1, dulieu          # Load address of data buffer
    li $a2, 40              # Number of bytes to read
    li $v0, 14              # Syscall to read file
    syscall

    # Close file
    lw $a0, descriptor          # Load file descriptor
    li $v0, 16              # Syscall to close file
    syscall

    # Copy data to array
    la $t0, dulieu          # Load address of the data buffer
    la $t4, array           # Load address of the array
    li $t1, 0               # Initialize counter for loop
    li $t3, 10              # Set the loop limit to 10

copy_to_array:
    bge $t1, $t3, print_initial_array   # Exit loop if counter >= 10

    lw $t2, 0($t0)          # Load word from buffer
    sw $t2, 0($t4)          # Store word to array

    addi $t0, $t0, 4        # Move to next word in buffer
    addi $t4, $t4, 4        # Move to next word in array
    addi $t1, $t1, 1        # Increment counter
    j copy_to_array         # Repeat loop

print_initial_array:
    la $t0, array            # Load address of the array
    li $t1, 0                # Initialize counter for loop
    li $t3, 10               # Set the loop limit to 10

    la $a0, str_start        # Load address of start string
    li $v0, 4                # Print string syscall
    syscall

print_initial_number:
    bge $t1, $t3, print_size # Exit loop if counter >= 10

    lw $t2, 0($t0)           # Load word from array
    li $v0, 1                # Print integer syscall
    move $a0, $t2            # Load integer to print
    syscall

    la $a0, space            # Load address of space string
    li $v0, 4                # Print string syscall
    syscall

    addi $t0, $t0, 4        # Move to next word in array
    addi $t1, $t1, 1        # Increment counter
    j print_initial_number  # Repeat loop

print_size: 
    la $a0, endl         # Load newline character
    li $v0, 4               # Print string syscall
    syscall

        # Xu ly
    	    la 		$a0, array			# a0: address of array
    	    lw 		$t3, n				# t3: size of array
    	    addi 	$t1, $t3, -1			# t1: size of array - 1
    	    addi 	$t0, $zero, 0			# t0: i = 0
    	    # while (i < n - 1)
    	    FOR_1:
    	    	beq 	$t0, $t1, END_FOR_1
    	    
    	    	add 	$t4, $zero, $t0			# t4: min idx = i
    	    	addi 	$t2, $t0, 1			# t2: j = i + 1
    	    	# while (j < n)
    	    	FOR_2:
    	    	    beq 	$t2, $t3 END_FOR_2
    	    	
    	    	    mul 	$t5, $t2, 4
    	    	    add 	$t5, $a0, $t5	
    	    	    lw 		$t5, 0($t5)		# t5: array[j]
    	    	    mul 	$t6, $t4, 4
    	    	    add 	$t6, $a0, $t6	
    	    	    lw 		$t6, 0($t6)		# t6: array[min_idx]
    	    	
    	    	    slt 	$t7, $t5, $t6		# t7 = 1 if array[j] < array[min idx]
    	    	    beq 	$t7, 0, NO_UPDATE_MIN_IDX
    	    	    add 	$t4, $zero, $t2		# min idx = j
    	    	    NO_UPDATE_MIN_IDX:
    	    	    addi 	$t2, $t2, 1
    	    	    j 		FOR_2
    	    	END_FOR_2:
		# if i != min then idx sway(arr[i], arr[min_idx]) and print array
		beq $t0, $t4, NO_SWAP_AND_PRINT		# if arr[i] == arr[min_idx] then no sway and print
    	    	# swap
		    # Store registers
    	    	    	addi 	$sp, $sp, -4
    	    		sw 	$a1, 0($sp)
    	    		addi 	$sp, $sp, -4
    	    		sw 	$a2, 0($sp)
    	    		# a1 = min idx = t4
    	    		add 	$a1, $zero, $t4
    	    		# a2 = i = t0
    	    		add 	$a2, $zero, $t0
		    # call swap
    	    		jal 	SWAP
    	    	    # Restore registers
    	    		lw 	$a2, 0($sp)
    	    		addi 	$sp, $sp, 4
    	    		lw 	$a1, 0($sp)
    	    		addi 	$sp, $sp, 4
    	    	# print
    	    	    jal 	PRINT_ARRAY
    	    	NO_SWAP_AND_PRINT:
    	    	addi	$t0, $t0, 1
    	    	j FOR_1
    	    END_FOR_1:
        # Xuat ket qua (syscall)
            # Dong file
            	addi 	$v0, $zero, 16         		# close_file syscall code
    		lw	$a0, descriptor 		# file descriptor to close
    		syscall
#Ket thuc chuong trinh (syscall)
    END_MAIN: 
        addi $v0, $zero, 10
        syscall 
#----------------------------------- 
#Cac chuong trinh con khac 
#-----------------------------------
    SWAP:
	# Use: a0, t0, t1, t2, t3, t4
	# Function: swap array[a1] and array[a2]
	# Argumet: array, a0, a1
	# Return: void
	
	# Store registers
	    addi 	$sp, $sp, -4
	    sw 		$a0, 0($sp)
	    addi	$sp, $sp, -4
	    sw 		$t0, 0($sp)
	    addi 	$sp, $sp, -4
	    sw 		$t1, 0($sp)
	    addi 	$sp, $sp, -4
	    sw 		$t2, 0($sp)
	    addi 	$sp, $sp, -4
	    sw 		$t3, 0($sp)
	    addi 	$sp, $sp, -4
	    sw 		$t4, 0($sp)
	# Load data
	    la 		$a0, array			# a0: address of array
	    mul 	$t1, $a1, 4
	    add 	$t1, $a0, $t1			# t1: address of array[a1]
	    mul 	$t2, $a2, 4
	    add 	$t2, $a0, $t2			# t2: address of array[a2]
	    
	    lw 		$t3, 0($t1)			# t3: array[a1]
	    lw 		$t4, 0($t2)			# t4: array[a2]
	# Swap
	    add 	$t0, $zero, $t3
	    add 	$t3, $zero, $t4
	    add 	$t4, $zero, $t0
	# Write back
	    sw 		$t3, 0($t1)
	    sw 		$t4, 0($t2)
	# Restore registers
	    lw 		$t4, 0($sp)
	    addi 	$sp, $sp, 4
	    lw 		$t3, 0($sp)
	    addi 	$sp, $sp, 4
	    lw 		$t3, 0($sp)
	    addi 	$sp, $sp, 4
	    lw 		$t1, 0($sp)
	    addi 	$sp, $sp, 4
	    lw 		$t0, 0($sp)
	    addi 	$sp, $sp, 4
	    lw 		$a0, 0($sp)
	    addi 	$sp, $sp, 4
    END_SWAP:
        jr $ra 
#-----------------------------------
#-----------------------------------  
    PRINT_ARRAY:
    	# Use: a0, a1, v0, t0, t1
    	# Function: print array
    	# Argumet: array, n
    	# Return: void
    	
    	# Store registers
    	    addi 	$sp, $sp, -4
    	    sw 		$a0, 0($sp)
    	    addi 	$sp, $sp, -4
    	    sw 		$a1, 0($sp)
    	    addi 	$sp, $sp, -4
    	    sw 		$v0, 0($sp)
    	    addi 	$sp, $sp, -4
    	    sw 		$t0, 0($sp)
    	    addi 	$sp, $sp, -4
    	    sw 		$t1, 0($sp)
    	# Handle
    	    la 		$a1, array		# a1: address of array
    	    lw 		$t1, n			# t1: size of array
    	    addi 	$t0, $zero, 0		# t0: i = 0
    	    # while (i < n)
    	    PRINT_ARRAY_LOOP:
    	    	beq 	$t0, $t1, PRINT_ARRAY_END_LOOP
    	    	
    	    	addi 	$v0, $zero, 1		# print integer, syscall code = 1
    	    	lw 	$a0, 0($a1)
    	    	syscall
    	    	addi 	$v0, $zero, 4		# print string, syscall code = 4
    	    	la 	$a0, tab		# print tab
    	    	syscall
    	    	
    	    	addi 	$a1, $a1, 4
    	    	addi 	$t0, $t0, 1
    	    	j 	PRINT_ARRAY_LOOP
    	    PRINT_ARRAY_END_LOOP:
    	    addi 	$v0, $zero, 4		# print string, syscall code = 4
    	    la 		$a0, endl		# print endline
    	    syscall
	# Restore registers
	    lw 		$t1, 0($sp)
    	    addi 	$sp, $sp, 4
    	    lw 		$t0, 0($sp)
    	    addi 	$sp, $sp, 4
    	    lw 		$v0, 0($sp)
    	    addi 	$sp, $sp, 4
    	    lw 		$a1, 0($sp)
    	    addi 	$sp, $sp, 4
    	    lw 		$a0, 0($sp)
    	    addi 	$sp, $sp, 4
    END_PRINT_ARRAY:
    	jr $ra
#-----------------------------------

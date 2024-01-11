#!/bin/bash

# This example includes the following things:
# - There're .c/.cpp files in $TARGET_DIR, which they read "input.txt" and store results to "answer.txt"
# - This script compiles them, executes them, and compare the answer with the correct one.
# - Finally it appends all scores to "score.txt"

CORRECTOR_DIR=$1
TESTCASE_DIR=$2

clear_log () {
	for i in $@; do
		if [ -e ${i} ]; then rm ${i}; fi
	done
}

correction () {
	for file in *; do
		if [[ ${file} == *3_5*.cpp || ${file} == *3_5*.c ]]; then

			echo Compiling {${file##/*/}} ...
			if [[ ${file} == *.cpp ]]; then g++ ${file}; fi
      		if [[ ${file} == *.c ]]; then gcc ${file}; fi
			if [ ! -f a.out ]; then echo Compiling failed.; continue; fi

			echo Executing {${file##/*/}} ...
			score=0
			for i in $(seq 1 1 5); do
				cp ${TESTCASE_DIR}/input${i}.txt input.txt 
				
				timeout 2s ./a.out > /dev/null

				if [ -f answer.txt ]; then
					DIFF=$(diff -wb answer.txt ${TESTCASE_DIR}/answer${i}.txt)
					if [ "${DIFF}" == "" ]; then ((score += 20)); fi
					clear_log answer.txt
				fi
			done
			echo ${file##/*/} ${score} >> ${CORRECTOR_DIR}/score.txt

			clear_log a.out
			clear_log input.txt
		fi
	done
}

### Main function
clear_log a.out
clear_log input.txt
clear_log answer.txt
clear_log ${CORRECTOR_DIR}/score.txt
correction

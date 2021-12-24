.PHONY: test_dir test_var test_macro test_target_name
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
CMD := echo my command to print: 
test_dir: 
	@echo ${PWD}
	@echo $(CURDIR)
	@echo ${ROOT_DIR}


test_var: MYVAR = 15
test_var: MYVAR2 = 30
test_var: 
	@echo ...${MYVAR}...${MYVAR2}...



test_macro:
	@$(CMD) Blah



test_target_name: 
	echo target ..$@...

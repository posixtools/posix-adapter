#=======================================================================================
# MAKE SETTINGS

.DEFAULT_GOAL := help
NAME := dm.tools


#=======================================================================================
# HELP TARGET

.PHONY: help
help:
	@echo ""
	@echo "-------------------------------------------------------------------"
	@echo "  $(NAME) make interface "
	@echo "-------------------------------------------------------------------"
	@echo ""
	@echo "   help              Prints out this help message."
	@echo "   test              Runs the tool testing suite."
	@echo ""


#=======================================================================================
# EXAMPLE TEST SUITES TARGET
#
.PHONY: test
test:
	@./tests/test_tools.sh

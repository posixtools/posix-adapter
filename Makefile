#=======================================================================================
# MAKE SETTINGS

.DEFAULT_GOAL := help
NAME := dm.tools

#=======================================================================================
# HELP TARGET
#=======================================================================================
.PHONY: help
help:
	@echo ""
	@echo "-------------------------------------------------------------------"
	@echo "  $(NAME) make interface "
	@echo "-------------------------------------------------------------------"
	@echo ""
	@echo "   help              Prints out this help message."
	@echo "   init              Initializes the development environment."
	@echo ""
	@echo "-------------------------------------------------------------------"
	@echo ""
	@echo "   test              Runs the tool testing suite."
	@echo ""
	@echo "-------------------------------------------------------------------"
	@echo ""
	@echo "   python_test       Runs the python utility testing suite."
	@echo "   python_format     Runs the python automatic formatter tools."
	@echo "   python_check      Runs the python code validator tools."
	@echo "   python_clean      Cleans up python runtime artifacts."
	@echo ""
	@echo "-------------------------------------------------------------------"
	@echo ""

#=======================================================================================
# INIT
#=======================================================================================
.PHONY: init
init: virtualenv_activated
	@pip install -r ./utils/requirements-dev.txt

#=======================================================================================
# TESTS
#=======================================================================================
.PHONY: test
test:
	@./tests/runner.sh

#=======================================================================================
# PYTHON BASED TOOLING TESTS AND UTILITIES
#=======================================================================================
.PHONY: test-utils
python_test: virtualenv_activated
	python -m pytest -vv ./utils/tests/ || true

.PHONY: python_format
python_format: virtualenv_activated
	isort ./utils
	black ./utils

.PHONY: python_check
python_check: virtualenv_activated
	flake8 --ignore E501 ./utils
	# Since we are only heving here individual utility python scripts, mypy would not
	# recognize the base package in the standard way. Ignoring the missing
	# imports is necessary here to have a meaningful result:
	# https://mypy.readthedocs.io/en/latest/running_mypy.html#missing-imports
	mypy --ignore-missing-imports ./utils

.PHONY: python_clean
python_clean:
	find . -type d -name __pycache__ -exec rm -rv {} +

#=======================================================================================
# UTILITY COMMANDS
#==============================================================================
.PHONY: virtualenv_activated
virtualenv_activated:
	@if [[ -z "${VIRTUAL_ENV}" ]]; then \
		echo "$(BOLD)$(RED)No python virtual env present. Create and/or activate one before you can use the make interface!$(RESET)"; \
		exit 1; \
	fi

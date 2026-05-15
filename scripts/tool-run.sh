#!/bin/bash

# import log_message function
scriptFolder=$( cd "$( dirname "${0}" )" && pwd )
scriptBaseName=$( basename "${0}" .sh )
configFileName="${scriptFolder}/${scriptBaseName}.conf"
if [ -f "${configFileName}" ]; then
	# shellcheck disable=SC1090
	source "${configFileName}"
fi
if [ -n "${TOOL_NAME}" ]; then
	scriptBaseName="${scriptBaseName}-"$( echo ${TOOL_NAME} | tr "[:upper:]" "[:lower:]" )
fi
DEFAULT_LOG_FOLDER="/logs"
DEFAULT_SOURCE_FOLDER="/source"
DEFAULT_TARGET_FOLDER="/target"
DEFAULT_DATA_FOLDER="/data"
DEFAULT_ORGANIZE_CONFIG="/config/config.yaml"
DEFAULT_ORGANIZE_COMMAND="run"

source "${scriptFolder}/log-message.sh"
set_logFolder "${LOG_FOLDER:-${DEFAULT_LOG_FOLDER}}"
set_logFileBaseName "${scriptBaseName}"

log_message "-+*+- -+*+- -+*+- -+*+- -+*+-"
log_message "-+*+-  Tool-Run  START  -+*+-"
log_message "-+*+- -+*+- -+*+- -+*+- -+*+-"

log_rotate

if [ -f "${configFileName}" ]; then
	log_message "Found Config file!"
else
	log_message "Config file not found: ${configFileName}, using default values"
fi

SOURCE_FOLDER="${SOURCE_FOLDER:-${DEFAULT_SOURCE_FOLDER}}"
TARGET_FOLDER="${TARGET_FOLDER:-${DEFAULT_TARGET_FOLDER}}"
DATA_FOLDER="${DATA_FOLDER:-${DEFAULT_DATA_FOLDER}}"
ORGANIZE_COMMAND="${ORGANIZE_COMMAND:-${DEFAULT_ORGANIZE_COMMAND}}"
ORGANIZE_CONFIG="${ORGANIZE_CONFIG:-${DEFAULT_ORGANIZE_CONFIG}}"

log_message "Checking folders..."
if [ ! -d "${SOURCE_FOLDER}" ]; then
	log_message_and_exit 11 "Invalid SOURCE_FOLDER: ${SOURCE_FOLDER}"
fi
if [ ! -r "${SOURCE_FOLDER}" ]; then
	log_message_and_exit 12 "Can not read from SOURCE_FOLDER: ${SOURCE_FOLDER}"
fi
if [ ! -w "${SOURCE_FOLDER}" ]; then
	log_message_and_exit 13 "Can not write on SOURCE_FOLDER: ${SOURCE_FOLDER}"
fi
if [ ! -d "${TARGET_FOLDER}" ]; then
	log_message_and_exit 14 "Invalid TARGET_FOLDER: ${TARGET_FOLDER}"
fi
if [ ! -r "${TARGET_FOLDER}" ]; then
	log_message_and_exit 15 "Can not read from TARGET_FOLDER: ${TARGET_FOLDER}"
fi
if [ ! -w "${TARGET_FOLDER}" ]; then
	log_message_and_exit 16 "Can not write on TARGET_FOLDER: ${TARGET_FOLDER}"
fi
if [ ! -d "${DATA_FOLDER}" ]; then
	log_message_and_exit 17 "Invalid DATA_FOLDER: ${DATA_FOLDER}"
fi
if [ ! -r "${DATA_FOLDER}" ]; then
	log_message_and_exit 18 "Can not read from DATA_FOLDER: ${DATA_FOLDER}"
fi
if [ ! -w "${DATA_FOLDER}" ]; then
	log_message_and_exit 19 "Can not write on DATA_FOLDER: ${DATA_FOLDER}"
fi
log_message "Found valid folders!"

log_message "Checking command..."
if [ "${ORGANIZE_COMMAND}" != "sim" ] && [ "${ORGANIZE_COMMAND}" != "run" ]; then
	log_message_and_exit 14 "Invalid ORGANIZE_COMMAND: ${ORGANIZE_COMMAND}"
fi
log_message "Found valid command!"

# is there a config file?
log_message "Checking for config/rules file"
if [ -z "${ORGANIZE_CONFIG}" ]; then
	log_message_and_exit 15 "No ORGANIZE_CONFIG var Found!"
fi
log_message "Found ORGANIZE_CONFIG var!"

if [ ! -f "${ORGANIZE_CONFIG}" ]; then
	log_message_and_exit 16 "Config/rules file not-found: ${ORGANIZE_CONFIG}"
fi
log_message "Found config/rules file!"

log_message "Checking whether the config/rules file has valid contents..."
checkResult=$( organize check "${ORGANIZE_CONFIG}" )
checkExitCode=${#}
log_message "...result: ${checkResult}"
if [ ${checkExitCode} -gt 0 ]; then
	log_message_and_exit ${checkExitCode} "There is a problem with the config/rules file: ${ORGANIZE_CONFIG}"
fi

log_message "Organize Tool: Start"
/usr/local/bin/organize "${ORGANIZE_COMMAND}" "${ORGANIZE_CONFIG}" 2>&1 | tee -a "$( get_logFileName )"
organizeExitCode=${#}
if [ ${organizeExitCode} -gt 0 ]; then
	log_message_and_exit ${organizeExitCode} "Organize Tool: Finish with errorCode: ${organizeExitCode}"
fi
log_message "Organize Tool: Finish"

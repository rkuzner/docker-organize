#!/bin/bash

# exit immediately on any shell error
set -e

scriptBaseName=$( basename "${0}" .sh )
logFolder="/logs"
logFile="${logFolder}/${scriptBaseName}-$( date +%F ).log"

# logs a message to console AND to logfile
function log_message() {
	local message2log="${*}"
	if [ -n "${message2log}" ]; then
		timeStamp=$( date "+%Y/%m/%d %H:%M:%S,%3N" )		# ej: 2018/02/02 15:34:02,241
		echo "${timeStamp} | ${message2log}" | tee -a "${logFile}"
	fi
}

# set the default ORGANIZE_COMMAND
THE_ORGANIZE_COMMAND="run"

log_message " -+*+- -+*+- -+*+- -+*+- "
log_message "showing path for Organize Config file:"
organize show --path | tee -a "${logFile}"
log_message " -+*+- -+*+- -+*+- -+*+- "
log_message "Checking whether the config file has valid contents.."
organize check | tee -a "${logFile}"
log_message " -+*+- -+*+- -+*+- -+*+- "

log_message "Prepare organize-run.conf file"
echo "#!/bin/bash" > /home/ot/organize-run.conf
echo 'THE_ORGANIZE_CONFIG="'${ORGANIZE_CONFIG}'"' >> /home/ot/organize-run.conf

# evaluate if ORGANIZE_COMMAND was set on ENV, if so, only use if valid
if [ -n "${ORGANIZE_COMMAND}" ]; then
  log_message "Found ORGANIZE_COMMAND environment var!"
  if [ "${ORGANIZE_COMMAND}" = "run" ] || [ "${ORGANIZE_COMMAND}" = "sim" ]; then
    THE_ORGANIZE_COMMAND="${ORGANIZE_COMMAND}"
    log_message "Valid ORGANIZE_COMMAND environment var: ${ORGANIZE_COMMAND}"
  fi
fi
log_message "Using THE_ORGANIZE_COMMAND: ${THE_ORGANIZE_COMMAND}"

log_message "Append ORGANIZE_COMMAND to organize-run.conf file"
echo 'THE_ORGANIZE_COMMAND="'${THE_ORGANIZE_COMMAND}'"' >> /home/ot/organize-run.conf

# check if ORGANIZE_SCHEDULE was set on ENV. if so, set crontab schedule with it; and keep the image running...
if [ -n "${ORGANIZE_SCHEDULE}" ]; then
  log_message "Found ORGANIZE_SCHEDULE environment var!"

  log_message "Clear crontab schedule"
  crontab -r 2>/dev/null | tee -a "${logFile}"

  log_message "Set crontab schedule"
  echo "${ORGANIZE_SCHEDULE} /home/ot/organize-run.sh" | crontab -

  log_message "restart cron service"
  service cron restart

  /bin/bash
fi

# at this point, only a single run should occur
if [ -z "${ORGANIZE_SCHEDULE}" ]; then
  log_message "No ORGANIZE_SCHEDULE environment var Found!"
  log_message "This is a Single run/sim!"
  exec /home/ot/organize-run.sh
fi

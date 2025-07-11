#!/bin/bash

# exit immediately on any shell error
#set -e

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
log_message "checking path for Organize Config file..."
whatPath=$(organize show --path)
log_message "...found: ${whatPath}"

log_message "Checking whether the config file has valid contents..."
checkResult=$(organize check)
log_message "...result: ${checkResult}"

log_message "Preparing organize-run.conf file..."
echo "#!/bin/bash" > /home/ot/organize-run.conf
log_message "Append ORGANIZE_CONFIG to organize-run.conf file"
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

log_message "Done preparing organize-run.conf file."

# check if ORGANIZE_SCHEDULE was set on ENV. if so, set crontab schedule with it
if [ -n "${ORGANIZE_SCHEDULE}" ]; then
  log_message "Found ORGANIZE_SCHEDULE environment var!"

  log_message "Clear crontab schedule"
  crontab -u ot -r 2>/dev/null | tee -a "${logFile}"

  log_message "Set crontab schedule"
  echo "${ORGANIZE_SCHEDULE} /home/ot/organize-run.sh" | crontab -u ot -

  log_message "restart cron service"
  service cron restart
  exitCode=${?}
  if [ ${exitCode} -gt 0 ] ; then
    log_message "There was a problem restarting cron service, exitCode was: ${exitCode}"
  fi
else
  log_message "No ORGANIZE_SCHEDULE environment var Found!"
  log_message "This is a Single run/sim!"
  exec /home/ot/organize-run.sh
  exit ${?}
fi

# keep the image running...
/bin/bash

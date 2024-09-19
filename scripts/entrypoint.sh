#!/bin/bash

# exit immediately on any shell error
set -e

# set the default ORGANIZE_COMMAND
THE_ORGANIZE_COMMAND="run"

echo " -+*+- -+*+- -+*+- -+*+- "
echo "showing path for Organize Config file:"
organize show --path
echo " -+*+- -+*+- -+*+- -+*+- "
echo "Checking whether the config file has valid contents.."
organize check
echo " -+*+- -+*+- -+*+- -+*+- "

echo "Prepare organize-run.conf file"
echo "#!/bin/bash" > /home/ot/organize-run.conf
echo 'THE_ORGANIZE_CONFIG="'${ORGANIZE_CONFIG}'"' >> /home/ot/organize-run.conf

# evaluate if ORGANIZE_COMMAND was set on ENV, if so, only use if valid
if [ -n "${ORGANIZE_COMMAND}" ]; then
  echo "Found ORGANIZE_COMMAND environment var!"
  if [ "${ORGANIZE_COMMAND}" = "run" ] || [ "${ORGANIZE_COMMAND}" = "sim" ]; then
    THE_ORGANIZE_COMMAND="${ORGANIZE_COMMAND}"
    echo "Valid ORGANIZE_COMMAND environment var: ${ORGANIZE_COMMAND}"
  fi
fi
echo "Using THE_ORGANIZE_COMMAND: ${THE_ORGANIZE_COMMAND}"
echo "Append ORGANIZE_COMMAND to organize-run.conf file"
echo 'THE_ORGANIZE_COMMAND="'${THE_ORGANIZE_COMMAND}'"' >> /home/ot/organize-run.conf

# check if ORGANIZE_SCHEDULE was set on ENV. if so, set crontab schedule with it; and keep the image running...
if [ -n "${ORGANIZE_SCHEDULE}" ]; then
  echo "Found ORGANIZE_SCHEDULE environment var!"
  (crontab -l 2>/dev/null; echo "${ORGANIZE_SCHEDULE} /home/ot/organize-run.sh") | crontab -
  service cron restart
  /bin/bash
fi

# at this point, only a single run should occur
if [ -z "${ORGANIZE_SCHEDULE}" ]; then
  echo "No ORGANIZE_SCHEDULE environment var Found!"
  echo "This is a Single run/sim!"
  exec /home/ot/organize-run.sh
fi

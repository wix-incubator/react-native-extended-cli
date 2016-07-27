echo "Killing processes with name ${1}"
pkill -f "${1}" || true
echo "--------------------------------"
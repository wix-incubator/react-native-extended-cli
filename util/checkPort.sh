# check if a process is listening to the specified port
port=${1}
pid=`lsof -n -i:${port} | grep LISTEN | awk '{ print $2 }' | uniq`
if [ -z "${pid}" ]; then
  echo "[checkPort]: Port ${port} is free."
else
  >&2 echo "[checkPort]: WARNING! Port ${port} is taken by:"
  >&2 echo "`ps -p ${pid}`"
  >&2 echo "`ps -vf -p ${pid}`"
fi

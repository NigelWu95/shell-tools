softdel()
{
  mv $@ ~/.trash/
}

truedel()
{
  /bin/rm -i $@
}

k8sexecbashforpod()
{
  kubectl exec -it $@ -- /bin/bash
}

dockerrunbash()
{
  docker run -it $@ /bin/bash
}

dockerexecbash()
{
  docker exec -it $@ /bin/bash
}

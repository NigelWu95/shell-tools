softdel()
{
  mv $@ ~/.trash/
}

truedel()
{
  /bin/rm -i $@
}

dockerrunbash()
{
  docker run -it $@ /bin/bash
}

dockerexecbash()
{
  docker exec -it $@ /bin/bash
}

k8sexecbashforpod()
{
  kubectl exec -it $@ -- /bin/bash
}

applyffork8s()
{
  kubectl apply -f $@
}

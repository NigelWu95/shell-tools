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

k8execbashforpod()
{
  kubectl exec -it $@ -- /bin/bash
}

applyffork8s()
{
  kubectl apply -f $@
}

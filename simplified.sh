softdel()
{
  mv $@ ~/.trash/
}

truedel()
{
  /bin/rm -i $@
}

dkerpull()
{
  docker pull $@
}

dkerpush()
{
  docker push $@
}

dkerrunbash()
{
  docker run -it $@ /bin/bash
}

dkerexecbash()
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

dockerrms()
{
  docker ps --filter status=dead --filter status=exited -aq | xargs -r docker rm -v
}

dkerirms()
{
  docker images | grep '^<none>' | awk '{print $3}' | xargs -r docker image rm -v
}

dkerrm()
{
  docker rm $@
}

dkerirm()
{
  docker image rm $@
}

gicheckout(){
  git checkout $@
}

giclone()
{
  git clone $@
}

gicommit()
{
  git commit -m $@
}

gimerge()
{
  git merge $@
}

gipsh()
{
  git push $@
}

gipshoset()
{
  git push origin $@ --set-upstream
}

gipll()
{
  git pull $@
}

gibcrt()
{
  git checkout -b $@
}

gibdel()
{
  git checkout -b $@
}

gibrdel()
{
  git push origin $@ --delete
}

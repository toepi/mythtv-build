build put result under /tm/mythtv-build, 
to enable access from host add a volume like:
  -v /home/${USER}/mythtv-builds:/tmp/mythtv-build

to change branch from master to a differnt one set env-entry:
  -e MYTHTV_BRANCH=fixes/0.27 to build latest 0.27 


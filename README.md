# ose3-rails

This repository is meant to add a basic Dockerimage to every new Ruby on Rails Application from Puzzle ITC which comes to deploy on Openshift.

To use it you simply have to create a Dockerfile in the wanted project and write the following line in it:
`FROM puzzle/ose3-rails`

if you want to set up your work as a service, get the OpenshiftCLI first:
on linux:
https://master.appuio-beta.ch/console/extensions/clients/linux/oc

log into the location you wante the service
`oc login path/to/your/openshift3-location`

Possible locations:
https://victory.rz.puzzle.ch:8443
https://ose3-master.puzzle.ch:8443

go to the git repository you have and want to deploy and write:
`oc new-app .`


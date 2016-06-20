# ose3-rails

To use it you simply have to create a Dockerfile in the wanted project and write the following line in it:
`FROM puzzle/ose3-rails`

if you want to set up your work as a service, get the OpenshiftCLI first:
on linux:
https://master.appuio-beta.ch/console/extensions/clients/linux/oc

log into the location you wante the service
`oc login path/to/your/openshift3-location`

go to the git repository you have and want to deploy and write:
`oc new-app .`

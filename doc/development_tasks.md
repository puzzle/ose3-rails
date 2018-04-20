# Easily build the testing application on OpenShift

Create an OpenShift project and do

    oc apply -f openshift/test-build.yml
    oc import-image base-image

    oc start-build ose3-rails

Follow the build logs with

    oc get pod -o name | tail -n 1 | xargs oc logs -f

# ose3-rails

Openshift-dockerimage for Ruby on Rails applications with Apache2 and mod_passenger.

This image is based on centos/ruby-22-centos7: https://github.com/sclorg/s2i-ruby-container/tree/master/2.2

## Preparations

Go to the project root. Decide which project name to use

project=<PROJECT-NAME>

Create an OpenShift project and apply the JSON template to it:

```
oc new-project $project
oc process -f ose3_project_templates/build_base_image.json | oc create -n $project -f -
```

This will create all necessary resources and policyBindings in order for other projects to use its built images. It will also automatically start building the image, which can then be referenced by your other projects that want to use it.


## Usage

To use this generic image you simply have to create a Dockerfile in the wanted project and write the following line into it:

`FROM puzzle/ose3-rails`

and then reference the image in your BuildConfig spec:

```
spec:
...
  strategy:
    type: Docker
    dockerStrategy:
      from:
        kind: ImageStreamTag
        namespace: <PROJECT-NAME>
        name: 'ose3-rails:latest'
      forcePull: true
```

## Development

See [Development](DEVELOPMENT.md)

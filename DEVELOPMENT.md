# Helpful commands

## OpenShift 3

### Export project

Set project name

    project=<name>

Export all ressources to yaml files

    oc export --as-template=$project -n $project -o yaml all > $project.yml

## Docker images

The Dockerfile of centos/ruby-22-centos7 is at https://github.com/sclorg/s2i-ruby-container/tree/master/2.2

### Build locally

    docker build . -t puzzle/ose3-rails

Go to your app `FROM puzzle/ose3-rails` and

    docker build .

### Useful commands

To run a built image locally

    image=<image_name>
    docker run -p 8080:8080 $image

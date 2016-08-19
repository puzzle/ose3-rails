# Helpful commands

## OpenShift 3

### Export project

Set project name

    project=<name>
    
Export all ressources to yaml files

    oc export --as-template=$project -n $project -o yaml all > $project.yml

## Docker images

The Dockerfile of centos/ruby-22-centos7 is at https://github.com/sclorg/s2i-ruby-container/tree/master/2.2

### Useful commands

To run a built image locally

    image=<image_name>
    sudo docker run -p 8080:8080 $image 

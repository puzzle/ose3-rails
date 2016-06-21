# ose3-rails

Openshift-dockerimage for Ruby on Rails applications with Apache 2 and mod_passenger.

this image is based on centos/ruby-22-centos7: https://github.com/sclorg/s2i-ruby-container/tree/master/2.2

To use it you simply have to create a Dockerfile in the wanted project and write the following line in it:

`FROM puzzle/ose3-rails`



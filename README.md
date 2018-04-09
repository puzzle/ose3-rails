# Dockerfiles for OpenShift 3 Rails deployments

## The Dockerfiles

_dist_ contains ready-to-build dockerfiles.

* _rails/pure_ An Apache/Passenger/Rails image
* _rails/nodejs_ An Apache/Passenger/Rails/nodejs image
* _rails/sphinx_ An Apache/Passenger/Rails/sphinx image
* _rails/sphinx-transifex_ An Apache/Passenger/Rails/sphinx/transifex image

## Dockerhub

All these images are built on [Dockerhub](https://hub.docker.com/u/puzzle/).

### Versioning concept

The ruby 2.2 images are organized in two **branches**, `master` and `stable`.
`master` contains release candidates ready for integration testing.
The `stable` branch contains the images used in production environments.

Each Dockerfile is released on it's own DockerHub repository:

* _dist/rails/pure/Dockerfile_ is built to [puzzle/ose3-rails:ruby22*](https://hub.docker.com/r/puzzle/ose3-rails)
* _dist/rails/sphinx/Dockerfile_ (includes Sphinx 2.2) is built to [puzzle/ose3-rails-sphinx:ruby22*](https://hub.docker.com/r/puzzle/ose3-rails-sphinx/tags/)
* _dist/rails/sphinx/transifex/Dockerfile_ (includes Sphinx transifex client 0.12) is built to [puzzle/ose3-rails-sphinx:ruby22*](https://hub.docker.com/r/puzzle/ose3-rails-sphinx/tags/)
* _dist/rails/nodejs/Dockerfile_ (includes node 8.9) is built to [puzzle/ose3-rails-nodejs:ruby22,puzzle/ose3-rails-nodejs:ruby22-nodejs-8.9](https://hub.docker.com/r/puzzle/ose3-rails-nodejs/tags/)
* _dist/rails/nodejs/nodejs6/Dockerfile_ (includes node 6) is built to [puzzle/ose3-rails-nodejs:ruby22-nodejs-6](https://hub.docker.com/r/puzzle/ose3-rails-nodejs/tags/)

There are more **docker tags** in place so you can pin your image to the versions of the software contained inside. Have a look at DockerHub.

Tags ending in `-dev` are the builds from the `master` branch used for integration tests.

## Building

### Locally

Change to the desired Dockerfiles' containing folder and `docker build .`

### On OpenShift

Sample `spec` section of your `BuildConfig`:

    source:
      type: "Git"
      git: 
        uri: "<this repos' uri>"
        ref: "master"
      contextDir: "<e.g. dist/rails/pure>" 

## Developing

Dockerfiles and build contexts under `dist` are generated from the source files at `src`.

### Building dist

Use ruby 2.3.1 (although everything > 2 should work), rvm will do so for you automatically.
 
    rvm use 2.3.1
    gem install bundler
    bundle install
    rake build
    
#### Source structure

`src` contains ERB templates to build the Dockerfiles and the necessary files for their build contexts.

    src
    ├── _build
    │   └── (The build script)
    └── rails (Collection of images)
        ├── _context (Contains files and folders to copy to build context)
        ├── _partials (Contains partials)
        ├── pure (An image)
        │   ├── Dockerfile.erb
        │   └── README.md.erb
        └── nodejs (Another image)
            ├── _context (nodejs specific build context contents)

An example: When building `nodejs`

* `dist/rails/nodejs/Dockerfile` is generated from `src/rails/nodejs/Dockerfile.erb`
  The template has access to all partials in `nodejs/_partials` and all parent folders (`rails/_partials` in this case). A partial `_foo.erb` is rendered by doing `<%= partial("foo") %>`. `nodejs/_partials/_foo.erb` will take precedence over `rails/_partials/_foo.erb`.
* All necessary files for the docker build context (store them in the `_context` folders) are copied to `dist/rails/nodejs/`. A file `nodejs/foofile` will override `rails/foofile`.

## Testing

Check out `bin/test.sh` for a simple integration test.

## Releasing

For now, only Puzzle members may release new versions of the images.

Refer to the [internal documentation at puzzle](https://gitlab.puzzle.ch/pitc_ruby/ose3-rails-configmanagement/blob/master/doc/operations/README.md) to learn how to test the image against a fow OpenShift projects before releasing it on DockerHub.

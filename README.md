# Dockerfiles for OpenShift 3 Rails deployments

## The Dockerfiles

_dist_ contains ready-to-build dockerfiles.

* _rails/pure_ An Apache/Passenger/Rails image
* _rails/nodejs_ An Apache/Passenger/Rails/nodejs image
* _rails/sphinx_ An Apache/Passenger/Rails/sphinx image
* _rails/sphinx-transifex_ An Apache/Passenger/Rails/sphinx/transifex image

## Dockerhub

All these images are built on [Dockerhub](https://hub.docker.com/u/puzzle/).

### About the tags

ruby22, ruby24: stable versions, built from the `stable` branch

* _dist/rails/pure/Dockerfile_ is built to [puzzle/ose3-rails:ruby22*](https://hub.docker.com/r/puzzle/ose3-rails)
* _dist/rails/sphinx/Dockerfile_ (includes Sphinx 2.2) is built to [puzzle/ose3-rails-sphinx:ruby22*](https://hub.docker.com/r/puzzle/ose3-rails-sphinx/tags/)
* _dist/rails/sphinx/transifex/Dockerfile_ (includes Sphinx transifex client 0.12) is built to [puzzle/ose3-rails-sphinx:ruby22*](https://hub.docker.com/r/puzzle/ose3-rails-sphinx/tags/)
* _dist/rails/nodejs/Dockerfile_ (includes node) is built to [puzzle/ose3-rails-nodejs:ruby22*](https://hub.docker.com/r/puzzle/ose3-rails-nodejs/tags/)

latest, devel: development versions, don't use in production

## Using

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

When building `nodejs`

* `dist/rails/nodejs/Dockerfile` is generated from `src/rails/nodejs/Dockerfile.erb`
  The template has access to all partials in `nodejs/_partials` and all parent folders (`rails/_partials` in this case). A partial `_foo.erb` is rendered by doing `<%= partial("foo") %>`. `nodejs/_partials/_foo.erb` will take precedence over `rails/_partials/_foo.erb`.
* All necessary files for the docker build context (store them in the `_context` folders) are copied to `dist/rails/nodejs/`. A file `nodejs/foofile` will override `rails/foofile`.

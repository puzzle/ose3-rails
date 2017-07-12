#!/usr/bin/env ruby

ARCH='x86_64'.freeze
DIST='rhel7'.freeze
MAJOR_SPHINX_VERSION=2.freeze
GITHUB_REPO_URL='https://github.com/sphinxsearch/sphinx'.freeze
DOWNLOAD_BASE_URL='https://github.com/sphinxsearch/sphinx/releases/download/'.freeze

def github_releases
  `git ls-remote -t #{GITHUB_REPO_URL}  | grep '-release$' -|sort -V -k2`
end

def most_recent_version
  github_releases.scan(/#{MAJOR_SPHINX_VERSION}\.\d+\.\d+/).last
end

def version
  @version ||= most_recent_version
end

def version_info
  p "most recent sphinx version #{MAJOR_SPHINX_VERSION} for #{DIST}.#{ARCH} is: #{version}" 
end

def releases_path
  "#{version}-release"
end

def file_name
  "sphinx-#{version}-1.#{DIST}.#{ARCH}.rpm"
end

def download_url
  "#{DOWNLOAD_BASE_URL}/#{releases_path}/#{file_name}"
end

def install_sphinx
  p "installing sphinx #{version} ..."
  `yum localinstall -y #{download_url}`
  `yum clean all -y`
end

version_info
install_sphinx

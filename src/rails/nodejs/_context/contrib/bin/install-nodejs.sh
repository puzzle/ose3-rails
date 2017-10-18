#!/usr/bin/env ruby

ARCH='x64'.freeze
MAJOR_NODEJS_VERSION=8.freeze
GITHUB_REPO_URL='https://github.com/nodejs/node.git'.freeze
DOWNLOAD_BASE_URL='https://nodejs.org/dist'.freeze

def github_releases
  `git ls-remote -t #{GITHUB_REPO_URL}`
end

def most_recent_version
  github_releases.scan(/#{MAJOR_NODEJS_VERSION}\.\d+\.\d+/).last
end

def version
  @version ||= most_recent_version
end

def version_info
  p "most recent nodejs version #{MAJOR_NODEJS_VERSION} is: #{version}" 
end

def file_name
  "node-v#{version}-linux-#{ARCH}.tar.gz"
end

def download_url
  "#{DOWNLOAD_BASE_URL}/v#{version}/#{file_name}"
end

def install_nodejs
  p "installing nodejs #{version} ..."
  Dir.chdir('/tmp') do
    system("mkdir -p /opt/nodejs")
    system("wget #{download_url}")
    system("tar xvfz #{file_name} -C /opt/nodejs --strip-components=1")
  end
end

version_info
install_nodejs

# -*- encoding : utf-8 -*-
require 'xmlrpc/client'

class BuildServer

  SUCCESS = 0
  ERROR = 1

  PLATFORM_NOT_FOUND = 1
  PLATFORM_PENDING = 2
  PROJECT_NOT_FOUND = 3
  PROJECT_VERSION_NOT_FOUND = 4
  PROJECT_SOURCE_ERROR = 6
  
  DEPENDENCY_TEST_FAILED = 21
  BINARY_TEST_FAILED = 22

  DEPENDENCIES_ERROR = 555
  BUILD_ERROR = 666
  BUILD_STARTED = 3000

  def self.client
    @@client ||= XMLRPC::Client.new3('host' => APP_CONFIG['build_server_ip'], 'port' => APP_CONFIG['build_server_port'], 'path' => APP_CONFIG['build_server_path'])
  end


  def self.add_platform name, platforms_root_folder, distrib_type, repos = {:src => [], :rpm => []}
    self.client.call('add_platform', name, platforms_root_folder, repos, distrib_type)
  end


  def self.delete_platform name
    self.client.call('delete_platform', name)
  end


  def self.clone_platform new_name, old_name, new_root_folder
    self.client.call('clone_platform', new_name, old_name, new_root_folder)
  end


  def self.create_repo name, platform_name
    self.client.call('create_repository', name, platform_name)
  end


  def self.delete_repo name, platform_name
    self.client.call('delete_repository', name, platform_name)
  end

  def self.clone_repo new_name, old_name, new_platform_name
    tmp = self.client.timeout # TODO remove this when core will be ready
    self.client.timeout = 30.minutes
    self.client.call('clone_repo', new_name, old_name, new_platform_name)
    self.client.timeout = tmp
  end

  def self.publish_container container_id
    self.client.call('publish_container', container_id)
  end

  def self.delete_container container_id
    self.client.call('delete_container', container_id)
  end

  def self.create_project name, platform_name, repo_name, git_project_path
    self.client.call('create_project', name, platform_name, repo_name, git_project_path)
  end

  def self.delete_project name, platform_name
    self.client.call('delete_project', name, platform_name)
  end

  def self.add_to_repo name, repo_name
    self.client.call('add_to_repo', name, repo_name)
  end

  def self.add_build_list project_name, project_version, plname, arch, bplname, update_type, build_requires, id_web, include_repos
    include_repos_hash = {}.tap do |h|
      include_repos.each do |r|
        repo = Repository.find r
        h[repo.name] = repo.platform.public_downloads_url(nil, arch, repo.name)
      end
    end
    # raise include_repos_hash.inspect
    self.client.call('add_build_list', project_name, project_version, plname, arch, bplname, update_type, build_requires, id_web, include_repos_hash)
  end
  
  def self.delete_build_list idlist
    self.client.call('delete_build_list', idlist)
  end
  
  def self.get_status
    self.client.call('get_status')
  end

  def self.freeze platform_name, new_repo_name = nil
    self.client.call('freeze_platform', platform_name, new_repo_name)
  end
end

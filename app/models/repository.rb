class Repository < ActiveRecord::Base
  belongs_to :platform
  has_many :projects, :dependent => :destroy

  validate :name, :presence => true, :uniqueness => true
  validate :unixname, :uniqueness => true, :presence => true, :format => { :with => /^[a-zA-Z0-9\-.]+$/ }

  before_create :create_directory

  def path
    build_path(unixname)
  end

  protected

    def build_path(dir)
      File.join(platform.path, dir)
    end

    #TODO: Spec me
    def create_directory
      exists = File.exists?(path) && File.directory?(path)
      raise "Directory #{path} already exists" if exists
      if new_record?
        FileUtils.mkdir_p(path)
      elsif unixname_changed?
        FileUtils.mv(build_path(unixname_was), buildpath(unixname))
      end 
    end

end
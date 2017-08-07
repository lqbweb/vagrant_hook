require "pathname"
require "vagrant_hook/plugin"

module VagrantPlugins
  module VagrantHook
    lib_path = Pathname.new(File.expand_path("../vagrant_hook", __FILE__))
    #autoload :Action,      lib_path.join("action")
    #autoload :DSL,         lib_path.join("dsl")
    #autoload :Config,      lib_path.join("config")
    #autoload :Errors,      lib_path.join("errors")
    #autoload :Provisioner, lib_path.join("provisioner")

    # This returns the path to the source of this plugin.
    #
    # @return [Pathname]
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end
  end
end
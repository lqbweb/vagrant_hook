module VagrantPlugins
  module VagrantHook
	class HooksConfig < Vagrant.plugin(2, :config)
	  attr_accessor :check_outdated_callbacks
	  attr_accessor :add_box_callbacks
	  attr_accessor :prepare_clone_callbacks
	  
	  def initialize
		@check_outdated_callbacks = []
		@add_box_callbacks = []
		@prepare_clone_callbacks = []
	  end
	  
	  def on_check_outdated(&proc)
		@check_outdated_callbacks << {:mproc => proc}
	  end
	  
	  def on_add_box(&proc)
		@add_box_callbacks << {:mproc => proc}
	  end
	  
	  def on_prepare_clone(&proc)
		@prepare_clone_callbacks << {:mproc => proc}
	  end
	end
	
	class HookActionAbstract
		def initialize(app, env, callbacks_list)
          @app = app
		  @callbacks_list = callbacks_list
        end
		
        def call(env)
		  callbacks = @callbacks_list.call
		  
		  callbacks.each do | clbk |
			clbk[:mproc].call(env)
		  end
		 
		  @app.call(env)
        end
	end
	
	class HookBoxCheckOutdated < HookActionAbstract
		def initialize(app, env)
			super(app, env, Proc.new { env[:machine].config.vagrant_hook.check_outdated_callbacks } )
        end
	end
	
	class AddBoxHook < HookActionAbstract
		def initialize(app, env)
			super(app, env, Proc.new { env[:machine].config.vagrant_hook.add_box_callbacks } )
        end
	end

	class PrepareCloneHook < HookActionAbstract
		def initialize(app, env)
			super(app, env, Proc.new { env[:machine].config.vagrant_hook.prepare_clone_callbacks } )
        end
	end
	
    class Plugin < Vagrant.plugin("2")
		name "vagrant_hook"
		
		config "vagrant_hook" do
			HooksConfig
		end
		
		action_hook(:vagrant_hook, Plugin::ALL_ACTIONS) do |hook|
			hook.after(Vagrant::Action::Builtin::BoxCheckOutdated, VagrantPlugins::VagrantHook::HookBoxCheckOutdated)
		end
		
		action_hook(:vagrant_hook, Plugin::ALL_ACTIONS) do |hook|
			hook.after(Vagrant::Action::Builtin::BoxAdd, VagrantPlugins::VagrantHook::AddBoxHook)
		end
		
		action_hook(:vagrant_hook, Plugin::ALL_ACTIONS) do |hook|
			hook.after(Vagrant::Action::Builtin::PrepareClone, VagrantPlugins::VagrantHook::PrepareCloneHook)
		end
	end
  end
end
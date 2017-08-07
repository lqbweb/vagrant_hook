module VagrantPlugins
  module VagrantHook
	class HooksConfig < Vagrant.plugin(2, :config)
	  attr_accessor :check_outdated_callbacks

	  def initialize
		@check_outdated_callbacks = []
	  end
	  
	  def check_outdated(&proc)
		@check_outdated_callbacks << {:mproc => proc}
	  end
	end
	
	class HookActionAbstract
		def initialize(app, env, callbacks_list)
          @app = app
		  @callbacks_list = callbacks_list
        end
		
        def call(env)
		  @host = env[:host]
		  
		  callbacks = @callbacks_list.call
		  puts callbacks.to_yaml
		  callbacks.each do | clbk |
			clbk[:mproc].call(@host)
		  end
		 
		  @app.call(env)
        end
	end
	
	class HookBoxCheckOutdated < HookActionAbstract
		def initialize(app, env)
			super(app, env, Proc.new { env[:machine].config.vagrant_hook.check_outdated_callbacks } )
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
	end
  end
end
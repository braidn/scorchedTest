class MyApp < Scorched::Controller
	#to use flash, we need some rack sessions
	middleware << proc {
		use Rack::Session::Cookie
	}

	render_defaults.merge!(
		engine: :haml,
		layout: :main_layout
	)
	#redirect after a 404 error
	after status:404 do
		redirect('/')
	end

	#simple route, nothing special
	#This block accepts all HTTP methods if (none defined)
	route '/' do
		@response = 'Welcome Home'
		#default engine seems to be 'erb' which... is an opinion!
		#which means there is some explaining to do http://scorchedrb.com
		render(:index)
	end

	#regex that needs to meet the has_name condition defined above
	get '/ass', 7 do |capture|
		@response = "Caught a regex! #{capture}"
		#this flash is nested and fires much the same as the flash[:error] above
		flash(:dick)[:nice_try] = 'Wow, clever'
		redirect('/')
	end

	get '/dick', 6 do
		@response = 'You should get a response for being one'
		render(:dick)
	end
	
	#little more complex, captures all methods and places item into the return value
	#the 5 is a priority value
	#If we wanted to specify one method on this request we could omit route and put method.downcase
	route '/*', -98, methods: ['POST', 'GET', 'DELETE'] do |capture|
		error = "I see someone is looking for #{capture}, feel free to fuck off"
		#flash session accessed during next request
		#IF NOT ACCESSED it hangs around until it is accessed
		flash[:error] = error
		redirect('/')
	end

	#this works the same as above just captures both the item and the slash (/)
	get '/**', -99 do |capture|
		@response = "I see you are looking for something with a #{capture}"
	end

end

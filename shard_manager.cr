require "http/client"

module Shards
	extend self
	RUNNER_VERSION = "0.1.0"
	VERSION = "0.0.2"
	PATH = "shard.yml"
	def help
		puts "Repl.it Shard Manager Help\n__________\nWhat can this (semi)shard do?\n - It simplifies the process of installing shards by creating an easy programming interface to install them.\n__________\nHow do I use it?\n - You've downloaded this file, or forked it on repl.it already. Great! Now, simply require \"./[filename]\", where [filename] is what you named this file.\n\n - Shards.help will display this help message.\n__________\nGuide\n - I learn best by example, so in this example, we will be installing the shards kemal and crest.\n\n -1- Create a new shard for crest by adding\n    crest = Shards::Shard.new \"crest\"\n\n -2- Add another shard for kemal\n    kemal = Shards::Shard.new \"kemal\"\n\n -3- Create (or update) the shard.yml file\n    Shard::Yml.make [crest, kemal]\n\n -4- Lastly, make sure your shards are installed by using the shard install command, or running\n    Shards::Yml.install"
	end
	class Shard
		@name : String = ""
		@version : String = ""
		@github : String = ""
		def initialize(name, version = "", github = "")
			temp = [] of String
			name.downcase.split("").each do |letter|
				temp << letter if /\w|_|-/.match letter
			end
			@name = temp.join("")
			temp = [] of String
			response = HTTP::Client.get("http://crystalshards.xyz/?filter="+@name)
			File.open "output", "w" do |file|
				file.puts response.body
			end
			if response.status_code == 200
				url = (/https:\/\/github.com\/(\w*\/\w*)/.match(response.body).try &.[1])
				if url.nil?
					raise "Shard #{@name} not found."
				else
					if url == "f/crystalshards" || url == ""
						raise "Shard #{@name} not found."
					else
						if url == github || github == ""
							@github = url
						else
							raise "A github adress was entered but a seperate adress was found for #{@name}."
						end
					end
				end
			else
				raise "Generic server error: non-200 response."
			end
			version.split("").each do |char|
				temp << char if /[0-9]|\./
			end
			@version = temp.join("")
		end

		def name
			@name
		end
		def github
			@github
		end
		def version
			@version
		end
		def yml_string
			str = "  #{@name}:\n    github: #{@github}\n"
			str += "    version: #{@version}\n" unless @version == ""
			str
		end
	end
	module Yml
		extend self
		def make(using = [] of Shard)
			shard = File.new PATH, "w"
			shard.puts "name: runner"
			shard.puts "version: #{RUNNER_VERSION}"
			shard.puts "dependencies:"
			using.each do |s|
				shard.puts s.yml_string
			end
			shard.close
		end
		def exists?
			File.exists? PATH
		end
		def formatted?
			if self.exists?
				lines = File.read_lines PATH
				if lines[0]? != nil && lines[1]? != nil
					lines[0] == "name: runner" && lines[1] == "version: #{RUNNER_VERSION}" ? true : false
				else
					false
				end
			else
				false
			end
		end
		def install(verbosity : Bool = false)
			puts "Installing/Updating Shards" if verbosity
			puts "Done" if verbosity
			system("shards install -q")
		end
	end
end

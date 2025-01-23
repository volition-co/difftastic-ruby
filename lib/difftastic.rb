# frozen_string_literal: true

require "difftastic/version"
require "tempfile"

module Difftastic
	autoload :ANSI, "difftastic/ansi"
	autoload :Differ, "difftastic/differ"
	autoload :Upstream, "difftastic/upstream"

	GEM_NAME = "difftastic"
	DEFAULT_DIR = File.expand_path(File.join(__dir__, "..", "exe"))

	def self.execute(command)
		`#{executable} #{command}`
	end

	def self.platform
		[:cpu, :os].map { |m| Gem::Platform.local.__send__(m) }.join("-")
	end

	def self.executable(exe_path: DEFAULT_DIR)
		difftastic_install_dir = ENV["DIFFTASTIC_INSTALL_DIR"]

		if difftastic_install_dir
			if File.directory?(difftastic_install_dir)
				warn "NOTE: using DIFFTASTIC_INSTALL_DIR to find difftastic executable: #{difftastic_install_dir}"
				exe_path = difftastic_install_dir
				exe_file = File.expand_path(File.join(difftastic_install_dir, "difft"))
			else
				raise DirectoryNotFoundException.new(<<~MESSAGE)
					DIFFTASTIC_INSTALL_DIR is set to #{difftastic_install_dir}, but that directory does not exist.
				MESSAGE
			end
		else
			if Difftastic::Upstream::NATIVE_PLATFORMS.keys.none? { |p| Gem::Platform.match_gem?(Gem::Platform.new(p), GEM_NAME) }
				raise UnsupportedPlatformException.new(<<~MESSAGE)
					difftastic-ruby does not support the #{platform} platform
					Please install difftastic following instructions at https://difftastic.io/install
				MESSAGE
			end

			exe_file = Dir.glob(File.expand_path(File.join(exe_path, "**", "difft"))).find do |f|
				Gem::Platform.match_gem?(Gem::Platform.new(File.basename(File.dirname(f))), GEM_NAME)
			end
		end

		if exe_file.nil? || !File.exist?(exe_file)
			raise ExecutableNotFoundException.new(<<~MESSAGE)
				Cannot find the difftastic executable for #{platform} in #{exe_path}

				If you're using bundler, please make sure you're on the latest bundler version:

				    gem install bundler
				    bundle update --bundler

				Then make sure your lock file includes this platform by running:

				    bundle lock --add-platform #{platform}
				    bundle install

				See `bundle lock --help` output for details.

				If you're still seeing this message after taking those steps, try running
				`bundle config` and ensure `force_ruby_platform` isn't set to `true`. See
				https://github.com/fractaledmind/difftastic-ruby#check-bundle_force_ruby_platform
				for more details.
			MESSAGE
		end

		exe_file
	end

	def self.pretty(object, buffer: +"", indent: 0, indent_width: 2, max_width: 80)
		case object
		when Hash
			buffer << "{\n"
			indent += 1
			object.each do |key, value|
				buffer << ("	" * indent)
				pretty(key, buffer:, indent:)
				buffer << " => "
				pretty(value, buffer:, indent:)
				buffer << ",\n"
			end
			indent -= 1
			buffer << ("	" * indent)
			buffer << "}"
		when Array
			if (inline = pretty_inline_array(object, constraint: max_width - (indent * indent_width)))
				buffer << inline
			else
				buffer << "[\n"
				indent += 1
				object.each do |value|
					buffer << ("	" * indent)
					pretty(value, buffer:, indent:)
					buffer << ",\n"
				end
				indent -= 1
				buffer << ("	" * indent)
				buffer << "]"
			end
		when Set
			if (inline = pretty_inline_set(object, constraint: max_width - (indent * indent_width)))
				buffer << inline
			else
				buffer << "Set[\n"
				indent += 1
				object.to_a.sort!.each do |value|
					buffer << ("	" * indent)
					pretty(value, buffer:, indent:)
					buffer << ",\n"
				end
				indent -= 1
				buffer << ("	" * indent)
				buffer << "]"
			end
		when Module
			buffer << object.name
		when Symbol, String, Integer, Float, Regexp, Range, Rational, Complex, true, false, nil
			buffer << object.inspect
		else
			instance_variables = object.instance_variables
			if instance_variables.length > 0
				buffer << "#{object.class.name}(\n"
				indent += 1
				object.instance_variables.each do |name|
					buffer << ("	" * indent)
					buffer << ":#{name} => "
					pretty(object.instance_variable_get(name), buffer:, indent:)
					buffer << ",\n"
				end
				indent -= 1
				buffer << ("	" * indent)
				buffer << ")"
			else
				buffer << "#{object.class.name}()"
			end
		end
	end

	def self.pretty_inline_array(object, constraint:)
		buffer = +"["

		object.each_with_index do |item, index|
			return false unless pretty_inline_items(buffer:, item:, index:, constraint:)
		end

		buffer << "]"
	end

	def self.pretty_inline_set(object, constraint:)
		buffer = +"Set["

		object.to_a.sort!.each_with_index do |item, index|
			return false unless pretty_inline_items(buffer:, item:, index:, constraint:)
		end

		buffer << "]"
	end

	def self.pretty_inline_items(buffer:, item:, index:, constraint:)
		buffer << ", " unless index == 0
		case item
		when Array
			buffer << pretty_inline_array(item, constraint: constraint - buffer.length)
		when Set
			buffer << pretty_inline_set(item, constraint: constraint - buffer.length)
		when Module
			buffer << item.name
		when Symbol, String, Integer, Float, Regexp, Range, Rational, Complex, true, false, nil
			buffer << item.inspect
		else
			return false
		end

		buffer.length <= constraint
	end
end

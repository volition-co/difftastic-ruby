# frozen_string_literal: true

#  Rake tasks to manage native gem packages with binary executables from benbjohnson/difft
#
#  TL;DR: run "rake package"
#
#  The native platform gems (defined by Difftastic::Upstream::NATIVE_PLATFORMS) will each contain
#  two files in addition to what the vanilla ruby gem contains:
#
#     exe/
#     ├── difft                             #  generic ruby script to find and run the binary
#     └── <Gem::Platform architecture name>/
#         └── difft                         #  the difft binary executable
#
#  The ruby script `exe/difft` is installed into the user's path, and it simply locates the
#  binary and executes it. Note that this script is required because rubygems requires that
#  executables declared in a gemspec must be Ruby scripts.
#
#  As a concrete example, an x86_64-linux system will see these files on disk after installing
#  difft-0.x.x-x86_64-linux.gem:
#
#     exe/
#     ├── difft
#     └── x86_64-linux/
#         └── difft
#
#  So the full set of gem files created will be:
#
#  - pkg/difft-1.0.0.gem
#  - pkg/difft-1.0.0-arm64-linux.gem
#  - pkg/difft-1.0.0-arm64-darwin.gem
#  - pkg/difft-1.0.0-x86_64-darwin.gem
#  - pkg/difft-1.0.0-x86_64-linux.gem
#
#  Note that in addition to the native gems, a vanilla "ruby" gem will also be created without
#  either the `exe/difft` script or a binary executable present.
#
#
#  New rake tasks created:
#
#  - rake gem:ruby           # Build the ruby gem
#  - rake gem:arm64-linux  # Build the aarch64-linux gem
#  - rake gem:arm64-darwin   # Build the arm64-darwin gem
#  - rake gem:x86_64-darwin  # Build the x86_64-darwin gem
#  - rake gem:x86_64-linux   # Build the x86_64-linux gem
#  - rake download           # Download all difft binaries
#
#  Modified rake tasks:
#
#  - rake gem                # Build all the gem files
#  - rake package            # Build all the gem files (same as `gem`)
#  - rake repackage          # Force a rebuild of all the gem files
#
#  Note also that the binary executables will be lazily downloaded when needed, but you can
#  explicitly download them with the `rake download` command.

require "rubygems/package"
require "rubygems/package_task"
require "open-uri"
require "zlib"
require "zip"
require_relative "../lib/difftastic/upstream"

def difftastic_download_url(filename)
	"https://github.com/Wilfred/difftastic/releases/download/#{Difftastic::Upstream::VERSION}/#{filename}"
end

DIFFTASTIC_RAILS_GEMSPEC = Bundler.load_gemspec("difftastic.gemspec")

gem_path = Gem::PackageTask.new(DIFFTASTIC_RAILS_GEMSPEC).define
desc "Build the ruby gem"
task "gem:ruby" => [gem_path]

exepaths = []
Difftastic::Upstream::NATIVE_PLATFORMS.each do |platform, filename|
	DIFFTASTIC_RAILS_GEMSPEC.dup.tap do |gemspec|
		exedir = File.join(gemspec.bindir, platform) # "exe/x86_64-linux"
		exepath = File.join(exedir, "difft") # "exe/x86_64-linux/difft"
		exepaths << exepath

		# modify a copy of the gemspec to include the native executable
		gemspec.platform = platform
		gemspec.files += [exepath, "LICENSE-DEPENDENCIES.md"]

		# create a package task
		gem_path = Gem::PackageTask.new(gemspec).define
		desc "Build the #{platform} gem"
		task "gem:#{platform}" => [gem_path]

		directory exedir

		file exepath => [exedir] do
			release_url = difftastic_download_url(filename)
			warn "Downloading #{exepath} from #{release_url} ..."

			URI.open(release_url) do |remote|
				if release_url.end_with?(".zip")
					Zip::File.open_buffer(remote) do |zip_file|
						zip_file.extract("difft", exepath)
					end
				elsif release_url.end_with?(".gz")
					Zlib::GzipReader.wrap(remote) do |gz|
						Gem::Package::TarReader.new(gz) do |reader|
							reader.seek("difft") do |file|
								File.binwrite(exepath, file.read)
							end
						end
					end
				end
			end
			FileUtils.chmod(0o755, exepath, verbose: true)
		end
	end
end

desc "Download all binaries"
task "download" => exepaths

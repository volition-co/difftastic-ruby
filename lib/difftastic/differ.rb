# frozen_string_literal: true

class Difftastic::Differ
	def initialize(background: nil, color: nil, syntax_highlight: nil, context: nil, tab_width: nil, parse_error_limit: nil, underline_highlights: true)
		@show_paths = false
		@background = background => :dark | :light | nil
		@color = color => :always | :never | :auto | nil
		@syntax_highlight = syntax_highlight => :on | :off | nil
		@context = context => Integer | nil
		@tab_width = tab_width => Integer | nil
		@parse_error_limit = parse_error_limit => Integer | nil
		@underline_highlights = underline_highlights => true | false
	end

	def diff_objects(old, new)
		old = Difftastic.pretty(old)
		new = Difftastic.pretty(new)

		diff_strings(old, new, file_extension: "rb")
	end

	def diff_ada(old, new)
		diff_strings(old, new, file_extension: "ada")
	end

	def diff_apex(old, new)
		diff_strings(old, new, file_extension: "apex")
	end

	def diff_bash(old, new)
		diff_strings(old, new, file_extension: "sh")
	end

	def diff_c(old, new)
		diff_strings(old, new, file_extension: "c")
	end

	def diff_cpp(old, new)
		diff_strings(old, new, file_extension: "cpp")
	end

	def diff_csharp(old, new)
		diff_strings(old, new, file_extension: "cs")
	end

	def diff_clojure(old, new)
		diff_strings(old, new, file_extension: "clj")
	end

	def diff_cmake(old, new)
		diff_strings(old, new, file_extension: "cmake")
	end

	def diff_commonlisp(old, new)
		diff_strings(old, new, file_extension: "lisp")
	end

	def diff_dart(old, new)
		diff_strings(old, new, file_extension: "dart")
	end

	def diff_devicetree(old, new)
		diff_strings(old, new, file_extension: "dts")
	end

	def diff_elixir(old, new)
		diff_strings(old, new, file_extension: "ex")
	end

	def diff_elm(old, new)
		diff_strings(old, new, file_extension: "elm")
	end

	def diff_elvish(old, new)
		diff_strings(old, new, file_extension: "elv")
	end

	def diff_erlang(old, new)
		diff_strings(old, new, file_extension: "erl")
	end

	def diff_elisp(old, new)
		diff_strings(old, new, file_extension: "el")
	end

	def diff_fsharp(old, new)
		diff_strings(old, new, file_extension: "fs")
	end

	def diff_gleam(old, new)
		diff_strings(old, new, file_extension: "gleam")
	end

	def diff_go(old, new)
		diff_strings(old, new, file_extension: "go")
	end

	def diff_hack(old, new)
		diff_strings(old, new, file_extension: "hack")
	end

	def diff_hare(old, new)
		diff_strings(old, new, file_extension: "ha")
	end

	def diff_haskell(old, new)
		diff_strings(old, new, file_extension: "hs")
	end

	def diff_janet(old, new)
		diff_strings(old, new, file_extension: "janet")
	end

	def diff_java(old, new)
		diff_strings(old, new, file_extension: "java")
	end

	def diff_javascript(old, new)
		diff_strings(old, new, file_extension: "js")
	end

	def diff_jsx(old, new)
		diff_strings(old, new, file_extension: "jsx")
	end

	def diff_julia(old, new)
		diff_strings(old, new, file_extension: "jl")
	end

	def diff_kotlin(old, new)
		diff_strings(old, new, file_extension: "kt")
	end

	def diff_lua(old, new)
		diff_strings(old, new, file_extension: "lua")
	end

	def diff_make(old, new)
		diff_strings(old, new, file_extension: "mk")
	end

	def diff_nix(old, new)
		diff_strings(old, new, file_extension: "nix")
	end

	def diff_objc(old, new)
		diff_strings(old, new, file_extension: "m")
	end

	def diff_ocaml(old, new)
		diff_strings(old, new, file_extension: "ml")
	end

	def diff_perl(old, new)
		diff_strings(old, new, file_extension: "pl")
	end

	def diff_php(old, new)
		diff_strings(old, new, file_extension: "php")
	end

	def diff_python(old, new)
		diff_strings(old, new, file_extension: "py")
	end

	def diff_qml(old, new)
		diff_strings(old, new, file_extension: "qml")
	end

	def diff_r(old, new)
		diff_strings(old, new, file_extension: "r")
	end

	def diff_racket(old, new)
		diff_strings(old, new, file_extension: "rkt")
	end

	def diff_ruby(old, new)
		diff_strings(old, new, file_extension: "rb")
	end

	def diff_rust(old, new)
		diff_strings(old, new, file_extension: "rs")
	end

	def diff_scala(old, new)
		diff_strings(old, new, file_extension: "scala")
	end

	def diff_scheme(old, new)
		diff_strings(old, new, file_extension: "scm")
	end

	def diff_smali(old, new)
		diff_strings(old, new, file_extension: "smali")
	end

	def diff_solidity(old, new)
		diff_strings(old, new, file_extension: "sol")
	end

	def diff_sql(old, new)
		diff_strings(old, new, file_extension: "sql")
	end

	def diff_swift(old, new)
		diff_strings(old, new, file_extension: "swift")
	end

	def diff_typescript(old, new)
		diff_strings(old, new, file_extension: "ts")
	end

	def diff_tsx(old, new)
		diff_strings(old, new, file_extension: "tsx")
	end

	def diff_vhdl(old, new)
		diff_strings(old, new, file_extension: "vhdl")
	end

	def diff_zig(old, new)
		diff_strings(old, new, file_extension: "zig")
	end

	def diff_css(old, new)
		diff_strings(old, new, file_extension: "css")
	end

	def diff_hcl(old, new)
		diff_strings(old, new, file_extension: "hcl")
	end

	def diff_html(old, new)
		diff_strings(old, new, file_extension: "html")
	end

	def diff_json(old, new)
		diff_strings(old, new, file_extension: "json")
	end

	def diff_latex(old, new)
		diff_strings(old, new, file_extension: "tex")
	end

	def diff_newick(old, new)
		diff_strings(old, new, file_extension: "newick")
	end

	def diff_scss(old, new)
		diff_strings(old, new, file_extension: "scss")
	end

	def diff_toml(old, new)
		diff_strings(old, new, file_extension: "toml")
	end

	def diff_xml(old, new)
		diff_strings(old, new, file_extension: "xml")
	end

	def diff_yaml(old, new)
		diff_strings(old, new, file_extension: "yaml")
	end

	def diff_strings(old, new, file_extension: nil)
		old_file = Tempfile.new(["old", ".#{file_extension}"])
		new_file = Tempfile.new(["new", ".#{file_extension}"])

		old_file.write(old)
		new_file.write(new)

		old_file.close
		new_file.close

		diff_files(old_file, new_file)
	ensure
		old_file.unlink
		new_file.unlink
	end

	def diff_files(old_file, new_file)
		options = [
			(old_file.path),
			(new_file.path),
			("--color=#{@color}" if @color),
			("--context=#{@context}" if @context),
			("--background=#{@background}" if @background),
			("--syntax-highlight=#{@syntax_highlight}" if @syntax_highlight),
			("--tab-width=#{@tab_width}" if @tab_width),
		].compact!

		result = Difftastic.execute(options.join(" "))

		unless @show_paths
			new_line_index = result.index("\n") + 1
			result = result.byteslice(new_line_index, result.bytesize - new_line_index)
		end

		# Removed due to inconsistencies in the original output. Need to improve the pattern matching.
		# if @underline_highlights
		# 	result.gsub!(/\e\[([0-9;]*)m/) {
		# 		codes = $1
		# 		if codes =~ /9[12];1|1;9[12]/ # Matches 91;1, 92;1, 1;91, or 1;92
		# 			"\e[#{codes};4m"
		# 		else
		# 			"\e[#{codes}m"
		# 		end
		# 	}
		# end

		result
	end
end

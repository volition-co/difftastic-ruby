# frozen_string_literal: true

test "sets are sorted" do
	object = Set[2, 3, 1]

	assert_equal Difftastic.pretty(object), <<~RUBY.chomp
		Set[
			1,
			2,
			3,
		]
	RUBY
end

test "nested hashes" do
	object = {
		foo: {
			bar: {
				baz: 1,
			},
		},
	}

	assert_equal Difftastic.pretty(object), <<~RUBY.chomp
		{
			:foo => {
				:bar => {
					:baz => 1,
				},
			},
		}
	RUBY
end

test "nested arrays" do
	object = [
		[
			1,
			2,
		],
		[
			3,
			4,
		],
	]

	assert_equal Difftastic.pretty(object), <<~RUBY.chomp
		[
			[
				1,
				2,
			],
			[
				3,
				4,
			],
		]
	RUBY
end

test "module and class" do
	assert_equal Difftastic.pretty([Difftastic, Integer]), <<~RUBY.chomp
		[
			Difftastic,
			Integer,
		]
	RUBY
end

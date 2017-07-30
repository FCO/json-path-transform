use JSON::Path;

multi jp-single(Str $jp, $data) {
	JSON::Path.new($jp).value: $data
}

multi jp-multi(Str $jp, $data) {
	JSON::Path.new($jp).values: $data
}
multi is-json-path($str --> False) {}

multi is-json-path(Str $str --> Bool()) {
	get-json-path $str
}

sub get-json-path(Str $str --> Match) {
	$str ~~ /^ \s* '$' | "{" ~ "}" [\s* '$']/
}

proto jpt($a, $b) {
	#dd [$a, $b];
	my $resp = {*}
	#dd $resp;
	$resp
}
multi jpt(Nil, $ --> Nil)                      is export {Nil}
multi jpt(% where *.elems == 0, $)             is export {{}}
multi jpt(@ where *.elems == 0, $)             is export {[]}
multi jpt($undef where not *.DEFINITE, $)      is export {$undef}
multi jpt(Numeric $i, $)                       is export {$i}
multi jpt(Str $i where {!.&is-json-path}, $)   is export {$i}
multi jpt(Promise $i, $data)                   is export {jpt await($i), $data}
multi jpt($i, Promise $data)                   is export {jpt $i, await $data}

multi jpt(["...", *@arr], $data) is export {
	|jpt(@arr, $data)
}

multi jpt(@arr ($ where {$_ !~~ Str or !.&is-json-path}, *@), $data) is export {
	@arr.map(-> $item {jpt $item, $data}).Array
}

multi jpt(Str $i, $data) is export {
	jp-single($i, $data)
}

multi jpt([$jp where {.&is-json-path}], $data) is export {
	jp-multi($jp, $data).Array
}

multi jpt([$jp where {.&is-json-path}, $tmpl], $data) is export {
	my @items = jp-multi($jp, $data);
	(@items.map: -> $item { jpt $tmpl, $item }).Array
}

multi jpt(%hash where .keys.none.&is-json-path, $data) is export {
	%(%hash.kv.map: -> $key, $value {$key => jpt $value, $data})
}

#`<<<
	{
		"$.a.b:$.name": "$.value"
	}
>>>

multi jpt(%hash, $data) is export {
	my %ret;
	for %hash.kv -> Str $key, $value {
		if $key ~~ /'$'/ {
			my ($jp, $jpkey) = $key.split: /\s* ":" \s*/;
			my @items = jp-multi($jp, $data);
			for @items -> $item {
				my $k = jp-single($jpkey, $item);
				%ret{ $k } = jpt $value, $item
			}
		} else {
			%ret{$key} = $value
		}
	}
	%ret
}


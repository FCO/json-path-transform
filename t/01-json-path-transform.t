use SixPM;
use lib "lib";
use JSON::Path::Transform;
use Test;

subtest "Empty object", {
	is-deeply jpt({}, Nil),                 {}, "return a empty hash if it was passed a empty hash";
	is-deeply jpt({}, ""),                  {}, "return a empty hash if it was passed a empty hash";
	is-deeply jpt({}, {}),                  {}, "return a empty hash if it was passed a empty hash";
	is-deeply jpt({}, []),                  {}, "return a empty hash if it was passed a empty hash";
	is-deeply jpt({}, Pair.new("bla", 42)), {}, "return a empty hash if it was passed a empty hash";
}

subtest "Emprty array", {
	is-deeply jpt([], Nil),                 [], "return a empty array if it was passed a empty array";
	is-deeply jpt([], ""),                  [], "return a empty array if it was passed a empty array";
	is-deeply jpt([], {}),                  [], "return a empty array if it was passed a empty array";
	is-deeply jpt([], []),                  [], "return a empty array if it was passed a empty array";
	is-deeply jpt([], Pair.new("bla", 42)), [], "return a empty array if it was passed a empty array";
}

#subtest "Nil", {
#	is-deeply jpt(Nil, Nil),                 Nil, "return a Nil if it was passed Nil";
#	is-deeply jpt(Nil, ""),                  Nil, "return a Nil if it was passed Nil";
#	is-deeply jpt(Nil, {}),                  Nil, "return a Nil if it was passed Nil";
#	is-deeply jpt(Nil, []),                  Nil, "return a Nil if it was passed Nil";
#	is-deeply jpt(Nil, Pair.new("bla", 42)), Nil, "return a Nil if it was passed Nil";
#}

subtest "Numeric", {
	is-deeply jpt(42, Nil),                 42,   "return the same Numeric if it was passed a Numeric";
	is-deeply jpt(3.14, ""),                3.14, "return the same Numeric if it was passed a Numeric";
	is-deeply jpt(-13, {}),                 -13,  "return the same Numeric if it was passed a Numeric";
	is-deeply jpt(10/3, []),                10/3, "return the same Numeric if it was passed a Numeric";
	is-deeply jpt(42, Pair.new("bla", 42)), 42,   "return the same Numeric if it was passed a Numeric";
}

subtest "Str", {
	is-deeply jpt("string", Nil),                 "string", "return the same Str if it was passed a Str without \$";
	is-deeply jpt("string", ""),                  "string", "return the same Str if it was passed a Str without \$";
	is-deeply jpt("string", {}),                  "string", "return the same Str if it was passed a Str without \$";
	is-deeply jpt("string", []),                  "string", "return the same Str if it was passed a Str without \$";
	is-deeply jpt("string", Pair.new("bla", 42)), "string", "return the same Str if it was passed a Str without \$";
}

subtest "Array", {
	is-deeply jpt(["string", 42, [], {}], Nil),                 ["string", 42, [], {}],
	   "return the same Array if it was passed a Array that doesnt start with a Str that contains \$"
	;
	is-deeply jpt(["string", 42, [], {}], ""),                  ["string", 42, [], {}],
	   "return the same Array if it was passed a Array that doesnt start with a Str that contains \$"
	;
	is-deeply jpt(["string", 42, [], {}], {}),                  ["string", 42, [], {}],
	   "return the same Array if it was passed a Array that doesnt start with a Str that contains \$"
	;
	is-deeply jpt(["string", 42, [], {}], []),                  ["string", 42, [], {}],
	   "return the same Array if it was passed a Array that doesnt start with a Str that contains \$"
	;
	is-deeply jpt(["string", 42, [], {}], Pair.new("bla", 42)), ["string", 42, [], {}],
	   "return the same Array if it was passed a Array that doesnt start with a Str that contains \$"
	;
	is-deeply jpt([["string", 42, [], {}],], {}), [["string", 42, [], {}],],
	   "return the same Array if it was passed a Array that doesnt start with a Str that contains \$"
	;
	is-deeply jpt([["...", "string", 42, [], {}],], {}), ["string", 42, [], {}], "return a slip" ;
}

subtest "JSON::Path", {
	is-deeply jpt('$.a.b',   {a => {b => 42}}),            42,               "return the json-path value";
	is-deeply jpt('$.a.b',   {a => {b => [42, 13, 111]}}), [42, 13, 111],    "return the json-path value";
	is-deeply jpt(['$.a.b'], {a => {b => 42}}),            [42],             "return the json-path value";
	is-deeply jpt(['$.a.b'], {a => {b => [42, 13, 111]}}), [[42, 13, 111],], "return the json-path value";
}

subtest "advanced", {
	is-deeply jpt({key => '$.a.b'}, {a => {b => 42}}), {key => 42}, "return the json-path value";
	is-deeply jpt(['$..a', {bla => '$.num'}], [{a => {num => 42}}, {a => {num => 43}}]), [{bla => 42}, {bla => 43}], "return the json-path value";
	is-deeply jpt([['...', '$..a', {bla => '$.num'}],], [{a => {num => 42}}, {a => {num => 43}}]), [{bla => 42}, {bla => 43}], "return the json-path value";
	is-deeply jpt({'$..a:$.name' => {bla => '$.num'}}, [{a => {name => "a", num => 42}}, {a => {name => "b", num => 43}}]), {a => {bla => 42}, b => {bla => 43}}, "return the json-path value";
}

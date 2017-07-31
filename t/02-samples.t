use SixPM;
use lib "lib";
use JSON::Path::Transform;
use Test;

my @tests := [
	{
		template => {
			'$.prices[*]:$.name'	=> {
				price	=> '$.price'
			},
			'$.prices[*]:$.name'		=> {
				desc	=> '$.price'
			},
		},
		data => {
			prices => [
				{
					name	=> "a",
					price	=> 12
				},
				{
					name	=> "b",
					price	=> 13
				}
			],
			descs => [
				{
					name	=> "a",
					desc	=> "aaa"
				}
			]
		},
		answer => {
			a => {
				price	=> 12,
				desc	=> "aaa"
			},
			b => {
				price	=> 13
			},
		}
	},
];

for @tests -> %test {
	#dd %test;
	is-deeply jpt(%test<template>, %test<data>), %test<answer>
}

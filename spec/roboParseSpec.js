var PEG = require('pegjs');
var assert = require('chai').assert;
var mocha = require('mocha');
var fs = require('fs'); // for loading files

var data = fs.readFileSync('../peg/robo.peg', 'utf-8');
// Show the PEG grammar file
// console.log(data);
// Create my parser
var parse = PEG.buildParser(data).parse;

assert.deepEqual(parse("fire"), ["fire"]);

suite('Basic commands', function() {
  test('move', function(){
    assert.deepEqual(
      parse("move"), ["move"]
    );
  });
  test('left', function(){
    assert.deepEqual(
      parse("left"), ["left"]
    );
  });
  test('right', function(){
    assert.deepEqual(
      parse("right"), ["right"]
    );
  });
  test('fire', function(){
    assert.deepEqual(
      parse("fire"), ["fire"]
    );
  });
  test('idle', function(){
    assert.deepEqual(
      parse("idle"), ["idle"]
    );
  });
});

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

suite('Mathematical Expressions', function() {
  test('addition', function(){
    assert.deepEqual(
      parse("3 + 7"), [['+', 3, 7]]
    );
  });
  test('addition', function(){
    assert.deepEqual(
      parse("3 + 7"), [['+', 3, 7]]
    );
  });
  test('subtraction', function(){
    assert.deepEqual(
      parse("13 - 7"), [['-', 13, 7]]
    );
  });
  test('mutliplication', function(){
    assert.deepEqual(
      parse("7 * 8"), [['*', 7, 8]]
    );
  });
  test('division', function(){
    assert.deepEqual(
      parse("2000 / 8"), [['/', 2000, 8]]
    );
  });
  test('order of operations', function(){
    assert.deepEqual(
      parse("27 / 3 + 7 * 8"), [['+', ['/', 27, 3], ['*', 7, 8]]]
    );
  });
  test('nested operation', function(){
    assert.deepEqual(
      parse("103 * 5 - 2 + 10 / 5"), [['-', ['*', 103, 5], ['+', 2, ['/', 10, 5]]]]
    );
  });
});



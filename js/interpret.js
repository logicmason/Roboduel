// Generated by CoffeeScript 1.4.0
(function() {

  window.roboEval = function(expr, env) {
    var item, _i, _len, _results;
    if (env == null) {
      env = {};
    }
    if (typeof expr === 'number') {
      return expr;
    }
    if (typeof expr === 'string') {
      return env[expr];
    }
    if (Object.prototype.toString.call(expr[0]) === '[object Array]') {
      if (expr.length === 1) {
        return roboEval(expr[0], env);
      } else {
        for (_i = 0, _len = expr.length; _i < _len; _i++) {
          item = expr[_i];
          console.log(item);
          roboEval(item, env);
        }
      }
    }
    switch (expr[0]) {
      case 'set':
        env[expr[1]] = roboEval(expr[2], env);
        return 0;
      case '=':
        if (roboEval(expr[1], env) === roboEval(expr[2], env)) {
          return '#t';
        } else {
          return '#f';
        }
        break;
      case '<':
        if (roboEval(expr[1], env) < roboEval(expr[2], env)) {
          return '#t';
        } else {
          return '#f';
        }
        break;
      case '>':
        if (roboEval(expr[1], env) > roboEval(expr[2], env)) {
          return '#t';
        } else {
          return '#f';
        }
        break;
      case '*':
        return roboEval(expr[1], env) * roboEval(expr[2], env);
      case '/':
        return roboEval(expr[1], env) / roboEval(expr[2], env);
      case '+':
        return roboEval(expr[1], env) + roboEval(expr[2], env);
      case '-':
        return roboEval(expr[1], env) - roboEval(expr[2], env);
      case 'check':
        if (roboEval(expr[1], env) === '#t') {
          return roboEval(expr[2], env);
        } else if ('#f') {
          return roboEval(expr[3], env);
        }
        break;
      case 'both':
        roboEval(expr[1], env);
        return roboEval(expr[2], env);
      case 'until':
        _results = [];
        while (roboEval(expr[1], env) === '#f') {
          roboEval(expr[2], env);
          _results.push(console.log(expr));
        }
        return _results;
    }
  };

}).call(this);
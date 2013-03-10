window.roboEval = (expr, env={})->
  return expr if (typeof expr == 'number')
  return env[expr] if (typeof expr == 'string')

  switch (expr[0])
    when 'set'
      env[expr[1]] = roboEval(expr[2], env)
      0
    when '='
      if (roboEval(expr[1], env) == roboEval(expr[2], env))
        return '#t'
      else
        return '#f'
    when '<'
      if (roboEval(expr[1], env) < roboEval(expr[2], env))
        return '#t'
      else
        return '#f'
    when '>'
      if (roboEval(expr[1], env) > roboEval(expr[2], env))
        return '#t'
      else
        return '#f'
    when '*' then roboEval(expr[1], env) * roboEval(expr[2], env)
    when '/' then roboEval(expr[1], env) / roboEval(expr[2], env)
    when '+' then roboEval(expr[1], env) + roboEval(expr[2], env)
    when '-' then roboEval(expr[1], env) - roboEval(expr[2], env)
    when 'check'
      if roboEval(expr[1], env) == '#t'
        roboEval(expr[2], env)
      else if '#f'
        roboEval(expr[3], env)
    when 'both'
      roboEval(expr[1], env)
      roboEval(expr[2], env)
    when repeat
      while (roboEval(expr[1]) == '#t')
        roboEval(expr[2])


/* Generated by Opal 0.8.0.beta1 */
(function(Opal) {
  Opal.dynamic_require_severity = "error";
  function $rb_ge(lhs, rhs) {
    return (typeof(lhs) === 'number' && typeof(rhs) === 'number') ? lhs >= rhs : lhs['$>='](rhs);
  }
  function $rb_plus(lhs, rhs) {
    return (typeof(lhs) === 'number' && typeof(rhs) === 'number') ? lhs + rhs : lhs['$+'](rhs);
  }
  function $rb_lt(lhs, rhs) {
    return (typeof(lhs) === 'number' && typeof(rhs) === 'number') ? lhs < rhs : lhs['$<'](rhs);
  }
  function $rb_gt(lhs, rhs) {
    return (typeof(lhs) === 'number' && typeof(rhs) === 'number') ? lhs > rhs : lhs['$>'](rhs);
  }
  function $rb_divide(lhs, rhs) {
    return (typeof(lhs) === 'number' && typeof(rhs) === 'number') ? lhs / rhs : lhs['$/'](rhs);
  }
  function $rb_minus(lhs, rhs) {
    return (typeof(lhs) === 'number' && typeof(rhs) === 'number') ? lhs - rhs : lhs['$-'](rhs);
  }
  function $rb_times(lhs, rhs) {
    return (typeof(lhs) === 'number' && typeof(rhs) === 'number') ? lhs * rhs : lhs['$*'](rhs);
  }
  var $a, $b, TMP_17, self = Opal.top, $scope = Opal, nil = Opal.nil, $breaker = Opal.breaker, $slice = Opal.slice, $klass = Opal.klass, $hash2 = Opal.hash2, $range = Opal.range, max = nil, pixel = nil, num_bits = nil, p_crossover = nil, p_mutation = nil, genetic = nil;

  Opal.add_stubs(['$attr_reader', '$attr_accessor', '$new', '$random_bitstring', '$num_bits', '$pop_size', '$each', '$[]=', '$onemax', '$[]', '$population', '$first', '$sort', '$<=>', '$binary_tournament', '$reproduce', '$p_crossover', '$p_mutation', '$sort!', '$puts', '$generation', '$times', '$==', '$max_gens', '$private', '$chr', '$size', '$inject', '$rand', '$each_with_index', '$modulo', '$crossover', '$point_mutation', '$<<', '$next_gen']);
  (function($base, $super) {
    function $Genetic(){};
    var self = $Genetic = $klass($base, $super, 'Genetic', $Genetic);

    var def = self.$$proto, $scope = self.$$scope;

    def.generation = nil;
    self.$attr_reader("num_bits");

    self.$attr_reader("max_gens");

    self.$attr_reader("pop_size");

    self.$attr_reader("p_crossover");

    self.$attr_reader("p_mutation");

    self.$attr_accessor("generation");

    self.$attr_accessor("population");

    def.$initialize = function($kwargs) {
      var $a, $b, TMP_1, self = this, _num_bits = nil, _max_gens = nil, _pop_size = nil, _p_crossover = nil, _p_mutation = nil;

      if ($kwargs == null) {
        $kwargs = $hash2([], {});
      }
      if (!$kwargs.$$is_hash) {
        throw Opal.ArgumentError.$new('expecting keyword args');
      }
      if ((_num_bits = $kwargs.smap['_num_bits']) == null) {
        _num_bits = 64
      }
      if ((_max_gens = $kwargs.smap['_max_gens']) == null) {
        _max_gens = 100
      }
      if ((_pop_size = $kwargs.smap['_pop_size']) == null) {
        _pop_size = 100
      }
      if ((_p_crossover = $kwargs.smap['_p_crossover']) == null) {
        throw new Error('expecting keyword arg: _p_crossover')
      }
      if ((_p_mutation = $kwargs.smap['_p_mutation']) == null) {
        throw new Error('expecting keyword arg: _p_mutation')
      }
      self.num_bits = _num_bits;
      self.max_gens = _max_gens;
      self.pop_size = _pop_size;
      self.p_crossover = _p_crossover;
      self.p_mutation = _p_mutation;
      self.generation = 0;
      return self.population = ($a = ($b = $scope.get('Array')).$new, $a.$$p = (TMP_1 = function(i){var self = TMP_1.$$s || this;
        if (i == null) i = nil;
        return $hash2(["bitstring"], {"bitstring": self.$random_bitstring(self.$num_bits())})}, TMP_1.$$s = self, TMP_1), $a).call($b, self.$pop_size());
    };

    def.$next_gen = function() {
      var $a, $b, TMP_2, $c, TMP_3, $d, TMP_4, $e, TMP_5, $f, TMP_6, self = this, best = nil, selected = nil, children = nil;

      ($a = ($b = self.$population()).$each, $a.$$p = (TMP_2 = function(c){var self = TMP_2.$$s || this;
        if (c == null) c = nil;
        return c['$[]=']("fitness", self.$onemax(c['$[]']("bitstring")))}, TMP_2.$$s = self, TMP_2), $a).call($b);
      best = ($a = ($c = self.$population()).$sort, $a.$$p = (TMP_3 = function(x, y){var self = TMP_3.$$s || this;
        if (x == null) x = nil;if (y == null) y = nil;
        return y['$[]']("fitness")['$<=>'](x['$[]']("fitness"))}, TMP_3.$$s = self, TMP_3), $a).call($c).$first();
      selected = ($a = ($d = $scope.get('Array')).$new, $a.$$p = (TMP_4 = function(i){var self = TMP_4.$$s || this;
        if (i == null) i = nil;
        return self.$binary_tournament(self.$population())}, TMP_4.$$s = self, TMP_4), $a).call($d, self.$pop_size());
      children = self.$reproduce(selected, self.$pop_size(), self.$p_crossover(), self.$p_mutation());
      ($a = ($e = children).$each, $a.$$p = (TMP_5 = function(c){var self = TMP_5.$$s || this;
        if (c == null) c = nil;
        return c['$[]=']("fitness", self.$onemax(c['$[]']("bitstring")))}, TMP_5.$$s = self, TMP_5), $a).call($e);
      ($a = ($f = children)['$sort!'], $a.$$p = (TMP_6 = function(x, y){var self = TMP_6.$$s || this;
        if (x == null) x = nil;if (y == null) y = nil;
        return y['$[]']("fitness")['$<=>'](x['$[]']("fitness"))}, TMP_6.$$s = self, TMP_6), $a).call($f);
      if ($rb_ge(children.$first()['$[]']("fitness"), best['$[]']("fitness"))) {
        best = children.$first()};
      self.population = children;
      self.$puts(" > gen " + (self.$generation()) + ", best: " + (best['$[]']("fitness")) + ", " + (best['$[]']("bitstring")));
      self.generation = $rb_plus(self.generation, 1);
      return best;
    };

    def.$search = function() {
      var $a, $b, TMP_7, $c, TMP_8, $d, TMP_9, self = this, best = nil;

      ($a = ($b = self.$population()).$each, $a.$$p = (TMP_7 = function(c){var self = TMP_7.$$s || this;
        if (c == null) c = nil;
        return c['$[]=']("fitness", self.$onemax(c['$[]']("bitstring")))}, TMP_7.$$s = self, TMP_7), $a).call($b);
      best = ($a = ($c = self.$population()).$sort, $a.$$p = (TMP_8 = function(x, y){var self = TMP_8.$$s || this;
        if (x == null) x = nil;if (y == null) y = nil;
        return y['$[]']("fitness")['$<=>'](x['$[]']("fitness"))}, TMP_8.$$s = self, TMP_8), $a).call($c).$first();
      ($a = ($d = self.$max_gens()).$times, $a.$$p = (TMP_9 = function(gen){var self = TMP_9.$$s || this, $a, $b, TMP_10, $c, TMP_11, $d, TMP_12, selected = nil, children = nil, population = nil;
        if (gen == null) gen = nil;
        selected = ($a = ($b = $scope.get('Array')).$new, $a.$$p = (TMP_10 = function(i){var self = TMP_10.$$s || this;
          if (i == null) i = nil;
          return self.$binary_tournament(self.$population())}, TMP_10.$$s = self, TMP_10), $a).call($b, self.$pop_size());
        children = self.$reproduce(selected, self.$pop_size(), self.$p_crossover(), self.$p_mutation());
        ($a = ($c = children).$each, $a.$$p = (TMP_11 = function(c){var self = TMP_11.$$s || this;
          if (c == null) c = nil;
          return c['$[]=']("fitness", self.$onemax(c['$[]']("bitstring")))}, TMP_11.$$s = self, TMP_11), $a).call($c);
        ($a = ($d = children)['$sort!'], $a.$$p = (TMP_12 = function(x, y){var self = TMP_12.$$s || this;
          if (x == null) x = nil;if (y == null) y = nil;
          return y['$[]']("fitness")['$<=>'](x['$[]']("fitness"))}, TMP_12.$$s = self, TMP_12), $a).call($d);
        if ($rb_ge(children.$first()['$[]']("fitness"), best['$[]']("fitness"))) {
          best = children.$first()};
        population = children;
        self.$puts(" > gen " + (gen) + ", best: " + (best['$[]']("fitness")) + ", " + (best['$[]']("bitstring")));
        if (best['$[]']("fitness")['$=='](self.$num_bits())) {
          return ($breaker.$v = nil, $breaker)
        } else {
          return nil
        };}, TMP_9.$$s = self, TMP_9), $a).call($d);
      return best;
    };

    self.$private();

    def.$onemax = function(bitstring) {
      var $a, $b, TMP_13, self = this, sum = nil;

      sum = 0;
      ($a = ($b = bitstring.$size()).$times, $a.$$p = (TMP_13 = function(i){var self = TMP_13.$$s || this;
        if (i == null) i = nil;
        if (bitstring['$[]'](i).$chr()['$==']("1")) {
          return sum = $rb_plus(sum, 1)
        } else {
          return nil
        }}, TMP_13.$$s = self, TMP_13), $a).call($b);
      return sum;
    };

    def.$random_bitstring = function(num_bits) {
      var $a, $b, TMP_14, self = this;

      return ($a = ($b = ($range(0, num_bits, true))).$inject, $a.$$p = (TMP_14 = function(s, i){var self = TMP_14.$$s || this, $a;
        if (s == null) s = nil;if (i == null) i = nil;
        return s = $rb_plus(s, ((function() {if ((($a = ($rb_lt(self.$rand(), 0.5))) !== nil && (!$a.$$is_boolean || $a == true))) {
          return "1"
        } else {
          return "0"
        }; return nil; })()))}, TMP_14.$$s = self, TMP_14), $a).call($b, "");
    };

    def.$binary_tournament = function(pop) {
      var $a, self = this, i = nil, j = nil;

      $a = [self.$rand(pop.$size()), self.$rand(pop.$size())], i = $a[0], j = $a[1];
      while (j['$=='](i)) {
        j = self.$rand(pop.$size())};
      return (function() {if ((($a = ($rb_gt(pop['$[]'](i)['$[]']("fitness"), pop['$[]'](j)['$[]']("fitness")))) !== nil && (!$a.$$is_boolean || $a == true))) {
        return pop['$[]'](i)
      } else {
        return pop['$[]'](j)
      }; return nil; })();
    };

    def.$point_mutation = function(bitstring, rate) {
      var $a, $b, TMP_15, self = this, child = nil;

      if (rate == null) {
        rate = $rb_divide(1, bitstring.$size())
      }
      child = "";
      ($a = ($b = bitstring.$size()).$times, $a.$$p = (TMP_15 = function(i){var self = TMP_15.$$s || this, $a, bit = nil;
        if (i == null) i = nil;
        bit = bitstring['$[]'](i).$chr();
        return child = $rb_plus(child, ((function() {if ((($a = ($rb_lt(self.$rand(), rate))) !== nil && (!$a.$$is_boolean || $a == true))) {
          return ((function() {if ((($a = (bit['$==']("1"))) !== nil && (!$a.$$is_boolean || $a == true))) {
            return "0"
          } else {
            return "1"
          }; return nil; })())
        } else {
          return bit
        }; return nil; })()));}, TMP_15.$$s = self, TMP_15), $a).call($b);
      return child;
    };

    def.$crossover = function(parent1, parent2, rate) {
      var self = this, point = nil;

      if ($rb_ge(self.$rand(), rate)) {
        return $rb_plus("", parent1)};
      point = $rb_plus(1, self.$rand($rb_minus(parent1.$size(), 2)));
      return $rb_plus(parent1['$[]']($range(0, point, true)), parent2['$[]']($range(point, (parent1.$size()), true)));
    };

    return (def.$reproduce = function(selected, pop_size, p_cross, p_mutation) {
        var $a, $b, TMP_16, self = this, children = nil;

        children = [];
        ($a = ($b = selected).$each_with_index, $a.$$p = (TMP_16 = function(p1, i){var self = TMP_16.$$s || this, $a, p2 = nil, child = nil;
          if (p1 == null) p1 = nil;if (i == null) i = nil;
          p2 = (function() {if ((($a = (i.$modulo(2)['$=='](0))) !== nil && (!$a.$$is_boolean || $a == true))) {
            return selected['$[]']($rb_plus(i, 1))
          } else {
            return selected['$[]']($rb_minus(i, 1))
          }; return nil; })();
          if (i['$==']($rb_minus(selected.$size(), 1))) {
            p2 = selected['$[]'](0)};
          child = $hash2([], {});
          child['$[]=']("bitstring", self.$crossover(p1['$[]']("bitstring"), p2['$[]']("bitstring"), p_cross));
          child['$[]=']("bitstring", self.$point_mutation(child['$[]']("bitstring"), p_mutation));
          children['$<<'](child);
          if ($rb_ge(children.$size(), pop_size)) {
            return ($breaker.$v = nil, $breaker)
          } else {
            return nil
          };}, TMP_16.$$s = self, TMP_16), $a).call($b);
        return children;
      }, nil) && 'reproduce';
  })(self, null);
  max = 1;
  pixel = 50;
  num_bits = $rb_divide($rb_times($rb_divide(300, pixel), 300), pixel);
  p_crossover = 0.98;
  p_mutation = $rb_times($rb_divide(1, num_bits), 1.5);
  genetic = $scope.get('Genetic').$new($hash2(["_num_bits", "_p_crossover", "_p_mutation"], {"_num_bits": num_bits, "_p_crossover": p_crossover, "_p_mutation": p_mutation}));
  return ($a = ($b = ($range(0, max, false))).$each, $a.$$p = (TMP_17 = function(){var self = TMP_17.$$s || this;

    return genetic.$next_gen()}, TMP_17.$$s = self, TMP_17), $a).call($b);
})(Opal);

// Generated by CoffeeScript 2.3.1
(function() {
  var clone, merge, set_modifier, set_quantity, set_separator;

  require('../../pegex/tree');

  require('../../pegex/grammar/atoms');

  Pegex.Pegex.AST = class AST extends Pegex.Tree {
    constructor(...args) {
      super(...args);
      this.atoms = (new Pegex.Grammar.Atoms).atoms;
      this.extra_rules = {};
    }

    got_grammar(got) {
      var grammar, i, key, len, meta_section, rule, rule_section, value;
      [meta_section, rule_section] = got;
      grammar = merge({
        '+toprule': this.toprule
      }, this.extra_rules, meta_section);
      for (i = 0, len = rule_section.length; i < len; i++) {
        rule = rule_section[i];
        for (key in rule) {
          value = rule[key];
          grammar[key] = value;
        }
      }
      return grammar;
    }

    got_meta_section(got) {
      var i, key, len, meta, next, old, val;
      meta = {};
      for (i = 0, len = got.length; i < len; i++) {
        next = got[i];
        if (next === '') {
          continue;
        }
        [key, val] = next;
        key = `+${key}`;
        old = meta[key];
        if (old != null) {
          if (typeof old === 'object') {
            old.push(val);
          } else {
            meta[key] = [old, val];
          }
        } else {
          meta[key] = val;
        }
      }
      return meta;
    }

    got_rule_definition(got) {
      var name, ret, value;
      [name, value] = got;
      name = name.replace(/-/g, '_');
      if (name === 'TOP') {
        this.toprule = name;
      }
      this.toprule || (this.toprule = name);
      ret = {};
      ret[name] = value;
      return ret;
    }

    got_bracketed_group(got) {
      var group, prefix, suffix;
      [prefix, group, suffix] = got;
      set_modifier(group, prefix);
      set_quantity(group, suffix);
      return group;
    }

    got_all_group(got) {
      var list;
      list = this.get_group(got);
      if (!list.length) {
        throw 0;
      }
      if (list.length === 1) {
        return list[0];
      }
      return {
        '.all': list
      };
    }

    got_any_group(got) {
      var list;
      list = this.get_group(got);
      if (!list.length) {
        throw 0;
      }
      if (list.length === 1) {
        return list[0];
      }
      return {
        '.any': list
      };
    }

    get_group(group) {
      var get;
      get = function(it) {
        var a, i, len, x;
        if (typeof it !== 'object') {
          return [];
        }
        if (it instanceof Array) {
          a = [];
          for (i = 0, len = it.length; i < len; i++) {
            x = it[i];
            a.push(...(get(x)));
          }
          return a;
        } else {
          return [it];
        }
      };
      return [...(get(group))];
    }

    got_rule_part(got) {
      var rule, sep;
      [rule, sep] = got;
      if (sep.length) {
        rule = set_separator(rule, ...sep);
      }
      return rule;
    }

    got_rule_reference(got) {
      var node, prefix, ref, ref1, ref2, regex, suffix;
      [prefix, ref1, ref2, suffix] = got;
      ref = ref1 || ref2;
      ref = ref.replace(/-/g, '_');
      node = {
        '.ref': ref
      };
      if (regex = this.atoms[ref]) {
        this.extra_rules[ref] = {
          '.rgx': regex
        };
      }
      set_modifier(node, prefix);
      set_quantity(node, suffix);
      return node;
    }

    got_quoted_regex(got) {
      got = got.replace(/([^\w\`\%\:\<\/\,\=\;])/g, '\\$1');
      return {
        '.rgx': got
      };
    }

    got_regex_rule_reference(got) {
      var ref;
      ref = got[0] || got[1];
      return {
        '.ref': ref
      };
    }

    got_whitespace_maybe() {
      return {
        '.rgx': '<_>'
      };
    }

    got_whitespace_must() {
      return {
        '.rgx': '<__>'
      };
    }

    got_whitespace_start(got) {
      var rule;
      rule = got === '+' ? '__' : '_';
      return {
        '.rgx': `<${rule}>`
      };
    }

    got_regular_expression(got) {
      var e, i, len, part, ref3, regex, set;
      if (got.length === 2) {
        part = got.shift();
        got[0].unshift(part);
      }
      set = [];
      ref3 = got[0];
      for (i = 0, len = ref3.length; i < len; i++) {
        e = ref3[i];
        if (typeof e !== 'string') {
          if ((part = e['.rgx']) != null) {
            set.push(part);
          } else if ((part = e['.ref']) != null) {
            set.push(`<${part}>`);
          } else {
            throw e;
          }
        } else {
          e = e.replace(/\(([ism]?\:|\=|\!)/g, '(?$1');
          set.push(e);
        }
      }
      regex = set.join('');
      return {
        '.rgx': regex
      };
    }

    got_whitespace_token(got) {
      var token;
      if (got.match(/^\~{1,2}$/)) {
        token = {
          '.ref': Array(got.length).join('_')
        };
      } else if (got.match(/^\-{1,2}$/)) {
        token = {
          '.ref': Array(got.length).join('_')
        };
      } else if (got === '+') {
        token = {
          '.ref': '__'
        };
      } else {
        throw 0;
      }
      return token;
    }

    got_error_message(got) {
      return {
        '.err': got
      };
    }

  };

  set_modifier = function(object, modifier) {
    if (!modifier) {
      return;
    }
    if (modifier === '=') {
      return object['+asr'] = 1;
    } else if (modifier === '!') {
      return object['+asr'] = -1;
    } else if (modifier === '.') {
      return object['-skip'] = 1;
    } else if (modifier === '+') {
      return object['-wrap'] = 1;
    } else if (modifier === '-') {
      return object['-flat'] = 1;
    } else {
      throw `Invalid modifier: '${modifier}`;
    }
  };

  set_quantity = function(object, quantity) {
    if (!quantity) {
      return;
    }
    if (quantity === '?') {
      return object['+max'] = 1;
    } else if (quantity === '*') {
      return object['+min'] = 0;
    } else if (quantity === '+') {
      return object['+min'] = 1;
    } else if (quantity.match(/^(\d+)$/)) {
      object['+min'] = Number(RegExp.$1);
      return object['+max'] = Number(RegExp.$1);
    } else if (quantity.match(/^(\d+)\-(\d+)$/)) {
      object['+min'] = Number(RegExp.$1);
      return object['+max'] = Number(RegExp.$2);
    } else if (quantity.match(/^(\d+)\+$/)) {
      return object['+min'] = Number(RegExp.$1);
    } else {
      throw `Invalid quantifier: '${quantity}'`;
    }
  };

  set_separator = function(rule, op, sep) {
    var copy, extra, last, max, min, new_, s;
    extra = op === '%%';
    if ((rule['+max'] == null) && (rule['+min'] == null)) {
      if (extra) {
        rule = {
          '.all': [
            rule,
            merge(clone(sep),
            {
              '+max': 1
            })
          ]
        };
      }
      return rule;
    } else if ((rule['+max'] != null) && (rule['+min'] != null)) {
      [min, max] = rule;
      delete rule.min;
      delete rule.max;
      if (min > 0) {
        min--;
      }
      if (max > 0) {
        max--;
      }
      rule = {
        '.all': [
          rule,
          {
            '+min': min,
            '+max': max,
            '-flat': 1,
            '.all': [sep,
          clone(rule)]
          }
        ]
      };
    } else if (!rule['+max']) {
      copy = clone(rule);
      min = copy['+min'];
      delete copy['+min'];
      new_ = {
        '.all': [
          copy,
          {
            '+min': 0,
            '-flat': 1,
            '.all': [sep,
          clone(copy)]
          }
        ]
      };
      if (rule['+min'] === 0) {
        rule = new_;
        rule['+max'] = 1;
      } else if (rule['+min'] === 1) {
        rule = new_;
      } else {
        rule = new_;
        if (min > 0) {
          min--;
        }
        last = rule['.all'].length - 1;
        rule['.all'][last]['+min'] = min;
      }
    } else {
      if (rule['+max'] === 1) {
        delete rule['+min'];
        rule = clone(rule);
        rule['+max'] = 1;
        if (extra) {
          s = clone(sep);
          s['+max'] = 1;
          rule = {
            '.all': [rule, s]
          };
        }
        return rule;
      } else {
        xxx('FAIL', rule, op, sep);
      }
    }
    if (extra) {
      s = clone(sep);
      s['+max'] = 1;
      push(rule['.all'].push(s));
    }
    return rule;
  };

  clone = function(o) {
    var c, k, v;
    if (!(o || typeof o === 'object')) {
      return o;
    }
    c = new o.constructor();
    for (k in o) {
      v = o[k];
      c[k] = clone(v);
    }
    return c;
  };

  merge = function(object, ...rest) {
    var hash, i, k, len, v;
    for (i = 0, len = rest.length; i < len; i++) {
      hash = rest[i];
      for (k in hash) {
        v = hash[k];
        object[k] = v;
      }
    }
    return object;
  };

}).call(this);

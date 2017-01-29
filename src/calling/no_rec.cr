module Calling
  module NoRec
    macro extended
      macro record_method(name, result, args = nil, &block)
        \{%
          name = name.id
        \%}

        \{% if args %}
          def self.\{{name}}(
            \{% for k, v in args %}
              \{{k.id}} : \{{v}},
            \{% end %}
          )
            \{{block.body}}
          end
        \{% else %}
          def self.\{{name}}
            \{{block.body}}
          end
        \{% end %}
      end
    end
  end
end

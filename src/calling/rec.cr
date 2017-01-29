module Calling
  module Rec
    macro extended
      # :nodoc:
      macro record_method(name, result, args = nil, &block)
        \{% if result == :any %}
          \{%
            is_any = true
            result = "::Calling::Any".id
            result_name = "Calling_Any".id
          \%}
        \{% else %}
          \{%
            is_any = false
            result_name = result.class_name == "Path" ? result.resolve.name : result.name
            result_name = result_name.split("::").join("_").id
          \%}
        \{% end %}
        \{%
          name = name.id
          prefix = "__#{result_name}__#{name}__".id
          records = "@@#{prefix}__records".id
          call = "#{prefix}__call".id
        \%}

        def self.\{{name}}(klass : \{{result}}.class)
          \{{records}}
        end

        \{% if args %}
          \{{records}} = [] of ::NamedTuple(
            args: \{{args}},
            \{% if !is_any %}
              result: \{{result}}
            \{% end %}
          )

          def self.\{{call}}(
            \{% for k in args %}
              \{{k.id}},
            \{% end %}
          )
            \{{block.body}}
          end

          def self.\{{name}}(
            \{% for k, v in args %}
              \{{k.id}} : \{{v}},
            \{% end %}
          )
            result = \{{call}}(
              \{% for k in args %}
                \{{k.id}},
              \{% end %}
            )
            \{{records}} << {
              args: {
                \{% for k in args %}
                  \{{k.id}}: \{{k.id}}
                \{% end %}
              },
              \{% if !is_any %}
                result: result
              \{% end %}
            }
            result
          end
        \{% else %}
          \{{records}} = [] of ::NamedTuple(result: \{{result}})

          def self.\{{call}}
            \{{block.body}}
          end

          def self.\{{name}}
            result = \{{call}}
            \{{records}} << {result: result}
            result
          end
        \{% end %}
      end
    end
  end
end

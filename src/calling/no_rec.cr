module Calling
  module NoRec
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

        \{% if args %}
          def self.\{{name}}(klass : \{{result}}.class)
            [] of ::NamedTuple(
              args: \{{args}},
              \{% if !is_any %}
                result: \{{result}}
              \{% end %}
            )
          end

          def self.\{{name}}(
            \{% for k, v in args %}
              \{{k.id}} : \{{v}},
            \{% end %}
          )
            \{{block.body}}
          end
        \{% else %}
          def self.\{{name}}(klass : \{{result}}.class)
            [] of ::NamedTuple(result: \{{result}})
          end

          def self.\{{name}}
            \{{block.body}}
          end
        \{% end %}
      end
    end
  end
end

# Calling

A Crystal library for recording method calls. Especially useful for testing if a method is called.

[![Build Status](https://travis-ci.org/mosop/calling.svg?branch=master)](https://travis-ci.org/mosop/calling)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  calling:
    github: mosop/calling
```

<a name="code_samples"></a>

## Code Samples

### Recording Time.now

```crystal
module Recorded
  module Time
    extend Calling::Rec

    record_method :now, ::Time do
      ::Time.now
    end
  end
end

Recorded::Time.now # 2017-01-29 12:34:56 +0900
Recorded::Time.now(Time)[0][:result] # 2017-01-29 12:34:56 +0900
```

### Recording sleep

```crystal
module Recorded
  extend Calling::Rec

  record_method :sleep, :any, {seconds: Float64} do |seconds|
    ::sleep seconds
  end
end

Recorded.sleep 5_f64
Recorded.sleep(Calling::Any)[0][:args][:seconds] # 5.0
```

### Conditional Recording

```crystal
module Recorded
  {% if flag?(:test) %}
    extend Calling::Rec
  {% else %}
    extend Calling::NoRec
  {% end %}

  record_method :sleep, :any, {seconds: Float64} do
    ::sleep seconds
  end
end
```

Without the *test* flag, this code is just expanded like:

```crystal
module Recorded
  def self.sleep(seconds : Float64)
    ::sleep seconds
  end
end
```

## Defining Recording Methods

A recording method stores information about method calls.

To define recording methods, use the record_method macro.

record_method parameters:

* *name* (ASTNode) : A method name.
* *result* (TypeNode | Path) : A result type. It is needed for declaring a type of stored information.
* *args* (NamedTupleLiteral) : A set of argument names and types. It is needed for declaring a type of stored information.
* *&block* (Block) : A method body.

Currently, record_method only supports class methods.

## The Record Object

Record objects have information about method calls.

To access record objects, call a recording method with its corresponding result type. The result type is given by the second argument of the record_method macro.

Then you get a named tuple that has arrays of record objects by method names.

The record object is a named tuple that has the :args and :result values.

The :args value is a named tuple that has argument values by names.

The :result value is a value that a defined method returns.

### Any Result Type

If you don't want to intend a specific result type, set an :any symbol to the second argument of record_method. Then you can access record objects with the Calling::Any type.

If a result type is any, corresponding record objects don't have the :result value.

## Usage

```crystal
require "calling"
```

and see:

* [Code Samples](#code_samples)

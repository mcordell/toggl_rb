YARD::Logger.instance.show_progress = false

class MyHandler < YARD::Handlers::Ruby::Base
  handles method_call(:request_method)
  handles method_call(:request_path)
  handles method_call(:param)
  handles method_call(:query_param)
  namespace_only

  process do
    extra_state.in_endpoint_definition = true
    extra_state.endpoint_definition ||= {}
    meth = statement.method_name(true).to_s
    case meth
    when "request_method"
      extra_state.endpoint_definition["request_method"] = statement.parameters.first[0].source[1..].upcase
    when "request_path"
      extra_state.endpoint_definition["request_path"] = statement.parameters.first[0].source
    when "param", "query_param"
      begin
        extra_state.endpoint_definition[meth + "s"] ||= []
        doc = statement.parameters.jump(:assoc).parent.find do |x|
          /description/ =~ x.source
        end.children[1].source.gsub("\n", "").gsub("\\\"", "").gsub(/\s\s+/, "").gsub("\"", "")
        name = statement.parameters[0].first.first
        name = name.first until name.is_a? String
        type = statement.parameters[1].first.first
        type = type.first until type.is_a? String
        extra_state.endpoint_definition[meth + "s"].push(
          {
            name: name,
            type: type,
            doc: doc
          }
        )
      rescue StandardError => e
        require "pry"
        binding.pry
        puts e
      end
    end
  end
end

class MyHandler2 < YARD::Handlers::Ruby::MethodHandler
  handles(:def)
  process do
    return super() unless extra_state.in_endpoint_definition

    meth = statement.method_name(true).to_s
    args = format_args
    blk = statement.block
    nobj = namespace
    mscope = scope
    if statement.type == :defs
      raise YARD::Parser::UndocumentableError, "method defined on object instance" if statement[0][0].type == :ident

      nobj = P(namespace, statement[0].source) if statement[0][0].type == :const
      mscope = :class
    end

    nobj = P(namespace, nobj.value) while nobj.type == :constant
    obj = register MethodObject.new(nobj, meth, mscope) do |o|
      o.explicit = true
      o.parameters = args
    end

    endpoint = extra_state.endpoint_definition
    obj.docstring.replace("**Endpoint**: #{endpoint["request_method"]} #{endpoint["request_path"]} \n" + obj.docstring.all)
    endpoint.fetch("params", []).each do |p_def|
      obj.add_tag(
        YARD::Tags::OptionTag.new(:option,
                                  "params",
                                  YARD::Tags::DefaultTag.new(:option, p_def[:doc], p_def[:type], ":#{p_def[:name]}"))
      )
    end
    endpoint.fetch("query_params", []).each do |p_def|
      obj.add_tag(
        YARD::Tags::OptionTag.new(:option,
                                  "query_params",
                                  YARD::Tags::DefaultTag.new(:option, p_def[:doc], p_def[:type], ":#{p_def[:name]}"))
      )
    end
    # delete any aliases referencing old method
    if nobj.is_a?(NamespaceObject)
      nobj.aliases.each do |aobj, name|
        next unless name == obj.name

        nobj.aliases.delete(aobj)
      end
    end

    if obj.constructor?
      unless obj.has_tag?(:return)
        obj.add_tag(YARD::Tags::Tag.new(:return,
                                        "a new instance of #{namespace.name}", namespace.name.to_s))
      end
    elsif mscope == :class && obj.docstring.blank? && %w[inherited included
                                                         extended method_added method_removed method_undefined].include?(meth)
      obj.add_tag(YARD::Tags::Tag.new(:private, nil))
    elsif meth.to_s =~ /\?$/
      add_predicate_return_tag(obj)
    end

    if obj.has_tag?(:option)
      # create the options parameter if its missing
      obj.tags(:option).each do |option|
        expected_param = option.name
        next if obj.tags(:param).find { |x| x.name == expected_param }

        new_tag = YARD::Tags::Tag.new(:param, "a customizable set of options", "Hash", expected_param)
        obj.add_tag(new_tag)
      end
    end

    info = obj.attr_info
    if info
      if meth.to_s =~ /=$/ # writer
        info[:write] = obj if info[:read]
      elsif info[:write]
        info[:read] = obj
      end
    end
    # obj.dynamic = true
    extra_state.endpoint_definition = nil
    extra_state.in_endpoint_definition = false

    parse_block(blk, owner: obj) # mainly for yield/exceptions
  rescue StandardError => e
    require "pry"
    binding.pry
  end
end

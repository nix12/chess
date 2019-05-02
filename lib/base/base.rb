class Base
  def to_json(options = {})
    hash = {}

    instance_variables.each do |var|
      hash[var] = instance_variable_get(var)
    end

    hash.to_json
  end
end

module StringSample
  module InstanceMethods
    def load
      JSON.parse(self).deep_symbolize_keys
    end
  end

  class ::String
    include InstanceMethods
  end
end

String.extend(StringSample)
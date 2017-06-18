module Utils
  class Time
    NON_TIME = I18n.t(:no_deadline_set)

    def initialize(time)
      @time = time
    end

    def format
      @time.nil? ? NON_TIME : I18n.l(::Time.parse(@time))
    end
  end
end
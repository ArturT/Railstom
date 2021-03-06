module CustomMatchers
  class ExistInDatabase
    def matches?(actual)
      @actual = actual
      @actual.class.exists?(@actual.id)
    end

    def failure_message
      "expected #{@actual.inspect} to exist in database"
    end

    def failure_message_when_negated
      "expected #{@actual.inspect} not to exist in database"
    end

    def description
      "#{@actual.class} exist in database"
    end
  end

  def exist_in_database
    ExistInDatabase.new
  end
end

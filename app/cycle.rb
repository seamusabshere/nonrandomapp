class Cycle
  INFINITY = 1.0/0

  attr_reader :id
  attr_reader :size
  attr_reader :redis_key

  def initialize(proto_id, options = {})
    @id = proto_id.to_s.strip
    unless id.length > 1
      raise ArgumentError, %{id #{id.inspect} is not valid}
    end
    @size = options.has_key?('size') ? options['size'].to_i : INFINITY
    @redis_key = "Cycle/#{id}"
  end

  def current
    if $redis.exists redis_key
      memo = $redis.incr redis_key
      if memo >= size
        memo = 0
        $redis.set redis_key, 0
      end
    else
      memo = 0
      $redis.set redis_key, 0
    end
    memo
  end
  lock_method :current, :spin => true, :ttl => 60

  def as_lock
    id
  end
end
